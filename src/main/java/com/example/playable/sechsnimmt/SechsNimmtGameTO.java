package com.example.playable.sechsnimmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;

import org.springframework.web.socket.WebSocketSession;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SechsNimmtGameTO {
	
	// 사용자들의 손패와 카드풀을 제외한 공개된 영역의 게임 진행상황
	private SechsNimmtCardTO[][] gameStatus;
	// 플레이어 목록 
	private HashMap<WebSocketSession, SechsNimmtPlayerTO> players;
	// 뽑을 수 있는 카드풀
	private ArrayList<Integer> cardPool;
	// 라운드
	private int round;
	// 플레이어들이 고른 카드 공개
	private ArrayList<SechsNimmtPlayerTO> picks;

	// 생성자 - 게임 초기화
	public SechsNimmtGameTO(ArrayList<WebSocketSession> playersList) {
		
		this.cardPool = new ArrayList<>();
		this.gameStatus = new SechsNimmtCardTO[4][6];
		this.players = new HashMap<>();
		this.round = 1;
		this.picks = new ArrayList<>();

		// 플레이어 추가
		for(WebSocketSession player : playersList) {
			SechsNimmtPlayerTO playerTO = new SechsNimmtPlayerTO(player);
			this.players.put(player, playerTO);
		}
		
		// 카드풀에 1부터 104까지의 카드 삽입
		for(int i=1; i<=104; i++) {
			this.cardPool.add(i);
		}
 
		// 각 플레이어에게 손패 10장씩 배분
		for(SechsNimmtPlayerTO player : players.values()) {
			for(int i=1; i<=10; i++) {
				int newCardNumber = drawCard();
				player.getHand().add(new SechsNimmtCardTO(newCardNumber));
			} 
		}
		
		// 초기 4행 생성
		for(int i=0; i<4; i++) {
			int newCardNumber = drawCard();
			this.gameStatus[i][0] = new SechsNimmtCardTO(newCardNumber);
		}
	}
	
	// 랜덤 카드뽑기
	public int drawCard() {
		int maxNum = this.cardPool.size();
		
		Random random = new Random();		
		int randomNumber = random.nextInt(maxNum);
		int randomCardNumber = cardPool.get(randomNumber);
		this.cardPool.remove(randomNumber);
		
		return randomCardNumber;
	}
	
	// picks 배열을 카드숫자 오름차순으로 정렬
	public void sortPicks() {
		for(int index=this.picks.size()-2; index>=0; index--) {			
			int cursor = index;

			while(true) {
				if(cursor == this.picks.size() - 1) break;
				SechsNimmtPlayerTO standard = this.picks.get(cursor);
				SechsNimmtPlayerTO target = this.picks.get(cursor + 1);
				
				if(target.getPick().getCardNumber() < standard.getPick().getCardNumber()) {
					this.picks.set(cursor + 1, standard);
					this.picks.set(cursor, target);
					cursor ++;
				}else {
					break;
				}
			}
		}
	}
	
}

