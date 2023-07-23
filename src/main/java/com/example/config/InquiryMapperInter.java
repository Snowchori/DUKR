package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.inquiry.InquiryListTO;
import com.example.model.inquiry.InquiryTO;
import com.example.model.report.ReportListTO;

public interface InquiryMapperInter {
	// 문의 목록 가져오기
	@Select("select i.seq seq, senderSeq, date_format(wdate, '%Y-%m-%d %T') wdate, subject, content, status, inquiryType, i.answer answer, m.nickname writer "
			+ "from inquiry i, member m where i.senderSeq=m.seq ${query} order by seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<InquiryTO> inquiryList(InquiryListTO listTO);
	
	// 문의 답변
	@Update("update inquiry set answer=#{answer}, status=1 where seq=#{seq}")
	public int inquiryAnswerWriteOk(InquiryTO to);
	
	// 문의 전체수 가져오기
	@Select("select count(*) from inquiry i, member m where i.senderSeq=m.seq ${query}")
	public int inquiryListTotal(InquiryListTO listTO);
}
