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

import spring.ict06team1.midpj.service.UserServiceImpl;

@Controller
public class UserController {

	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserServiceImpl service;
	
	// [첫페이지] ----------------------------------------------------------------------------------------
	@RequestMapping("/main.do")
	public String main(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /main >>>");

		return "common/main";
	}
	
	// [회원가입] -------------------------------------------------------------------------------------------------------------------
	// [회원가입] 회원가입 페이지 이동 -----------------------------------------------------------------------
	@RequestMapping("/join.do")
	public String join(HttpServletRequest request, HttpServletResponse response, Model model) 
		throws ServletException, IOException {
		logger.info("<<< url => join.do>>>");
		
		return "user/join/join";
	}
	
	// [회원가입] 1. 아이디 중복 확인 (AJAX에서 사용, 중복이면 1 아니면 0 반환) --------------------------------------
	@RequestMapping("/idCheck.do")
	public String idCheck(HttpServletRequest request, HttpServletResponse response, Model model) 
		throws ServletException, IOException {
		logger.info("<<< url => idCheck.do>>>");
		
		service.idCheck(request, response, model);
		
		return "user/join/idCheck";
	}
	
	// [회원가입] 2. 회원가입 처리 -----------------------------------------------------------------------------
	@RequestMapping("/joinAction.do")
	public String joinAction(HttpServletRequest request, HttpServletResponse response, Model model) 
		throws ServletException, IOException {
		logger.info("<<< url => joinAction.do>>>");
		
		service.joinAction(request, response, model);
		return "user/join/joinAction";
	}
	
	// [로그인] 2. 회원가입 처리 -----------------------------------------------------------------------------
	// 3. 로그인 인증 (아이디와 비번을 받아 일치하는 회원이 있는지 확인)
	// 로그인 페이지로 이동
	@RequestMapping("/login.do")	
	public String login(HttpServletRequest request, HttpServletResponse response, Model model) 
		throws ServletException, IOException {
		logger.info("<<< url => login.do>>>");
		
		return "user/login/login";
	}
	
	// 로그인 처리 
	@RequestMapping("/loginAction.do")	
	public String loginAction(HttpServletRequest request, HttpServletResponse response, Model model) 
		throws ServletException, IOException {
		logger.info("<<< url => loginAction.do>>>");
		
		service.loginAction(request, response, model);
		
		return "user/login/loginAction";
	}
	
	// 로그아웃 처리 
	@RequestMapping("/logout.do")	
	public String logout(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => logout.do>>>");
		
		request.getSession().invalidate();
		
		return "common/main";
	}
	
	
	// 4. 회원 탈퇴 
	// [회원탈퇴]-----------------------------
	// 회원탈퇴 - 인증화면
	@RequestMapping("/deleteUser.do")	
	public String deleteCustomer(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => deleteUser.do>>>");
		
		return "user/mypage/deleteUser";
	}
	
	// 회원탈퇴 처리	
	@RequestMapping("/deleteUserAction.do")	
	public String deleteUserAction(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => deleteUserAction.do>>>");
		
		// service.deleteUserAction(request, response, model);
		
		return "user/mypage/deleteUserAction";
	}	
		
	// 5. 회원 상세 정보 조회 (마이페이지에서 사용)
	
	// [마이페이지] ----------------------------------------------------------------------------------------
	// [마이페이지] 홈 
	@RequestMapping("/myPageHome.do")	
	public String myPageHome(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => myPageHome.do>>>");
		
		return "user/mypage/myPageHome";
	}
	
	// [마이페이지] 회원수정 - 인증화면
	@RequestMapping("/modifyUser.do")	
	public String modifyUser(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => modifyUser.do>>>");
		
		return "user/mypage/modifyUser";
	}
	
	// [마이페이지] 회원수정 - 상세페이지
	@RequestMapping("/modifyDetailPage.do")	
	public String modifyDetailPage(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => modifyDetailPage.do>>>");
		
		// service.modifyDetailPage(request, response, model); // 현재 오류 발생. 2주차에 수정 필요 
		
		return "user/mypage/modifyDetailPage";
	}
	
	// [마이페이지] 회원수정 완료 
	@RequestMapping("/modifyUserAction.do")	
	public String modifyUserAction(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => modifyUserAction.do>>>");
		
		return "user/mypage/modifyUserAction";
	}
	
	// [마이페이지] 즐겨찾기 조회-> 맛집/숙소/축제 페이지로 이동
	@RequestMapping("/viewBookmarks.do")	
	public String viewBookmarks(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => viewBookmarks.do>>>");
		
		return "user/mypage/viewBookmarks";
	}
	
	// [마이페이지] 예약 목록
	@RequestMapping("/viewReservations.do")	
	public String viewReservations(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => viewReservations.do>>>");
		
		return "user/mypage/viewReservations";
	}
	
	// [마이페이지] 예약 상세 조회
	@RequestMapping("/reservationDetail.do")	
	public String reservationDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => reservationDetail.do>>>");
		
		return "user/mypage/reservationDetail";
	}
	
	// [마이페이지] 1:1 문의목록
	@RequestMapping("/viewInquiries.do")	
	public String viewInquiries(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => viewInquiries.do>>>");
		
		return "user/mypage/viewInquiries";
	}
	
	// [마이페이지] 1:1 문의목록 상세
	@RequestMapping("/inquiryDetail.do")	
	public String inquiryDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => inquiryDetail.do>>>");
		
		return "user/mypage/inquiryDetail";
	}
	
	// [고객지원] ----------------------------------------------------------------------------------------
	// [고객지원] FAQ - FAQ페이지
	@RequestMapping("/FAQ.do")	
	public String FAQ(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => FAQ.do>>>");
		
		return "user/faq/faq";
	}
	
	// [고객지원] FAQ 상세 페이지
	@RequestMapping("/FAQDetail.do")	
	public String FAQDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => FAQDetail.do>>>");
		
		return "user/faq/faqDetail";
	}
	
	// [고객지원] 1:1문의 - inquiry 페이지
	@RequestMapping("/inquiry.do")	
	public String inquiry(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => inquiry.do>>>");
		
		return "user/inquiry/inquiry";
	}
	
	// 커뮤니티에만 공지를 넣기로 했던 것으로 기억해서 주석 처리했습니다. 혹시 추후 기능 추가 시 주석 해제하고 사용하면 될 것 같습니다.
//	// [고객지원] 공지 - notice 페이지
//	@RequestMapping("/notice.do")	
//	public String notice(HttpServletRequest request, HttpServletResponse response, Model model) 
//			throws ServletException, IOException {
//		logger.info("<<< url => notice.do>>>");
//		
//		return "user/notice/notice";
//	}
}
