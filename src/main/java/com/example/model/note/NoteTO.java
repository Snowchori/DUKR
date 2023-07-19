package com.example.model.note;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class NoteTO {
	private String seq;
	private String receiverSeq;
	private String senderSeq;
	private String wdate;
	private String subject;
	private String content;
	private int status;
}
