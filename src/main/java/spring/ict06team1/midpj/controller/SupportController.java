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
import spring.ict06team1.midpj.dto.InquiryDTO;
import spring.ict06team1.midpj.service.SupportService;

@Controller
public class SupportController {

	private static final Logger logger = LoggerFactory.getLogger(SupportController.class);
	
    @Autowired
    private SupportService service;

    // ===========================================================
    // FAQ (자주 묻는 질문) 관련 
    // ===========================================================

    // 1. FAQ 메인 페이지 (카테고리별 Top 5 로드)
    @RequestMapping("/faqMain.sp")
    public String faqMain(HttpServletRequest request, Model model) {
        logger.info("[url => /faqMain.sp]");

        // 처음 접속 시에는 카테고리가 없으므로 null 전송 -> 서비스에서 처리함
        List<FaqDTO> top5List = service.getFaqTop5ByCtg(null); 
        List<FaqDTO> top10Global = service.getFaqTop10Global(); // 이것도 String이나 void로 변경 권장

        model.addAttribute("faqList", top5List);
        model.addAttribute("top10Global", top10Global);
        model.addAttribute("isMainPage", true);
        
        return "user/faq/faqMain"; 
    }

    // 2. 카테고리 아코디언 UI, [비동기] 카테고리 클릭 시 데이터만 반환 (JSON)
    @RequestMapping("/getFaqTop5Ctg.sp")
    @ResponseBody
    public List<FaqDTO> getFaqTop5Ctg(HttpServletRequest request) {
        String category = request.getParameter("category");
        
        // 알맹이(category)만 쏙 빼서 서비스에 전달!
        return service.getFaqTop5ByCtg(category);
    }
    
    // 3. FAQ 검색 결과 페이지, [비동기] 중앙 검색창 실시간 검색 (JSON)
    @RequestMapping("/searchFaqAjax.sp")
    @ResponseBody
    public List<FaqDTO> searchFaqAjax(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {
        logger.info("[Ajax => /searchFaqAjax.sp]");
        
        service.searchFaqList(request, response, model);
        return (List<FaqDTO>) model.asMap().get("searchResult");
    }

    // 4. FAQ 상세 페이지 (조회수 증가 로직 포함)
    @RequestMapping("/faqDetail.sp")
    public String faqDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {
    	logger.info("[url => /faqDetail.sp]");
    	
        // 서비스 내부에서 updateFaqViewCount 실행 후 상세 조회 진행
        service.getFaqDetail(request, response, model);
        return "user/faq/faqDetail";
    }


    // ===========================================================
    // 2. INQUIRY (1:1 문의) 관련 컨트롤러
    // ===========================================================

    // 5. 1:1 문의 작성 폼 이동
    @RequestMapping("/inquiryWrite.sp")
    public String inquiryWrite(HttpServletRequest request) {
        logger.info("[url => /inquiryWrite.sp]");
        
        // 세션에서 'sessionID'라는 이름으로 저장된 아이디를 꺼냅니다.
        String sessionUserId = (String) request.getSession().getAttribute("sessionID");
        
        // 로그 확인용
        logger.info("현재 로그인된 아이디: " + sessionUserId);
        
        // 로그인 체크: sessionUserId가 없으면 로그인 페이지로 리다이렉트
        if (sessionUserId == null || sessionUserId.equals("")) {
            logger.warn("로그인 세션 없음 -> login.do 이동");
            return "redirect:/login.do"; 
        }
        
        // 로그인이 확인되면 문의 작성 폼으로 이동
        return "user/inquiry/inquiryWrite";
    }

    // 6. 1:1 문의 등록 처리(Action)
    @RequestMapping("/inquiryInsert.sp")
    public String inquiryInsert(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {
    	logger.info("[url => /inquiryInsert.sp]");

    	service.inquiryInsert(request, response, model);
        
        // 등록 후 나의 문의 내역 리스트로 이동 (또는 결과 알림 페이지)
        return "redirect:/viewInquiries.do?user_id=" + request.getParameter("user_id");
    }
    
    // 7. 불편사항 등록 
    @ResponseBody
    @RequestMapping(value = "/reportInsertAjax.sp")
    public String reportInsert(InquiryDTO dto) { // Spring이 파라미터를 DTO로 바로 묶어줍니다!
        // 기존에 만들어둔 서비스의 insert 메서드를 그대로 재사용!
        // 예: int result = supportService.insertInquiry(dto); 
        int result = service.inquiryInsert(dto); 
        
        return (result > 0) ? "success" : "fail";
    }

}