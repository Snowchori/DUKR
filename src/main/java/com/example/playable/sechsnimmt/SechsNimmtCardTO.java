package com.example.playable.sechsnimmt;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SechsNimmtCardTO {
	private int cardNumber;
	private int penalty;
	
	// 생성자
	public SechsNimmtCardTO(int number) {
		this.cardNumber = number;
		this.penalty = 1;
	}
}
