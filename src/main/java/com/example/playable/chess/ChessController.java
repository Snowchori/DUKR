package com.example.playable.chess;

import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ChessController {
	
	@RequestMapping("/playChess")
	public ModelAndView chess(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("/playable/chess/chess");
		return mav;
	}

}
