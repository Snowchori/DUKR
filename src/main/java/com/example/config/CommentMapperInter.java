package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Select;

import com.example.model.comment.CommentListTO;
import com.example.model.comment.CommentTO;

public interface CommentMapperInter {
	
	//마이페이 comment갯수 가져오기
	@Select("select count(*) from comment c, member m where m.nickname=#{keyWord} and not c.isDel and c.memSeq=m.seq")
	public int mycommentWriteTotal(CommentListTO listTO);
	
	//마이페이 comment 리스트 가져오기
	@Select("select boardSeq, content, date_format(wdate, '%Y-%m-%d') wdate, recCnt, wip, m.nickname writer, isDel "
			+ "from comment c, member m where not c.isDel and m.nickname=#{keyWord} and c.memSeq=m.seq order by c.seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<CommentTO> mycommentWrite(CommentListTO listTO);
}
