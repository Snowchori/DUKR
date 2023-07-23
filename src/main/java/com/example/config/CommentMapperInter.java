package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
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
	
	// 댓글쓰고 cmtCnt +1
	@Update("update board set cmtCnt=cmtCnt+1 where seq=#{seq}")
	public int boardCmtCntPlus(String seq);
	
	// 댓글 추천여부 검사
	@Select("select count(*) from commentrecommend where memSeq=#{memSeq} and cmtSeq=#{cmtSeq}")
	public int commentRecCheck(String memSeq, String cmtSeq);
	
	// 댓글 추천하기 
	@Insert("insert into commentrecommend values(#{memSeq}, #{cmtSeq})")
	public int commentRec(String memSeq, String cmtSeq);
	
	// 댓글 추천해제하기 
	@Delete("delete from commentrecommend where memSeq=#{memSeq} and cmtSeq=#{cmtSeq}")
	public int commentRecCancel(String memSeq, String cmtSeq);
	
	// 댓글 삭제하기
	@Delete("delete from comment where seq=#{seq}")
	public int commentDelete(String seq);
	
	// 해당 게시글의 모든 댓글 삭제 처리
	@Update("update comment set isDel = 1 where boardSeq=#{boardSeq}")
	public int allCommentDelete(String boardSeq);
	
	// 댓글 수정하기
	@Update("update comment set content=#{content} where seq=#{seq}")
	public int modifyComment(String seq, String content);
	
	// 댓글 삭제하고 cmtCnt -1
	@Update("update board set cmtCnt=cmtCnt-1 where seq=#{seq}")
	public int boardCmtCntMinus(String seq);
	
	// 댓글 전체 삭제처리 board의 cmtCnt 초기화
	@Update("update board set cmtCnt=0 where seq=#{boardSeq}")
	public int boardCmtCntReset(String boardSeq);
	
	// 댓글 추천카운트 +1
	@Update("update comment set recCnt=recCnt+1 where seq=#{seq}")
	public int recCntPlus(String seq);
	
	// 댓글 추천카운트 -1
	@Update("update comment set recCnt=recCnt-1 where seq=#{seq}")
	public int recCntMinus(String seq);
	
	// ajax응답용 추천수 가져오기
	@Select("select recCnt from comment where seq=#{seq}")
	public int getRecCnt(String seq);
	
	// seq로 특정댓글 정보 가져오기
	@Select("select c.seq seq, c.content content, m.nickname writer from comment c inner join member m on c.memSeq=m.seq where c.seq=#{seq}")
	public CommentTO getCmtInfoBySeq(CommentTO to);
}
