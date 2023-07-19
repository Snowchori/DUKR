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
}
