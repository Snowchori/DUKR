package com.example.model.party;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.config.BoardMapperInter;
import com.example.config.PartyMapperInter;
import com.example.model.board.BoardTO;

@Repository
public class PartyDAO {
	@Autowired
	private PartyMapperInter partyMapper;
	@Autowired
	private BoardMapperInter boardMapper;
	
	/* 모임 정보 리스트 반환 */
	public ArrayList<ApiPartyTO> getParties(int type, String value) {
		ArrayList<ApiPartyTO> data = null;

		// 0: 도(시) 검색 / 1: 시/군(구) 검색 / 2: 유저 검색
		switch(type) {
			case 0:
				if(value.equals("0")) {
					value = "";
				}
				data = partyMapper.getPartiesByDo(value + "%");
				break;
			case 1:
				data = partyMapper.getPartiesBySi(value);
				break;
			case 2:
				data = partyMapper.getUserParties(value);
		}
		
		return data;
	}
	
	/* 모임 정보 반환 */
	public PartyTO getParty(String boardSeq, String userSeq) {
		PartyTO pto = partyMapper.getParty(boardSeq, userSeq);
		
		return pto;
	}
		
	public ArrayList<ApplyTO> getAppliers(String boardSeq){
		ArrayList<ApplyTO> atos = null;
		
		atos = partyMapper.getAppliers(boardSeq);
		if(atos == null) {
			atos = new ArrayList<ApplyTO>();
		}
		
		return atos;
	}
	
	// 게시글에 해당하는 모임정보
	public PartyTO getPartyByBoardSeq(PartyTO to) {
		to = partyMapper.getPartyByBoardSeq(to);
		return to;
	}
	
	/* 모임 등록 */
	public int registerPartyOk(BoardTO bto, PartyTO mto) {
		int flag = 1;
		
		int result = boardMapper.writeNew(bto);
		if(result == 1) {
			mto.setBoardSeq(bto.getSeq());
			int result2 = partyMapper.registerPartyOk(mto);
			if(result2 == 1) {
				flag = 0;
			}
		}
		
		return flag;
	}
	
	/* 모임 신청 여부 */
	public int isApplied(ApplyTO ato) {
		int status = 0;
		
		Integer result = partyMapper.isApplied(ato);
		if(result != null) {
			status = result.intValue();
		}
		
		return status;
	}
	
	/* 모임 신청 */
	public int applyPartyOk(ApplyTO ato) {
		int flag = 1;
		
		int result = partyMapper.applyPartyOK(ato);
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	/* 모임 신청 | 취소*/
	public int togglePartyOk(ApplyTO ato) {
		int flag = 1;
		
		int result = partyMapper.togglePartyOK(ato);
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// 모임정보 수정
	public int partyModifyOk(PartyTO to) {
		int result = partyMapper.partyModifyOk(to);
		return result;
	}
}
