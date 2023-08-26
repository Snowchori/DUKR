package com.example.playable.chess;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

public class ChessWebSocketHandler implements WebSocketHandler {
	
	// 전체 플레이어 세션 목록
	private HashMap<WebSocketSession, Boolean> players = new HashMap<>(); 
	// 매칭 대기중인 플레이어 세션 목록
	private ArrayList<WebSocketSession> matchablePlayers = new ArrayList<>();
	// 매치 성사된(게임이 시작된) 세션쌍 해시맵
	private HashMap<WebSocketSession, WebSocketSession> matchedGames = new HashMap<>();
	// 게임별 체스보드 상태
	private HashMap<WebSocketSession, ChessBoardTO> chessBoards = new HashMap<>();
	
	// HashMap => JSON string 변환 메소드
	private String hashmapToJson(ChessBoardTO cbTO) {
		StringBuilder sbJson  = new StringBuilder();
		
		sbJson.append("{");
		for(int i=1; i<=8; i++) {
			for(int j=1; j<=8; j++) {
				int key = i * 10 + j;
				ChessPieceTO value = cbTO.getBoardStatus().get(key);
				
				sbJson.append("\"" + key + "\":");
				if(value != null) {
					sbJson.append("{");
					sbJson.append("\"bw\": \"" + value.isBw() + "\",");
					sbJson.append("\"isMoved\": \"" + value.isMoved() + "\",");
					sbJson.append("\"grade\": \"" + value.getGrade() + "\",");
					sbJson.append("\"position\": \"" + value.getPosition() + "\",");
					sbJson.append("\"possibleMoves\":\"");
					for(Integer possiblePosition : value.getPossibleMoves()) {
						sbJson.append(possiblePosition + "/");
					}
					sbJson.append("\"");
					sbJson.append("},");
				}else {
					sbJson.append("\"null\",");
				}
			}
		}
		sbJson.append("}");
		sbJson.deleteCharAt(sbJson.lastIndexOf(","));
		
		return sbJson.toString();
	}
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// TODO Auto-generated method stub
		
