package spring.ict06team1.midpj.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class AdminController {

	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

	// 0. ADMIN HOME
	@RequestMapping("/adminHome.ad")
	public String adminHome(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminHome.ad]");
//		return "admin/home";
		return "admin/adminHome";
	}
	
	// Sample page 테스트
	@RequestMapping("/adminSample.ad")
	public String adminSample(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminSample.ad]");
		return "admin/adminSample";
	}
}
