package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.inquiry.InquiryTO;

public interface InquiryMapperInter {
	@Select("select i.seq seq, senderSeq, date_format(wdate, '%Y-%m-%d %T') wdate, subject, content, status, inquiryType, i.answer answer, m.nickname writer "
			+ "from inquiry i, member m where i.senderSeq=m.seq order by seq desc")
	public ArrayList<InquiryTO> inquiryList();
	
	@Update("update inquiry set answer=#{answer}, status=1 where seq=#{seq}")
	public int inquiryAnswerWriteOk(InquiryTO to);
}
