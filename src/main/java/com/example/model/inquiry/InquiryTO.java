package com.example.model.inquiry;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class InquiryTO {
	private String seq;
	private String senderSeq;
	private String writer;
	private String wdate;
	private String subject;
	private String content;
	private int status;
	private String inquiryType;
}
