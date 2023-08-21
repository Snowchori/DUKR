package com.example.playable.chess;

import java.util.HashMap;

import org.springframework.web.socket.WebSocketSession;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChessBoardTO {

	// 체스판 상태를 나타내는 해쉬맵
	private HashMap<Integer, ChessPieceTO> boardStatus;
	// 진행 턴수
	private int turn;
	// 흑 백 진영별 플레이어
	HashMap<WebSocketSession, String> players;

	// 생성자 - 체스보드 초기화, 해쉬맵에 보드 초기상태 입력
	public ChessBoardTO() {
		boardStatus = new HashMap<>();
		this.turn = 1;

		for (int i = 1; i <= 8; i++) {

			if (i == 1 || i == 8) {

				// 흑백 설정
				boolean bw;
				if (i == 1) {
					bw = false;
				} else {
					bw = true;
				}

				ChessPieceTO rook1 = new ChessPieceTO(bw, i * 10 + 1, 3);
				ChessPieceTO knight1 = new ChessPieceTO(bw, i * 10 + 2, 1);
				ChessPieceTO bishop1 = new ChessPieceTO(bw, i * 10 + 3, 2);
				ChessPieceTO queen = new ChessPieceTO(bw, i * 10 + 4, 4);
				ChessPieceTO king = new ChessPieceTO(bw, i * 10 + 5, 5);
				ChessPieceTO bishop2 = new ChessPieceTO(bw, i * 10 + 6, 2);
				ChessPieceTO knight2 = new ChessPieceTO(bw, i * 10 + 7, 1);
				ChessPieceTO rook2 = new ChessPieceTO(bw, i * 10 + 8, 3);
				this.boardStatus.put(i * 10 + 1, rook1);
				this.boardStatus.put(i * 10 + 2, knight1);
				this.boardStatus.put(i * 10 + 3, bishop1);
				this.boardStatus.put(i * 10 + 4, queen);
				this.boardStatus.put(i * 10 + 5, king);
				this.boardStatus.put(i * 10 + 6, bishop2);
				this.boardStatus.put(i * 10 + 7, knight2);
				this.boardStatus.put(i * 10 + 8, rook2);
				
			} else if (i == 2 || i == 7) {

				// 흑백 설정
				boolean bw;
				if (i == 2) {
					bw = false;
				} else {
					bw = true;
				}

				for (int j = 1; j <= 8; j++) {
					ChessPieceTO pawn = new ChessPieceTO(bw, i * 10 + j, 0);
					this.boardStatus.put(i * 10 + j, pawn);
				}

			}else {
				for(int j=1; j<=8; j++) {
					// 빈공간 처리
					this.boardStatus.put(i*10 + j, null);
				}
			}

		}

	}
}
