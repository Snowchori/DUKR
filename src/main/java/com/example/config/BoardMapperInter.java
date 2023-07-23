package com.example.config;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.model.board.BanTO;
import com.example.model.board.BoardListTO;
import com.example.model.board.BoardTO;

public interface BoardMapperInter {		
	// 공지글 최근 2개 가져오기
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from board b, member m where boardType = 0 and not b.isDel and b.memSeq=m.seq order by seq desc limit 2")
	public ArrayList<BoardTO> announceListTwo();
	
	// 게시글 목록 가져오기
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from board b, member m where boardType = #{boardType} and ${query} not b.isDel and b.memSeq=m.seq order by seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<BoardTO> boardList(BoardListTO listTO);
	
	// 게시글 전체수 가져오기
	@Select("select count(*) from board b, member m where boardType = #{boardType} and ${query} not b.isDel and b.memSeq=m.seq")
	public int boardListTotal(BoardListTO listTO);
	
	//마이페이지 내가쓴 board리스트 가져오기
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from board b, member m where not b.isDel and m.nickname=#{keyWord} and b.memSeq=m.seq order by seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<BoardTO> myboardWrite(BoardListTO listTO);
	
	//마이페이지 내가쓴 board갯수 가져오기
	@Select("select count(*) from board b, member m where m.nickname=#{keyWord} and not b.isDel and b.memSeq=m.seq")
	public int myboardWriteTotal(BoardListTO listTO);
	
	//마이페이지 내가 좋아요한 board 갯수 가져오기
	@Select("select count(*) from boardrecommend where memSeq=#{keyWord}")
	public int myfavboardTotal(BoardListTO listTO);
	
	//마이페이지 내가 좋아요한 board리스트 가져오기
	@Select("select b.seq seq, tag, subject, date_format(wdate, '%Y-%m-%d') wdate, hit, recCnt, cmtCnt, m.nickname writer, isDel "
			+ "from boardrecommend r, member m, board b where not b.isDel and r.memSeq=#{keyWord} and r.boardSeq=b.Seq and b.memSeq=m.Seq order by b.seq desc limit #{skip}, #{recordPerPage}")
	public ArrayList<BoardTO> myfavboard(BoardListTO listTO);
	
	// 글쓰기
	@Insert("insert into board values(0, #{memSeq}, #{subject}, #{content}, #{wip}, now(), 0, 0, 0, 0, #{tag}, #{boardType})")
	@Options(useGeneratedKeys = true, keyProperty = "seq")
	public int writeNew(BoardTO to);
	
	// seq로 글정보 가저오기
	@Select("select b.seq seq, memSeq, subject, content, wip, wdate, hit, recCnt, cmtCnt, tag, nickname writer, boardType, isDel from board b inner join member m on b.memSeq=m.seq where b.seq=#{seq}")
	public BoardTO boardView(BoardTO to);
	
	// seq로 글정보 가져오기( 글 수정 ) - 제목, 내용, 태그
	@Select("select seq, subject, content, tag from board where seq = #{seq}")
	public BoardTO boardModify(BoardTO to);
	
	// 게시글 수정하기
	@Update("update board set subject=#{subject}, content=#{content}, tag=#{tag} where seq=#{seq}")
	public int boardModifyOk(BoardTO to);
	
	// 게시글의 파일 포함여부 검사
	@Select("select count(*) from board where content like '%<img src=\"%' and seq=#{seq};")
	public int hasFile(BoardTO to);
	
	@Select("select content from board where seq=#{seq}")
	public String boardContent(String seq);
	
	// 뷰 진입시 조회수 +1
	@Update("update board set hit=hit+1 where seq=#{seq}")
	public int hitPlus(String seq);
	
	// 게시글 추천하기
	@Insert("insert into boardrecommend values(#{memSeq}, #{boardSeq})")
	public int boardRecommend(String memSeq, String boardSeq);
	
	// 게시글 추천 해제하기
	@Delete("delete from boardrecommend where memSeq=#{memSeq} and boardSeq=#{boardSeq}")
	public int boardRecommendCancel(String memSeq, String boardSeq);
	
	// 게시글 추천후 recCnt +1
	@Update("update board set recCnt=recCnt+1 where seq=#{seq}")
	public int boardRecCntPlus(String seq);
	
	// 게시글 추천해제 후 recCnt -1
	@Update("update board set recCnt=recCnt-1 where seq=#{seq}")
	public int boardRecCntMinus(String seq);
	
	// 게시글 추천여부
	@Select("select count(*) from boardrecommend where memSeq=#{memSeq} and boardSeq=#{boardSeq}")
	public int recCheck(String memSeq, String boardSeq);
	
	// 게시글 추천수
	@Select("select count(*) from boardrecommend where boardSeq=#{boardSeq}")
	public int recCount(String boardSeq);
	
	// 밴 ip 목록
	@Select("select seq, bip, bdate from ipban order by seq desc")
	public ArrayList<BanTO> banIp();
	
	// 밴 ip 해제
	@Delete("delete from ipban where seq = #{seq}")
	public int banIpDeleteOk(BanTO to);
	
	// 회원 게시글 전부 지우기
	@Update("update board set isDel = true where memSeq = #{seq}")
	public int boardDeleteAll(String seq);
	
	// 게시글 지우기
	@Update("update board set isDel = true where seq = #{seq}")
	public int boardDelete(String seq);
	
	// 밴 ip 등록 확인
	@Select("select bip from ipban where bip=#{bip}")
	public String bipCheck(String bip);
	
	// 밴 ip 등록
	@Insert("insert into ipban values(0, #{bip}, now())")
	public int ipBan(String bip);
	
	// 게시글 ip 가져오기
	@Select("select wip from board where seq=#{seq}")
	public String getBip(String seq);
}
