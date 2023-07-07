package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BoardTO {
	private String seq;
	private String memSeq;
	private String subject;
	private String content;
	private String wip;
	private String wdate;
	private String hit;
	private String recCnt;
	private String cmtCnt;
	private boolean isDel;
	private String tag;
	private String boardType;
	private boolean hasFile;
	private String writer;
}
