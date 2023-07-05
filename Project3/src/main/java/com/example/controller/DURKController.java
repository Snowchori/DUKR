package com.example.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.servlet.ModelAndView;

import com.example.model.ApiMeetTO;
import com.example.model.BoardDAO;
import com.example.model.BoardTO;
import com.example.model.BoardgameDAO;
import com.example.model.BoardgameTO;
import com.example.model.EvaluationDAO;
import com.example.model.EvaluationTO;
import com.example.model.MeetDAO;
import com.example.model.MeetTO;
import com.example.model.MemberDAO;
import com.example.model.MemberTO;
import com.example.model.SearchFilterTO;

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
	private MeetDAO meetDAO;
	
	@Autowired
	private JavaMailSender javaMailSender;
	
	@RequestMapping("/")
	public ModelAndView root(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("main");
		
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
		
		ArrayList<BoardgameTO> gameList = gameDAO.gameList();
		ArrayList<String> gameRecList = gameDAO.gameRecList();
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/game_manage");
		modelAndView.addObject("gameList", gameList);
		modelAndView.addObject("gameRecList", gameRecList);
		
		return modelAndView;
	}
	
	@RequestMapping("/gameModifyOk")
	public ModelAndView gameModifyOk(HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		boolean isAdmin = (userInfo != null) ? userInfo.isAdmin() : false;
		if(!isAdmin) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("admin/not_admin");
			
			return modelAndView;
		}
		BoardgameTO gameTO = new BoardgameTO();
		gameTO.setSeq(request.getParameter("seq"));
		gameTO.setBrief(request.getParameter("brief"));
		gameTO.setGenre(request.getParameter("genre"));
		gameTO.setTheme(request.getParameter("theme"));
		
		int flag = gameDAO.gameModifyOk(gameTO);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/game_modify_ok");
		modelAndView.addObject("seq", gameTO.getSeq());
		modelAndView.addObject("flag", flag);
		
		return modelAndView;
	}
	
	
	@RequestMapping("/gameView")
	public ModelAndView gameView(HttpServletRequest request) {
		BoardgameTO gameTO = gameDAO.gameInfo(request.getParameter("seq"));
		if(gameTO == null) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("game/info/no_info");
			
			return modelAndView;
		}
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		String userSeq = (userInfo != null) ? userInfo.getSeq() : null;
		
		ArrayList<BoardTO> boardList = boardDAO.boardListByTag(gameTO.getTitle());
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
		modelAndView.addObject("boardList", boardList);
		modelAndView.addObject("evalList", evalList);
		
		return modelAndView;
	}
	
	@RequestMapping("/evalWriteOk")
	public ModelAndView evalWriteOk(HttpServletRequest request) {
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
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("game/info/eval_write_ok");
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("seq", to.getGameSeq());
		
		return modelAndView;
	}
	
	@RequestMapping("/evalDeleteOk")
	public ModelAndView evalDeleteOk(HttpServletRequest request) {
		EvaluationTO to = new EvaluationTO();
		to.setSeq(request.getParameter("evalSeq"));
		to.setGameSeq(request.getParameter("seq"));
		
		int flag = evalDAO.evalDeleteOk(to);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("game/info/eval_delete_ok");
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("seq", to.getGameSeq());
		
		return modelAndView;
	}
	
	@RequestMapping("/gameFavoriteWriteOk")
	public ModelAndView gameFavoriteWriteOk(HttpServletRequest request) {
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
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("game/info/game_favorite_write_ok");
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("seq", seq);
		modelAndView.addObject("isFav", isFav);
		
		return modelAndView;
	}
	
	@RequestMapping("/gameRecommendWriteOk")
	public ModelAndView gameRecommendWriteOk(HttpServletRequest request) {
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
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("game/info/game_recommend_write_ok");
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("seq", seq);
		modelAndView.addObject("isRec", isRec);
		
		return modelAndView;
	}
	
	@RequestMapping("/recommendgameWriteOk")
	public ModelAndView recommendgameWriteOk(HttpServletRequest request, @RequestParam List<String> checkedValue) {
		HttpSession session = request.getSession();
		MemberTO userInfo = (MemberTO)session.getAttribute("logged_in_user");
		boolean isAdmin = (userInfo != null) ? userInfo.isAdmin() : false;
		if(!isAdmin) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("admin/not_admin");
			
			return modelAndView;
		}
		gameDAO.gameRecClear();
		int flag = 0;
		for(String value: checkedValue) {
			flag += gameDAO.gameRecInsert(value);
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("admin/game_recommend_write_ok");
		modelAndView.addObject("flag", flag);
		
		return modelAndView;
	}
	
	@RequestMapping("/evalRecommendWriteOk")
	public ModelAndView evalRecommendWriteOk(HttpServletRequest request) {
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
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("game/info/eval_recommend_write_ok");
		modelAndView.addObject("flag", flag);
		modelAndView.addObject("seq", seq);
		modelAndView.addObject("isEvalRec", isEvalRec);
		
		return modelAndView;
	}
	
	@RequestMapping("/map")
	public ModelAndView map(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("map");
		
		return modelAndView;
	}
	
	@RequestMapping("/meetWrite")
	public ModelAndView meetWrite(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("meet_write");
		
		return modelAndView;
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
	
	// 카카오 소셜로그인
	@RequestMapping("/loginKakao")
	public ModelAndView loginKakao(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("login/login_kakao");
			
		return mav;
	}
	
	// 일반로그인 처리
	@RequestMapping("/loginOk")
	public ModelAndView loginOk(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("login/login_ok");
		
		MemberTO to = new MemberTO();
		to.setId(req.getParameter("id"));
		to.setPassword(req.getParameter("password"));
		to = memberDAO.normalLogin(to);
		
		// 로그인 성공/오류 처리
		if(to == null) {
			mav.setViewName("login/login");
			mav.addObject("error", "error");
		}else {
			req.getSession().setAttribute("logged_in_user", to);
		}

		return mav;
	}
	
	// 소셜로그인 > 서버측 세션에 토큰, 유저정보 저장요청
	@PostMapping("/saveToken")
	@ResponseBody
	public String save_token(HttpServletRequest req) {
		//System.out.println("save token");
		//System.out.println(token);
		
		String token = req.getParameter("token");
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
		to.setCertification(true);
		to.setRate(30);
		
		to = memberDAO.trySocialLogin(to);
        req.getSession().setAttribute("logged_in_user", to);
        
        return "소셜로그인 성공";
	}
	
	// 회원가입 페이지
	@RequestMapping("/signup")
	public ModelAndView signup(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("login/signup/signup");
		return mav;
	}
	
	// 회원가입 - DB통신
	@RequestMapping("/signupOk")
	public ModelAndView signupOk(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("login/signup/signup_ok");
		
		MemberTO to = new MemberTO();
		to.setId(req.getParameter("id"));
		to.setNickname(req.getParameter("nickname"));
		to.setPassword(req.getParameter("password"));
		to.setEmail(req.getParameter("email"));
		to.setHintSeq(req.getParameter("hintSeq"));
		to.setAnswer(req.getParameter("answer"));
		to.setCertification(false);
		to.setRate(30);
		
		int result = memberDAO.addMember(to);
		mav.addObject("result", result);
		
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
	
		// 아이디/비밀번호 찾기
		@RequestMapping("/find")
		public ModelAndView find(HttpServletRequest req) {
			ModelAndView mav = new ModelAndView("login/find/find");

			if(req.getAttribute("sucess") != null) {
				mav.addObject("sucess", req.getAttribute("success"));
			}
			
			return mav;
		}
	
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
			}else {
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
		}else {
			mav.addObject("to", to);
		}
		
		return mav;
	}
	
	// 비밀번호 변경
	@RequestMapping("/newPwdOk")
	public ModelAndView newPwdOk(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("/login/find/new_pwd_ok");
		
		MemberTO to = new MemberTO();
		to.setSeq(req.getParameter("seq"));
		to.setPassword(req.getParameter("new_pwd1"));
		
		int result = 0;
		result = memberDAO.newPassword(to);
		mav.addObject("result", result);
		
		return mav;
		}
	
	@RequestMapping("/meetSearch")
	public ModelAndView searchmeet() {
		ModelAndView model = new ModelAndView("map/meet_search");
		return model;
	}
	
	@RequestMapping("/meetRegister")
	public ModelAndView registermeet() {
		
		ModelAndView model = new ModelAndView("map/meet_register");
		return model;
	}
	
	@RequestMapping("/meetRegisterOk")
	public ModelAndView registermeetok(HttpServletRequest request) {
		
		BoardTO bto = new BoardTO();
		bto.setSubject(request.getParameter("subject"));
		String content = request.getParameter("content");
		if(content != null){
			bto.setContent(content);
		}
		bto.setWip(request.getRemoteAddr());
		
		MeetTO mto = new MeetTO();
		String adr = request.getParameter("address");
		String extra = request.getParameter("extra");
		if(extra != null){
			adr = adr.concat(extra);
		}
		mto.setAddress(adr);
		mto.setDetail(request.getParameter("detail"));
		mto.setLocation(request.getParameter("location").trim());
		mto.setDate(request.getParameter("date"));
		mto.setDesired(request.getParameter("desired"));
		mto.setLoccode(request.getParameter("loccode"));
		mto.setLatitude(request.getParameter("latitude"));
		mto.setLongitude(request.getParameter("longitude"));
		
		int flag = meetDAO.registerMeetOk(bto, mto);
		
		ModelAndView model = new ModelAndView("map/meet_register_ok");
		model.addObject("flag", flag);
		return model;
	}
	
	@GetMapping("api/geoCodes.json")
	public ModelAndView geoCodes(HttpServletRequest request) {
		String loccode = request.getParameter("loccode") != null ? request.getParameter("loccode") : "";

		ModelAndView model = new ModelAndView("map/geoCodes");
		model.addObject("loccode", loccode);
		return model;
	}
	
	@GetMapping("api/meetings.json")
	@ResponseBody
	public ArrayList<ApiMeetTO> apiMeetings(HttpServletRequest request) {
		ArrayList<ApiMeetTO> data = null;
		
		String loccode = request.getParameter("loccode") != null ? request.getParameter("loccode") : "";
		
		data = meetDAO.apiMeetings(loccode);
		return data;
	}
	
	@RequestMapping("/freeBoardList")
	public ModelAndView freeBoardList(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("community/free/free_board_list");
		
		return modelAndView;
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
		
		String sort = "";
		if(request.getParameter("sort") != null) {
			sort = request.getParameter("sort");
		}

		SearchFilterTO filterTO = new SearchFilterTO();
		filterTO.setKeyword(keyword);
		filterTO.setPlayers(players);
		filterTO.setGenre(genre);
		filterTO.setSort(sort);
		
		ArrayList<Map<String, String>> lists = gameDAO.gameSearch(filterTO);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("game/search/game_search");
		modelAndView.addObject("lists", lists);
		return modelAndView;
	}
	
	//마이페이지 servlet 영역 시작
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
			
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/mypage_info");
			
			return modelAndView;
		}
		/*
		@RequestMapping("/gameSearch")
		public ModelAndView gameSearch(HttpServletRequest request) {
			ModelAndView modelAndView = new ModelAndView();
			modelAndView.setViewName("mypage/game_search");
			
			return modelAndView;
		}*/
		
		
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
			modelAndView.setViewName("mypage/mypage_mywrite");
			
			return modelAndView;
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
			modelAndView.setViewName("mypage/mypage_mycomment");
			
			return modelAndView;
		}
		
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
			modelAndView.setViewName("mypage/mypage_favwrite");
			
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
		// 마이페이지 영역 끝
}
