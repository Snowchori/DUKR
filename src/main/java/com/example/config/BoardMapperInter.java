package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Select;

import com.example.model.BoardTO;

public interface BoardMapperInter {
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from board b, member m where tag = #{tag} and b.memSeq=m.seq")
	public ArrayList<BoardTO> boardListByTag(String tag);
	
	@Select("select filename from file where boardSeq = #{seq}")
	public ArrayList<String> boardFile(String seq);
}
