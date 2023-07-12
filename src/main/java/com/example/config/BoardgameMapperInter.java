package com.example.config;

import java.util.ArrayList;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.boardgame.BoardgameTO;

public interface BoardgameMapperInter {
	// 보드게임 정보 가져오기
	@Select("select seq, title, imageUrl, yearpublished, minPlayer, maxPlayer, minPlaytime, maxPlaytime,"
			+ "minAge, brief, hit, recCnt, evalCnt, theme, genre, isModi, bgColor from boardgame where seq = #{seq}")
	public BoardgameTO gameInfo(BoardgameTO to);
	
	// 보드게임 정보 삽입
	@Insert("insert into boardgame values(#{seq}, #{title}, #{imageUrl}, #{yearpublished},"
			+ "#{minPlayer}, #{maxPlayer}, #{minPlaytime}, #{maxPlaytime}, #{minAge}, #{brief},"
			+ "0, 0, 0, #{theme}, #{genre}, #{isModi}, #{bgColor})")
	public int gameInsert(BoardgameTO to);
	
	// 보드게임 배경색 삽입
	@Update("update boardgame set bgColor = #{bgColor} where seq = #{seq}")
	public int gameBgColorInsert(BoardgameTO to);
	
	// 보드게임 조회수 증가
	@Update("update boardgame set hit = hit + 1 where seq = #{seq} ")
	public int hitUp(BoardgameTO to);
	
	// 보드게임 즐겨찾기 추가
	@Insert("insert into favorites values(#{memSeq}, #{gameSeq})")
	public int gameFavoriteInsert(Map<String, String> map);
	
	// 보드게임 즐겨찾기 삭제
	@Delete("delete from favorites where memSeq=#{memSeq} and gameSeq=#{gameSeq}")
	public int gameFavoriteDelete(Map<String, String> map);
	
	// 평가수 증가
	@Update("update boardgame set evalCnt = evalCnt + 1 where seq=#{seq}")
	public int gameEvalCntUp(String seq);
	
	// 평가수 감소
	@Update("update boardgame set evalCnt = evalCnt - 1 where seq=#{seq}")
	public int gameEvalCntDown(String seq);
	
	// 보드게임 추천 추가
	@Insert("insert into gamerecommend values(#{gameSeq}, #{memSeq})")
	public int gameRecommendInsert(Map<String, String> map);
	
	// 보드게임 추천 삭제
	@Delete("delete from gamerecommend where gameSeq=#{gameSeq} and memSeq=#{memSeq}")
	public int gameRecommendDelete(Map<String, String> map);
	
	// 보드게임 추천수 증가
	@Update("update boardgame set recCnt = recCnt + 1 where seq=#{seq}")
	public int gameRecCntUp(String seq);
	
	// 보드게임 추천수 감소
	@Update("update boardgame set recCnt = recCnt - 1 where seq=#{seq}")
	public int gameRecCntDown(String seq);
	
	// 정렬된 보드게임 목록 가져오기
	@Select("select seq, title, imageUrl, yearpublished, minPlayer, maxPlayer, minPlaytime, maxPlaytime,"
			+ "minAge, brief, theme, genre, isModi, bgColor from boardgame order by ${sort} desc")
	public ArrayList<BoardgameTO> gameList(String sort);
	
	// 보드게임 정보 수정
	@Update("update boardgame set brief = #{brief}, theme = #{theme}, genre=#{genre}, isModi=true where seq = #{seq}")
	public int gameInfoModify(BoardgameTO to);
	
	// 추천 보드게임 초기화
	@Delete("delete from recommend")
	public int gameRecClear();
	
	// 추천 보드게임 추가
	@Insert("insert into recommend values(0, #{seq})")
	public int gameRecInsert(String seq);
	
	// 추천 보드게임 목록 가져오기
	@Select("select gameSeq from recommend")
	public ArrayList<String> gameRecList();
	
	// 보드게임 장르 가져오기
	@Select("select genre from boardgame where seq = #{gameId}")
	public String genreSearch(String gameId);
	
	// 즐겨찾기한 보드게임 목록
	@Select("select gameSeq from favorites where memSeq = #{userSeq}")
	public ArrayList<String> gameFavList(String userSeq);
	
	// 메인페이지 즐겨찾기한 보드게임 목록
	@Select("select gameSeq from favorites where memSeq = #{userSeq} limit 0, 6")
	public ArrayList<String> gameMainFavList(String userSeq);
	
	// 메인페이지 보드게임 목록
	@Select("select seq, title, imageUrl, yearpublished, minPlayer, maxPlayer, minPlaytime, maxPlaytime,"
			+ "minAge, brief, hit, recCnt, evalCnt, theme, genre, isModi from boardgame order by yearpublished desc limit 0, 6")
	public ArrayList<BoardgameTO> gameMainList();
}
