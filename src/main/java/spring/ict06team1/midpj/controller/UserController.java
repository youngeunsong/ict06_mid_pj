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
		
		return "user/login/login";
	}
	
	// 로그인 처리
	@RequestMapping("/loginAction.do")	
	public String loginAction(HttpServletRequest request, HttpServletResponse response, Model model) 
	    throws ServletException, IOException {
	    
	    service.loginAction(request, response, model);
	    
	    int selectCnt = (Integer) request.getAttribute("selectCnt");
	    
	    if (selectCnt == 1) {
	        // 세션에서 권한 확인
	        String userRole = (String) request.getSession().getAttribute("userRole");

	        if ("ADMIN".equals(userRole)) {
	            return "redirect:/adminHome.ad"; // 관리자면 여기로!
	        } else {
	            return "redirect:/main.do";      // 일반인이면 여기로!
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
    // [고객지원]고객센터 메인: FAQ 전체 및 카테고리 메인 페이지
    @RequestMapping("/faqMain.sp")
    public String faqMain(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /faqMain.sp]");
        
        // 서비스에서 초기 FAQ 데이터를 가져와 model에 담는 로직이 들어갈 예정입니다.
        // service.getFaqMainList(request, response, model);
        
        return "support/faqMain"; // FAQ 메인 JSP로 이동
    }
    
    // [고객지원]FAQ 카테고리별 데이터 조회: 비동기(Ajax) 방식으로 리스트(JSON) 반환
    @ResponseBody // 별도의 JSP 없이 리스트 객체를 직접 데이터로 전송합니다.
    @RequestMapping("/getFaqByCategory.sp")
    public List<FaqDTO> getFaqByCategory(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /getFaqByCategory.sp]");
        
        // 서비스에서 카테고리 필터링된 리스트를 반환받습니다.
        // return supportService.getFaqListByCategory(request, response, model);
        return null; 
    }

    // [고객지원]1:1 문의 작성 폼 이동
    @RequestMapping("/inquiryWrite.sp")
    public String inquiryWrite(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /inquiryWrite.sp]");
        
        return "support/inquiryWrite"; // 문의 작성 페이지
    }

    // [고객지원]1:1 문의 등록 처리 (Action)
    @RequestMapping("/inquiryWriteAction.sp")
    public String inquiryWriteAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /inquiryWriteAction.sp]");
        
        // 사용자가 입력한 제목, 내용 등을 DB에 저장하는 로직입니다.
        // supportService.insertInquiryAction(request, response, model);
        
        return "support/inquiryWriteAction"; // 등록 완료 알림 및 리다이렉트 페이지
    }

    // [고객지원]나의 문의내역: 본인이 작성한 내역만 확인 
    @RequestMapping("/myInquiryList.sp")
    public String myInquiryList(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /myInquiryList.sp]");
        
        // 세션 ID를 기준으로 본인의 문의글만 조회하여 model에 담습니다.
        // supportService.getMyInquiryList(request, response, model);
        
        return "support/myInquiryList"; // 나의 문의내역 JSP
    }
	

}
