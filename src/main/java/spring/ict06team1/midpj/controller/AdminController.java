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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.dto.MemberDTO;
import spring.ict06team1.midpj.service.AdDashboardService;
import spring.ict06team1.midpj.service.UserServiceImpl;

@Controller
public class AdminController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);
	
	@Autowired
	private UserServiceImpl userService;
	
	@Autowired
	private AdDashboardService adDashService;
	
	// 0. ADMIN HOME / 대시보드
	@RequestMapping("/adminHome.ad")
	public String adminHome(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminHome.ad]");
		
		adDashService.getAdminHomeDashboard(request, response, model);
		
		return "admin/adminHome";
	}
	
	// 1. 금일 사용자 만족도 표
	// 현 페이지 미사용 / 추후 작업 중 필요 시 사용하기 위해 유지
	@RequestMapping("/todaySurveyStatus.ad")
	public String todaySurveyStatus(HttpServletRequest request, HttpServletResponse response, Model model) {
		logger.info("[url => /todaySurveyStatus.ad]");
		
		adDashService.getTodaySurveyStatus(request, response, model);
		
		return "admin/todaySurveyStatus";
	}
	
	// 2. 사용자 만족도 워드클라우드 이미지 생성
	@PostMapping(value = "/admin/wordcloud.ad", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String generateWordCloud(HttpServletRequest request) {
		logger.info("[url => /admin/wordcloud.ad]");
		
		String text = request.getParameter("text");
		System.out.println("controller text => " + text);
		return adDashService.generateWordCloud(text);
	}
	
	// 3. 관리자 마이페이지
	@RequestMapping("/adminMyPage.ad")
	public String adminMyPage(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminMyPage.ad]");
		
		String sessionID = (String) request.getSession().getAttribute("sessionID");
		MemberDTO dto = userService.getAdminDetail(sessionID);
		
		model.addAttribute("dto", dto);
		return "admin/mypage/adminMyPage";
	}
	
	// 4. 관리자 정보 수정 처리
	@RequestMapping("/adminMyPageAction.ad")
	public String adminMyPageAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminMyPageAction.ad]");
		
		int updateCnt = userService.modifyAdminAction(request, response, model);
		model.addAttribute("updateCnt", updateCnt);
		
		return "admin/mypage/adminMyPageAction";
	}
	
	/*
	// Sample page 테스트
	@RequestMapping("/adminSample.ad")
	public String adminSample(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminSample.ad]");
		return "admin/adminSample";
	}
	*/
	
	// 5. 대시보드 - 사용자 만족도 조사 결과 표 표시
	@RequestMapping("/userSatisfactionTable.ad")
	public String userSatisfactionTable(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /userSatisfactionTable.ad]");
		
		return "admin/userSatisfactionTable";
	}
}