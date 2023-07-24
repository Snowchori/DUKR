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
	
	// 받은 쪽지 목록 목록보기
	public NoteListTO mynoteGetList(NoteListTO listTO) {
		listTO.setTotalRecord(noteMapper.mynoteGetTotal(listTO));
		listTO.setSkip();
		listTO.setNoteList(noteMapper.mynoteGetList(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		return listTO;
	}
	
	// 보낸 쪽지 목록 목록보기
	public NoteListTO mynoteSendList(NoteListTO listTO) {
		listTO.setTotalRecord(noteMapper.mynoteSendTotal(listTO));
		listTO.setSkip();
		listTO.setNoteList(noteMapper.mynoteSendList(listTO));
		listTO.setTotalPage();
		listTO.setStartBlock();
		listTO.setEndBlock();
		
		return listTO;
	}
	
	// 쪽지 보기 reciver sender seq 전부 닉네임으로 전환
	public NoteTO getNoteView(String seq) {
		
		NoteTO noteTO = noteMapper.noteView(seq);
		
		return noteTO;
	}
	
	// 쪽지 읽음으로 변환
	public int noteStatusChange(String seq) {
		
		int flag = noteMapper.noteStatusChange(seq);
		
		return flag;
	}
	
	// 쪽지 삭제
	public int noteDelte(String seq) {
		int flag = noteMapper.noteDelete(seq);
		
		return flag;
	}
}
