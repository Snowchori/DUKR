package com.example.model.report;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ReportTO {
	private String seq;
	private String boardSeq;
	private String commentSeq;
	private String memSeq;
	private String writer;
	private String content;
	private String rdate;
	private int status;
	private String answer;
	private String processType;
	private boolean isBoardDel;
	private String targetType;
}
