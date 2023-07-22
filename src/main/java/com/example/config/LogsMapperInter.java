package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import com.example.model.board.BoardListTO;
import com.example.model.logs.LogListTO;
import com.example.model.logs.LogsTO;

public interface LogsMapperInter {
	// 로그 목록 가져오기
	@Select("select l.seq seq, memSeq, log, ldate, remarks, logType, m.nickname nickname "
			+ "from logs l, member m where l.memSeq=m.seq and logType=#{logType} and "
			+ "nickname like #{keyWord} order by seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<LogsTO> logsList(LogListTO listTO);
	
	// 로그 추가
	@Insert("insert into logs values(0, #{memSeq}, #{log}, now(), #{remarks}, #{logType})")
	public int logsWriteOk(LogsTO to);
	
	// 로그 전체수 가져오기
	@Select("select count(*) from logs l, member m where l.memSeq=m.seq and logType=#{logType} and "
			+ "nickname like #{keyWord}")
	public int logListTotal(LogListTO listTO);
}