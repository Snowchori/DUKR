package com.example.model;

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
	
	public ArrayList<BoardTO> announceListTwo() {
		ArrayList<BoardTO> lists = boardMapper.announceListTwo();
		
		for(BoardTO list: lists) {
			ArrayList<String> files = boardMapper.boardFile(list.getSeq());
			if(files.size() != 0) {
				list.setHasFile(true);
			} else {
				list.setHasFile(false);
			}
		}
		
		return lists;
	}
	
	public BoardListTO boardList(BoardListTO listTO) {
		listTO.setTotalRecord(boardMapper.boardListTotal(listTO));
		listTO.setSkip();
		listTO.setBoardLists(boardMapper.boardList(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		for(BoardTO list: listTO.getBoardLists()) {
			ArrayList<String> files = boardMapper.boardFile(list.getSeq());
			if(files.size() != 0) {
				list.setHasFile(true);
			} else {
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
		
		for(BoardTO list: listTO.getBoardLists()) {
			ArrayList<String> files = boardMapper.boardFile(list.getSeq());
			if(files.size() != 0) {
				list.setHasFile(true);
			} else {
				list.setHasFile(false);
			}
		}
		return listTO;
	}
}
