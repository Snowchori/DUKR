package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BoardTO {
	String seq;
	String memSeq;
	String subject;
	String content;
	String wip;
	String wdate;
	String hit;
	String recCnt;
	String cmtCnt;
	boolean isDel;
	String tag;
	boolean hasFile;
	String writer;
}
