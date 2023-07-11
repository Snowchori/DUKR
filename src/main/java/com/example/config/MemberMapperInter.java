package com.example.config;

import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.member.MemberTO;

public interface MemberMapperInter {
	// 회원이 게임 추천했는지
	@Select("select gameSeq from gamerecommend where gameSeq = #{gameSeq} and memSeq = #{memSeq}")
	public String isRecommend(Map<String, String> map);
	
	// 회원이 게임 즐겨찾기했는지
	@Select("select gameSeq from favorites where gameSeq = #{gameSeq} and memSeq = #{memSeq}")
	public String isFavorites(Map<String, String> map);
	
	// 일반로그인
	@Select("select seq, id, nickname, email, rate, isAdmin from member where id=#{id} and password=#{password}")
	public abstract MemberTO login(MemberTO to);
	
	// seq로 회원정보 가져오기
	@Select("select id, nickname, email, rate, isAdmin from member where seq=#{seq}")
	public abstract MemberTO memberinfoGet(String seq);
	
	// 일반유저 회원가입
	@Insert("insert into member values(0, #{hintSeq}, #{id}, #{password}, #{nickname}, #{email}, #{answer}, #{rate}, false, null)") 
	public abstract int newUser(MemberTO to);
	
	// 회원가입 시 아이디 중복확인
	@Select("select count(*) from member where id=#{id}")
	public abstract int duplCheck(String id);
	
	// 비밀번호 찾기
	@Select("select seq from member where id=#{id} and hintSeq=#{hintSeq} and answer=#{answer}")
	public abstract MemberTO findPassword(MemberTO to);
	
	// 비밀번호 변경
	@Update("update member set password=#{password} where seq=#{seq}")
	public abstract int newPassword(MemberTO to);
	
	// 아이디 찾기
	@Select("select seq, email, id from member where email=#{email}")
	public abstract MemberTO findId(MemberTO to);
	
	// 카카오 소셜로그인시 유저정보 가져오기
	@Select("select seq, id, nickname, rate, isAdmin from member where uuid=#{uuid}")
	public abstract MemberTO trySocialLogin(MemberTO to);
	
	// 카카오 소셜로그인시 유저정보 업데이트
	@Update("update member set nickname=#{nickname}, email=#{email} where seq=#{seq}")
	public abstract int updateSocialAccount(MemberTO to);
	
	// trySocialLogin()시도 후 리턴값이 null일때(사이트에 최초 소셜로그인한 계정인 경우)
	@Insert("insert into member values(0, #{hintSeq}, null, #{password}, #{nickname}, #{email}, #{answer}, #{rate}, false, #{uuid})")
	public int firstVisit(MemberTO to);
	
	// 이메일 중복확인
	@Select("select count(*) from member where email=#{email}")
	public int emailDuplCheck(String email);
	
	// 닉네임 중복확인
	@Select("select count(*) from member where nickname=#{nickname}")
	public int nicknameDuplCheck(String nickname);

	// 비밀번호 확인
	@Select("select count(*) from member where id=#{id} and password=#{password}")
	public abstract int memberpasswordCheck(MemberTO to);
	
	// 회원정보 변경
	@Update("update member set nickname=#{nickname}, email=#{email} , password=#{password} where seq=#{seq}")
	public abstract int memberUpdate(MemberTO to);
	
	// 소셜회원가입회원 정보 변경
	@Update("update member set nickname=#{nickname}, email=#{email} where seq=#{seq}")
	public abstract int socialmemberUpdate(MemberTO to);
	
	// 소셜인증시 카카오 소셜아이디 유효성(중복) 검사
	@Select("select count(*) from member where uuid=#{uuid}")
	public abstract int socialAccountValidCheck(String uuid);
	
	// 소셜인증하기(uuid 추가)
	@Update("update member set uuid=#{uuid} where seq=#{seq}")
	public abstract int socialCertificationOk(MemberTO to);
}
