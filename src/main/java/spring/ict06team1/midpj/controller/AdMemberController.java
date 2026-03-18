package spring.ict06team1.midpj.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.service.AdMemberServiceImpl;

@Controller
public class AdMemberController {

	private static final Logger logger = LoggerFactory.getLogger(AdMemberController.class);
	
	@Autowired
	private AdMemberServiceImpl adMemService;

	//1. 전체 회원 목록
	@RequestMapping("/memberList.adme")
	public String memberList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /memberList.adme]");
		adMemService.getMemberList(request, response, model);
		
		return "admin/member/memberList";
	}
	
	//2. 제재 회원 목록
	@RequestMapping("/bannedList.adme")
	public String bannedList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /bannedList.adme]");
		adMemService.getBannedList(request, response, model);
		
		return "admin/member/bannedList";
	}
	
	//3. 작성자 제재(AJAX)
	@ResponseBody
	@RequestMapping("/banUser.adme")
	public String banUser(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /banUser.adme]");
		adMemService.banUser(request, response, model);
		
		int result = (Integer)request.getAttribute("result");
		
		return result > 0 ? "success" : "fail";
	}
	
	//4. 작성자 제재 해제(AJAX)
	@ResponseBody
	@RequestMapping("/unbanUser.adme")
	public String unbanUser(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /unbanUser.adme]");
		adMemService.unbanUser(request, response, model);
		
		int result = (Integer)request.getAttribute("result");
		
		return result > 0 ? "success" : "fail";
	}
	
	//5. 전체 제재
	@ResponseBody
	@RequestMapping("/bulkBan.adme")
	public String bulkBan(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /bulkBan.adme]");
		adMemService.bulkBan(request, response, model);
		
		int successCount = (Integer)request.getAttribute("successCount");
		int totalCount = (Integer)request.getAttribute("totalCount");
		return successCount + "/" + totalCount;
	}
	
	
	//6. 전체 제재 해제
	@ResponseBody
	@RequestMapping("/bulkUnban.adme")
	public String bulkUnban(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /bulkUnban.adme]");
		adMemService.bulkUnban(request, response, model);
		
		int successCount = (Integer)request.getAttribute("successCount");
		int totalCount = (Integer)request.getAttribute("totalCount");
		return successCount + "/" + totalCount;
	}
}
