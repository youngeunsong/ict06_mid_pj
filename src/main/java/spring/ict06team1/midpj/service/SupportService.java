package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dto.FaqDTO;
import spring.ict06team1.midpj.dto.InquiryDTO;

public interface SupportService {

    // ===========================================================
    // 1. FAQ (자주 묻는 질문) 관련 서비스
    // ===========================================================

    // 카테고리 클릭 시 해당 카테고리 Top 5 로드
	public List<FaqDTO> getFaqTop5ByCtg(String category);

    // 메인에서 보여줄 전체 인기 FAQ
	public List<FaqDTO> getFaqTop10Global();

    // FAQ 키워드 검색 리스트 조회
    public void searchFaqList(HttpServletRequest request, HttpServletResponse response, Model model) 
           throws ServletException, IOException;

    // FAQ 상세 보기 및 조회수 증가 처리
    public void getFaqDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
           throws ServletException, IOException;


    // ===========================================================
    // 2. INQUIRY (1:1 문의) 관련 서비스
    // ===========================================================

    // 1:1 문의 신규 등록 처리
    public void inquiryInsert(HttpServletRequest request, HttpServletResponse response, Model model) 
           throws ServletException, IOException;

    // report 때문에 추가할 메서드
    public int inquiryInsert(InquiryDTO dto);
    
    // 나의 1:1 문의 내역 리스트 조회
    public void getMyInquiryList(HttpServletRequest request, HttpServletResponse response, Model model) 
           throws ServletException, IOException;

    // 페이징 처리를 위한 전체 문의글 개수 조회 (관리자/사용자 공통)
    public void getInquiryCount(HttpServletRequest request, HttpServletResponse response, Model model) 
           throws ServletException, IOException;
}