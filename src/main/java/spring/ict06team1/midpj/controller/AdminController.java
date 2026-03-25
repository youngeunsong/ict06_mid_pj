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

import spring.ict06team1.midpj.dto.MemberDTO;
import spring.ict06team1.midpj.service.AdDashboardServiceImpl;
import spring.ict06team1.midpj.service.UserServiceImpl;

@Controller
public class AdminController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);
	
	@Autowired
	private UserServiceImpl userService;
	@Autowired
	private AdDashboardServiceImpl adDashService;

	// 0. ADMIN HOME / 대시보드
	@RequestMapping("/adminHome.ad")
	public String adminHome(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminHome.ad]");
		
		adDashService.getDashboardData(request, response, model);
		return "admin/adminHome";
	}
	
	//1. 관리자 마이페이지
	@RequestMapping("/adminMyPage.ad")
	public String adminMyPage(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminMyPage.ad]");
		
		String sessionID = (String)request.getSession().getAttribute("sessionID");
		MemberDTO dto = userService.getAdminDetail(sessionID);
		
		//관리자 정보 조회
		model.addAttribute("dto", dto);
		return "admin/mypage/adminMyPage";
	}
	
	//2. 관리자 정보 수정 처리
	@RequestMapping("/adminMyPageAction.ad")
	public String adminMyPageAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminMyPageAction.ad]");
		
		int updateCnt = userService.modifyAdminAction(request, response, model);
		model.addAttribute("updateCnt", updateCnt);
		return "admin/mypage/adminMyPageAction";
	}
	
	/*
	 * // Sample page 테스트
	 * 
	 * @RequestMapping("/adminSample.ad") public String
	 * adminSample(HttpServletRequest request, HttpServletResponse response, Model
	 * model) throws ServletException, IOException {
	 * logger.info("[url => /adminSample.ad]"); return "admin/adminSample"; }
	 */
	
	// 대시보드 - 사용자 만족도 조사 결과 표 표시
	@RequestMapping("/userSatisfactionTable.ad")
	public String userSatisfactionTable(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /userSatisfactionTable.ad]");
		
		return "admin/userSatisfactionTable";
	}
}
