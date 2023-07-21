package com.example.model.report;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.ReportMapperInter;

@Repository
public class ReportDAO {
	@Autowired
	ReportMapperInter reportMapper;
	
	public ArrayList<ReportTO> reportList(){
		ArrayList<ReportTO> lists = reportMapper.reportList();
		
		return lists;
	}
	
	public int reportAnswerWriteOk(ReportTO to) {
		int flag = 1;
		int result = reportMapper.reportAnswerWriteOk(to);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
}
