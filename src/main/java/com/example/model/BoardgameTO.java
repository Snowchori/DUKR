package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BoardgameTO {
	String seq;
	String title;
	String imageUrl;
	String yearpublished;
	String minPlayer;
	String maxPlayer;
	String minPlaytime;
	String maxPlaytime;
	String minAge;
	String brief;
	String hit;
	String recCnt;
	String evalCnt;
	String theme;
	String genre;
	String difficulty;
	String rate;
	boolean isinDB;
	boolean isModi;
}
