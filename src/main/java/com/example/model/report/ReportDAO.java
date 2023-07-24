package com.example.model.report;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.ReportMapperInter;

@Repository
public class ReportDAO {
	@Autowired
	ReportMapperInter reportMapper;
	
	public ReportListTO reportList(ReportListTO listTO) {
		listTO.setTotalRecord(reportMapper.reportListTotal(listTO));
		listTO.setSkip();
		listTO.setReportLists(reportMapper.reportList(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		return listTO;
	}
	
	public int reportAnswerWriteOk(ReportTO to) {
		int flag = 1;
		int result = reportMapper.reportAnswerWriteOk(to);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// 신고 접수
	public int newReport(ReportTO to) {
		int result = reportMapper.newReport(to);
		System.out.println("신고접수");
		return result;
	}
}
