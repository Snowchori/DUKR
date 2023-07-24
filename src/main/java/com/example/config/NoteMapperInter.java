package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.note.NoteListTO;
import com.example.model.note.NoteTO;

public interface NoteMapperInter {
	// 쪽지 보내기
	@Insert("insert into note values(0, #{senderSeq}, #{receiverSeq}, now(), #{subject}, #{content}, 0)")
	public int noteSend(NoteTO to);
	
	//마이페이지 내가 받은 note 리스트 가져오기
	@Select("select n.seq seq, receiverSeq, m.nickname senderSeq, wdate, subject, content, status "
			+ "from note n, member m where receiverSeq=#{seq} and n.senderSeq=m.seq order by n.seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<NoteTO> mynoteGetList(NoteListTO listTO);
		
	//마이페이지 내가 받은 note 갯수 가져오기
	@Select("select count(*) from note where receiverseq=#{seq}")
	public int mynoteGetTotal(NoteListTO listTO);
	
	//마이페이지 내가 보낸 note 리스트 가져오기
	@Select("select n.seq seq, m.nickname receiverSeq, senderSeq, wdate, subject, content, status "
			+ "from note n, member m where senderSeq=#{seq} and n.receiverSeq=m.seq order by n.seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<NoteTO> mynoteSendList(NoteListTO listTO);
	
	//마이페이지 내가 보낸 note 갯수 가져오기
	@Select("select count(*) from note where senderSeq=#{seq}")
	public int mynoteSendTotal(NoteListTO listTO);
	
	// 쪽지 내용 보기
	@Select("select n.seq seq, g.nickname receiverSeq, s.nickname senderSeq, wdate, subject, content, status "
			+ "from note n, member g, member s where n.seq=#{seq} and n.receiverSeq=g.seq and n.senderSeq=s.seq")
	public NoteTO noteView(String seq);
	
	// 쪽지 읽음으로 변환
	@Update("update note set status = 1 where seq=#{seq}")
	public int noteStatusChange(String seq);
	
	// 쪽지 삭제
	@Delete("delete from note where seq=#{seq}")
	public int noteDelete(String seq);
}
