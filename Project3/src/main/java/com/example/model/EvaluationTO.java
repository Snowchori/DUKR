package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class EvaluationTO {
	private String seq;
	private String gameSeq;
	private String memSeq;
	private String rate;
	private String eval;
	private String recCnt;
	private String difficulty;
	private String wdate;
	private int isEvalRec;
	private String writer;
}
