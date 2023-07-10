package com.example.model.member;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.MemberMapperInter;

@Repository
public class MemberDAO {
	@Autowired
	private MemberMapperInter memberMapper;
	
	// 게임 추천 여부
	public int isRecommend(String gameSeq, String memSeq) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("gameSeq", gameSeq);
		map.put("memSeq", memSeq);
		String result = memberMapper.isRecommend(map);
		if(result != null) {
			return 1;
		} else {
			return 2;			
		}
	}
	
	// 게임 즐겨찾기 여부
	public int isFavorites(String gameSeq, String memSeq) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("gameSeq", gameSeq);
		map.put("memSeq", memSeq);
		String result = memberMapper.isFavorites(map);
		if(result != null) {
			return 1;
		} else {
			return 2;			
		}
	}
	
	// 멤버 일반로그인
	public MemberTO normalLogin(MemberTO to) {
		to = memberMapper.login(to);
		
		return to;
	}
	
	// 멤버 추가
	public int addMember(MemberTO to) {
		int result = 0;
		result = memberMapper.newUser(to);
		
		return result;
	}
	
	// 회원가입 시 아이디 중복확인
	public int duplCheck(String id) {
		int count = memberMapper.duplCheck(id);
		return count;
	}
	
	// 회원가입 시 이메일 중복확인
	public int emailDuplCheck(String email) {
		int count = memberMapper.emailDuplCheck(email);
		return count;
	}
	
	// 비밀번호 찾기
	public MemberTO findPassword(MemberTO to) {
		to = memberMapper.findPassword(to);
		return to;
	}
	
	// 비밀번호 변경
	public int newPassword(MemberTO to) {
		int result = 0;
		result = memberMapper.newPassword(to);
		
		return result;
	}
	
	// 아이디 찾기
	public MemberTO findId(MemberTO to) {
		to = memberMapper.findId(to);
		return to;
	}
	
	// 소셜로그인 사용자가 DB에 등록되어있는지 확인
	public MemberTO trySocialLogin(MemberTO to) {
		// 소셜로그인한 계정의 DB등록여부 확인
		MemberTO existenceCheck = memberMapper.trySocialLogin(to);
		
		if(existenceCheck != null) {
			// 이미 등록된 사용자의 경우 로그인시 유저정보 업데이트
			memberMapper.updateSocialAccount(to);
			to.setSeq(existenceCheck.getSeq());
		}else {
			// 소셜로그인을 최초로 시도한 계정의 경우 유저정보 추가
			memberMapper.firstVisit(to);
			to = memberMapper.trySocialLogin(to);
		}
		
		// 소셜로그인 시도한 계정 정보와 seq정보를 포함시켜 리턴
		return to;
	}
	
	// 닉네임 중복확인
	public int nicknameDuplCheck(String nickname) {
		int count = memberMapper.nicknameDuplCheck(nickname);
		return count;
	}
	
	// 회원정보 변경
	public int memberUpdate(MemberTO to) {
		int result = memberMapper.memberUpdate(to);
		return result;
	}
	
	// 소셜회원가입유저 정보 변경
	public int socialmemberUpdate(MemberTO to) {
		int result = memberMapper.socialmemberUpdate(to);
		return result;
	}
	
	// 비밀번호 확인
	public int memberpasswordCheck(MemberTO to) {
		int result = memberMapper.memberpasswordCheck(to);
		return result;
	}
	
	//seq로 멤버 정보 가져오기
	public MemberTO memberinfoGet(String seq) {
		MemberTO memberTO = memberMapper.memberinfoGet(seq);
		return memberTO;
	}
}
