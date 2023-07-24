package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.board.BanTO;
import com.example.model.board.BoardDAO;
import com.example.model.board.BoardListTO;
import com.example.model.board.BoardTO;
import com.example.model.boardgame.BoardgameDAO;
import com.example.model.boardgame.BoardgameTO;
import com.example.model.boardgame.SearchFilterTO;
import com.example.model.comment.CommentDAO;
import com.example.model.comment.CommentListTO;
import com.example.model.comment.CommentTO;
import com.example.model.evaluation.EvaluationDAO;
import com.example.model.evaluation.EvaluationTO;
import com.example.model.inquiry.InquiryDAO;
import com.example.model.inquiry.InquiryListTO;
import com.example.model.inquiry.InquiryTO;
import com.example.model.logs.LogListTO;
import com.example.model.logs.LogsDAO;
import com.example.model.logs.LogsTO;
import com.example.model.member.MemberDAO;
import com.example.model.member.MemberListTO;
import com.example.model.member.MemberTO;
import com.example.model.note.NoteDAO;
import com.example.model.note.NoteListTO;
import com.example.model.note.NoteTO;
import com.example.model.party.ApiPartyTO;
import com.example.model.party.ApplyTO;
import com.example.model.party.PartyDAO;
import com.example.model.party.PartyTO;
import com.example.model.report.ReportDAO;
import com.example.model.report.ReportListTO;
import com.example.model.report.ReportTO;

@RestController
public class DURKController {
	
	@Autowired
	private BoardgameDAO gameDAO;
	
	@Autowired
	private MemberDAO memberDAO;
	
	@Autowired
	private BoardDAO boardDAO;
	
	@Autowired
	private EvaluationDAO evalDAO;
	
	@Autowired
	private PartyDAO partyDAO;
	
	@Autowired
	private CommentDAO commentDAO;
	
	@Autowired
	private NoteDAO noteDAO;
	
	@Autowired
	private InquiryDAO inquiryDAO;
	
	@Autowired
	private ReportDAO reportDAO;
	
	@Autowired
	private LogsDAO logsDAO;
	
	@Autowired
	private JavaMailSender javaMailSender;
	
	// main
	@RequestMapping("/")
	public ModelAndView root(HttpServletRequest request) {
		return main(request);
	}
	
	@RequestMapping("/main")
	public ModelAndView main(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		ArrayList<BoardgameTO> recently_list = (ArrayList<BoardgameTO>)session.getAttribute("recently_list");
		if(recently_list == null) {
			recently_list = new ArrayList<BoardgameTO>();
			session.setAttribute("recently_list", recently_list);
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("main");
		
		ArrayList<String> recSeqList = gameDAO.gameRecList(); 
		ArrayList<BoardgameTO> recList = new ArrayList<BoardgameTO>();
		ArrayList<BoardgameTO> favList = new ArrayList<BoardgameTO>();
		
		if(userSeq != null) {
			ArrayList<String> favSeqList = gameDAO.gameMainFavList(userSeq);
			for(String seq : favSeqList) {
				favList.add(gameDAO.gameInfo(seq));
			}
		}
		
		for(String seq : recSeqList) {
			recList.add(gameDAO.gameInfo(seq));
		}
		
		ArrayList<BoardgameTO> totallist = gameDAO.gameMainList();
		modelAndView.addObject("recList",recList);
		modelAndView.addObject("favlist", favList);
		modelAndView.addObject("totallist", totallist);
		modelAndView.addObject("recently_list", recently_list);
		return modelAndView;
	}
	
	// admin
	@RequestMapping("/banUserManage")
	public ModelAndView banUserManage(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		boolean isAdmin = (userInfo != null) ? userInfo.isAdmin() : false;
		if(!isAdmin) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("admin/not_admin");
			
			return modelAndView;
		}
		
		ArrayList<BanTO> ban_list = boardDAO.banIp();
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/ban_user_manage");
		modelAndView.addObject("ban_list", ban_list);
		
		return modelAndView;
	}
	
	@RequestMapping("/banDeleteOk")
	public int banDeleteOk(HttpServletRequest request) {
		BanTO to = new BanTO();
		to.setSeq(request.getParameter("seq"));
		
		int flag = boardDAO.banIpDeleteOk(to);
		
		return flag;
	}
	
	@RequestMapping("/gameManage")
	public ModelAndView gameManage(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		boolean isAdmin = (userInfo != null) ? userInfo.isAdmin() : false;
		if(!isAdmin) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("admin/not_admin");
			
			return modelAndView;
		}
		
		ArrayList<BoardgameTO> gameList = gameDAO.gameList("yearpublished");
		ArrayList<String> gameRecList = gameDAO.gameRecList();
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/game_manage");
		modelAndView.addObject("gameList", gameList);
		modelAndView.addObject("gameRecList", gameRecList);
		
