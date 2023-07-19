package com.example.config;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import com.example.model.note.NoteTO;

public interface NoteMapperInter {
	// 쪽지 보내기
	@Insert("insert into note values(0, #{senderSeq}, #{receiverSeq}, now(), #{subject}, #{content}, 0)")
	public int noteSend(NoteTO to);
}
