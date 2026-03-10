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

import spring.ict06team1.midpj.service.AdSupportService;
import spring.ict06team1.midpj.service.AdSupportServiceImpl;

@Controller
public class AdSupportController {

    private static final Logger logger = LoggerFactory.getLogger(AdSupportController.class);

    @Autowired
    private AdSupportServiceImpl adsupportService; // 관리자 전용 고객지원 서비스

    // [관리자 1:1 문의 관리] ---------------------------------------------------------------------------------

    // 1. 전체 및 카테고리별 문의 목록 조회
    @RequestMapping("/adInquiryList.adsp")
    public String adInquiryList(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /adInquiryList.adsp]");

         // [탭 버튼 기능 포인트] 
         // 사진 속 [예약문의, 제휴문의 등] 버튼 클릭 시 전달되는 category 파라미터를 
         // 서비스 단에서 수집하여 필터링된 리스트를 가져옵니다.
         
        adsupportService.selectInquiryList(request, response, model);

        return "admin/inquiry/adInquiryList"; 
    }

    // 2. 1:1 문의 상세 보기 및 답변 작성 폼
    @RequestMapping("/adInquiryDetail.adsp")
    public String adInquiryDetail(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /adInquiryDetail.adsp]");

        // 특정 문의글의 상세 내용을 로드
        adsupportService.inquiryDetail(request, response, model);

        return "admin/inquiry/adInquiryDetail";
    }

    // 3. 1:1 문의 답변 등록 처리 (Action)
    @RequestMapping("/adInquiryAnswerAction.adsp")
    public String adInquiryAnswerAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /adInquiryAnswerAction.adsp]");

          // [알람 기능 구현]
          // 서비스 단(updateInquiryAnswer)에서 DB 업데이트 후, 
          // '메일 발송 로직'이 이곳에서 함께 실행예정.
        
        adsupportService.updateInquiryAnswer(request, response, model);

        return "admin/inquiry/adInquiryAnswerAction";
    }


    // [관리자 FAQ 관리] --------------------------------------------------------------------------------------

    // 4. FAQ 관리 목록 (수정/삭제 버튼 포함)
    @RequestMapping("/adFaqList.adsp")
    public String adFaqList(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /adFaqList.adsp]");

        adsupportService.getFaqList(request, response, model);

        return "admin/support/adFaqList";
    }

    // 5. FAQ 신규 항목 등록 처리 (Action)
    @RequestMapping("/adFaqWriteAction.adsp")
    public String adFaqWriteAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /adFaqWriteAction.adsp]");

        adsupportService.insertFaqAction(request, response, model);

        return "admin/support/adFaqWriteAction";
    }

    // 6. 기존 FAQ 항목 수정 처리 (Action)
    @RequestMapping("/adFaqUpdateAction.adsp")
    public String adFaqUpdateAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /adFaqUpdateAction.adsp]");

        adsupportService.updateFaqAction(request, response, model);

        return "admin/support/adFaqUpdateAction";
    }

    // 7. FAQ 항목 삭제 처리 (Action)
    @RequestMapping("/adFaqDeleteAction.adsp")
    public String adFaqDeleteAction(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("[url => /adFaqDeleteAction.adsp]");

        adsupportService.deleteFaqAction(request, response, model);

        return "admin/support/adFaqDeleteAction";
    }
}