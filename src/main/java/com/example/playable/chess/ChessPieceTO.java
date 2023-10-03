package com.example.playable.chess;

import java.util.ArrayList;
import java.util.HashMap;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter 
public class ChessPieceTO {
	
	// bw - false면 백, true면 흑
	private boolean bw;
	// 기물 이동여부
	private boolean moved;
	// position - 체스보드상 기물위치, 보드좌표 11~88, 십의자리가 가로축, 일의자리가 세로축, 00은 죽은상태
	private int position;
	// possibleMoves - 기물이 이동할수있는 위치 저장
	private ArrayList<Integer> possibleMoves;
	// grade - 기물 종류 / 0=pawn / 1=knight / 2=bishop / 3=rook / 4=queen / 5=king /
	private int grade;

	// 생성자
	public ChessPieceTO(boolean bw, int position, int grade) {
		this.setBw(bw);
		this.setMoved(false);
		this.setPosition(position);
		this.setGrade(grade);
		this.possibleMoves = new ArrayList<>();
	}
	
	// 수 계산기1 -   
	public ArrayList<Integer> calcPossibleMoves1(HashMap<Integer, ChessPieceTO> boardStatus, ChessPieceTO cpTO, int enPassant) {
		
		// 초기화
		if(this.possibleMoves != null || this.possibleMoves.size() != 0) {
			this.possibleMoves.clear();
		}
		
		// pawn
		if(this.grade == 0) {

			// 흑인 경우
			if(this.bw) {
				// 흑 - 움직이지 않은 경우
				if(!this.isMoved()) {
					// 전진
					if(boardStatus.get(this.position - 10) == null) {
						this.possibleMoves.add(this.position - 10);
					}
					if(boardStatus.get(this.position - 20) == null && boardStatus.get(this.position - 10) == null) {
						this.possibleMoves.add(this.position - 20);
					}
					// 흑 - 대각선에 상대기물이 존재하는 경우
					if(boardStatus.get(this.position - 11) != null) {
						if(!boardStatus.get(this.position - 11).bw) {
							this.possibleMoves.add(this.position - 11);
						}
					}
					if(boardStatus.get(this.position - 9) != null) {
						if(!boardStatus.get(this.position - 9).bw) {
							this.possibleMoves.add(this.position - 9);
						}
					}
				}
				// 흑 - 움직인 경우
				else {
					// 전진
					if(boardStatus.get(this.position - 10) == null) {
						this.possibleMoves.add(this.position - 10);
					}
					// 흑 - 대각선에 상대기물이 존재하는 경우
					if(boardStatus.get(this.position - 11) != null) {
						if(!boardStatus.get(this.position - 11).bw) {
							this.possibleMoves.add(this.position - 11);
						}
					}
					if(boardStatus.get(this.position - 9) != null) {
						if(!boardStatus.get(this.position - 9).bw) {
							this.possibleMoves.add(this.position - 9);
						}
					}
				}
				
				// 앙파상 - 좌
				if(boardStatus.get(this.position - 1) != null) {
					if(enPassant == this.getPosition() - 1 && boardStatus.get(enPassant).isBw() != this.isBw()) {
						this.possibleMoves.add(this.getPosition() - 11);
					}
				}
				// 앙파상 - 우
				if(boardStatus.get(this.position + 1) != null) {
					if(enPassant == this.getPosition() + 1 && boardStatus.get(enPassant).isBw() != this.isBw()) {
						this.possibleMoves.add(this.getPosition() - 9);
					}
				}
			}
			// 백인 경우
			else {
				// 백 - 움직이지 않은 경우
				if(!this.isMoved()) {
					// 전진
					if(boardStatus.get(this.position + 10) == null) {
						this.possibleMoves.add(this.position + 10);
					}
					if(boardStatus.get(this.position + 20) == null && boardStatus.get(this.position + 10) == null) {
						this.possibleMoves.add(this.position + 20);
					}
					// 대각선에 상대기물이 존재하는 경우
					if(boardStatus.get(this.position + 11) != null) {
						if(boardStatus.get(this.position + 11).bw) {
							this.possibleMoves.add(this.position + 11);
						}
					}
					if(boardStatus.get(this.position + 9) != null) {
						if(boardStatus.get(this.position + 9).bw) {
							this.possibleMoves.add(this.position + 9);
						}
					}
				}
				// 백 - 움직인 경우
				else {
					// 전진
					if(boardStatus.get(this.position + 10) == null) {
						this.possibleMoves.add(this.position + 10);
					}
					// 대각선에 상대기물이 존재하는 경우
					if(boardStatus.get(this.position + 11) != null) {
						if(boardStatus.get(this.position + 11).bw) {
							this.possibleMoves.add(this.position + 11);
						}      
					}
					if(boardStatus.get(this.position + 9) != null) {
						if(boardStatus.get(this.position + 9).bw) {
							this.possibleMoves.add(this.position + 9);
						}
					}
				}
				
				// 앙파상 - 좌
				if(boardStatus.get(this.position - 1) != null) {
					if(enPassant == this.getPosition() - 1 && boardStatus.get(enPassant).isBw() != this.isBw()) {
						this.possibleMoves.add(this.getPosition() + 9);
					}
				}
				// 앙파상 - 우
				if(boardStatus.get(this.position + 1) != null) {
					if(enPassant == this.getPosition() + 1 && boardStatus.get(enPassant).isBw() != this.isBw()) {
						this.possibleMoves.add(this.getPosition() + 11);
					}
				}
			}
		}

		// knight
		if(this.grade == 1) {

			// knight - move1
			int nextPosition = this.position + 20 + 1;
			int col = nextPosition / 10;
			int row = nextPosition % 10;
			if(col<=8 && col>=1 && row<=8 && row>=1) {
				if(boardStatus.get(this.position + 20 + 1) == null) {
					this.possibleMoves.add(this.position + 20 + 1);
				}else if(boardStatus.get(this.position + 20 + 1).bw != this.bw) {
					this.possibleMoves.add(this.position + 20 + 1);
				}
			}
			
			// knight - move2
			nextPosition = this.position + 20 - 1;
			col = nextPosition / 10;
			row = nextPosition % 10;
			if(col<=8 && col>=1 && row<=8 && row>=1) {
				if(boardStatus.get(this.position + 20 - 1) == null) {
					this.possibleMoves.add(this.position + 20 - 1);
				}else if(boardStatus.get(this.position + 20 - 1).bw != this.bw) {
					this.possibleMoves.add(this.position + 20 - 1);
				}
			}
			
			// knight - move3
			nextPosition = this.position - 20 + 1;
			col = nextPosition / 10;
			row = nextPosition % 10;
			if(col<=8 && col>=1 && row<=8 && row>=1) {
				if(boardStatus.get(this.position - 20 + 1) == null) {
					this.possibleMoves.add(this.position - 20 + 1);
				}else if(boardStatus.get(this.position - 20 + 1).bw != this.bw) {
					this.possibleMoves.add(this.position - 20 + 1);
				}
			}
			
			// knight - move4
			nextPosition = this.position - 20 - 1;
			col = nextPosition / 10;
			row = nextPosition % 10;
			if(col<=8 && col>=1 && row<=8 && row>=1) {
				if(boardStatus.get(this.position - 20 - 1) == null) {
					this.possibleMoves.add(this.position - 20 - 1);
				}else if(boardStatus.get(this.position - 20 - 1).bw != this.bw) {
					this.possibleMoves.add(this.position - 20 - 1);
				}
			}
			
			// knight - move5
			nextPosition = this.position + 2 + 10;
			col = nextPosition / 10;
			row = nextPosition % 10;
			if(col<=8 && col>=1 && row<=8 && row>=1) {
				if(boardStatus.get(this.position + 2 + 10) == null) {
					this.possibleMoves.add(this.position + 2 + 10);
				}else if(boardStatus.get(this.position + 2 + 10).bw != this.bw) {
					this.possibleMoves.add(this.position + 2 + 10);
				}
			}
			
			// knight - move6
			nextPosition = this.position + 2 - 10;
			col = nextPosition / 10;
			row = nextPosition % 10;
			if(col<=8 && col>=1 && row<=8 && row>=1) {
				if(boardStatus.get(this.position + 2 - 10) == null) {
					this.possibleMoves.add(this.position + 2 - 10);
				}else if(boardStatus.get(this.position + 2 - 10).bw != this.bw) {
					this.possibleMoves.add(this.position + 2 - 10);
				}
			}
			
			// knight - move7
			nextPosition = this.position - 2 + 10;
			col = nextPosition / 10;
			row = nextPosition % 10;
			if(col<=8 && col>=1 && row<=8 && row>=1) {
				if(boardStatus.get(this.position - 2 + 10) == null) {
					this.possibleMoves.add(this.position - 2 + 10);
				}else if(boardStatus.get(this.position - 2 + 10).bw != this.bw) {
					this.possibleMoves.add(this.position - 2 + 10);
				}
			}
			
			// knight - move8
			nextPosition = this.position - 2 - 10;
			col = nextPosition / 10;
			row = nextPosition % 10;
			if(col<=8 && col>=1 && row<=8 && row>=1) {
				if(boardStatus.get(this.position - 2 - 10) == null) {
					this.possibleMoves.add(this.position - 2 - 10);
				}else if(boardStatus.get(this.position - 2 - 10).bw != this.bw) {
					this.possibleMoves.add(this.position - 2 - 10);
				}
			}
			
		}
		
		// bishop
		if(this.grade == 2 || this.grade == 4) {
			int startPoint = this.getPosition();

			// 비숍 - 좌상 
			int count1 = 1;
			while(true) {

				int nextPosition = startPoint + (9 * count1);
				int col = nextPosition % 10;
				int row = nextPosition / 10;
				if(boardStatus.get(nextPosition) != null || row>8 || col<1) {
					if(boardStatus.get(nextPosition) != null) {
						if(boardStatus.get(nextPosition).bw != this.bw) {
							this.possibleMoves.add(nextPosition);
						}
					}
					break;
				}else {
					this.possibleMoves.add(nextPosition);
					count1 ++;
				}
			}
			
			// 비숍 - 좌하
			int count2 = 1;
			while(true) {
				int nextPosition = startPoint - (11 * count2);
				int col = nextPosition / 10;
				int row = nextPosition % 10;
				if(boardStatus.get(nextPosition) != null || row<1 || col<1) {
					if(boardStatus.get(nextPosition) != null) {
						if(boardStatus.get(nextPosition).bw != this.bw) {
							this.possibleMoves.add(nextPosition);
						}
					}
					break;
				}else {
					this.possibleMoves.add(nextPosition);
					count2 ++;
				}
			}
			
			// 비숍 - 우상
			int count3 = 1;
			while(true) {
				int nextPosition = startPoint + (11 * count3);
				int col = nextPosition / 10;
				int row = nextPosition % 10;
				if(boardStatus.get(nextPosition) != null || row>8 || col>8) {
					if(boardStatus.get(nextPosition) != null) {
						if(boardStatus.get(nextPosition).bw != this.bw) {
							this.possibleMoves.add(nextPosition);
						}
					}
					break;
				}else {
					this.possibleMoves.add(nextPosition);
					count3++;
				}
			}
			
			// 비숍 - 우하
			int count4 = 1;
			while(true) {
				int nextPosition = startPoint - (9 * count4);
				int col = nextPosition / 10;
				int row = nextPosition % 10;
				if(boardStatus.get(nextPosition) != null || row<1 || col>8) {
					if(boardStatus.get(nextPosition) != null) {
						if(boardStatus.get(nextPosition).bw != this.bw) {
							this.possibleMoves.add(nextPosition);
						}
					}
					break;
				}else {
					this.possibleMoves.add(nextPosition);
					count4++;
				}
			}
			
		}
		
		// rook
		if(this.grade == 3 || this.grade == 4) {

			// 룩 - 상
			int count1 = 1;
			while(true) {
				int nextPosition = this.position + 10*count1;
				int row = nextPosition / 10; 
				if(boardStatus.get(nextPosition) != null || row>8) {
					if(boardStatus.get(nextPosition) != null) {
						if(boardStatus.get(nextPosition).bw != this.bw) {
							this.possibleMoves.add(nextPosition);
						}
					}
					break;
				}
				this.possibleMoves.add(nextPosition);
				count1 ++;
			}
			
			// 룩 - 하
			int count2 = 1;
			while(true) {
				int nextPosition = this.position - 10*count2;
				int row = nextPosition / 10; 
				if(boardStatus.get(nextPosition) != null || row<1) {
					if(boardStatus.get(nextPosition) != null) {
						if(boardStatus.get(nextPosition).bw != this.bw) {
							this.possibleMoves.add(nextPosition);
						}
					}
					break;
				}
				this.possibleMoves.add(nextPosition);
				count2 ++;
			}
			
			// 룩 - 좌
			int count3 = 1;
			while(true) {
				int nextPosition = this.position - count3;
				int col = nextPosition % 10; 
				if(boardStatus.get(nextPosition) != null || col<1) {
					if(boardStatus.get(nextPosition) != null) {
						if(boardStatus.get(nextPosition).bw != this.bw) {
							this.possibleMoves.add(nextPosition);
						}
					}
					break;
				}
				this.possibleMoves.add(nextPosition);
				count3 ++;
			}
			
			// 룩 - 우
			int count4 = 1;
			while(true) {
				int nextPosition = this.position + count4;
				int col = nextPosition % 10; 
				if(boardStatus.get(nextPosition) != null || col>8) {
					if(boardStatus.get(nextPosition) != null) {
						if(boardStatus.get(nextPosition).bw != this.bw) {
							this.possibleMoves.add(nextPosition);
						}
					}
					break;
				}
				this.possibleMoves.add(nextPosition);
				count4 ++;
			}
			
		}
		
		// queen
		if(this.grade == 4) {
			// 룩 + 비숍 에서 처리
		}
		
		// king
		if(this.grade == 5) {
			
			// 현위치 체크여부 판별용
			this.possibleMoves.add(this.getPosition());
			
			// king - 상
			if(boardStatus.get(this.position + 10) == null) {
				this.possibleMoves.add(this.position + 10);
			}else if(boardStatus.get(this.position + 10).bw != this.bw) {
				this.possibleMoves.add(this.position + 10);
			}
			
			// king - 하
			if(boardStatus.get(this.position - 10) == null) {
				this.possibleMoves.add(this.position - 10);
			}else if(boardStatus.get(this.position - 10).bw != this.bw) {
				this.possibleMoves.add(this.position - 10);
			}
			
			// king - 좌
			if(boardStatus.get(this.position - 1) == null) {
				this.possibleMoves.add(this.position - 1);
			}else if(boardStatus.get(this.position - 1).bw != this.bw) {
				this.possibleMoves.add(this.position - 1);
			}
			
			// king - 우
			if(boardStatus.get(this.position + 1) == null) {
				this.possibleMoves.add(this.position + 1);
			}else if(boardStatus.get(this.position + 1).bw != this.bw) {
				this.possibleMoves.add(this.position + 1);
			}
			
			// king - 우상
			if(boardStatus.get(this.position + 11) == null) {
				this.possibleMoves.add(this.position + 11);
			}else if(boardStatus.get(this.position + 11).bw != this.bw) {
				this.possibleMoves.add(this.position + 11);
			}
			
			// king - 우하
			if(boardStatus.get(this.position - 9) == null) {
				this.possibleMoves.add(this.position - 9);
			}else if(boardStatus.get(this.position - 9).bw != this.bw) {
				this.possibleMoves.add(this.position - 9);
			}
			
			// king - 좌상
			if(boardStatus.get(this.position + 9) == null) {
				this.possibleMoves.add(this.position + 9);
			}else if(boardStatus.get(this.position + 9).bw != this.bw) {
				this.possibleMoves.add(this.position + 9);
			}
			
			// king - 좌하
			if(boardStatus.get(this.position - 11) == null) {
				this.possibleMoves.add(this.position - 11);
			}else if(boardStatus.get(this.position - 11).bw != this.bw) {
				this.possibleMoves.add(this.position - 11);
			}
			
			// 캐슬링
			if(!this.isMoved()) {
				int positionOfKing = this.getPosition();
				int row = positionOfKing / 10;
				int positionOfRook1 = row * 10 + 1;
				int positionOfRook2 = row * 10 + 8;
				int nullCheck1 = 0;
				int nullCheck2 = 0;

				if(boardStatus.get(positionOfRook1) != null) {
					ChessPieceTO rook1 = boardStatus.get(positionOfRook1);
					if(rook1.getGrade() == 3 && !rook1.isMoved()) {
						for(int cursor=positionOfRook1+1; cursor<positionOfKing; cursor++) {
							if(boardStatus.get(cursor) == null) {
								nullCheck1 ++;
							}else {
								break;
							}
						}
					}
				}
				
				if(boardStatus.get(positionOfRook2) != null) {
					ChessPieceTO rook2 = boardStatus.get(positionOfRook2);
					if(rook2.getGrade() == 3 && !rook2.isMoved()) {
						for(int cursor=positionOfRook2-1; cursor>positionOfKing; cursor--) {
							if(boardStatus.get(cursor) == null) {
								nullCheck2 ++;
							}else {
								break;
							}
						}
					}
				}
				
				if(Math.abs(positionOfKing - positionOfRook1) == nullCheck1 + 1) {
					this.possibleMoves.add(positionOfKing - 2);
				}
				if(Math.abs(positionOfKing - positionOfRook2) == nullCheck2 + 1) {
					this.possibleMoves.add(positionOfKing + 2);
				}
				
			}
		}
		
		// 체크 여부 판별
		ArrayList<Integer> result = new ArrayList<>();
		// 1. 킹 위치 특정하기
		int positionOfKing = 0;
		for(int i=1; i<=8; i++) {
			for(int j=1; j<=8; j++) {
				int cursor = i*10 + j;
				if(boardStatus.get(cursor) != null && boardStatus.get(cursor).getGrade() == 5 && boardStatus.get(cursor).isBw() == cpTO.isBw()) {
					positionOfKing = cursor;
					break;
				}
			}
		}

		// 2. 체크 시뮬레이션
		for(int possibleMove : this.possibleMoves) {
			// 가능한 위치로 이동한다고 상정, boardStatus 수정
			HashMap<Integer, ChessPieceTO> modifiedBoardStatus = (HashMap<Integer, ChessPieceTO>) boardStatus.clone(); 
			modifiedBoardStatus.put(possibleMove, cpTO);
			modifiedBoardStatus.put(cpTO.getPosition(), null);
			if(cpTO.getGrade() == 5) {
				positionOfKing = possibleMove;
			}
			// 잠재적 위험요소
			ChessPieceTO candidate = null;
			// possibleMove 의 안전 여부
			boolean isSafe = true; 
			
			// 상대방의 폰으로부터 안전한가?
			if(cpTO.isBw()) {
				// 킹의 진영이 흑인 경우
				if(modifiedBoardStatus.get(positionOfKing - 11) != null) {
					candidate = modifiedBoardStatus.get(positionOfKing - 11);
					if(candidate.getGrade() == 0 && !candidate.isBw()) {
						isSafe = false;
					}
				} 
				if(modifiedBoardStatus.get(positionOfKing - 9) != null) {
					candidate = modifiedBoardStatus.get(positionOfKing - 9);
					if(candidate.getGrade() == 0 && !candidate.isBw()) {
						isSafe = false;
					}
				}
			}else {
				// 킹의 진영이 백인 경우
				if(modifiedBoardStatus.get(positionOfKing + 11) != null) {
					candidate = modifiedBoardStatus.get(positionOfKing + 11);
					if(candidate.getGrade() == 0 && candidate.isBw()) {
						isSafe = false;
					}
				}
				if(modifiedBoardStatus.get(positionOfKing + 9) != null) {
					candidate = modifiedBoardStatus.get(positionOfKing + 9);
					if(candidate.getGrade() == 0 && candidate.isBw()) {
						isSafe = false;
					}
				}
			}
			
			// 상대방의 나이트로부터 안전한가?
			if(isSafe && modifiedBoardStatus.get(positionOfKing + 8) != null) {
				candidate = modifiedBoardStatus.get(positionOfKing + 8);
				if(candidate.getGrade() == 1 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				} 
			} 
			if(isSafe && modifiedBoardStatus.get(positionOfKing - 12) != null) {
				candidate = modifiedBoardStatus.get(positionOfKing - 12);
				if(candidate.getGrade() == 1 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
			}
			if(isSafe && modifiedBoardStatus.get(positionOfKing + 19) != null) {
				candidate = modifiedBoardStatus.get(positionOfKing + 19);
				if(candidate.getGrade() == 1 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
			}
			if(isSafe && modifiedBoardStatus.get(positionOfKing + 21) != null) {
				candidate = modifiedBoardStatus.get(positionOfKing + 21);
				if(candidate.getGrade() == 1 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
			}
			if(isSafe && modifiedBoardStatus.get(positionOfKing + 12) != null) {
				candidate = modifiedBoardStatus.get(positionOfKing + 12);
				if(candidate.getGrade() == 1 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
			}
			if(isSafe && modifiedBoardStatus.get(positionOfKing - 8) != null) {
				candidate = modifiedBoardStatus.get(positionOfKing - 8);
				if(candidate.getGrade() == 1 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
			}
			if(isSafe && modifiedBoardStatus.get(positionOfKing - 19) != null) {
				candidate = modifiedBoardStatus.get(positionOfKing - 19);
				if(candidate.getGrade() == 1 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
			}
			if(isSafe && modifiedBoardStatus.get(positionOfKing - 21) != null) {
				candidate = modifiedBoardStatus.get(positionOfKing - 21);
				if(candidate.getGrade() == 1 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
			}

			// 상대방의 비숍으로부터 안전한가?
			if(isSafe) {
				// 좌 상 방향 
				int count1 = 1;
				while(true) {
					int candidatePosition = positionOfKing + count1*9;
					int candidatePositionCol = candidatePosition % 10;
					int candidatePositionRow = candidatePosition / 10;
					if(candidatePositionCol < 1 || candidatePositionRow > 8) {
						break;
					}
					candidate = modifiedBoardStatus.get(candidatePosition);
					if(candidate != null) {
						if((candidate.getGrade() == 2 || candidate.getGrade() == 4) && candidate.isBw() != cpTO.isBw()) {
							isSafe = false;
						}
						break;
					}
					
					count1 ++;
				}
				
				// 우 상 방향
				if(isSafe) {
					int count2 = 1;
					while(true) {
						int candidatePosition = positionOfKing + count2*11;
						int candidatePositionCol = candidatePosition % 10;
						int candidatePositionRow = candidatePosition / 10;
						if(candidatePositionCol > 8 || candidatePositionRow > 8) {
							break;
						}
						candidate = modifiedBoardStatus.get(candidatePosition);
						if(candidate != null) {
							if((candidate.getGrade() == 2 || candidate.getGrade() == 4) && candidate.isBw() != cpTO.isBw()) {
								isSafe = false;
							}
							break;
						}
						
						count2 ++;
					}
				}
				
				// 좌 하 방향
				if(isSafe) {
					int count3 = 1;
					while(true) {
						int candidatePosition = positionOfKing - count3*11;
						int candidatePositionCol = candidatePosition % 10;
						int candidatePositionRow = candidatePosition / 10;
						if(candidatePositionCol < 1 || candidatePositionRow < 1) {
							break;
						}
						candidate = modifiedBoardStatus.get(candidatePosition);
						if(candidate != null) {
							if((candidate.getGrade() == 2 || candidate.getGrade() == 4) && candidate.isBw() != cpTO.isBw()) {
								isSafe = false;
							}
							break;
						}
						
						count3 ++;
					}
				}
				
				// 우 하 방향
				if(isSafe) {
					int count4 = 1;
					while(true) {
						int candidatePosition = positionOfKing - count4*9;
						int candidatePositionCol = candidatePosition % 10;
						int candidatePositionRow = candidatePosition / 10;
						if(candidatePositionCol > 8 || candidatePositionRow < 1) {
							break;
						}
						candidate = modifiedBoardStatus.get(candidatePosition);
						if(candidate != null) {
							if((candidate.getGrade() == 2 || candidate.getGrade() == 4) && candidate.isBw() != cpTO.isBw()) {
								isSafe = false;
							}
							break;
						}
						
						count4 ++;
					}
				}
			}
			
			// 상대방의 룩으로부터 안전한가?
			if(isSafe) {
				// 상
				int count5 = 1;
				while(true) {
					int candidatePosition = positionOfKing + count5*10;
					int candidatePositionRow = candidatePosition / 10;
					if(candidatePositionRow > 8) {
						break;
					}
					candidate = modifiedBoardStatus.get(candidatePosition);
					if(candidate != null) {
						if((candidate.getGrade() == 3 || candidate.getGrade() == 4) && candidate.isBw() != cpTO.isBw()) {
							isSafe = false;
						}
						break;
					}	
					
					count5 ++;
				}
				// 하
				if(isSafe) {
					int count6 = 1;
					while(true) {
						int candidatePosition = positionOfKing - count6*10;
						int candidatePositionRow = candidatePosition / 10;
						if(candidatePositionRow < 1) {
							break;
						}
						candidate = modifiedBoardStatus.get(candidatePosition);
						if(candidate != null) {
							if((candidate.getGrade() == 3 || candidate.getGrade() == 4) && candidate.isBw() != cpTO.isBw()) {
								isSafe = false;
							}
							break;
						}
						
						count6 ++;
					}
				}
				// 좌
				if(isSafe) {
					int count7 = 1;
					while(true) {
						int candidatePosition = positionOfKing - count7;
						int candidatePositionCol = candidatePosition % 10;
						if(candidatePositionCol < 1) {
							break;
						}
						candidate = modifiedBoardStatus.get(candidatePosition);
						if(candidate != null) {
							if((candidate.getGrade() == 3 || candidate.getGrade() == 4) && candidate.isBw() != cpTO.isBw()) {
								isSafe = false;
							}
							break;
						}
						
						count7 ++;
					}
				}
				// 우
				if(isSafe) {
					int count8 = 1;
					while(true) {
						int candidatePosition = positionOfKing + count8;
						int candidatePositionCol = candidatePosition % 10;
						if(candidatePositionCol > 8) {
							break;
						}
						candidate = modifiedBoardStatus.get(candidatePosition);
						if(candidate != null) {
							if((candidate.getGrade() == 3 || candidate.getGrade() == 4) && candidate.isBw() != cpTO.isBw()) {
								isSafe = false;
							}
							break;
						}
						
						count8 ++;
					}
				}
			}
			
			// 상대방의 퀸으로부터 안전한가?
			if(isSafe) {
				// 룩 + 비숍에서 처리
			}
			
			// 상대방의 킹으로부터 안전한가?
			if(isSafe) {
				// 상
				candidate = modifiedBoardStatus.get(positionOfKing + 10);
				if(candidate != null && candidate.getGrade() == 5 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
				
				// 하
				candidate = modifiedBoardStatus.get(positionOfKing - 10);
				if(candidate != null && candidate.getGrade() == 5 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
				
				// 좌
				candidate = modifiedBoardStatus.get(positionOfKing - 1);
				if(candidate != null && candidate.getGrade() == 5 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
				
				// 우
				candidate = modifiedBoardStatus.get(positionOfKing + 1);
				if(candidate != null && candidate.getGrade() == 5 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
				
				// 우상
				candidate = modifiedBoardStatus.get(positionOfKing + 11);
				if(candidate != null && candidate.getGrade() == 5 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
				
				// 우하
				candidate = modifiedBoardStatus.get(positionOfKing - 9);
				if(candidate != null && candidate.getGrade() == 5 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
				
				// 좌하
				candidate = modifiedBoardStatus.get(positionOfKing - 11);
				if(candidate != null && candidate.getGrade() == 5 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
				
				// 좌상
				candidate = modifiedBoardStatus.get(positionOfKing + 9);
				if(candidate != null && candidate.getGrade() == 5 && candidate.isBw() != cpTO.isBw()) {
					isSafe = false;
				}
			}
			
			// 모든 경우에 상대 기물로부터의 체크에서 안전하다면 리턴할 결과에 추가
			if(isSafe) {
				if(cpTO.getGrade() == 5 && Math.abs(cpTO.getPosition() - possibleMove) == 2) {
					// 킹 캐슬링하는 경우 추가
					if(result.contains(cpTO.getPosition())) {
						if(cpTO.getPosition() - possibleMove == 2) {
							if(result.contains(cpTO.getPosition() - 1)) {
								result.add(possibleMove);
							}	
						}
						if(cpTO.getPosition() - possibleMove == -2) {
							if(result.contains(cpTO.getPosition() + 1)) {
								result.add(possibleMove);
							}
						}
					}
				}else {
					result.add(possibleMove);
				}
			}
		}

		// 현재 체크상태 판별을 위해 집어넣은 확인용 데이터 제거
		if(cpTO.getGrade() == 5 && result.contains(cpTO.getPosition())) {
			result.remove(result.indexOf(cpTO.getPosition()));
		}
	
		return result;
	}
	
}
