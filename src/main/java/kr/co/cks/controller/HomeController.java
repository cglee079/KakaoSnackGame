package kr.co.cks.controller;

import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/")
	public String home(Locale locale, Model model) {
		return "intro";
	}
	
	@RequestMapping(value = "/play")
	public String init(Locale locale, Model model, String sound) {
		model.addAttribute("sound", sound);
		return "play";
	}
	
}
