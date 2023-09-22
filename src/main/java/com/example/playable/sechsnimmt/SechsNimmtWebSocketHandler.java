package com.example.playable.sechsnimmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

public class SechsNimmtWebSocketHandler implements WebSocketHandler {
	
	// 진행중인 게임 목록
	volatile private HashMap<String, SechsNimmtGameTO> games = new HashMap<>(); 
	// 플레이어 그룹
	volatile private HashMap<String, ArrayList<WebSocketSession>> playerGroups = new HashMap<>();
	// 매칭 대기중인 플레이어 그룹
	volatile private ArrayList<WebSocketSession> waitingRoom = new ArrayList<>();	
	
	// 게임객체 -> JSON String 변환 메소드 
	public String gameToJson(SechsNimmtGameTO game, WebSocketSession player) {
		StringBuilder sbResult = new StringBuilder();
		
		sbResult.append("{");
		sbResult.append("\"gameStatus\": ");
		sbResult.append("[");	
		for(int row=0; row<4; row++) {
			sbResult.append("[");
			for(int col=0; col<6; col++) {
				SechsNimmtCardTO card = game.getGameStatus()[row][col];
				if(card != null) {
					sbResult.append(card.getCardNumber());
				}else {
					sbResult.append("0");
				}
				if(col != 5) {
					sbResult.append(", ");
				}
			}
			sbResult.append("]");
			if(row != 3) {
				sbResult.append(", ");
			}
		}
		sbResult.append("],");
		
		sbResult.append("\"hand\": ");
		sbResult.append("[");
		ArrayList<SechsNimmtCardTO> hand = game.getPlayers().get(player).getHand();
		for(SechsNimmtCardTO card : hand) {
			sbResult.append(card.getCardNumber() + ", ");
		}
		sbResult.deleteCharAt(sbResult.lastIndexOf(","));
		sbResult.append("],");
		
		sbResult.append("\"players\": ");
		sbResult.append("[");
		for(SechsNimmtPlayerTO playerTO : game.getPlayers().values()) {
			sbResult.append("\"" + playerTO.getName() + "\",");
		}
		sbResult.deleteCharAt(sbResult.lastIndexOf(","));
		sbResult.append("]");
		
		sbResult.append("}");
		
		return sbResult.toString();
	}
	
	// picks배열 -> JSON String
	public String picksToJson(ArrayList<SechsNimmtPlayerTO> players) {
		StringBuilder sbResult = new StringBuilder();
		
		sbResult.append("{");
		sbResult.append("\"players\": ");
		sbResult.append("[");
		for(SechsNimmtPlayerTO player : players) {
			sbResult.append("\"" + player.getName() + "\", ");
		}
		sbResult.deleteCharAt(sbResult.lastIndexOf(","));
		sbResult.append("],");
		
		sbResult.append("\"picks\": ");
		sbResult.append("[");
		for(SechsNimmtPlayerTO player : players) {
			sbResult.append(player.getPick().getCardNumber() + ",");
		}
		sbResult.deleteCharAt(sbResult.lastIndexOf(","));
		sbResult.append("]");
		sbResult.append("}");
		
		return sbResult.toString();
	}
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// TODO Auto-generated method stub
	} 

	@Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
		// TODO Auto-generated method stub
		
		// 매칭 요청을 수신한 경우
		if(message.getPayload().equals("match request")) {
			
			// 매칭요청한 플레이어의 세션을 대기 어레이에 추가
			waitingRoom.add(session);
			
			// 5인의 플레이어 매칭이 완성된 경우
			if(waitingRoom.size() == 5) {
				// 해당 유저그룹의 고유 코드 생성
				UUID uuid = UUID.randomUUID();
				// 플레이어 그룹 목록에 완성된 매칭 추가
				playerGroups.put(uuid.toString(), waitingRoom);		
				// 새로운 게임객체 생성
				SechsNimmtGameTO newGame = new SechsNimmtGameTO(waitingRoom);				
				// 진행중인 게임목록에 새로 생성된 게임 추가
				games.put(uuid.toString(), newGame);
				
				// 매칭된 플레이어들 각자에게 게임 고유코드 및 정보 전달
				for(WebSocketSession player : waitingRoom) {
					player.sendMessage(new TextMessage("uuid@" + uuid.toString()));
					player.sendMessage(new TextMessage("game@" + gameToJson(newGame, player)));
					// 유저 구분자 전달
					player.sendMessage(new TextMessage("playerID@" + player.getId()));
				}
				
				// 대기열 비우기
				waitingRoom.removeAll(waitingRoom);
			}
		}
		
		// 게임 조작정보 수신
		if(message.getPayload().toString().split("@")[0].equals("gameID")) {
			String strMessage = message.getPayload().toString();
			String gameID = strMessage.split("@")[1];
			SechsNimmtGameTO game = games.get(gameID);
			SechsNimmtPlayerTO player = game.getPlayers().get(session);
			
			// 카드 선택정보 수신/처리
			if(strMessage.split("@")[2].equals("pick")) {
				
				int pickIndex = Integer.parseInt(strMessage.split("@")[3]);
				ArrayList<SechsNimmtCardTO> hand = player.getHand();
				SechsNimmtCardTO pick = hand.get(pickIndex);
				
				// 플레이어의 손패에서 플레이어가 고른 카드를 제거하고 pick카드로 등록
				hand.remove(pickIndex);
				player.setPick(pick);
				game.getPicks().add(player);
				
				// 모든 플레이어의 카드 선택 여부
				System.out.println("size1" + game.getPicks().size());
				System.out.println("size2" + game.getPlayers().size());
				boolean allPlayersReady = (game.getPicks().size() == game.getPlayers().size());
				
				// 모든 플레이어카 카드를 고른 경우
				if(allPlayersReady) {
					game.sortPicks();
					String transfer = game.autoTransfer();
					System.out.println(transfer);
					
					for(SechsNimmtPlayerTO playerTO : game.getPlayers().values()) {
						String picksJson = picksToJson(game.getPicks());
						playerTO.getPlayerSession().sendMessage(new TextMessage("picks@" + picksJson));
						playerTO.getPlayerSession().sendMessage(new TextMessage(transfer));
					}
				}
			}
			
			// 카드이동 지시사항 완료응답 수신
			if(strMessage.split("@")[2].equals("next instruction request")) {
				synchronized (game) {
					game.countResponse();
				}				
	
				// 모든 플레이어의 브라우저로부터 완료응답을 수신한 경우 => 다음 카드이동 지시사항 전달
				if(game.getInstructionResponseCount() == 5) {
					game.setInstructionResponseCount(0);
					String transfer = game.autoTransfer();
					System.out.println(transfer);
					for(SechsNimmtPlayerTO playerTO : game.getPlayers().values()) {
						if(transfer.equals("transfer_complete")) {
							playerTO.getPlayerSession().sendMessage(new TextMessage("game@" + gameToJson(game, playerTO.getPlayerSession())));
						}else {
							playerTO.getPlayerSession().sendMessage(new TextMessage(transfer));
						}
					}
				}
			}
		}
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean supportsPartialMessages() {
		// TODO Auto-generated method stub
		return false;
	}

}
