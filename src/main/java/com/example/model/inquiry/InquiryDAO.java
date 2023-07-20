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
}
