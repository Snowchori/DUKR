package com.example.model.note;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.NoteMapperInter;

@Repository
public class NoteDAO {
	@Autowired
	private NoteMapperInter noteMapper;
	
	// 쪽지 보내기
	public int noteSend(NoteTO to) {
		int flag = 1;
		int result = noteMapper.noteSend(to);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
}
