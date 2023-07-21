package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import com.example.model.logs.LogsTO;

public interface LogsMapperInter {
	@Select("select l.seq seq, memSeq, log, ldate, remarks, logType, m.nickname nickname "
			+ "from logs l, member m where l.memSeq=m.seq and nickname like #{keyWord} order by seq desc")
	public ArrayList<LogsTO> logsList(String keyWord);
	
	@Insert("insert into logs values(0, #{memSeq}, #{log}, now(), #{remarks}, #{logType})")
	public int logsWriteOk(LogsTO to);
}