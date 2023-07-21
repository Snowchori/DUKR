package com.example.model.logs;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.LogsMapperInter;

@Repository
public class LogsDAO {
	@Autowired
	LogsMapperInter logsMapper;
	
	public ArrayList<LogsTO> logsList(String keyWord) {
		ArrayList<LogsTO> lists = logsMapper.logsList(keyWord);
		
		return lists;
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
