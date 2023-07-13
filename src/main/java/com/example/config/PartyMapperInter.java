package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;

import com.example.model.board.BoardTO;
import com.example.model.party.ApiPartyTO;
import com.example.model.party.PartyTO;

@Mapper
public interface PartyMapperInter {
	
	/* 모임 정보 반환 */
	String meetsuffix = "select boardSeq, address, location, date_format(wdate, '%m/%d') date, loccode, left(loccode, 2) loccode2, latitude, longitude "
			+ "from party where wdate > now() and desired > participants and loccode ";
	String meetprefix = "order by address, wdate";
	@Select(meetsuffix + "= #{loccode} " + meetprefix)
	ArrayList<ApiPartyTO> getPartiesBySi(String sival);
	@Select(meetsuffix + "like #{loccode} " + meetprefix)
	ArrayList<ApiPartyTO> getPartiesByDo(String doval);
	
	/* 모임 등록 */
	@Insert("insert into board values(0, 1, #{subject}, #{content}, #{wip}, now(), 0, 0, 0, 0, #{tag}, 2)")
	@Options(useGeneratedKeys = true, keyProperty = "seq")
	int registerPartyOk(BoardTO to);
	
	@Insert("insert into party values(0, #{boardSeq}, #{address}, #{detail}, #{location}, #{date}, #{desired}, 0, #{loccode}, #{latitude}, #{longitude})")
	int registerPartyOk2(PartyTO to);
}
