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
public class AdCommunityController {

	private static final Logger logger = LoggerFactory.getLogger(AdCommunityController.class);

	// [관리자 - 커뮤니티 관리] 홈
	@RequestMapping("/communityHome.adco")
	public String communityHome(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /communityHome.adco]");
		return "admin/community/communityHome";
	}
	
	
}
