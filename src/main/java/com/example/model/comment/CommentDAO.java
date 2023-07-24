package com.example.model.comment;

import java.util.ArrayList;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.CommentMapperInter;

@Repository
public class CommentDAO {
	@Autowired
	private CommentMapperInter commentMapperInter;
	
	//마이페이 내가 쓴 댓글 목록
	public CommentListTO mycommentList(CommentListTO listTO) {
		listTO.setTotalRecord(commentMapperInter.mycommentWriteTotal(listTO));
		listTO.setSkip();
		listTO.setCommentList(commentMapperInter.mycommentWrite(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		return listTO;
	}
	
	// seq로 특정 댓글정보 가져오기
	public CommentTO getCmtInfoBySeq(CommentTO to) {
		to = commentMapperInter.getCmtInfoBySeq(to);
		return to;
	}
	
	// 자유게시판 뷰 - 댓글목록
	public ArrayList<CommentTO> boardCommentList(String boardSeq){
		ArrayList<CommentTO> commentList = commentMapperInter.boardCommentList(boardSeq);
		return commentList;
	}
	
	// 자유게시판 뷰 - 댓글쓰기
	public int boardCommentWrite(CommentTO to) {
		int result = commentMapperInter.boardCommentWrite(to);
		commentMapperInter.boardCmtCntPlus(to.getBoardSeq());
		return result;
	}
	
	// 댓글 추천여부 검사
	public int commentRecCheck(String memSeq, String cmtSeq) {
		int result = commentMapperInter.commentRecCheck(memSeq, cmtSeq);
		return result;
	}
	
	// 댓글 추천하기
	public int commentRec(String memSeq, String cmtSeq) {
		int result = commentMapperInter.commentRec(memSeq, cmtSeq);
		commentMapperInter.recCntPlus(cmtSeq);
		return result;
	}
	
	// 댓글 추천해제하기
	public int commentRecCancel(String memSeq, String cmtSeq) {
		int result = commentMapperInter.commentRecCancel(memSeq, cmtSeq);
		commentMapperInter.recCntMinus(cmtSeq);
		return result;
	}
	
	// ajax응답용 추천수 가져오기
	public int getRecCnt(String seq) {
		int result = commentMapperInter.getRecCnt(seq);
		return result;
	}
	
	// 댓글 삭제하기
	public int commentDelete(String commentSeq, String boardSeq) {
		int result = commentMapperInter.commentDelete(commentSeq);
		commentMapperInter.boardCmtCntMinus(boardSeq);
		return result;
	}
	
	// 해당 게시글의 모든 댓글 삭제 처리
	public int allCommentDelete(String boardSeq) {
		int flag = 1;	// 0 : 정상 , 1 : 비정상
		int result = commentMapperInter.allCommentDelete(boardSeq);

		if(result >= 0) {
			result = commentMapperInter.boardCmtCntReset(boardSeq);
		}
		
		if(result == 1 ) {
			flag = 0;
		}	

		return flag;
	}
	
	// 댓글 삭제하기
	public int modifyComment(String seq, String content) {
		int result = commentMapperInter.modifyComment(seq, content);
		return result;
	}
}
