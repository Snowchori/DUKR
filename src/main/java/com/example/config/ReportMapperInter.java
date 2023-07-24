package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.logs.LogListTO;
import com.example.model.report.ReportListTO;
import com.example.model.report.ReportTO;

public interface ReportMapperInter {
	// 신고글 목록 가져오기
	@Select("select r.seq seq, boardSeq, commentSeq, r.memSeq memSeq, r.content content, status, date_format(rdate, '%Y-%m-%d %T') rdate, m.nickname writer, r.answer answer, processType, b.isDel isBoardDel "
			+ "from report r, member m, board b where r.memSeq=m.seq and b.seq=r.boardSeq ${query}"
			+ " order by seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<ReportTO> reportList(ReportListTO listTO);
	
	// 신고글 답변
	@Update("update report set answer=#{answer}, status=1, processType=#{processType} where seq=#{seq}")
	public int reportAnswerWriteOk(ReportTO to);
	
	// 신고글 전체수 가져오기
	@Select("select count(*) from report r, member m, board b where r.memSeq=m.seq and b.seq=r.boardSeq ${query}")
	public int reportListTotal(ReportListTO listTO);
	
	// 신고글 등록
	@Insert("insert into report values(0, #{boardSeq}, #{commentSeq}, #{memSeq}, #{content}, 0, now(), '', '')")
	public int newReport(ReportTO to);
}
