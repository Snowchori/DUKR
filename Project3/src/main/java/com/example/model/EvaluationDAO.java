package com.example.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.BoardgameMapperInter;
import com.example.config.EvaluationMapperInter;

@Repository
@MapperScan( basePackages = { "com.example.config" } )
public class EvaluationDAO {
	@Autowired
	private EvaluationMapperInter evalMapper;
	
	@Autowired
	private BoardgameMapperInter gameMapper;
	
	public ArrayList<EvaluationTO> evalList(String seq) {
		ArrayList<EvaluationTO> lists = evalMapper.evalList(seq);
		
		return lists;
	}
	
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
