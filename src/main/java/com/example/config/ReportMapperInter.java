package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.inquiry.InquiryTO;
import com.example.model.report.ReportTO;

public interface ReportMapperInter {
	@Select("select r.seq seq, boardSeq, r.memSeq memSeq, r.content content, status, date_format(rdate, '%Y-%m-%d') rdate, m.nickname writer, r.answer answer, processType, b.isDel isBoardDel "
			+ "from report r, member m, board b where r.memSeq=m.seq and b.seq=r.boardSeq order by seq desc")
	public ArrayList<ReportTO> reportList();
	
	@Update("update report set answer=#{answer}, status=1, processType=#{processType} where seq=#{seq}")
	public int reportAnswerWriteOk(ReportTO to);
}
