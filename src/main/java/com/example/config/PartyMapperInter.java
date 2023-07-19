package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.ResultMap;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

import com.example.model.board.BoardTO;
import com.example.model.party.ApiPartyTO;
import com.example.model.party.ApplyTO;
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
	@Insert("insert into party values(0, #{boardSeq}, #{address}, #{detail}, #{location}, #{date}, #{desired}, 0, #{loccode}, #{latitude}, #{longitude})")
	int registerPartyOk(PartyTO to);
	
	/* 모임 신청 여부 확인 */
	@Select("select status from apply where senderSeq=#{senderSeq} and partySeq=#{partySeq}")
	Integer isApplied(ApplyTO to);
	
	/* 모임 신규 신청 */
	@Insert("insert into apply values(#{senderSeq}, #{partySeq}, 1)")
	int applyPartyOK(ApplyTO to);
	
	/* 모임 신청 | 취소*/
	@Update("update apply set status=#{status} where senderSeq=#{senderSeq} and partySeq=#{partySeq}")
	int togglePartyOK(ApplyTO to);
}
