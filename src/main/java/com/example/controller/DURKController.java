package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.model.board.BoardDAO;
import com.example.model.board.BoardListTO;
import com.example.model.board.BoardTO;
import com.example.model.boardgame.BoardgameDAO;
import com.example.model.boardgame.BoardgameTO;
import com.example.model.boardgame.SearchFilterTO;
import com.example.model.comment.CommentDAO;
import com.example.model.comment.CommentListTO;
import com.example.model.evaluation.EvaluationDAO;
import com.example.model.evaluation.EvaluationTO;
import com.example.model.member.MemberDAO;
import com.example.model.member.MemberTO;
import com.example.model.party.ApiPartyTO;
import com.example.model.party.PartyDAO;
import com.example.model.party.PartyTO;

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
	private JavaMailSender javaMailSender;
	
	// main
	@RequestMapping("/")
	public ModelAndView root(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
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
		return modelAndView;
	}
	
	@RequestMapping("/main")
	public ModelAndView main(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
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
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/ban_user_manage");
		
		return modelAndView;
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
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/inquiry_manage");
		
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
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/report_list");
		
		return modelAndView;
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
		
		ArrayList<MemberTO> user_list = memberDAO.memberList();
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/user_list");
		modelAndView.addObject("user_list", user_list);
		
		return modelAndView;
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
	
	@RequestMapping("/announceBoardWriteOk")
	public ModelAndView announceBoardWriteOk(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("community/announce/announce_board_write_ok");
		
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
		modelAndView.addObject("to", to);
		
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
	
	// ck에디터 이미지 업로드하기@@
	@PostMapping("/upload/freeboard")
	public String imgUpload(HttpServletRequest req, MultipartFile upload) {
		//System.out.println("upload request");
		Boolean uploadResult = false;
		
		String originalFileName = upload.getOriginalFilename();
		String fileNamePrefix = originalFileName.substring(0, originalFileName.lastIndexOf("."));
		//System.out.println(fileNamePrefix);
		String fileNameSuffix = originalFileName.substring(originalFileName.lastIndexOf("."));
		//System.out.println(fileNameSuffix);
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
	@PostMapping("/freeBoardWriteOk")
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
		
		//System.out.println(content);
		//System.out.println(memSeq + " / " + boardType);
		
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

	@GetMapping("api/geoCodes.json")
	public ModelAndView getGeocodes(HttpServletRequest request) {
		String prvcode = request.getParameter("prvcode") != null ? request.getParameter("prvcode") : "";

		ModelAndView model = new ModelAndView("community/party/geocodes");
		model.addObject("prvcode", prvcode);
		return model;
	}

	@GetMapping("api/party.json")
	public ArrayList<ApiPartyTO> getParties(HttpServletRequest request) {
		ArrayList<ApiPartyTO> data = null;
		
		String loccode = request.getParameter("loccode") != null ? request.getParameter("loccode") : "";
		
		data = partyDAO.getParties(loccode);
		return data;
	}

	
	// game/info
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
	
	@RequestMapping("/gameView")
	public ModelAndView gameView(HttpServletRequest request) {
		BoardgameTO gameTO = gameDAO.gameInfo(request.getParameter("seq"));
		if(gameTO == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("game/info/no_info");
			
			return modelAndView;
		}
		
		gameTO = gameDAO.getBgColor(gameTO);
		
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
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
		modelAndView.setViewName("game/info/game_view");
		modelAndView.addObject("gameTO", gameTO);
		modelAndView.addObject("isRec", isRec);
		modelAndView.addObject("isFav", isFav);
		modelAndView.addObject("listTO", listTO);
		modelAndView.addObject("evalList", evalList);
		
		return modelAndView;
	}
	
	// game/search
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
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("game/search/game_search");
		modelAndView.addObject("lists", lists);
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
	public ModelAndView logout(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("login/logout");
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
		
		if(uuid == null) {
			userType = 0;
		} else if (id==null) {
			userType = 2;
		} else {
			userType = 1;
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
	public ModelAndView mypageEdit(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		ModelAndView modelAndView = new ModelAndView();
		
		MemberTO memberTO = new MemberTO();
		memberTO.setSeq(userSeq);
		memberTO.setNickname(request.getParameter("nickname"));
		memberTO.setId(request.getParameter("id"));
		memberTO.setEmail(request.getParameter("email"));
		memberTO.setPassword(request.getParameter("password"));
		//memberTO.setNewpassword(request.getParameter("newpassword"));
		String newpassword = request.getParameter("newpassword");
		//소셜회원체크 소셜회원가입유저는 비밀번호 확인을 건너뛰고 닉네임 이메일 바로변경
		if(newpassword.equals("")) {
			
			int flag = memberDAO.socialmemberUpdate(memberTO);
			if(flag == 1) {
				flag = 0;
			}
			modelAndView.addObject("flag", flag);
			modelAndView.setViewName("mypage/mypage_ok");
			return modelAndView;
			
		} else {
			
			int flag = memberDAO.memberpasswordCheck(memberTO);
			if(flag != 1) {
				flag = 3;
				modelAndView.addObject("flag", flag);
				modelAndView.setViewName("mypage/mypage_ok");
				
			} else {
				memberTO.setPassword(newpassword);
				flag = memberDAO.memberUpdate(memberTO);
				if(flag == 1) {
					flag = 0;
				}
				
				modelAndView.addObject("flag", flag);
				modelAndView.setViewName("mypage/mypage_ok");
				
			}
			
			return modelAndView;
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
		modelAndView.setViewName("mypage/myadmin/mypage_admin");
		
		return modelAndView;
	}
	
	// mypage/mymail
	@RequestMapping("/mailGetview")
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
		modelAndView.setViewName("mypage/mymail/mypage_mail_getview");
		
		return modelAndView;
	}
	
	@RequestMapping("/mailSendview")
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
		modelAndView.setViewName("mypage/mymail/mypage_mail_sendview");
		
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
		modelAndView.setViewName("mypage/mymail/mypage_mail_write");
		
		return modelAndView;
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
		modelAndView.setViewName("mypage/mymail/mypage_mail");
		
		return modelAndView;
	}
}
