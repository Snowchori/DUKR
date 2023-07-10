package com.example.model.comment;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommentTO {
	private String seq;
	private String boardSeq;
	private String memSeq;
	private String content;
	private String wdate;
	private String writer;
	private int recCnt;
	private String wip;
	private boolean isDel;
	
}
