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
		

		for(BoardTO list : listTO.getBoardLists()) {
			// 파일 포함 여부, 썸네일 추가
			int hasFile = boardMapper.hasFile(list);
			if(hasFile == 1) {
				list.setHasFile(true);
				
				String content = boardMapper.boardContent(list.getSeq());
				String[] imgs =content.split("<img");
				int imgEnd = imgs[1].indexOf("\">");
				String thumbnail = "<img" + imgs[1].substring(0, imgEnd + 2);

				list.setThumbnail(thumbnail);
			}else {
				list.setHasFile(false);
			}
			// 추천수 기입
			list.setRecCnt(boardMapper.recCount(list.getSeq()) + "");
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
		String seq = to.getSeq();
		boardMapper.hitPlus(seq);
		
		to = boardMapper.boardView(to);
		return to;
	}
	
	// 게시글 추천
	public int boardRecommend(String memSeq, String boardSeq) {
		int result = boardMapper.boardRecommend(memSeq, boardSeq);
		boardMapper.boardRecCntPlus(boardSeq);
		return result;
	}
	
	// 게시글 추천여부
	public int recCheck(String memSeq, String boardSeq) {
		int result = boardMapper.recCheck(memSeq, boardSeq);
		return result;
	}
	
	// 게시글 추천수
	public int recCount(String boardSeq) {
		int result = boardMapper.recCount(boardSeq);
		return result;
	}
	
	// 밴 ip 목록
	public ArrayList<BanTO> banIp() {
		ArrayList<BanTO> lists = boardMapper.banIp();
				
		return lists;
	}
	
	// 밴 ip 해제
	public int banIpDeleteOk(BanTO to) {
		int flag = 1;
		int result = boardMapper.banIpDeleteOk(to);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// 게시글 지우기
	public int boardDeleteAll(String seq) {
		int flag = 1;
		int result = boardMapper.boardDeleteAll(seq);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
}
