package com.example.playable.sechsnimmt;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class SechsNimmtController {
	
	@RequestMapping("/playSechsNimmt")
	public ModelAndView sechsNimmt(HttpServletRequest req) {
		ModelAndView mav = new ModelAndView("/playable/sechsnimmt/sechsnimmt");
		return mav;
	}
}
