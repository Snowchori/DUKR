package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

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
	
	// 자유게시판 뷰 - 댓글목록 가져오기
	@Select("select c.seq seq, boardSeq, memSeq, content, wdate, recCnt, wip, isDel, nickname writer from comment c inner join member m on c.memSeq=m.seq where boardSeq=#{boardSeq}")
	public ArrayList<CommentTO> boardCommentList(String boardSeq);
	
	// 자유게시판 뷰 - 댓글쓰기
	@Insert("insert into comment values(0, #{boardSeq}, #{memSeq}, #{content}, now(), 0, #{wip}, 0)")
	public int boardCommentWrite(CommentTO to);
	
	// 댓글 추천여부 검사
	@Select("select count(*) from commentrecommend where memSeq=#{memSeq} and cmtSeq=#{cmtSeq}")
	public int commentRecCheck(String memSeq, String cmtSeq);
	
	// 댓글 추천하기
	@Insert("insert into commentrecommend values(#{memSeq}, #{cmtSeq})")
	public int commentRec(String memSeq, String cmtSeq);
	
	// 댓글 추천카운트 +1
	@Update("update comment set recCnt=recCnt+1 where seq=#{seq}")
	public int recCntPlus(String seq);
}
