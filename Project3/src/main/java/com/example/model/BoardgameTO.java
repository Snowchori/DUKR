package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BoardgameTO {
	private String seq;
	private String title;
	private String imageUrl;
	private String yearpublished;
	private String minPlayer;
	private String maxPlayer;
	private String minPlaytime;
	private String maxPlaytime;
	private String minAge;
	private String brief;
	private String hit;
	private String recCnt;
	private String evalCnt;
	private String theme;
	private String genre;
	private String difficulty;
	private String rate;
	private boolean isinDB;
	private boolean isModi;
}
