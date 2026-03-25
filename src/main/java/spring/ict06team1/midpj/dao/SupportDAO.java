package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import spring.ict06team1.midpj.dto.FaqDTO;
import spring.ict06team1.midpj.dto.InquiryDTO;

public interface SupportDAO {

    // ===========================================================
    // 1. FAQ (자주 묻는 질문) 관련 설계
    // ===========================================================

    // 사용자용 카테고리별 Top 5 조회
    public List<FaqDTO> getFaqTop5ByCtg(@Param("category") String category);

    // 사용자용 전체 인기 질문 Top 10 조회 (사이드바)
    public List<FaqDTO> getFaqTop10Global();

    // FAQ 검색 결과 리스트 조회
    public List<FaqDTO> searchFaqList(String keyword);

    // FAQ 상세 내용 보기
    public FaqDTO getFaqDetail(int faq_id);
    
    // FAQ 조회수 증가 로직
    public int updateFaqViewCount(int faq_id);


    // ===========================================================
    // 2. INQUIRY (1:1 문의) 관련 설계
    // ===========================================================

    // 조건에 맞는 문의글 개수 계산 (페이징 및 통계용)
    public int getInquiryCount(Map<String, Object> map);

    // 1:1 문의글 신규 등록
    public int insertInquiry(InquiryDTO dto);

}