		// 기존에 연결되어있던 사용자의 경우
		if(players.get(session) != null) {
			ChessBoardTO chessBoard = chessBoards.get(session);
			String strJsonBoardStatus = hashmapToJson(chessBoard);
			
			if(chessBoard.getPlayers().get(session).equals("black")) {
				session.sendMessage(new TextMessage("camp@black"));
			}else {
				session.sendMessage(new TextMessage("camp@white"));
			}
			
			session.sendMessage(new TextMessage(strJsonBoardStatus));
		}else {
			// 새로 연결된 사용자의 경우
			players.put(session, true);
		}

	}

	@Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {

		// 게임 매칭요청 처리
		if(message.getPayload().equals("match request")) {
			
			// 대기중인 다른 플레이어가 존재할 경우
			if(matchablePlayers.size() != 0) {
				
				// 대기중인 플레이어와 매칭 요청한 플레이어를 matched에 포함
				ArrayList<WebSocketSession> matchedGame = new ArrayList<>();
				matchedGame.add(matchablePlayers.get(0));
				matchedGame.add(session);
				
				// 매치된 플레이어를 매칭 대기 리스트에서 제거
				matchablePlayers.remove(matchablePlayers.get(0));
				
				// 성사된 매치를 matchedGames에 추가
				matchedGames.put(matchedGame.get(0), matchedGame.get(1));
				matchedGames.put(matchedGame.get(1), matchedGame.get(0));
				
				// 새로운 초기상태 체스보드 생성 
				ChessBoardTO cbTO = new ChessBoardTO();
				// 생성된 체스보드의 가능한 수 계산, 해시맵의 각 값에 해당하는 기물TO의 possibleMoves 업데이트
				for(int i=1; i<=8; i++) {
					for(int j=1; j<=8; j++) {
						
						int key = i*10 + j;
						ChessPieceTO cpTO = cbTO.getBoardStatus().get(key);	
						
						if(cpTO != null) {
							ArrayList<Integer> possibleMoves = cpTO.calcPossibleMoves1(cbTO.getBoardStatus(), cpTO);
							cbTO.getBoardStatus().get(key).setPossibleMoves(possibleMoves);
						}
						
					}
				}
				
				// 새로 성사된 게임에 초기화된 체스보드 연결 
				chessBoards.put(matchedGame.get(0), cbTO);
				chessBoards.put(matchedGame.get(1), cbTO);
				
				// 매칭된 플레이어 각자에게 상대방의 세션 해시코드 전달
				matchedGame.get(0).sendMessage( new TextMessage("opponenet@" + matchedGame.get(1).hashCode()) );
				matchedGame.get(1).sendMessage( new TextMessage("opponenet@" + matchedGame.get(0).hashCode()) );
				
				// 각 플레이어의 흑/백 진영 배정
				HashMap<WebSocketSession, String> players = new HashMap<>();
				players.put(matchedGame.get(0), "white");
				players.put(matchedGame.get(1), "black");
				chessBoards.get(matchedGame.get(0)).setPlayers(players);
				matchedGame.get(0).sendMessage( new TextMessage("camp@white") );
				matchedGame.get(1).sendMessage( new TextMessage("camp@black") ); 
				
				// 각 플레이어에게 보드 초기상태 전달
				String boardStatus = hashmapToJson(cbTO);	
				matchedGame.get(0).sendMessage( new TextMessage("turn@1@boardStatus@" + boardStatus) );
				matchedGame.get(1).sendMessage( new TextMessage("turn@1@boardStatus@" + boardStatus) ); 
		
			}else {
				// 매칭 대기중인 다른 플레이어가 존재하지 않을 경우 매칭 대기리스트에 추가
				matchablePlayers.add(session);
			}
			
		}

		// 기물 이동 요청 처리
		if(message.getPayload().toString().split("@")[0].equals("move")) {

			System.out.println(message.getPayload());
			
			// 상대방 세션 정보
			WebSocketSession opponent = matchedGames.get(session);
			
			// 기물 이동 정보
			String moveOrder = message.getPayload().toString().split("@")[1];
			int currentPosition = Integer.parseInt(moveOrder.split("to")[0]);
			int nextPosition = Integer.parseInt(moveOrder.split("to")[1]);

			// 기물 이동 요청이 접수된 게임의 체스판 불러오기
			HashMap<Integer, ChessPieceTO> currentBoardStatus = chessBoards.get(session).getBoardStatus();
			
			// 디버깅용 해시맵 랜더러(콘솔)
			/*
			for(int i=8; i>=1; i--) {
				for(int j=1; j<=8; j++) {
					int key = i*10 + j;
					if(currentBoardStatus.get(key) != null) {
						System.out.print(currentBoardStatus.get(key).getGrade());
						System.out.print('|');
					}else {
						System.out.print(' ');
						System.out.print('|');
					}
				}
				System.out.println();
			}
			*/
			
			// 해시맵상에서 기물 이동
			ChessPieceTO movingPiece = currentBoardStatus.get(currentPosition);
			movingPiece.setPosition(nextPosition);
			movingPiece.setMoved(true);
			chessBoards.get(session).getBoardStatus().put(currentPosition, null);
			chessBoards.get(session).getBoardStatus().put(nextPosition, movingPiece);
			chessBoards.get(opponent).getBoardStatus().put(currentPosition, null);
			chessBoards.get(opponent).getBoardStatus().put(nextPosition, movingPiece);
			
			// 턴
			int turn = chessBoards.get(session).getTurn();
			
			if(movingPiece.getGrade() == 0 && ( nextPosition / 10 == 8 || nextPosition / 10 == 1 )) {
				
				// 폰 프로모션	시작
				chessBoards.get(session).removeAllPossibleMoves();
				String promoting = hashmapToJson(chessBoards.get(session));
				
				session.sendMessage(new TextMessage("turn@" + turn + "@boardStatus@" + promoting + "@promotable@" + nextPosition));
			 
			}else {
				// 기물 이동 후 수정된 보드에서 가능한 수 계산
				// 생성된 체스보드의 가능한 수 계산, boardStatus
				for(int i=1; i<=8; i++) {
					for(int j=1; j<=8; j++) {
						
						int key = i*10 + j;
						ChessPieceTO cpTO = chessBoards.get(session).getBoardStatus().get(key);
						
						if(cpTO != null) {
							ArrayList<Integer> possibleMoves = cpTO.calcPossibleMoves1(chessBoards.get(session).getBoardStatus(), cpTO);
							cpTO.setPossibleMoves(possibleMoves);
							chessBoards.get(session).getBoardStatus().put(key, cpTO);
							chessBoards.get(opponent).getBoardStatus().put(key, cpTO);
						}					
					}
				}
				
				// 턴 카운트 올림
				chessBoards.get(session).setTurn(turn + 1);
				chessBoards.get(opponent).setTurn(turn + 1);
				
				// 기물 이동 후 가능한 움직임까지 계산된 해시맵을 json 형태로 변환
				String newBoardStatus = hashmapToJson(chessBoards.get(session));
				// 각 플레이어에게 갱신된 체스판 전송
				session.sendMessage(new TextMessage("turn@" + (turn + 1) + "@boardStatus@" + newBoardStatus));
				opponent.sendMessage(new TextMessage("turn@" + (turn + 1) + "@boardStatus@" + newBoardStatus));
			}
	
		}
		
		// 폰 프로모션 요청 처리
		if(message.getPayload().toString().split("@")[0].equals("promote")) {
			// 상대방 세션 정보
			WebSocketSession opponent = matchedGames.get(session);
			// 프로모션 요청 위치
			int promotingLoc = Integer.parseInt(message.getPayload().toString().split("@")[1]);
			// 프로모션 기물 등급
			int pGrade = Integer.parseInt(message.getPayload().toString().split("@")[3]);
			
			// 해시맵 상에서 폰 프로모션 진행
			chessBoards.get(session).getBoardStatus().get(promotingLoc).setGrade(pGrade);
			chessBoards.get(opponent).getBoardStatus().get(promotingLoc).setGrade(pGrade);
			
			// 가능한 수 업데이트
			for(int i=1; i<=8; i++) {
				for(int j=1; j<=8; j++) {
					
					int key = i*10 + j;
					ChessPieceTO cpTO = chessBoards.get(session).getBoardStatus().get(key);
					
					if(cpTO != null) {
						ArrayList<Integer> possibleMoves = cpTO.calcPossibleMoves1(chessBoards.get(session).getBoardStatus(), cpTO);
						cpTO.setPossibleMoves(possibleMoves);
						chessBoards.get(session).getBoardStatus().put(key, cpTO);
						chessBoards.get(opponent).getBoardStatus().put(key, cpTO);
					}					
				}
			}
			
			// 턴
			int turn = chessBoards.get(session).getTurn();
			
			// 턴 카운트 올림
			chessBoards.get(session).setTurn(turn + 1);
			chessBoards.get(opponent).setTurn(turn + 1);
			
			// 프로모션 후 가능한 움직임까지 계산된 해시맵을 json 형태로 변환
			String newBoardStatus = hashmapToJson(chessBoards.get(session));
			// 각 플레이어에게 갱신된 체스판 전송
			session.sendMessage(new TextMessage("turn@" + (turn + 1) + "@boardStatus@" + newBoardStatus));
			opponent.sendMessage(new TextMessage("turn@" + (turn + 1) + "@boardStatus@" + newBoardStatus));
		}
		
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
		// 플레이어 세션 목록에서 제거
		players.remove(session);
		
		// 매칭중이던 플레이어가 연결이 끊길 경우 대기목록에서 제거
		if(matchablePlayers.contains(session)) {
			matchablePlayers.remove(session);
		}
	}

	@Override
	public boolean supportsPartialMessages() {
		// TODO Auto-generated method stub
		return false;
	}

}
