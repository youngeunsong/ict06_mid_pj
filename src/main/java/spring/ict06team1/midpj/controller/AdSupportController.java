package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.dto.FaqDTO;
import spring.ict06team1.midpj.service.AdSupportService;
import spring.ict06team1.midpj.service.AdSupportServiceImpl;

@Controller
public class AdSupportController {

    private static final Logger logger = LoggerFactory.getLogger(AdSupportController.class);

    @Autowired
    private AdSupportService adsupportservice; 

    // [관리자 1:1 문의 관리] ---------------------------------------------------------------------------------

    // 1. 전체 및 카테고리별 문의 목록 조회
    @RequestMapping("/adInquiryList.adsp")
    public String adInquiryList(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /adInquiryList.adsp]");

        String pageNum = request.getParameter("pageNum");
        logger.info("[url => /adInquiryList.adsp] | pageNum: " + pageNum);

        adsupportservice.selectInquiryList(request, response, model);

        return "admin/support/adInquiryList"; 
    }

    // 2. 1:1 문의 상세 보기 및 답변 작성 폼
    @RequestMapping("/adInquiryDetail.adsp")
    public String adInquiryDetail(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /adInquiryDetail.adsp]");

        // 특정 문의글의 상세 내용을 로드
        String inquiry_id = request.getParameter("inquiry_id");
        logger.info("[url => /adInquiryDetail.adsp] | inquiry_id: " + inquiry_id);

        adsupportservice.inquiryDetail(request, response, model);

        return "admin/support/adInquiryDetail";
    }

    // 3. 1:1 문의 답변 등록 처리 (Action)
    @ResponseBody // JSON 응답
    @RequestMapping("/adInquiryAnswerAction.adsp")
    public Map<String, Object> adInquiryAnswerAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        
        logger.info("[url => /adInquiryAnswerAction.adsp]");

        // 1. 응답할 결과를 담을 바구니(Map)
        Map<String, Object> result = new HashMap<>();

        try {
            // 2. 기존 서비스 호출 (기존 방식 그대로 request를 전달!)
            adsupportservice.updateInquiryAnswer(request, response, model);

            // 3. 서비스가 에러 없이 끝났다면 성공 메시지
            result.put("success", true);
            
        } catch (Exception e) {
            // 4. 서비스 도중 에러가 나면 실패 메시지
            logger.error("답변 처리 중 오류 발생: " + e.getMessage());
            result.put("success", false);
        }

        // 5. Map 객체를 리턴
        return result; 
    }

    // [관리자 FAQ 관리] --------------------------------------------------------------------------------------

    // 4. FAQ 관리 목록
    @RequestMapping("/adFaqList.adsp")
    public String adFaqList(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {

        logger.info("[url => /adFaqList.adsp]");

        // 우리가 합의한 구조대로 서비스 호출 (request, response, model 다 보냄!)
        adsupportservice.getFaqList(request, response, model);

        return "admin/support/adFaqList";
    }
    
    // 5-1. FAQ 신규 등록 폼으로 이동 (하얀 입력창 띄우기)
    @RequestMapping("/adFaqWrite.adsp")
    public String adFaqWrite(Model model) {
        logger.info("[url => /adFaqWrite.adsp]");
        // 이 리턴값이 실제 JSP 파일의 경로입니다!
        return "admin/support/adFaqWrite"; 
    }
    
    // 5-2. FAQ 신규 항목 등록 처리 (Action)
    @RequestMapping("/adFaqWriteAction.adsp")
    public String adFaqWriteAction(HttpServletRequest request, HttpServletResponse response, Model model) 
            throws ServletException, IOException {

        logger.info("[url => /adFaqWriteAction.adsp]");

     // 1. request에서 데이터 직접 꺼내기 (서블릿 방식)
        String category = request.getParameter("category");      // 문의 유형
        String order_no = request.getParameter("order_no"); // 정렬 순서 (문자열로 넘어옴)
        String status = request.getParameter("status");          // 노출 상태 (즉시노출/숨김)
        String question = request.getParameter("question");      // 질문 내용
        String answer = request.getParameter("answer");          // 답변 및 상세 설명


        // 2. 서비스 호출 
        adsupportservice.insertFaqAction(request, response, model);

        // 3. 목록으로 이동
        return "redirect:/adFaqList.adsp";
    }
    
    // 6. FAQ 수정 페이지로 이동 (기존 데이터 조회)
    @RequestMapping("/adFaqUpdate.adsp")
    public String adFaqUpdate(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
    	logger.info("[url => /adFaqUpdate.adsp]");
    	
        // 서비스에서 해당 글 정보를 가져와서 모델에 담는 로직
        adsupportservice.getFaqDetail(request, response, model);
        
        return "admin/support/adFaqUpdate"; // 수정 폼 JSP로 이동
    }
    
    // 7. 기존 FAQ 항목 수정 처리 (Action)
    @RequestMapping("/adFaqUpdateAction.adsp")
    public String adFaqUpdateAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
    	logger.info("[url => /adFaqUpdateAction.adsp]");

    	adsupportservice.updateFaqAction(request, response, model);

    	return "redirect:/adFaqList.adsp";
    }

    // 8. FAQ 항목 삭제 처리 (Action)
    @RequestMapping("/adFaqDeleteAction.adsp")
    public String adFaqDeleteAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /adFaqDeleteAction.adsp]");

        adsupportservice.deleteFaqAction(request, response, model);

        return "redirect:/adFaqList.adsp";
    }
}