package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Select;

import com.example.model.inquiry.InquiryTO;

public interface InquiryMapperInter {
	@Select("select i.seq seq, senderSeq, date_format(wdate, '%Y-%m-%d') wdate, subject, content, status, inquiryType, m.nickname writer "
			+ "from inquiry i, member m where i.senderSeq=m.seq")
	public ArrayList<InquiryTO> inquiryList();
}
