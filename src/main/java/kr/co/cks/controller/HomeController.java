package kr.co.cks.controller;

import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {
	@RequestMapping(value = "/")
	public String home(Locale locale, Model model) {
		return "main";
	}
	
	@RequestMapping(value = "/error/size")
	public String error(Locale locale, Model model) {
		return "error/error_size";
	}
	
	
}
