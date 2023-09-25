package com.example.playable.sechsnimmt;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SechsNimmtCardTO {
	// 카드 스펙
	private int cardNumber;
	private int penalty;
	// gameStatus 배열상의 위치
	private int row;
	private int col;
	
	// 생성자
	public SechsNimmtCardTO(int number) {
		this.cardNumber = number;
		this.penalty = 1;
	}
}
