package com.example.config;

import java.util.ArrayList;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.BoardgameTO;

public interface BoardgameMapperInter {
	@Select("select seq, title, imageUrl, yearpublished, minPlayer, maxPlayer, minPlaytime, maxPlaytime,"
			+ "minAge, brief, hit, recCnt, evalCnt, theme, genre, isModi from boardgame where seq = #{seq}")
	public BoardgameTO gameInfo(BoardgameTO to);
	
	@Insert("insert into boardgame values(#{seq}, #{title}, #{imageUrl}, #{yearpublished},"
			+ "#{minPlayer}, #{maxPlayer}, #{minPlaytime}, #{maxPlaytime}, #{minAge}, #{brief},"
			+ "0, 0, 0, #{theme}, #{genre}, #{isModi})")
	public int gameInsert(BoardgameTO to);
	
	@Update("update boardgame set hit = hit + 1 where seq = #{seq} ")
	public int hitUp(BoardgameTO to);
	
	@Insert("insert into favorites values(#{memSeq}, #{gameSeq})")
	public int gameFavoriteInsert(Map<String, String> map);
	
	@Delete("delete from favorites where memSeq=#{memSeq} and gameSeq=#{gameSeq}")
	public int gameFavoriteDelete(Map<String, String> map);
	
	@Update("update boardgame set evalCnt = evalCnt + 1 where seq=#{seq}")
	public int gameEvalCntUp(String seq);
	
	@Update("update boardgame set evalCnt = evalCnt - 1 where seq=#{seq}")
	public int gameEvalCntDown(String seq);
	
	@Insert("insert into gamerecommend values(#{gameSeq}, #{memSeq})")
	public int gameRecommendInsert(Map<String, String> map);
	
	@Delete("delete from gamerecommend where gameSeq=#{gameSeq} and memSeq=#{memSeq}")
	public int gameRecommendDelete(Map<String, String> map);
	
	@Update("update boardgame set recCnt = recCnt + 1 where seq=#{seq}")
	public int gameRecCntUp(String seq);
	
	@Update("update boardgame set recCnt = recCnt - 1 where seq=#{seq}")
	public int gameRecCntDown(String seq);
	
	@Select("select seq, title, imageUrl, yearpublished, minPlayer, maxPlayer, minPlaytime, maxPlaytime,"
			+ "minAge, brief, theme, genre, isModi from boardgame")
	public ArrayList<BoardgameTO> gameList();
	
	@Update("update boardgame set brief = #{brief}, theme = #{theme}, genre=#{genre}, isModi=true where seq = #{seq}")
	public int gameInfoModify(BoardgameTO to);
	
	@Delete("delete from recommend")
	public int gameRecClear();
	
	@Insert("insert into recommend values(0, #{seq})")
	public int gameRecInsert(String seq);
	
	@Select("select gameSeq from recommend")
	public ArrayList<String> gameRecList();
	
	@Select("select genre from boardgame where seq = #{gameId}")
	public String genreSearch(String gameId);
}
