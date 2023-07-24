package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.inquiry.InquiryListTO;
import com.example.model.inquiry.InquiryTO;

public interface InquiryMapperInter {
	@Select("select i.seq seq, senderSeq, date_format(wdate, '%Y-%m-%d %T') wdate, subject, content, status, inquiryType, i.answer answer, m.nickname writer "
			+ "from inquiry i, member m where i.senderSeq=m.seq order by seq desc")
	public ArrayList<InquiryTO> inquiryList();
	
	@Update("update inquiry set answer=#{answer}, status=1 where seq=#{seq}")
	public int inquiryAnswerWriteOk(InquiryTO to);
	
	//유저 문의 작성
	@Insert("insert into inquiry values(0,#{senderSeq},now(),#{subject},#{content},0,#{inquiryType},#{answer})")
	public int inquiryWrite(InquiryTO to);
	
	//마이페이지 내가 쓴 문의글 총 갯수
	@Select("select count(*) from inquiry where senderSeq=#{seq}")
	public int myInquiryTotal(InquiryListTO to);
	
	//마이페이지 내가 쓴 문의글 리스트 가져오기
	@Select("select i.seq seq, date_format(wdate, '%Y-%m-%d') wdate, subject, status, inquiryType, m.nickname writer "
			+ "from inquiry i, member m where i.senderSeq=m.seq order by seq desc")
	public ArrayList<InquiryTO> myInquiryList(InquiryListTO to);
	
	//마이페이지 문의 글 보기
	@Select("select subject, inquiryType, status, content, date_format(wdate, '%Y-%m-%d') wdate, answer from inquiry where seq=#{seq}")
	public InquiryTO inquiryView(String seq);
}
