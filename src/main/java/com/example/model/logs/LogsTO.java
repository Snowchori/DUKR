package com.example.model.logs;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class LogsTO {
	private String seq;
	private String memSeq;
	private String log;
	private String ldate;
	private String remarks;
	private String logType;
	private String nickname;
}
