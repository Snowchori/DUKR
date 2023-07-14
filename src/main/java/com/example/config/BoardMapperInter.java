package com.example.config;

import java.util.ArrayList;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import com.example.model.board.BoardListTO;
import com.example.model.board.BoardTO;

public interface BoardMapperInter {	
	// 게시판 파일이름 가져오기
	@Select("select filename from file where boardSeq = #{seq}")
	public ArrayList<String> boardFile(String seq);
	
	// 공지글 최근 2개 가져오기
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from board b, member m where boardType = 0 and not b.isDel and b.memSeq=m.seq order by seq desc limit 2")
	public ArrayList<BoardTO> announceListTwo();
	
	// 게시글 목록 가져오기
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from board b, member m where boardType = #{boardType} and ${query} not b.isDel and b.memSeq=m.seq order by seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<BoardTO> boardList(BoardListTO listTO);
	
	// 게시글 전체수 가져오기
	@Select("select count(*) from board b, member m where boardType = #{boardType} and ${query} not b.isDel and b.memSeq=m.seq")
	public int boardListTotal(BoardListTO listTO);
	
	//마이페이지 내가쓴 board리스트 가져오기
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from board b, member m where not b.isDel and m.nickname=#{keyWord} and b.memSeq=m.seq order by seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<BoardTO> myboardWrite(BoardListTO listTO);
	
	//마이페이지 내가쓴 board갯수 가져오기
	@Select("select count(*) from board b, member m where m.nickname=#{keyWord} and not b.isDel and b.memSeq=m.seq")
	public int myboardWriteTotal(BoardListTO listTO);
	
	//마이페이지 내가 좋아요한 board 갯수 가져오기
	@Select("select count(*) from boardrecommend where memSeq=#{keyWord}")
	public int myfavboardTotal(BoardListTO listTO);
	
	//마이페이지 내가 좋아요한 board리스트 가져오기
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from boardrecommend r, member m, board b where not b.isDel and r.memSeq=#{keyWord} and r.boardSeq=b.Seq and b.memSeq=m.Seq order by b.seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<BoardTO> myfavboard(BoardListTO listTO);
	
	// 글쓰기
	@Insert("insert into board values(0, #{memSeq}, #{subject}, #{content}, #{wip}, now(), 0, 0, 0, 0, #{tag}, #{boardType})")
	public int writeNew(BoardTO to);
	
	// seq로 글정보 가저오기
	@Select("select * from board where seq=#{seq}")
	public BoardTO boardView(BoardTO to);
	
}
