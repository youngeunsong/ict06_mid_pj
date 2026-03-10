package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.ui.Model;

public interface AdSupportService {

    // ===== [1:1 문의 관리] =====
    
    // 1. 문의 목록 조회 (Paging 처리 및 카테고리 필터링 포함)
    public void selectInquiryList(HttpServletRequest request, HttpServletResponse response, Model model);

    // 2. 문의 상세 내용 조회 
    public void inquiryDetail(HttpServletRequest request, HttpServletResponse response, Model model);

    // 3. 문의 답변 등록 처리 (알람 발송)
    public void updateInquiryAnswer(HttpServletRequest request, HttpServletResponse response, Model model);


    // ===== [FAQ 관리] =====
    
    // 4. FAQ 목록 조회 
    public void getFaqList(HttpServletRequest request, HttpServletResponse response, Model model);

    // 5. 신규 FAQ 등록 처리 
    public void insertFaqAction(HttpServletRequest request, HttpServletResponse response, Model model);

    // 6. 기존 FAQ 수정 처리 
    public void updateFaqAction(HttpServletRequest request, HttpServletResponse response, Model model);

    // 7. FAQ 삭제 처리 
    public void deleteFaqAction(HttpServletRequest request, HttpServletResponse response, Model model);
}