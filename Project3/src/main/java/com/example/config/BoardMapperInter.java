package com.example.config;

import java.util.ArrayList;
import java.util.Map;

import org.apache.ibatis.annotations.Select;

import com.example.model.BoardListTO;
import com.example.model.BoardTO;

public interface BoardMapperInter {	
	@Select("select filename from file where boardSeq = #{seq}")
	public ArrayList<String> boardFile(String seq);
	
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from board b, member m where boardType = 0 and not b.isDel and b.memSeq=m.seq order by seq desc limit 2")
	public ArrayList<BoardTO> announceListTwo();
	
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from board b, member m where boardType = #{boardType} and ${query} not b.isDel and b.memSeq=m.seq order by seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<BoardTO> boardList(BoardListTO listTO);
	
	@Select("select count(*) from board b, member m where boardType = #{boardType} and ${query} not b.isDel and b.memSeq=m.seq")
	public int boardListTotal(BoardListTO listTO);
	
	//마이페이 board리스트 가져오기
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from board b, member m where not b.isDel and m.nickname=#{keyWord} and b.memSeq=m.seq order by seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<BoardTO> myboardWrite(BoardListTO listTO);
	
	//마이페이 board갯수 가져오기
	@Select("select count(*) from board b, member m where m.nickname=#{keyWord} and not b.isDel and b.memSeq=m.seq")
	public int myboardWriteTotal(BoardListTO listTO);
}
