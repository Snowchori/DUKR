package com.example.config;

import java.util.ArrayList;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.EvaluationTO;

public interface EvaluationMapperInter {
	@Select("select e.seq seq, gameSeq, memSeq, e.rate rate, eval, recCnt, difficulty, m.nickname writer, date_format(wdate, '%Y-%m-%d') wdate from evaluation e, member m where gameSeq = #{seq} and e.memSeq = m.seq")
	public ArrayList<EvaluationTO> evalList(String seq);
	
	@Select("select memSeq from evaluationrecommend where memSeq = #{memSeq} and evalSeq = #{evalSeq}")
	public String isEvalRecommend(Map<String, String> map);
	
	@Select("select format(avg(rate), 2) from evaluation where gameSeq = #{seq}")
	public String evalRateAvg(String seq);
	
	@Select("select format(avg(difficulty), 2) from evaluation where gameSeq = #{seq}")
	public String evalDifficultyAvg(String seq);
	
	@Insert("insert into evaluation values(0, #{gameSeq}, #{memSeq}, #{rate}, #{eval}, 0, #{difficulty}, now())")
	public int evalWriteOk(EvaluationTO to);
	
	@Insert("insert into evaluationrecommend values(#{memSeq}, #{evalSeq})")
	public int evalRecommendInsert(Map<String, String> map);
	
	@Delete("delete from evaluationrecommend where memSeq=#{memSeq} and evalSeq=#{evalSeq}")
	public int evalRecommendDelete(Map<String, String> map);
	
	@Update("update evaluation set recCnt = recCnt + 1 where seq=#{seq}")
	public int evalRecCntUp(String seq);
	
	@Update("update evaluation set recCnt = recCnt - 1 where seq=#{seq}")
	public int evalRecCntDown(String seq);
	
	@Delete("delete from evaluation where seq=#{seq}")
	public int evalDeleteOk(EvaluationTO to);
	
	@Delete("delete from evaluationrecommend where evalSeq=#{seq}")
	public int evalRecommendDeleteAll(EvaluationTO to);
}
