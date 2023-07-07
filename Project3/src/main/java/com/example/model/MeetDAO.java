package com.example.model;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.MeetingMapperInter;

@Repository
public class MeetDAO {
	@Autowired
	private MeetingMapperInter meetMapper;
	
	/* 모임 정보 반환 */
	public ArrayList<ApiMeetTO> apiMeetings(String loccode) {
		ArrayList<ApiMeetTO> data = null;
		
		if(loccode.length() == 5) {
			data = meetMapper.apiSi(loccode);
		}else {
			data = meetMapper.apiDo(loccode + "%");
		}
		
		return data;
	}
	
	/* 모임 등록 */
	public int registerMeetOk(BoardTO bto, MeetTO mto) {
		int flag = 1;
		
		int result = meetMapper.registerMeetOk(bto);
		if(result == 1) {
			mto.setBoardSeq(bto.getSeq());
			int result2 = meetMapper.registerMeetOk2(mto);
			if(result2 == 1) {
				flag = 0;
			}
		}
		
		return flag;
	}
}
