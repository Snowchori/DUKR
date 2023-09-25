package com.example.playable.sechsnimmt;

import java.util.ArrayList;

import org.springframework.web.socket.WebSocketSession;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SechsNimmtPlayerTO {
	
	private WebSocketSession playerSession;
	private ArrayList<SechsNimmtCardTO> hand;
	private int score;
	private SechsNimmtCardTO pick;
	private String name;
	
	public SechsNimmtPlayerTO(WebSocketSession session) {
		this.playerSession = session;
		this.hand = new ArrayList<>();
		this.name = "익명" + session.getId();
		this.score = 100;
	}
}
