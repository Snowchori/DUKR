package com.example.model;

import java.util.ArrayList;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.BoardMapperInter;

@Repository
@MapperScan( basePackages = { "com.example.config" } )
public class BoardDAO {
	@Autowired
	private BoardMapperInter boardMapper;
	
	public ArrayList<BoardTO> boardListByTag(String tag) {
		ArrayList<BoardTO> lists = boardMapper.boardListByTag(tag);
		
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
}
