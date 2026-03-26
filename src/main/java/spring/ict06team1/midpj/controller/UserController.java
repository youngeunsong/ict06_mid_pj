package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.List;

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

import spring.ict06team1.midpj.dto.FaqDTO;
import spring.ict06team1.midpj.service.UserServiceImpl;

@Controller
public class UserController {

	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserServiceImpl service;
	
	// [회원가입] ----------------------------------------------------------------------------------------
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
		
		/* 비로그인 상태로 북마크 클릭 시 원래 있던 페이지로 돌아오기 위한 코드 작성 */
		// 북마크) 주소창에 붙어온 next 값 파싱
	    String next = request.getParameter("next");
	    model.addAttribute("next", next);
		
		return "user/login/login";
	}
	
	// 로그인 처리
	@RequestMapping("/loginAction.do")	
	public String loginAction(HttpServletRequest request, HttpServletResponse response, Model model) 
	    throws ServletException, IOException {
	    
	    service.loginAction(request, response, model);
	    
	    int selectCnt = (Integer) request.getAttribute("selectCnt");
	    
	    if (selectCnt == 1) {
	    	// 북마크) hidden input으로 넘어온 next 값 파싱
	    	String next = request.getParameter("next");
	    	
	        // 세션에서 권한 확인
	        String userRole = (String) request.getSession().getAttribute("userRole");

	        if ("ADMIN".equals(userRole)) {
	            return "redirect:/adminHome.ad"; // 관리자면 여기로!
	        } else {
	        	// 북마크) next값이 있으면 그곳으로, 없으면 메인으로!
	        	if (next != null && !next.isEmpty()) {
	                
	        		String cp = request.getContextPath(); // cp = "/midpj"
	                
	        		// next 값에서 "/midpj" 삭제
	                if (next.startsWith(cp)) {
	                    next = next.substring(cp.length()); // 결과: "/search.do?keyword=노을"
	                }
	                
	                logger.info("<<< 중복 제거 후 리다이렉트 경로: " + next + " >>>");
	                return "redirect:" + next; // Spring이 다시 "/midpj"를 붙여서 올바른 주소가 됨
	            }
	            return "redirect:/main.do";
	        }
	    } else {
	        // 로그인 실패하면 원래 가던 jsp로
	        return "user/login/loginAction"; 
	    }
	}
	
	// 로그아웃 처리 
	@RequestMapping("/logout.do")	
	public String logout(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => logout.do>>>");
		
		request.getSession().invalidate();
		
		return "redirect:/main.do";
	}
	
	//비밀번호 찾기 폼
	@RequestMapping("/findPassword.do")
	public String findPassword(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => findPassword.do>>>");
		
		return "user/login/findPassword";
	}
	
	//비밀번호 찾기 처리
	@RequestMapping("/findPasswordAction.do")
	public String findPasswordAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => findPasswordAction.do>>>");
		service.findPasswordAction(request, response, model);
		return "user/login/findPasswordResult";
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
		
		service.deleteUserAction(request, response, model);
		
		return "user/mypage/deleteUserAction";
	}	
		
	// 5. 회원 상세 정보 조회 (마이페이지에서 사용)
	
	// [마이페이지] ----------------------------------------------------------------------------------------
	// [마이페이지] 홈 
	@RequestMapping("/myPageHome.do")	
	public String myPageHome(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => myPageHome.do>>>");
		
		String sessionID = (String)request.getSession().getAttribute("sessionID");
		
		if(sessionID == null) {
			return "redirect:/login.do";
		}
		
		service.myPageHomeAction(request, response, model);
		
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
		
		service.modifyDetailPage(request, response, model); // 현재 오류 발생. 2주차에 수정 필요 
		
		// 서비스가 model에 담아준 결과값 꺼내기 / asMap() => Model의 스프링 바구니를 자바의 Map형식으로 변환해 값을 꺼내쓰기위한 메서드
		int selectCnt = (Integer)model.asMap().get("selectCnt");
		
		if(selectCnt == 1) {
			// 인증 성공 -> 내 정보가 담긴 상세 수정 페이지로
			return "user/mypage/modifyDetailPage";
		} else {
			// 인증 실패 -> 다시 비번 입력 폼으로 보내면서 메시지 띄우기
			model.addAttribute("errMsg", "비밀번호가 틀렸습니다.");
			return "user/mypage/modifyUser";
		}
	}
	
	// [마이페이지] 회원수정 완료 
	@RequestMapping("/modifyUserAction.do")	
	public String modifyUserAction(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => modifyUserAction.do>>>");
		
		// 서비스에서 db업데이트 실행 후 결과(1 or 0)을 받아옴
		int updateCnt = service.modifyUserAction(request, response, model);
		
		// 결과값을 jsp에서 쓸 수 있도록 모델에 담기
		model.addAttribute("updateCnt",updateCnt);
		
		// 알림창을 띄워줄 결과 페이지로 이동
		return "user/mypage/modifyUserAction";
	}
	
	// [마이페이지] 즐겨찾기 조회-> 맛집/숙소/축제 페이지로 이동
	@RequestMapping("/viewBookmarks.do")	
	public String viewBookmarks(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => viewBookmarks.do>>>");
		
		// 세션에서 로그인 여부 확인
		String sessionID = (String)request.getSession().getAttribute("sessionID");
		
		if (sessionID == null) {
			return "redirect:/login.do";
		}
		
		service.viewBookmarksAction(request, response, model);
		
		return "user/mypage/viewBookmarks";
	}
	
	// [마이페이지] 예약 목록
	@RequestMapping("/viewReservations.do")	
	public String viewReservations(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => viewReservations.do>>>");
		
		String sessionID = (String) request.getSession().getAttribute("sessionID");

	    if (sessionID == null) {
	        return "redirect:/login.do";
	    }

	    service.viewMyReservationsAction(request, response, model);
	    
		return "user/mypage/viewReservations";
	}
	
	// [마이페이지] 예약 상세 조회
	@RequestMapping("/reservationDetail.do")	
	public String reservationDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => reservationDetail.do>>>");
		
		 String sessionID = (String) request.getSession().getAttribute("sessionID");

		    if (sessionID == null) {
		        return "redirect:/login.do";
		    }
		    
		    service.myReservationDetailAction(request, response, model);
		
		return "user/mypage/reservationDetail";
	}
	
	// [마이페이지] 1:1 문의목록
	@RequestMapping("/viewInquiries.do")	
	public String viewInquiries(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => viewInquiries.do>>>");
		
		// 세션에서 로그인 여부 확인
		String sessionID = (String)request.getSession().getAttribute("sessionID");
		
		if (sessionID == null) {
			return "redirect:/login.do";
		}
		
		// 페이징 계산, db조회 처리
		service.viewInquiriesAction(request, response, model);
		
		return "user/mypage/viewInquiries";
	}
	
	// [마이페이지] 1:1 문의목록 상세
	@RequestMapping("/inquiryDetail.do")	
	public String inquiryDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => inquiryDetail.do>>>");
		
		String sessionID = (String)request.getSession().getAttribute("sessionID");
		
		if (sessionID == null) {
			return "redirect:/login.do";
		}
		
		service.inquiryDetailAction(request, response, model);
		
		return "user/mypage/inquiryDetail";
	}

}	
	
