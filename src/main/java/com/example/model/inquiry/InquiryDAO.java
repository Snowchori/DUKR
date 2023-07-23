package com.example.model.inquiry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.InquiryMapperInter;

@Repository
public class InquiryDAO {
	@Autowired
	InquiryMapperInter inquiryMapper;
	
	public InquiryListTO inquiryList(InquiryListTO listTO) {
		listTO.setTotalRecord(inquiryMapper.inquiryListTotal(listTO));
		listTO.setSkip();
		listTO.setInquiryLists(inquiryMapper.inquiryList(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		return listTO;
	}
	
	public int inquiryAnswerWriteOk(InquiryTO to) {
		int flag = 1;
		int result = inquiryMapper.inquiryAnswerWriteOk(to);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
}
