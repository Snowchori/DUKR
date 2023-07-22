package com.example.model.logs;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.LogsMapperInter;

@Repository
public class LogsDAO {
	@Autowired
	LogsMapperInter logsMapper;
	
	public LogListTO logsList(LogListTO listTO) {
		listTO.setTotalRecord(logsMapper.logListTotal(listTO));
		listTO.setSkip();
		listTO.setLogLists(logsMapper.logsList(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		return listTO;
	}
	
	public int logsWriteOk(LogsTO to) {
		int flag = 1;
		int result = logsMapper.logsWriteOk(to);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
}
