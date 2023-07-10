package com.example.model.comment;

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
}
