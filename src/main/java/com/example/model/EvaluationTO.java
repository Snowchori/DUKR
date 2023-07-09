package com.example.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class EvaluationTO {
	String seq;
	String gameSeq;
	String memSeq;
	String rate;
	String eval;
	String recCnt;
	String difficulty;
	String wdate;
	int isEvalRec;
	String writer;
}
