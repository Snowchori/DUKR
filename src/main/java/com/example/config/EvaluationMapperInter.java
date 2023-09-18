package com.example.config;

import java.util.ArrayList;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.evaluation.EvaluationTO;

public interface EvaluationMapperInter {
	// 평가 목록 불러오기
	@Select("select e.seq seq, gameSeq, memSeq, e.rate rate, eval, recCnt, difficulty, m.nickname writer, date_format(wdate, '%Y-%m-%d') wdate from evaluation e, member m where gameSeq = #{seq} and e.memSeq = m.seq")
	public ArrayList<EvaluationTO> evalList(String seq);
	
	// 회원이 평가를 추천했는지
	@Select("select memSeq from evaluationrecommend where memSeq = #{memSeq} and evalSeq = #{evalSeq}")
	public String isEvalRecommend(Map<String, String> map);
	
	// 평점 평균 구하기
	@Select("select format(avg(rate), 2) from evaluation where gameSeq = #{seq}")
	public String evalRateAvg(String seq);
	
	// 난이도 평균 구하기
	@Select("select format(avg(difficulty), 2) from evaluation where gameSeq = #{seq}")
	public String evalDifficultyAvg(String seq);
	
	// 평가 쓰기
	@Insert("insert into evaluation values(0, #{gameSeq}, #{memSeq}, #{rate}, #{eval}, 0, #{difficulty}, now())")
	public int evalWriteOk(EvaluationTO to);
	
	// 평가 추천 추가
	@Insert("insert into evaluationrecommend values(#{memSeq}, #{evalSeq})")
	public int evalRecommendInsert(Map<String, String> map);
	
	// 평가 추천 삭제
	@Delete("delete from evaluationrecommend where memSeq=#{memSeq} and evalSeq=#{evalSeq}")
	public int evalRecommendDelete(Map<String, String> map);
	
	// 평가 추천수 증가
	@Update("update evaluation set recCnt = recCnt + 1 where seq=#{seq}")
	public int evalRecCntUp(String seq);
	
	// 평가 추천수 감소
	@Update("update evaluation set recCnt = recCnt - 1 where seq=#{seq}")
	public int evalRecCntDown(String seq);
	
	// 평가 삭제
	@Delete("delete from evaluation where seq=#{seq}")
	public int evalDeleteOk(EvaluationTO to);
	
	// 평가 추천 전부 삭제
	@Delete("delete from evaluationrecommend where evalSeq=#{seq}")
	public int evalRecommendDeleteAll(EvaluationTO to);
}
