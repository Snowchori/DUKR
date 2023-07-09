package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;

import com.example.model.ApiMeetTO;
import com.example.model.BoardTO;
import com.example.model.MeetTO;

@Mapper
public interface MeetingMapperInter {
	
	/* 모임 정보 반환 */
	String meetsuffix = "select boardSeq, address, location, date_format(wdate, '%m/%d') date, loccode, left(loccode, 2) loccode2, latitude, longitude "
			+ "from meeting where wdate > now() and desired > participants and loccode ";
	String meetprefix = " order by address, wdate";
	@Select(meetsuffix + "= #{loccode}" + meetprefix)
	ArrayList<ApiMeetTO> apiSi(String sival);
	@Select(meetsuffix + "like #{loccode}" + meetprefix)
	ArrayList<ApiMeetTO> apiDo(String doval);
	
	/* 모임 등록 */
	@Insert("insert into board values(0, 1, 'tester', #{content}, #{wip}, now(), 0, 0, 0, 0, '모임')")
	@Options(useGeneratedKeys = true, keyProperty = "seq")
	int registerMeetOk(BoardTO to);
	
	@Insert("insert into meeting values(0, #{boardSeq}, #{address}, #{detail}, #{location}, #{date}, #{desired}, 0, #{loccode}, #{latitude}, #{longitude})")
	int registerMeetOk2(MeetTO to);
	
}