		return modelAndView;
	}
	
	@RequestMapping("/gameModifyOk")
	public int gameModifyOk(HttpServletRequest request) {
		BoardgameTO gameTO = new BoardgameTO();
		gameTO.setSeq(request.getParameter("seq"));
		gameTO.setBrief(request.getParameter("brief"));
		gameTO.setGenre(request.getParameter("genre"));
		gameTO.setTheme(request.getParameter("theme"));
		
		int flag = gameDAO.gameModifyOk(gameTO);
		
		return flag;
	}
	
	@RequestMapping("/recommendgameWriteOk")
	public int recommendgameWriteOk(HttpServletRequest request, @RequestParam(value="checkedValue[]") List<String> checkedValue) {
		gameDAO.gameRecClear();
		int flag = 0;
		for(String value: checkedValue) {
			flag += gameDAO.gameRecInsert(value);
		}
		
		return flag;
	}
	
	@RequestMapping("/recommendgameClear")
	public int recommendgameClear(HttpServletRequest request) {
		int flag = gameDAO.gameRecClear();
		
		return flag;
	}
	
	@RequestMapping("/inquiryManage")
	public ModelAndView inquiryManage(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		boolean isAdmin = (userInfo != null) ? userInfo.isAdmin() : false;
		if(!isAdmin) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("admin/not_admin");
			
			return modelAndView;
		}
		
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		String status = (request.getParameter("status") != null && !request.getParameter("status").equals("")) ? request.getParameter("status") : "";
		
		InquiryListTO listTO = new InquiryListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		if(status.equals("0")) {
			listTO.setQuery(" and status = 0");
		} else if(status.equals("1")) {
			listTO.setQuery(" and status = 1");
		} else {
			listTO.setQuery("");
		}
		
		listTO.setStatus(status);
		
		listTO = inquiryDAO.inquiryList(listTO);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/inquiry_manage");
		modelAndView.addObject("listTO", listTO);
		
		return modelAndView;
	}
	
	@RequestMapping("/inquiryAnswerWriteOk")
	public int inquiryAnswerWriteOk(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		InquiryTO to = new InquiryTO();
		to.setSeq(request.getParameter("seq"));
		to.setAnswer(request.getParameter("answer"));
		
		int flag = inquiryDAO.inquiryAnswerWriteOk(to);
		
		if(flag == 0) {
			NoteTO noteTO = new NoteTO();
			noteTO.setReceiverSeq(request.getParameter("senderSeq"));
			noteTO.setSenderSeq(userInfo.getSeq());
			noteTO.setSubject("문의 답변 완료");
			noteTO.setContent("관리자가 문의에 답변을 남겼습니다.");
			
			noteDAO.noteSend(noteTO);
		}
		
		return flag;
	}
	
	@RequestMapping("/logManage")
	public ModelAndView logManage(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		boolean isAdmin = (userInfo != null) ? userInfo.isAdmin() : false;
		if(!isAdmin) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("admin/not_admin");
			
			return modelAndView;
		}
		
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		String keyWord = (request.getParameter("keyWord") != null && !request.getParameter("keyWord").equals("")) ? request.getParameter("keyWord") : "%";
		String logType = (request.getParameter("logType") != null && !request.getParameter("logType").equals("")) ? request.getParameter("logType") : "1";
		
		LogListTO listTO = new LogListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setKeyWord(keyWord);
		listTO.setLogType(logType);
		
		listTO = logsDAO.logsList(listTO);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/log_manage");
		modelAndView.addObject("listTO", listTO);
		
		return modelAndView;
	}
	
	@RequestMapping("/noteSendAll")
	public ModelAndView noteSendAll(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		boolean isAdmin = (userInfo != null) ? userInfo.isAdmin() : false;
		if(!isAdmin) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("admin/not_admin");
			
			return modelAndView;
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/note_send_all");
		
		return modelAndView;
	}
	
	@RequestMapping("/noteSendAllOk")
	public int noteSendAllOk(HttpServletRequest request) {
		NoteTO to = new NoteTO();
		to.setSenderSeq(request.getParameter("seq"));
		to.setSubject(request.getParameter("subject"));
		to.setContent(request.getParameter("content"));
		
		int flag = 0;
		
		ArrayList<MemberTO> lists = memberDAO.memberList();
		
		for(MemberTO mto: lists) {
			if(!request.getParameter("seq").equals(mto.getSeq())) {
				to.setReceiverSeq(mto.getSeq());
				flag += noteDAO.noteSend(to);
			}
		}
		
		return flag;
	}
	
	@RequestMapping("/reportList")
	public ModelAndView reportList(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		boolean isAdmin = (userInfo != null) ? userInfo.isAdmin() : false;
		if(!isAdmin) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("admin/not_admin");
			
			return modelAndView;
		}
		
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		String status = (request.getParameter("status") != null && !request.getParameter("status").equals("")) ? request.getParameter("status") : "";
		
		ReportListTO listTO = new ReportListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		if(status.equals("0")) {
			listTO.setQuery(" and status = 0");
		} else if(status.equals("1")) {
			listTO.setQuery(" and status = 1");
		} else {
			listTO.setQuery("");
		}
		
		listTO.setStatus(status);
		
		listTO = reportDAO.reportList(listTO);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/report_list");
		modelAndView.addObject("listTO", listTO);
		
		return modelAndView;
	}
	
	@RequestMapping("/reportAnswerWriteOk")
	public int reportAnswerWriteOk(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		ReportTO to = new ReportTO();
		to.setSeq(request.getParameter("seq"));
		to.setAnswer(request.getParameter("answer"));
		to.setProcessType("답변완료");
		
		int flag = reportDAO.reportAnswerWriteOk(to);
		
		if(flag == 0) {
			NoteTO noteTO = new NoteTO();
			noteTO.setReceiverSeq(request.getParameter("senderSeq"));
			noteTO.setSenderSeq(userInfo.getSeq());
			noteTO.setSubject("신고글 답변 완료");
			noteTO.setContent("관리자가 신고글에 답변을 남겼습니다.");
			
			noteDAO.noteSend(noteTO);
		}
		
		return flag;
	}
	
	@RequestMapping("/boardView")
	public ModelAndView boardView(HttpServletRequest request) {
		BoardTO to = new BoardTO();
		to.setSeq(request.getParameter("seq"));
		to = boardDAO.boardView(to);
		
		String boardType = to.getBoardType();
		
		if(boardType.equals("0")) {
			return announceBoardView(request);
		} else if(boardType.equals("1")) {
			return freeBoardView(request);
		} else if(boardType.equals("2")) {
			return partyBoardView(request);
		}
		
		return new ModelAndView();
	}
	
	@RequestMapping("/deleteBoardOk")
	public int deleteBoardOk(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		ReportTO to = new ReportTO();
		to.setSeq(request.getParameter("seq"));
		to.setAnswer(request.getParameter("answer"));
		to.setProcessType("게시글삭제");
		
		int flag = reportDAO.reportAnswerWriteOk(to);
		
		if(flag == 0) {
			boardDAO.boardDelete(request.getParameter("boardSeq"));
			
			NoteTO noteTO = new NoteTO();
			noteTO.setReceiverSeq(request.getParameter("senderSeq"));
			noteTO.setSenderSeq(userInfo.getSeq());
			noteTO.setSubject("신고글 게시글 삭제 완료");
			noteTO.setContent("관리자가 신고글의 게시글을 삭제하였습니다.");
			
			noteDAO.noteSend(noteTO);
		}
		
		return flag;
	}
	
	@RequestMapping("/deleteCommentOk")
	public int deleteCommentOk(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		ReportTO to = new ReportTO();
		to.setSeq(request.getParameter("seq"));
		to.setAnswer(request.getParameter("answer"));
		to.setProcessType("댓글삭제");
		
		int flag = reportDAO.reportAnswerWriteOk(to);
		
		if(flag == 0) {
			commentDAO.commentDelete(request.getParameter("commentSeq"), request.getParameter("boardSeq"));
			
			NoteTO noteTO = new NoteTO();
			noteTO.setReceiverSeq(request.getParameter("commentSeq"));
			noteTO.setSenderSeq(userInfo.getSeq());
			noteTO.setSubject("신고글 댓글 삭제 완료");
			noteTO.setContent("관리자가 신고글의 댓글을 삭제하였습니다.");
			
			noteDAO.noteSend(noteTO);
		}
		
		return flag;
	}
	
	@RequestMapping("/ipBanOk")
	public int ipBanOk(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		ReportTO to = new ReportTO();
		to.setSeq(request.getParameter("seq"));
		to.setAnswer(request.getParameter("answer"));
		to.setProcessType("ip밴");
		
		int flag = reportDAO.reportAnswerWriteOk(to);
		
		if(flag == 0) {
			NoteTO noteTO = new NoteTO();
			noteTO.setReceiverSeq(request.getParameter("senderSeq"));
			noteTO.setSenderSeq(userInfo.getSeq());
			
			if(request.getParameter("commentSeq")  != null && request.getParameter("commentSeq").equals("")) {
				int check = boardDAO.bipCheck(request.getParameter("boardSeq"));
				if(check == 0) {
					boardDAO.ipBan(request.getParameter("boardSeq"));
				}
				boardDAO.boardDelete(request.getParameter("boardSeq"));
				noteTO.setSubject("신고글 게시글 ip밴 완료");
				noteTO.setContent("관리자가 신고글 게시글의 ip를 밴하였습니다.");
			} else {
				int check = commentDAO.bipCheck(request.getParameter("commentSeq"));
				if(check == 0) {
					commentDAO.ipBan(request.getParameter("commentSeq"));
				}
				commentDAO.commentDelete(request.getParameter("commentSeq"), request.getParameter("boardSeq"));
				noteTO.setSubject("신고글 댓글 ip밴 완료");
				noteTO.setContent("관리자가 신고글 댓글의 ip를 밴하였습니다.");
			}
			
			noteDAO.noteSend(noteTO);
		}
		
		return flag;
	}
	
	@RequestMapping("/userList")
	public ModelAndView userList(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		boolean isAdmin = (userInfo != null) ? userInfo.isAdmin() : false;
		if(!isAdmin) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("admin/not_admin");
			
			return modelAndView;
		}
		
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		String keyWord = (request.getParameter("keyWord") != null && !request.getParameter("keyWord").equals("")) ? "%" + request.getParameter("keyWord") + "%" : "%";
		
		MemberListTO listTO = new MemberListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setKeyWord(keyWord);
		
		listTO = memberDAO.userList(listTO);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/user_list");
		modelAndView.addObject("listTO", listTO);
		
		return modelAndView;
	}
	
	@RequestMapping("/userDeleteOk")
	public int userDeleteOk(HttpServletRequest request) {
		MemberTO to = new MemberTO();
		to.setSeq(request.getParameter("seq"));
		
		int flag = memberDAO.userDeleteOk(to);
		
		if(flag == 0) {
			ArrayList<String> seqs = boardDAO.userBoardList(to.getSeq());
			for(String seq: seqs) {
				boardDAO.boardDelete(seq);
				commentDAO.allCommentDelete(seq);
			}
		}
		
		return flag;
	}
	
	@RequestMapping("/nicknameChangeOk")
	public int nicknameChangeOk(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		MemberTO to = new MemberTO();
		to.setSeq(request.getParameter("seq"));
		to.setNickname(request.getParameter("nickname"));
		
		int flag = memberDAO.nicknameChangeOk(to);
		
		if(flag == 0) {
			NoteTO noteTO = new NoteTO();
			noteTO.setReceiverSeq(to.getSeq());
			noteTO.setSenderSeq(userInfo.getSeq());
			noteTO.setSubject("강제 닉네임 변경 안내");
			noteTO.setContent("관리자에 의하여 '" + to.getNickname() + "'으로 닉네임이 강제변경 되었습니다.");
			
			noteDAO.noteSend(noteTO);
		}
		
		return flag;
	}
	
	// community/announce
	@RequestMapping("/announceBoardList")
	public ModelAndView announceBoardList(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		String select = request.getParameter("select");
		String search =	request.getParameter("search");
		
		BoardListTO listTO = new BoardListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setKeyWord("%" + search + "%");
		listTO.setBoardType("0");
		
		if(select == null) {
			listTO.setQuery("");
		} else if(select.equals("0")) {
			// 전체 검색
			listTO.setQuery("(subject like #{keyWord} or content like #{keyWord} or m.nickname like #{keyWord} or tag like #{keyWord}) and");
		} else if(select.equals("1")) {
			// 제목 검색
			listTO.setQuery("subject like #{keyWord} and");
		} else if(select.equals("2")) {
			// 제목 + 내용 검색
			listTO.setQuery("(subject like #{keyWord} or content like #{keyWord}) and");
		} else if(select.equals("3")) {
			// 작성자 검색
			listTO.setQuery("m.nickname like #{keyWord} and");
		} else if(select.equals("4")) {
			// 태그 검색
			listTO.setQuery("tag like #{keyWord} and");
		} else {
			// 전체 검색
			listTO.setQuery("");
		}
		
		listTO = boardDAO.boardList(listTO);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("community/announce/announce_board_list");
		modelAndView.addObject("listTO", listTO);
		
		return modelAndView;
	}
	
	@RequestMapping("/announceBoardView")
	public ModelAndView announceBoardView(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("community/announce/announce_board_view");
		
		BoardTO to = new BoardTO();
		to.setSeq(request.getParameter("seq"));
		to = boardDAO.boardView(to);
		
		if(to == null) {
			modelAndView.setViewName("community/no_board");
			
			return modelAndView;
		}
		
		to.setRecCnt(boardDAO.recCount(to.getSeq()) + "");
		
		if(to.isDel()) {
			modelAndView.setViewName("community/deleted_board");
			
			return modelAndView;
		}
		
		MemberTO userInfo = (MemberTO)request.getSession().getAttribute("logged_in_user");
		
		// 보고있는 유저의 게시글 추천여부 감지 
		boolean didUserRec = false;
		String uSeq = null;
		
		if(userInfo != null) {
			uSeq = userInfo.getSeq();
			
			int recCheck = boardDAO.recCheck(uSeq, request.getParameter("seq"));
			if(recCheck == 1) {
				didUserRec = true;
			}
		}

		String comments = commentsBuilder(request.getParameter("seq"), uSeq);
		
		modelAndView.addObject("to", to);
		modelAndView.addObject("didUserRec", didUserRec);
		modelAndView.addObject("comments", comments);
		
		return modelAndView;
	}
	
	@RequestMapping("/announceBoardWrite")
	public ModelAndView announceBoardWrite(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("community/announce/announce_board_write");
		
		return modelAndView;
	}
	
	// 공지사항 수정
	@RequestMapping("/announceBoardModify")
	public ModelAndView announceBoardModify(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
				
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
					
			return modelAndView;
		}
				
		BoardTO to = new BoardTO();
		to.setSeq(request.getParameter("seq"));
		to = boardDAO.boardModify(to);
					
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("to", to);
				
		modelAndView.setViewName("community/announce/announce_board_modify");		
		return modelAndView;
	}	
	
	// community/free
	@RequestMapping("/freeBoardList")
	public ModelAndView freeBoardList(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		String select = request.getParameter("select");
		String search =	request.getParameter("search");
		
		ArrayList<BoardTO> announceList = boardDAO.announceListTwo();
		BoardListTO listTO = new BoardListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setKeyWord("%" + search + "%");
		listTO.setBoardType("1");
		
		if(select == null) {
			listTO.setQuery("");
		} else if(select.equals("0")) {
			// 전체 검색
			listTO.setQuery("(subject like #{keyWord} or content like #{keyWord} or m.nickname like #{keyWord} or tag like #{keyWord}) and");
		} else if(select.equals("1")) {
			// 제목 검색
			listTO.setQuery("subject like #{keyWord} and");
		} else if(select.equals("2")) {
			// 제목 + 내용 검색
			listTO.setQuery("(subject like #{keyWord} or content like #{keyWord}) and");
		} else if(select.equals("3")) {
			// 작성자 검색
			listTO.setQuery("m.nickname like #{keyWord} and");
		} else if(select.equals("4")) {
			// 태그 검색
			listTO.setQuery("tag like #{keyWord} and");
		} else {
			// 전체 검색
			listTO.setQuery("");
		}
		
		listTO = boardDAO.boardList(listTO);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("community/free/free_board_list");
		modelAndView.addObject("announceList", announceList);
		modelAndView.addObject("listTO", listTO);
		
		return modelAndView;
	}
	
	@RequestMapping("/freeBoardView")
	public ModelAndView freeBoardView(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("community/free/free_board_view");

		BoardTO to = new BoardTO();
		to.setSeq(request.getParameter("seq"));
		to = boardDAO.boardView(to);
		
		if(to == null) {
			modelAndView.setViewName("community/no_board");
			
			return modelAndView;
		}
		
		to.setRecCnt(boardDAO.recCount(to.getSeq()) + "");
		
		if(to.isDel()) {
			modelAndView.setViewName("community/deleted_board");
			
			return modelAndView;
		}

		MemberTO userInfo = (MemberTO)request.getSession().getAttribute("logged_in_user");
		
		// 보고있는 유저의 게시글 추천여부 감지 
		boolean didUserRec = false;
		String uSeq = null;
		
		if(userInfo != null) {
			uSeq = userInfo.getSeq();
			
			int recCheck = boardDAO.recCheck(uSeq, request.getParameter("seq"));
			if(recCheck == 1) {
				didUserRec = true;
			}
		}

		String comments = commentsBuilder(request.getParameter("seq"), uSeq);
		
		modelAndView.addObject("to", to);
		modelAndView.addObject("didUserRec", didUserRec);
		modelAndView.addObject("comments", comments);
		
		return modelAndView;
	}
	
	@RequestMapping("/freeBoardWrite")
	public ModelAndView freeBoardWrite(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("community/free/free_board_write");
		
		return modelAndView;
	}
	
	//글 수정
	@RequestMapping("/freeBoardModify")
	public ModelAndView freeBoardModify(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
			
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
				
			return modelAndView;
		}
			
		BoardTO to = new BoardTO();
		to.setSeq(request.getParameter("seq"));
		to = boardDAO.boardModify(to);
				
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("to", to);
			
		modelAndView.setViewName("community/free/free_board_modify");		
		return modelAndView;
	}
	
	// 글수정 완료
	@PostMapping( value = {"/freeBoardModifyOk", "/announceBoardModifyOk"})
	public int boardModifyOk(HttpServletRequest req) {
		int result = 0;
		
		String boardSeq = req.getParameter("boardSeq");
		String subject = req.getParameter("subject");
		String content = req.getParameter("content");
		String tags = req.getParameter("tags");
		
		BoardTO modifiedPost = new BoardTO();
		modifiedPost.setSeq(boardSeq);
		modifiedPost.setSubject(subject);
		modifiedPost.setContent(content);
		modifiedPost.setTag(tags);
		
		result = boardDAO.boardModifyOk(modifiedPost);
		
		return result;
	}
	
	@RequestMapping("/freeBoardDeleteOk")
	public int boardDeleteOK(HttpServletRequest request) {
				
		String boardSeq = request.getParameter("seq");
		int flag = boardDAO.boardDelete(boardSeq);

		if(flag == 0) {
			flag = commentDAO.allCommentDelete(boardSeq);
		}
		
		return flag;
	}
		
	// 댓글쓰기
	@PostMapping("/freeboardCommentWrite")
	public String freeboardCommentWrite(HttpServletRequest req){
		StringBuilder sbResponseHtml = new StringBuilder();

		CommentTO to = new CommentTO();
		to.setBoardSeq(req.getParameter("boardSeq"));
		to.setMemSeq(req.getParameter("memSeq"));
		to.setContent(req.getParameter("content"));
		to.setWip(req.getRemoteAddr());

		if(!to.getMemSeq().equals("")) {
			 commentDAO.boardCommentWrite(to);			 
			 sbResponseHtml.append(commentsBuilder(req.getParameter("boardSeq"), req.getParameter("memSeq")));
		}	

		return sbResponseHtml.toString();
	}
	
	// 댓글목록 업데이트 => HTML 생성 메소드
	public String commentsBuilder(String boardSeq, String memSeq) {
		CommentListTO updatedComments = new CommentListTO();
		updatedComments.setCommentList(commentDAO.boardCommentList(boardSeq));
		
		StringBuilder sbReturn = new StringBuilder();
		for(CommentTO comment : updatedComments.getCommentList()) {
			String cWriter = comment.getWriter();
			String cWdate = comment.getWdate();
			int cRecCnt = comment.getRecCnt();
			String cContent = comment.getContent();	
			String cSeq = comment.getSeq();
			String writerSeq = comment.getMemSeq();
			
			// 보고있는사람이 작성자인지 여부
			boolean isWriter = ( memSeq != null && memSeq.equals(writerSeq) );
			
			// 추천버튼 색상
			String comRecBtnColor = "#4db2b2";
			int didUserRecommendedThisComment = commentDAO.commentRecCheck(memSeq, cSeq);
			if(didUserRecommendedThisComment == 1) {
				comRecBtnColor = "#F08080";
			}

			if(isWriter) {
				sbReturn.append("<div style='background-color: #f0f0f0; display: block; margin-top: -8px; padding: 0;'>");
			}else {
				sbReturn.append("<div style='display: block; margin-top: -8px;'>");
			}
			sbReturn.append("<span class='dropdown' style='margin-top: 8px;'>");	
			sbReturn.append("<a href='#' role='button' data-bs-toggle='dropdown'>");	
			sbReturn.append(cWriter);	
			sbReturn.append("</a>");
			sbReturn.append("<ul class='dropdown-menu'>");
			sbReturn.append("<li><a class='dropdown-item' href='/freeBoardList?select=3&search=" + cWriter + "'>게시글 보기</a></li>");	
			sbReturn.append("<li><a class='dropdown-item' href='/freeBoardList?'>댓글 보기</a></li>");	
			sbReturn.append("</ul>");	
			sbReturn.append("</span>&nbsp;");	
			sbReturn.append("<span style='color:#888888;'>" + cWdate + "</span>");	
			sbReturn.append("<button id='cmtRecBtn" + cSeq + "' class='btn' style='font-size:14px; color: " + comRecBtnColor + ";' onclick='recommendComment(\"" + writerSeq + "\", \"" + memSeq + "\", \"" + cSeq + "\")'>");
			sbReturn.append("<i class='fas fa-thumbs-up'></i>&nbsp;");		
			sbReturn.append(cRecCnt);		
			sbReturn.append("</button>");

			// 옵션
			sbReturn.append("<span id='cmtOptions" + cSeq + "' class='float-end me-2'>");
			sbReturn.append("<button class='btn' role='button' data-bs-toggle='dropdown'>");	
			sbReturn.append("<i class=\"fas fa-bars\"></i>");	
			sbReturn.append("</button>");
			sbReturn.append("<ul class='dropdown-menu'>");
			// 메뉴버튼: 자기댓글 => 수정/삭제, 남의댓글 => 신고
			if(isWriter){
				sbReturn.append("<li><a class='dropdown-item' onclick='modifyComment(\"" + cSeq + "\")'>수정하기</a></li>");	
				sbReturn.append("<li><a class='dropdown-item' onclick='deleteComment(\"" + cSeq + "\")'>삭제하기</a></li>");
			}else {
				sbReturn.append("<li><a class='dropdown-item' onclick='report(\"" + cSeq + "\", \"comment\")'>신고하기</a></li>");	
			}
			sbReturn.append("</ul>");
			sbReturn.append("</span>");
			sbReturn.append("<br>");
			
			sbReturn.append("<span id='cmtContent" + cSeq + "'>");
			sbReturn.append(cContent);
			sbReturn.append("</span>");
			
			sbReturn.append("<hr class='mt-3 my-2'>");
			sbReturn.append("</div>");
		 }
		
		return sbReturn.toString();
	}
	
	// 댓글 삭제
	@PostMapping("/commentDelete")
	public String commentDelete(HttpServletRequest req) {
		String boardSeq = req.getParameter("boardSeq");
		String userSeq = req.getParameter("userSeq");
		String commentSeq = req.getParameter("commentSeq");
		commentDAO.commentDelete(commentSeq, boardSeq);
		
		String strReturn = commentsBuilder(boardSeq, userSeq);

		return strReturn;
	}
	
	// 댓글 수정
	@PostMapping("/modifyComment")
	public String modifyComment(HttpServletRequest req) {
		String cSeq = req.getParameter("cSeq");
		String userSeq = req.getParameter("userSeq");
		String boardSeq = req.getParameter("boardSeq");
		String content = req.getParameter("content");

		commentDAO.modifyComment(cSeq, content);
		String updatedComments = commentsBuilder(boardSeq, userSeq);
		
		return updatedComments;
	}
	
	// 댓글 추천
	@PostMapping("/commentRec")
	public String commentRec(HttpServletRequest req) {
		String response;
		
		String cmtSeq = req.getParameter("cmtSeq");
		String memSeq = req.getParameter("memSeq");
		String boardSeq = req.getParameter("boardSeq");

		if(memSeq.equals("") || memSeq.equals("null")) {
			response = "0";
		}else {
			int recCheck = commentDAO.commentRecCheck(memSeq, cmtSeq);
			
			if(recCheck == 0) {
				commentDAO.commentRec(memSeq, cmtSeq);
				response = "1";
					
				String updatedComments = commentsBuilder(boardSeq, memSeq); 
				response += updatedComments;
			}else {
				commentDAO.commentRecCancel(memSeq, cmtSeq);
				response = "2";
					
				String updatedComments = commentsBuilder(boardSeq, memSeq);
				response += updatedComments;
			}
		}
		
		return response;
	}
	
	// 신고 팝업창
	@RequestMapping("/report")
	public ModelAndView report(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("/community/report_form");
		
		// 게시글인지 댓글인지
		String targetType = req.getParameter("targetType");
		String subject = null;
		// 글 또는 댓글 seq
		String seq = req.getParameter("seq");
		
		// 신고자 정보
		MemberTO userInfo = (MemberTO)req.getSession().getAttribute("logged_in_user");
		String userSeq = null;
		if(userInfo == null) {
			// 로그인하지 않고 신고페이지를 요청할경우 로그인페이지로 
			mav.setViewName("/login/login");
		}else {
			userSeq = userInfo.getSeq();
		}
		
		// 신고글 정보
		String content = null;
		String writer = null;
		String boardSeq = null;
		String commentSeq = null;
		if(targetType.equals("board")) {
			// 게시글인경우 게시글정보
			BoardTO to = new BoardTO();
			to.setSeq(seq);
			to = boardDAO.boardView(to);
			subject = to.getSubject();
			content = to.getContent();
			writer = to.getWriter();
			boardSeq = to.getSeq();
		}else if(targetType.equals("comment")) {
			// 댓글인경우 댓글정보
			CommentTO to = new CommentTO();
			to.setSeq(seq);
			to = commentDAO.getCmtInfoBySeq(to);
			content = to.getContent();
			writer = to.getWriter();
			boardSeq = to.getBoardSeq();
			commentSeq = to.getSeq();
		}
		
		System.out.println("boardSeq : " +  boardSeq);
		
		mav.addObject("targetType", targetType);
		mav.addObject("subject", subject);
		mav.addObject("boardseq", boardSeq);
		mav.addObject("commentSeq", commentSeq);
		mav.addObject("userSeq", userSeq);
		mav.addObject("content", content);
		mav.addObject("writer", writer);
		
		return mav;
	}
	
	// 신고 접수
	@RequestMapping("/newReport")
	public void newReport(HttpServletRequest req) {
		String boardSeq = req.getParameter("boardSeq");
		String commentSeq = req.getParameter("commentSeq");
		String memSeq = req.getParameter("memSeq");
		String content = req.getParameter("reason");
		
		System.out.println("컨트롤러 - 신고접수");
		System.out.println(boardSeq);
		System.out.println(commentSeq);
		
		ReportTO to = new ReportTO();
		to.setBoardSeq(boardSeq);
		to.setCommentSeq(commentSeq);
		to.setMemSeq(memSeq);
		to.setContent(content);
		
		int result = reportDAO.newReport(to);
		
		//return result;
	}
	
	// ck에디터 이미지 업로드하기@@
	@PostMapping( value = { "/upload/freeboard", "/upload/announce" })
	public String imgUpload(HttpServletRequest req, MultipartFile upload) {
		Boolean uploadResult = false;
		
		String originalFileName = upload.getOriginalFilename();
		String fileNamePrefix = originalFileName.substring(0, originalFileName.lastIndexOf("."));
		String fileNameSuffix = originalFileName.substring(originalFileName.lastIndexOf("."));
		String curTime = "_" + System.currentTimeMillis();
		
		String newFileName = fileNamePrefix + curTime + fileNameSuffix;
		
		try {
			upload.transferTo(new File(newFileName));
			uploadResult = true;
		} catch (IllegalStateException e) {
			System.out.println("파일 업로드 오류 - " + e.getMessage());
		} catch (IOException e) {
			System.out.println("파일 업로드 오류 - " + e.getMessage());
		}
		
		String url = "./upload/" + newFileName;
		String result = "{\"url\": \"" + url + "\", \"uploaded\": \"" + uploadResult + "\"}";
		
		return result;
	}
	
	// 글쓰기
	@PostMapping( value = { "/freeBoardWriteOk", "/announceBoardWriteOk" } )
	public int writeOk(HttpServletRequest req){
		int result = 0;
		
		String subject = req.getParameter("subject");
		String content = req.getParameter("content");
		String memSeq = req.getParameter("memSeq");
		String writer = req.getParameter("writer");
		String boardType = req.getParameter("boardType");
		String wip = req.getRemoteAddr();
		// 여러 태그들 구분자 합의필요, 임시로 공백사용
		//String[] tags = req.getParameter("tags").split(" "); 
		String tag = req.getParameter("tags");

		BoardTO to = new BoardTO();
		to.setSubject(subject);
		to.setContent(content);
		to.setWriter(writer);
		to.setMemSeq(memSeq);
		to.setBoardType(boardType);
		to.setTag(tag);
		to.setWip(wip);
		
		result = boardDAO.writeNew(to);
		
		return result;
	}
	
	// 글 추천
	@PostMapping("/rec")
	public int recommend(HttpServletRequest req) {
		System.out.println();
		int response = 0;
		
		String boardSeq = req.getParameter("boardSeq");
		String userSeq = req.getParameter("userSeq");
		String isWriter = req.getParameter("isWriter");
		
		if(userSeq == "") {
			response = 2;
		}else {
			int recCheck = boardDAO.recCheck(userSeq, boardSeq);
			if(recCheck == 1) {
				// 이미 추천한 게시글인 경우, 추천해제
				boardDAO.boardRecommendCancel(userSeq, boardSeq);
				response = 3;
			}else {
				// 추천 성공
				boardDAO.boardRecommend(userSeq, boardSeq);
				response = 1;
			}
		}
		
		// 추천수 업데이트
		int updatedRecCnt = boardDAO.recCount(boardSeq);
		response += (updatedRecCnt * 10);
		
		return response;
	}
	
	// community/party
	@RequestMapping("/partyBoardList")
	public ModelAndView partyBoardList(HttpServletRequest request) {
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		String select = request.getParameter("select");
		String search =	request.getParameter("search");
		
		ArrayList<BoardTO> announceList = boardDAO.announceListTwo();
		BoardListTO listTO = new BoardListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setKeyWord("%" + search + "%");
		listTO.setBoardType("2");
		
		if(select == null) {
			listTO.setQuery("");
		} else if(select.equals("0")) {
			// 전체 검색
			listTO.setQuery("(subject like #{keyWord} or content like #{keyWord} or m.nickname like #{keyWord} or tag like #{keyWord}) and");
		} else if(select.equals("1")) {
			// 제목 검색
			listTO.setQuery("subject like #{keyWord} and");
		} else if(select.equals("2")) {
			// 제목 + 내용 검색
			listTO.setQuery("(subject like #{keyWord} or content like #{keyWord}) and");
		} else if(select.equals("3")) {
			// 작성자 검색
			listTO.setQuery("m.nickname like #{keyWord} and");
		} else if(select.equals("4")) {
			// 태그 검색
			listTO.setQuery("tag like #{keyWord} and");
		} else {
			// 전체 검색
			listTO.setQuery("");
		}
		
		listTO = boardDAO.boardList(listTO);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("community/party/party_board_list");
		modelAndView.addObject("announceList", announceList);
		modelAndView.addObject("listTO", listTO);
		
		return modelAndView;
	}
	
	@RequestMapping("/partyBoardView")
	public ModelAndView partyBoardView(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("community/party/party_board_view");
		
		String seq = request.getParameter("seq");
		
		BoardTO to = new BoardTO();
		to.setSeq(seq);
		to = boardDAO.boardView(to);
		
		if(to == null) {
			modelAndView.setViewName("community/no_board");
			
			return modelAndView;
		}
		
		to.setRecCnt(boardDAO.recCount(to.getSeq()) + "");
		
		if(to.isDel()) {
			modelAndView.setViewName("community/deleted_board");
			
			return modelAndView;
		}

		MemberTO userInfo = (MemberTO)request.getSession().getAttribute("logged_in_user");
		String uSeq = null;
		
		int status = 0;
		if(userInfo != null) {
			ApplyTO ato = new ApplyTO();
			ato.setPartySeq(seq);
			ato.setSenderSeq(userInfo.getSeq());
			status = partyDAO.isApplied(ato);
			
			uSeq = userInfo.getSeq();
		}

		String comments = commentsBuilder(seq, uSeq);
		
		// 보고있는 유저의 게시글 추천여부 감지
		boolean didUserRec = false;
		if(uSeq != null) {
			int recCheck = boardDAO.recCheck(uSeq, request.getParameter("seq"));
			if(recCheck == 1) {
				didUserRec = true;
			}
		}
		
		modelAndView.addObject("to", to);
		modelAndView.addObject("status", status);
		modelAndView.addObject("didUserRec", didUserRec);
		modelAndView.addObject("comments", comments);
		
		return modelAndView;
	}
	
	@PostMapping("/partyApplyOk")
	public int partyApplyOk(HttpServletRequest request) {
		ApplyTO ato = new ApplyTO();
		
		ato.setSenderSeq(request.getParameter("memSeq"));
		ato.setPartySeq(request.getParameter("boardSeq"));
		
		int flag = partyDAO.applyPartyOk(ato);
		return flag;
	}
	
	@PostMapping("/partyToggleOk")
	public int partyCancelAppliedOk(HttpServletRequest request) {
		ApplyTO ato = new ApplyTO();
		
		ato.setSenderSeq(request.getParameter("memSeq"));
		ato.setPartySeq(request.getParameter("boardSeq"));
		ato.setStatus(request.getParameter("status"));
		
		int flag = partyDAO.togglePartyOk(ato);
		return flag;
	}

	@RequestMapping("/partyBoardRegister")
	public ModelAndView partyBoardRegister(HttpServletRequest request) {
		MemberTO userInfo = (MemberTO)request.getSession().getAttribute("logged_in_user");
		
		if(userInfo != null) {
			return new ModelAndView("community/party/party_board_register");
		}else {
			return new ModelAndView("mypage/no_login");
		}
	}

	@PostMapping("/partyBoardRegisterOk")
	public int partyBoardRegisterOk(HttpServletRequest request) {
		MemberTO userInfo = (MemberTO)request.getSession().getAttribute("logged_in_user");
		int flag = 1;
		
		if(userInfo != null) {
			// 모임 글 정보
			BoardTO bto = new BoardTO();
			bto.setMemSeq(userInfo.getSeq());
			bto.setSubject(request.getParameter("subject"));
			String content = request.getParameter("content");
			if(content != null){
				bto.setContent(content);
			}
			bto.setWip(request.getRemoteAddr());
			bto.setTag(request.getParameter("tag"));
			bto.setBoardType("2");
			
			// 모임 위치, 시간 정보 등
			PartyTO pto = new PartyTO();
			String adr = request.getParameter("address");
			String extra = request.getParameter("extra");
			if(extra != null){
				adr = adr.concat(extra);
			}
			pto.setAddress(adr);
			pto.setDetail(request.getParameter("detail"));
			pto.setLocation(request.getParameter("location").trim());
			pto.setDate(request.getParameter("date"));
			pto.setDesired(request.getParameter("desired"));
			pto.setLoccode(request.getParameter("loccode"));
			pto.setLatitude(request.getParameter("latitude"));
			pto.setLongitude(request.getParameter("longitude"));
			
			flag = partyDAO.registerPartyOk(bto, pto);
		}
		return flag;
	}
	
	@RequestMapping("/partySearch")
	public ModelAndView partySearch() {
		ModelAndView model = new ModelAndView("community/party/party_search");
		return model;
	}

	@GetMapping("/api/geoCodes.json")
	public ModelAndView getGeocodes(HttpServletRequest request) {
		String prvcode = request.getParameter("prvcode") != null ? request.getParameter("prvcode") : "";

		ModelAndView model = new ModelAndView("community/party/geocodes");
		model.addObject("prvcode", prvcode);
		return model;
	}

	@GetMapping("/api/party.json/{type}/{value}")
	public ArrayList<ApiPartyTO> partyApi(HttpServletRequest request, @PathVariable Map<String, String> param) {
		ArrayList<ApiPartyTO> data = null;
		
		String type = param.get("type");
		String value = param.get("value");
		
		// 0: 도(시) 검색 / 1: 시/군(구) 검색 / 2: 유저 검색
		if(type.equals("prvcode")) {
			data = partyDAO.getParties(0, value);
		}else if(type.equals("sggcode")) {
			data = partyDAO.getParties(1, value);
		}else if(type.equals("user")) {
			data= partyDAO.getParties(2, value);
		}
		
		return data;
	}

	
	// game
	@RequestMapping("/evalDeleteOk")
	public int evalDeleteOk(HttpServletRequest request) {
		EvaluationTO to = new EvaluationTO();
		to.setSeq(request.getParameter("evalSeq"));
		to.setGameSeq(request.getParameter("seq"));
		
		int flag = evalDAO.evalDeleteOk(to);
		
		return flag;
	}
	
	@RequestMapping("/evalRecommendWriteOk")
	public int evalRecommendWriteOk(HttpServletRequest request) {
		String seq = request.getParameter("seq");
		String evalSeq = request.getParameter("evalSeq");
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		int isEvalRec = Integer.parseInt(request.getParameter("isEvalRec"));
		
		int flag = 2;
		// 1: 해제 2: 추가
		if(isEvalRec == 1) {
			flag = evalDAO.evalRecommendDeleteOk(userSeq, evalSeq);
		} else if(isEvalRec == 2) {
			flag = evalDAO.evalRecommendInsertOk(userSeq, evalSeq);
		}
		
		return flag;
	}
	
	@RequestMapping("/evalWriteOk")
	public int evalWriteOk(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		EvaluationTO to = new EvaluationTO();
		to.setGameSeq(request.getParameter("gameSeq"));
		to.setMemSeq(userSeq);
		to.setRate(request.getParameter("rate"));
		to.setDifficulty(request.getParameter("difficulty"));
		to.setEval(request.getParameter("eval"));
		
		int flag = evalDAO.evalWriteOk(to);
		
		return flag;
	}
	
	@RequestMapping("/gameFavoriteWriteOk")
	public int gameFavoriteWriteOk(HttpServletRequest request) {
		String seq = request.getParameter("seq");
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		int isFav = Integer.parseInt(request.getParameter("isFav"));
		
		int flag = 2;
		// 1: 해제 2: 추가
		if(isFav == 1) {
			flag = gameDAO.gameFavoriteDeleteOk(userSeq, seq);
		} else if(isFav == 2) {
			flag = gameDAO.gameFavoriteInsertOk(userSeq, seq);
		}
		
		return flag;
	}
	
	@RequestMapping("/gameRecommendWriteOk")
	public int gameRecommendWriteOk(HttpServletRequest request) {
		String seq = request.getParameter("seq");
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		int isRec = Integer.parseInt(request.getParameter("isRec"));
		
		int flag = 2;
		// 1: 해제 2: 추가	
		if(isRec == 1) {
			flag = gameDAO.gameRecommendDeleteOk(userSeq, seq);
		} else if(isRec == 2) {
			flag = gameDAO.gameRecommendInsertOk(userSeq, seq);
		}
		
		return flag;
	}
	
	@RequestMapping("/gameSearch")
	public ModelAndView gameSearch(HttpServletRequest request) {
		
		String keyword = "";
		if(request.getParameter("stx") != null) {
			keyword = request.getParameter("stx");
		}
		
		String players = "";
		if(request.getParameter("players") != null) {
			players = request.getParameter("players");
		}
		
		String genre = "";
		if(request.getParameter("genre") != null) {
			genre = request.getParameter("genre");
		}
		
		String sort = "yearpublished";
		if(request.getParameter("sort") != null) {
			sort = request.getParameter("sort");
		} else {
			sort = "yearpublished";
		}

		SearchFilterTO filterTO = new SearchFilterTO();
		filterTO.setKeyword(keyword);
		filterTO.setPlayers(players);
		filterTO.setGenre(genre);
		filterTO.setSort(sort);
		
		ArrayList<BoardgameTO> lists = gameDAO.gameSearch(filterTO);
		
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq != null) {
			LogsTO logTO = new LogsTO();
	        logTO.setMemSeq(userSeq);
	        logTO.setLog("게임검색");
	        logTO.setLogType("2");
	        
	        String remarks = "검색어: ";
	        if(!keyword.equals("")) {
	        	remarks += keyword;
	        }
	        
	        remarks += "<br>";
	        
	        if(!players.equals("")) {
	        	remarks += players + "명/";
	        }
	        
	        if(!genre.equals("")) {
	        	remarks += genre + "/";
	        }
	        
	        if(sort.equals("yearpublished")) {
	        	remarks += "최신순";
	        } else if(sort.equals("hit")) {
	        	remarks += "조회수";
	        } else if(sort.equals("recCnt")) {
	        	remarks += "추천순";
	        }

	        logTO.setRemarks(remarks);
	        
	        logsDAO.logsWriteOk(logTO);
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("game/game_search");
		modelAndView.addObject("lists", lists);
		return modelAndView;
	}
	
	@RequestMapping("/gameView")
	public ModelAndView gameView(HttpServletRequest request) {
		BoardgameTO gameTO = gameDAO.gameInfo(request.getParameter("seq"));
		if(gameTO == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("game/no_info");
			
			return modelAndView;
		}
		
		gameTO = gameDAO.getBgColor(gameTO);
		
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		ArrayList<BoardgameTO> recently_list = (ArrayList<BoardgameTO>)session.getAttribute("recently_list");
		if(recently_list == null) {
			recently_list = new ArrayList<BoardgameTO>();
			session.setAttribute("recently_list", recently_list);
		}
		
		for(BoardgameTO to: recently_list) {
			if(to.getTitle().equals(gameTO.getTitle())) {
				recently_list.remove(to);
				break;
			}
		}
		
		recently_list.add(0, gameTO);
		
		if(recently_list.size() > 12) {
			recently_list.remove(recently_list.size()-1);
		}
		
		BoardListTO listTO = new BoardListTO();
		listTO.setKeyWord(gameTO.getTitle());
		listTO.setBoardType("1");
		listTO.setQuery("tag like #{keyWord} and");
		
		listTO = boardDAO.boardList(listTO);
		ArrayList<EvaluationTO> evalList = evalDAO.evalList(gameTO.getSeq());
		
		int isRec = 0;
		int isFav = 0;
		
		if(userSeq != null) {
			isRec = memberDAO.isRecommend(gameTO.getSeq(), userSeq);
			isFav = memberDAO.isFavorites(gameTO.getSeq(), userSeq);
		}
		
		for(EvaluationTO eval: evalList) {
			eval.setIsEvalRec(0);
			if(userSeq != null) {
				eval.setIsEvalRec(evalDAO.isEvalRecoomend(userSeq, eval.getSeq()));
			}
		}
		
		gameTO.setRate(evalDAO.evalRateAvg(gameTO.getSeq()));
		gameTO.setDifficulty(evalDAO.evalDifficultyAvg(gameTO.getSeq()));
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("game/game_view");
		modelAndView.addObject("gameTO", gameTO);
		modelAndView.addObject("isRec", isRec);
		modelAndView.addObject("isFav", isFav);
		modelAndView.addObject("listTO", listTO);
		modelAndView.addObject("evalList", evalList);
		
		return modelAndView;
	}
	
	// login
	// 카카오 소셜로그인
	@RequestMapping("/loginKakao")
	public ModelAndView loginKakao(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("login/login_kakao");
			
		return mav;
	}
	
	// 소셜로그인 > 서버측 세션에 토큰, 유저정보 저장요청
	@PostMapping("/saveToken")
	@ResponseBody
	public String save_token(HttpServletRequest req) {
		String userInfo = req.getParameter("userInfo");
		
		String uuid = userInfo.split("/")[0];
		String nickname = userInfo.split("/")[1];
		String email = userInfo.split("/")[2];
		
		MemberTO to = new MemberTO();
		to.setUuid(uuid);
		to.setNickname(nickname);
		to.setEmail(email);
		to.setHintSeq("0");
		to.setPassword("");
		to.setAnswer("");
		to.setRate(30);
		
		to = memberDAO.trySocialLogin(to);
        req.getSession().setAttribute("logged_in_user", to);
        
        LogsTO logTO = new LogsTO();
        logTO.setMemSeq(to.getSeq());
        logTO.setLog("로그인");
        logTO.setRemarks("");
        logTO.setLogType("1");
        
        logsDAO.logsWriteOk(logTO);
        
        return "소셜로그인 성공";
	}
	
	// 일반로그인 처리
	@RequestMapping("/loginOk")
	public int loginOk(HttpServletRequest req) {
		int flag = 1;
		
		MemberTO to = new MemberTO();
		to.setId(req.getParameter("id"));
		to.setPassword(req.getParameter("password"));
		to = memberDAO.normalLogin(to);
		
		// 로그인 성공/오류 처리
		if(to != null) {
			req.getSession().setAttribute("logged_in_user", to);
			flag = 0;
			
			LogsTO logTO = new LogsTO();
	        logTO.setMemSeq(to.getSeq());
	        logTO.setLog("로그인");
	        logTO.setRemarks("");
	        logTO.setLogType("1");
	        
	        logsDAO.logsWriteOk(logTO);
		}

		return flag;
	}
	
	@RequestMapping("/login")
	public ModelAndView login(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("login/login");
		
		return modelAndView;
	}
	
	// 로그아웃 처리 페이지
	@RequestMapping("/logout")
	public ModelAndView logout(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		ModelAndView mav = new ModelAndView("login/logout");
		
		LogsTO logTO = new LogsTO();
        logTO.setMemSeq(userSeq);
        logTO.setLog("로그아웃");
        logTO.setRemarks("");
        logTO.setLogType("1");
        
        logsDAO.logsWriteOk(logTO);
		
		return mav;
	}
	
	// login/find
	// 아이디 찾기
	@RequestMapping("/findId")
	public ModelAndView findId(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("login/find/find_id");
		
		MemberTO to = new MemberTO();
		String email = req.getParameter("email");
		to.setEmail(email);
		
		to = memberDAO.findId(to);
		// 입력한 이메일에 해당하는 아이디가 없을 경우 => 에러코드 포함해서 찾기페이지로 회귀
		if(to == null) {
			mav.setViewName("login/find/find");
			mav.addObject("error", "id_error");
		} else {
			// 입력한 이메일해 해당하는 아이디 존재 => 아이디에 등록된 이메일로 아이디정보 발송
			String id = to.getId();
			String toEmail = email;
			String toName = email;
			String subject = "DUKR - 사용자 아이디";
			String content = "귀하의 아이디는 " + id + " 입니다";
			
			this.mailSender1(toEmail, toName, subject, content);
			System.out.println("전송완료");
		}
		
		return mav;
	}
	
	// 사용자 아이디찾기 - 메일샌더
	public void mailSender1(String toEmail, String toName, String subject, String content) {
		SimpleMailMessage simpleMailMessage = new SimpleMailMessage();
		
		simpleMailMessage.setTo(toName);
		simpleMailMessage.setSubject(subject);
		simpleMailMessage.setText(content);
		simpleMailMessage.setSentDate(new Date());
		
		javaMailSender.send(simpleMailMessage);
		System.out.println("전송완료");
	}
	
	// 아이디/비밀번호 찾기
	@RequestMapping("/find")
	public ModelAndView find(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("login/find/find");

		if(req.getAttribute("sucess") != null) {
			mav.addObject("sucess", req.getAttribute("success"));
		}
		
		return mav;
	}
	
	// 비밀번호 찾기
	@RequestMapping("/findPassword")
	public ModelAndView findPassword(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("login/find/new_password");
		
		MemberTO to = new MemberTO();
		to.setId(req.getParameter("id"));
		to.setHintSeq(req.getParameter("hintSeq"));
		to.setAnswer(req.getParameter("hint_ans"));

		to = memberDAO.findPassword(to);
		// 입력한 정보에 해당하는 아이디가 없을 경우 => 에러코드 포함해서 찾기페이지로 회귀
		if(to == null) {
			mav.setViewName("login/find/find");
			mav.addObject("error", "pwd_error");
		} else {
			mav.addObject("to", to);
		}
		
		return mav;
	}
	
	// 비밀번호 변경
	@RequestMapping("/newPwdOk")
	public int newPwdOk(HttpServletRequest req) {
		int flag = 1;
		
		MemberTO to = new MemberTO();
		to.setSeq(req.getParameter("seq"));
		to.setPassword(req.getParameter("new_pwd1"));
		
		int result = memberDAO.newPassword(to);
		
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// login/signup
	// 회원가입 - DB통신
	@RequestMapping("/signupOk")
	public int signupOk(HttpServletRequest req) {
		int flag = 1;
		
		MemberTO to = new MemberTO();
		to.setId(req.getParameter("id"));
		to.setNickname(req.getParameter("nickname"));
		to.setPassword(req.getParameter("password"));
		to.setEmail(req.getParameter("email"));
		to.setHintSeq(req.getParameter("hintSeq"));
		to.setAnswer(req.getParameter("answer"));
		to.setRate(30);
		
		int result = memberDAO.addMember(to);
		if(result == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	// 회원가입 페이지
	@RequestMapping("/signup")
	public ModelAndView signup(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("login/signup");
		return mav;
	}
	
	// 아이디 중복확인
	@PostMapping("/duplCheck")
	@ResponseBody
	public String duplCheck(HttpServletRequest req) {
		String id = req.getParameter("id");
		String responseText = "possible";
		
		int count = memberDAO.duplCheck(id);
		if(count != 0) {
			responseText = "impossible";
		}
		
		return responseText;
	}
	
	// 이메일 인증 1 - 중복확인 및 이메일로 코드전송
	@PostMapping("/emailDuplCheck")
	@ResponseBody
	public String emailDuplCheck(HttpServletRequest req) {
		String email = req.getParameter("email");
		System.out.println(email);
		String responseText = "possible";
		
		// 이메일 중복확인
		int count = memberDAO.emailDuplCheck(email);
		System.out.println("count - " + count);
		
		if(count != 0) {
			responseText = "impossible";
		}else {
			// 이메일 인증용 난수코드 생성, 세션에 저장
			UUID uuid = UUID.randomUUID();
			String code = uuid.toString().substring(0, 6);
			req.getSession().setAttribute("emailCode", code);
			
			// 메일전송 - 비동기처리
			Thread thread = new Thread(() -> {
				String subject = "DUKR 이메일 인증";
				String content = "귀하의 이메일 인증 코드는 " + code + " 입니다.";
				mailSender1(email, email, subject, content);
				System.out.println("메일전송 스레드 종료");
			});
			thread.start();
		}
		
		return responseText;
	}
	
	// 이메일 인증 2 - 코드일치여부 확인
	@PostMapping("/emailCodeCheck")
	@ResponseBody
	public String emailCodeCheck(HttpServletRequest req) {
		String emailCode = req.getParameter("emailCode");
		String responseText = "invalid";
		String answer = (String)req.getSession().getAttribute("emailCode");
		
		System.out.println("emailCode - " + emailCode);
		System.out.println("answer - " + answer);
		
		if(emailCode.equals(answer)) {
			System.out.println("valid@@@@@");
			responseText = "valid";
			req.getSession().removeAttribute("emailCode");
		}
		
		return responseText;
	}
		
	// 닉네임 중복확인
	@PostMapping("/nicknameCheck")
	public String nicknameCheck(HttpServletRequest req) {
		String nickname = req.getParameter("nickname");
		String responseText = "impossible";
		
		int count = memberDAO.nicknameDuplCheck(nickname);
		if(count == 0) {
			responseText = "possible";
		}
		
		return responseText;
	}
	
	// mypage
	@RequestMapping("/favgame")
	public ModelAndView favgame(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();
		
		ArrayList<BoardgameTO> list = gameDAO.myfavBoardGame(userSeq);
		
		modelAndView.addObject("myfavBoardGame", list);
		modelAndView.setViewName("mypage/mypage_favgame");
		
		return modelAndView;
	}
	
	@RequestMapping("/favwrite")
	public ModelAndView favwrite(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		BoardListTO listTO = new BoardListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setKeyWord(userSeq);
		
		listTO = boardDAO.myfavboardList(listTO);
		
		modelAndView.addObject("myfavboardList",listTO);
		modelAndView.setViewName("mypage/mypage_favwrite");
		
		return modelAndView;
	}
	
	@RequestMapping("/mypage")
	public ModelAndView mypage(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		
		userInfo = memberDAO.memberinfoGet(userSeq);
		
		String id = userInfo.getId();
		String uuid = userInfo.getUuid();
		
		//0일경우 일반회원가입후 소셜인증을 안한 회원
		//1일경우 일반회원가입후 소셜인증을 한 회원
		//2일경우 소셜회원가입을 한 회원
		int userType;
		
		if(uuid != null & id != null) {
			userType = 1;
		} else if (id == null) {
			userType = 2;
		} else {
			userType = 0;
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("userSeq", userSeq);
		modelAndView.addObject("id", id);
		modelAndView.addObject("userType", userType);
		modelAndView.addObject("email", userInfo.getEmail());
		modelAndView.addObject("nickname", userInfo.getNickname());
		modelAndView.addObject("rate", userInfo.getRate());
		modelAndView.setViewName("mypage/mypage_info");
		
		return modelAndView;
	}
	
	// 카카오 인증처리
	@PostMapping("kakaoCertifyOk")
	public String kakaoCertifyOk(HttpServletRequest request) {
		String responsetText = "해당 카카오 계정으로 인증된 아이디가 이미 존재합니다";
		
		// 현재 접속중인(소셜인증 시도하는) 유저
		MemberTO currentUser = (MemberTO)request.getSession().getAttribute("logged_in_user");
		
		String[] userInfo = request.getParameter("userInfo").split("/");
		String uuid = userInfo[0];
		String nickname = userInfo[1];
		String email = userInfo[2];

		int isDupl = memberDAO.socialAccountValidCheck(uuid);
		if(isDupl == 0) {
			currentUser.setUuid(uuid);
			int result = memberDAO.socialCertificationOk(currentUser);
			
			// 세션 - 소셜인증한 유저정보로 업데이트
			currentUser = memberDAO.memberinfoGet(currentUser.getSeq());
			request.getSession().setAttribute("logged_in_user", currentUser);
			
			responsetText = "소셜 인증이 완료되었습니다";
		}
		
		return responsetText;
	}
	
	@RequestMapping("/mypageEdit")
	public int mypageEdit(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		MemberTO memberTO = new MemberTO();
		memberTO.setSeq(userSeq);
		memberTO.setNickname(request.getParameter("nickname"));
		memberTO.setId(request.getParameter("id"));
		memberTO.setEmail(request.getParameter("email"));
		memberTO.setPassword(request.getParameter("password"));
		String newpassword = request.getParameter("newpassword");
		//소셜회원체크 소셜회원가입유저는 비밀번호 확인을 건너뛰고 닉네임 이메일 바로변경
		if(newpassword.equals("")) {
			
			int flag = memberDAO.socialmemberUpdate(memberTO);
			if(flag == 1) {
				flag = 0;
			}
			return flag;
		} else {
			int flag = memberDAO.memberpasswordCheck(memberTO);
			if(flag != 1) {
				flag = 3;
			} else {
				memberTO.setPassword(newpassword);
				flag = memberDAO.memberUpdate(memberTO);
				if(flag == 1) {
					flag = 0;
				}
			}
			return flag;
		}
	}
	
	@RequestMapping("/mycomment")
	public ModelAndView mycomment(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		
		ModelAndView modelAndView = new ModelAndView();
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		userInfo = memberDAO.memberinfoGet(userSeq);
		CommentListTO listTO = new CommentListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setKeyWord(userInfo.getNickname());
		
		listTO = commentDAO.mycommentList(listTO);
		
		modelAndView.addObject("mycommentList",listTO);
		modelAndView.setViewName("mypage/mypage_mycomment");
		
		return modelAndView;
	}
	
	@RequestMapping("/myparty")
	public ModelAndView myparty(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypage/mypage_myparty");
		
		return modelAndView;
	}
	
	@RequestMapping("/mywrite")
	public ModelAndView mywrite(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		userInfo = memberDAO.memberinfoGet(userSeq);
		BoardListTO listTO = new BoardListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setKeyWord(userInfo.getNickname());
		
		listTO = boardDAO.myboardList(listTO);
		
		modelAndView.addObject("myboardList",listTO);
		modelAndView.setViewName("mypage/mypage_mywrite");
		
		return modelAndView;
	}
	
	// mypage/myadmin
	@RequestMapping("/adminView")
	public ModelAndView adminview(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();
		
		InquiryTO inquiryTO = inquiryDAO.inquiryView(request.getParameter("seq"));
		
		modelAndView.addObject("inquiryTO", inquiryTO);
		modelAndView.setViewName("mypage/myadmin/mypage_admin_view");
		
		return modelAndView;
	}
	
	@RequestMapping("/adminWrite")
	public ModelAndView adminwrite(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypage/myadmin/mypage_admin_write");
		
		return modelAndView;
	}
	
	@RequestMapping("/adminWriteOK")
	public int adminwriteOK(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		// 0 성공 / 1 실패 및 오류
		if(userSeq == null) {
			return 1;
		}
		InquiryTO inquiryTO = new InquiryTO();
		
		inquiryTO.setSubject(request.getParameter("subject"));
		inquiryTO.setContent(request.getParameter("content"));
		inquiryTO.setInquiryType(request.getParameter("inquiryType"));
		inquiryTO.setSenderSeq(userSeq);
		
		int flag = inquiryDAO.inquiryWrite(inquiryTO);
		
		return flag;
	}
	
	@RequestMapping("/admin")
	public ModelAndView admin(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();
		
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		InquiryListTO listTO = new InquiryListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setSeq(userSeq);
		
		listTO = inquiryDAO.myInquiryList(listTO);
		
		modelAndView.addObject("listTO", listTO);
		modelAndView.setViewName("mypage/myadmin/mypage_admin");
		
		return modelAndView;
	}
	
	// mypage/mymail
	@RequestMapping("/mailGetView")
	public ModelAndView mailgetview(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();
		
		String seq = request.getParameter("seq");
		NoteTO noteTO = noteDAO.getNoteView(seq);
		if(noteTO.getStatus() == 0) {
			noteDAO.noteStatusChange(seq);
		}
		
		modelAndView.addObject("noteTO", noteTO);
		modelAndView.setViewName("mypage/mynote/mypage_note_getview");
		
		return modelAndView;
	}
	
	@RequestMapping("/mailSendView")
	public ModelAndView mailsendview(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		ModelAndView modelAndView = new ModelAndView();
		
		String seq = request.getParameter("seq");
		NoteTO noteTO = noteDAO.getNoteView(seq);
		if(noteTO.getStatus() == 0) {
			noteDAO.noteStatusChange(seq);
		}
		
		modelAndView.addObject("noteTO", noteTO);
		modelAndView.setViewName("mypage/mynote/mypage_note_sendview");
		
		return modelAndView;
	}
	
	@RequestMapping("/mailWrite")
	public ModelAndView mailwrite(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;

		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("mypage/mynote/mypage_note_write");
		
		return modelAndView;
	}
	
	@RequestMapping("mailWriteOK")
	public int mailWriteOK(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			return 1;
		}
		String receiverSeq = memberDAO.seqSearchToNickname(request.getParameter("nickname"));
		if(receiverSeq == null || receiverSeq.equals("")) {
			return 2;
		}
		NoteTO noteTO = new NoteTO();
		
		noteTO.setSenderSeq(userSeq);
		noteTO.setReceiverSeq(receiverSeq);
		noteTO.setSubject(request.getParameter("subject"));
		noteTO.setContent(request.getParameter("content"));
		
		int flag = noteDAO.noteSend(noteTO);
		
		if(flag == 1) {
			flag = 0;
		}
		
		return flag;
	}
	
	@RequestMapping("/mail")
	public ModelAndView mail(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		
		ModelAndView modelAndView = new ModelAndView();
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		NoteListTO listTO = new NoteListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setSeq(userSeq);
		
		listTO = noteDAO.mynoteGetList(listTO);
		
		modelAndView.addObject("myNoteList",listTO);
		modelAndView.setViewName("mypage/mynote/mypage_Getnote");
		
		return modelAndView;
	}
	
	@RequestMapping("/mailSend")
	public ModelAndView mailSend(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		if(userSeq == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/no_login");
			
			return modelAndView;
		}
		
		ModelAndView modelAndView = new ModelAndView();
		String cpage = request.getParameter("cpage");
		String recordPerPage = request.getParameter("recordPerPage");
		String blockPerPage = request.getParameter("blockPerPage");
		
		
		NoteListTO listTO = new NoteListTO();
		
		if(cpage != null && !cpage.equals("")) {
			listTO.setCpage(Integer.parseInt(cpage));
		}
		
		if(recordPerPage != null && !recordPerPage.equals("")) {
			listTO.setRecordPerPage(Integer.parseInt(recordPerPage));
		}
		
		if(blockPerPage != null && !blockPerPage.equals("")) {
			listTO.setBlockPerPage(Integer.parseInt(blockPerPage));
		}
		
		listTO.setSeq(userSeq);
		
		listTO = noteDAO.mynoteSendList(listTO);
		
		modelAndView.addObject("myNoteList",listTO);
		modelAndView.setViewName("mypage/mynote/mypage_Sendnote");
		
		return modelAndView;
	}
	
	@RequestMapping("/mailDeleteOK")
	public int mailDelete(HttpServletRequest request, @RequestBody List<Integer> selectedIds) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		//0 성공 / 1 실패
		if(userSeq == null) {
			
			return 1;
		}
		int flag = 0;
		for(int seq : selectedIds) {
			flag = noteDAO.noteDelte(Integer.toString(seq));
		}
		
		if(flag == 1) {
			flag = 0;
		}
		
		return flag;
	}
}
