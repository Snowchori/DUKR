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
	
	/* 모임 정보 리스트 반환 */
	String meetsuffix = "select boardSeq, address, location, date_format(date, '%m/%d') date, loccode, left(loccode, 2) loccode2, latitude, longitude "
			+ "from party where date > now() and desired > participants and loccode ";
	String meetprefix = "order by address, date";
	
	@Select(meetsuffix + "like #{loccode} " + meetprefix)
	ArrayList<ApiPartyTO> getPartiesByDo(String doval);
	@Select(meetsuffix + "= #{loccode} " + meetprefix)
	ArrayList<ApiPartyTO> getPartiesBySi(String sival);
	
	/* 특정 유저 신청 모임 리스트 반환 */
	@Select("select boardSeq, address, location, date, loccode, left(loccode, 2) loccode2, latitude, longitude, status from party inner join apply on boardSeq=partySeq and senderSeq=#{userSeq} where status!=-1 " + meetprefix)
	ArrayList<ApiPartyTO> getUserParties(String userSeq);
	
	/* 모임 정보 반환 */
	@Select("select address, detail, location, date, desired, participants, latitude, longitude, ifnull(status, 0) status "
			+ "from (select * from party where boardSeq=#{boardSeq}) party left join (select senderSeq, status from apply where partySeq=#{boardSeq}) apply on senderSeq=#{userSeq}")
	PartyTO getParty(String boardSeq, String userSeq);
	
	// 게시글에 해당하는 모임정보
	@Select("select seq, address, location, date, detail, location, desired, latitude, longitude from party where boardSeq=#{boardSeq}")
	public PartyTO getPartyByBoardSeq(PartyTO to);
	
	/* 게시글에 해당하는 지원자 정보 */
	@Select("select senderSeq, nickname, status from apply inner join member on senderSeq=seq and partySeq=#{boardSeq} order by adate desc")
	ArrayList<ApplyTO> getAppliers(String boardSeq);
	
	/* 모임 승인 거부 */
	@Update("update apply set status=#{status} where partySeq=#{partySeq} and senderSeq=#{senderSeq}")
	int changeStatus(ApplyTO ato);
	
	/* 모임 등록 */
	@Insert("insert into party values(0, #{boardSeq}, #{address}, #{detail}, #{location}, #{date}, #{desired}, 0, #{loccode}, #{latitude}, #{longitude})")
	int registerPartyOk(PartyTO to);
	
	/* 모임 신청 여부 확인 */
	@Select("select status from apply where senderSeq=#{senderSeq} and partySeq=#{partySeq}")
	Integer isApplied(ApplyTO to);
	
	/* 모임 신규 신청 */
	@Insert("insert into apply values(#{senderSeq}, #{partySeq}, 1, now())")
	int applyPartyOK(ApplyTO to);
	
	/* 모임 신청 | 취소*/
	@Update("update apply set status=#{status} where senderSeq=#{senderSeq} and partySeq=#{partySeq}")
	int togglePartyOK(ApplyTO to);
	
	// 모임정보 수정
	@Update("update party set address=#{address}, detail=#{detail}, location=#{location}, date=#{date}, desired=#{desired}, loccode=#{loccode}, latitude=#{latitude}, longitude=#{longitude} where seq=#{seq}")
	public int partyModifyOk(PartyTO to); 
}
