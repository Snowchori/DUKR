package com.example.model.board;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.BoardMapperInter;

@Repository
public class BoardDAO {
	@Autowired
	private BoardMapperInter boardMapper;
	
	// 공지글 최근 2개 가져오기
	public ArrayList<BoardTO> announceListTwo() {
		ArrayList<BoardTO> lists = boardMapper.announceListTwo();
		
		for(BoardTO list : lists) {
			int hasFile = boardMapper.hasFile(list);
			if(hasFile == 1) {
				list.setHasFile(true);
			} else {
				list.setHasFile(false);
			}
		}
		
		return lists;
	}
	
	// 게시글 목록 가져오기
	public BoardListTO boardList(BoardListTO listTO) {
		listTO.setTotalRecord(boardMapper.boardListTotal(listTO));
		listTO.setSkip();
		listTO.setBoardLists(boardMapper.boardList(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		// 파일 가지고있는지
		/*
		for(BoardTO list: listTO.getBoardLists()) {
			ArrayList<String> files = boardMapper.boardFile(list.getSeq());
			if(files.size() != 0) {
				list.setHasFile(true);
			} else {
				list.setHasFile(false);
			}
		}
		*/
		// file테이블 사용하지 않는방식
		for(BoardTO list : listTO.getBoardLists()) {
			int hasFile = boardMapper.hasFile(list);
			if(hasFile == 1) {
				list.setHasFile(true);
			}else {
				list.setHasFile(false);
			}
		}
		
		return listTO;
	}
	
	//마이페이지 내가쓴글 목록
	public BoardListTO myboardList(BoardListTO listTO) {
		listTO.setTotalRecord(boardMapper.myboardWriteTotal(listTO));
		listTO.setSkip();
		listTO.setBoardLists(boardMapper.myboardWrite(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		for(BoardTO list : listTO.getBoardLists()) {
			int hasFile = boardMapper.hasFile(list);
			if(hasFile == 1) {
				list.setHasFile(true);
			} else {
				list.setHasFile(false);
			}
		}
		
		return listTO;
	}
	
	//마이페이지 좋아요한 글 목록
	public BoardListTO myfavboardList(BoardListTO listTO) {
		listTO.setTotalRecord(boardMapper.myfavboardTotal(listTO));
		listTO.setSkip();
		listTO.setBoardLists(boardMapper.myfavboard(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		
		
		for(BoardTO list : listTO.getBoardLists()) {
			int hasFile = boardMapper.hasFile(list);
			if(hasFile == 1) {
				list.setHasFile(true);
			} else {
				list.setHasFile(false);
			}
		}
		
		return listTO;
	}
	
	// 글쓰기
	public int writeNew(BoardTO to) {
		int result = boardMapper.writeNew(to);
		return result;
	}
	
	// board view
	public BoardTO boardView(BoardTO to) {
		to = boardMapper.boardView(to);
		return to;
	}
	
}
