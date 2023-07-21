package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Select;

import com.example.model.report.ReportTO;

public interface ReportMapperInter {
	@Select("select r.seq seq, boardSeq, memSeq, content, status, date_format(rdate, '%Y-%m-%d') rdate, m.nickname writer, r.answer answer, processType "
			+ "from report r, member m where r.memSeq=m.seq")
	public ArrayList<ReportTO> reportList();
}
