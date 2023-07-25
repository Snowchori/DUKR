package com.example.model.evaluation;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.BoardgameMapperInter;
import com.example.config.EvaluationMapperInter;

@Repository
public class EvaluationDAO {
	@Autowired
	private EvaluationMapperInter evalMapper;
	
	@Autowired
	private BoardgameMapperInter gameMapper;
	
	// 평가 목록
	public ArrayList<EvaluationTO> evalList(String seq) {
		ArrayList<EvaluationTO> lists = evalMapper.evalList(seq);
		
		return lists;
	}
	
	// 회원이 평가 추천했는지
	public int isEvalRecoomend(String memSeq, String evalSeq) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("memSeq", memSeq);
		map.put("evalSeq", evalSeq);
		String result = evalMapper.isEvalRecommend(map);
		if(result != null) {
			return 1;
		} else {
			return 2;			
		}
	}
	
	
	// 평점 평균 구하기
	public String evalRateAvg(String seq) {
		return evalMapper.evalRateAvg(seq);
	}
	
	public String evalDifficultyAvg(String seq) {
		return evalMapper.evalDifficultyAvg(seq);
	}
	
	public int evalWriteOk(EvaluationTO to) {
		int flag = 1;
		int result = evalMapper.evalWriteOk(to);
		
		if(result == 1) {
			flag = 0;
			gameMapper.gameEvalCntUp(to.getGameSeq());
		}
		
		return flag;
	}
	
	// 평가 추천 추가
	public int evalRecommendInsertOk(String memSeq, String evalSeq) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("memSeq", memSeq);
		map.put("evalSeq", evalSeq);
		
		int flag = 1;
		int result = evalMapper.evalRecommendInsert(map);
		
		if(result == 1) {
			flag = 0;
			evalMapper.evalRecCntUp(evalSeq);
		}
		
		return flag;
	}
	
	// 평가 추천 삭제
	public int evalRecommendDeleteOk(String memSeq, String evalSeq) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("memSeq", memSeq);
		map.put("evalSeq", evalSeq);
		
		int flag = 1;
		int result = evalMapper.evalRecommendDelete(map);
		
		if(result == 1) {
			flag = 0;
			evalMapper.evalRecCntDown(evalSeq);
		}
		
		return flag;
	}
	
	// 평가 삭제
	public int evalDeleteOk(EvaluationTO to) {
		int flag = 1;
		int result = evalMapper.evalDeleteOk(to);
		
		if(result == 1) {
			flag = 0;
			gameMapper.gameEvalCntDown(to.getGameSeq());
			evalMapper.evalRecommendDeleteAll(to);
		}
		
		return flag;
	}
}
