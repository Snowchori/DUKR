package com.example.model.inquiry;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.InquiryMapperInter;

@Repository
public class InquiryDAO {
	@Autowired
	InquiryMapperInter inquiryMapper;

	public ArrayList<InquiryTO> inquiryList(){
		ArrayList<InquiryTO> lists = inquiryMapper.inquiryList();
		
		return lists;
	}
	
	public int inquiryAnswerWriteOk(InquiryTO to) {
		int flag = 1;
		int result = inquiryMapper.inquiryAnswerWriteOk(to);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// 유저 문의 작성
	public int inquiryWrite(InquiryTO to) {
		int flag = inquiryMapper.inquiryWrite(to);
		
		if(flag == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// 마이페이지 문의 내역 목록 보기
	public InquiryListTO myInquiryList(InquiryListTO listTO) {
		listTO.setTotalRecord(inquiryMapper.myInquiryTotal(listTO));
		listTO.setSkip();
		listTO.setInquiryList(inquiryMapper.myInquiryList(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		return listTO;
	}
	
	//a 마이페이지 문의 글 보기
	public InquiryTO inquiryView(String seq) {
		InquiryTO inquiryTO = inquiryMapper.inquiryView(seq);
		
		return inquiryTO;
	}
}
