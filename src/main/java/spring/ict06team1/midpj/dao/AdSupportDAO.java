package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;
import spring.ict06team1.midpj.dto.FaqDTO;
import spring.ict06team1.midpj.dto.InquiryDTO;

public interface AdSupportDAO {

    // ===== [1:1 문의 관리] =====
    // 1. 문의글 총 개수 (페이징 계산용, 카테고리 필터 포함)
    public int getInquiryCount(Map<String, Object> map);

    // 2. 문의 목록 조회 (startRow, endRow 포함)
    public List<InquiryDTO> selectInquiryList(Map<String, Object> map);

    // 3. 문의글 상세 조회
    public InquiryDTO inquiryDetail(int inquiry_id);

    // 4. 문의 답변 등록 및 상태 업데이트
    public int updateInquiryAnswer(InquiryDTO dto);


    // ===== [FAQ 관리] =====
    // 5. FAQ 목록 조회
    public List<FaqDTO> getFaqList();

    // 6. 신규 FAQ 등록 
    public int insertFaq(FaqDTO dto);
    
    // 7. 수정
    public int updateFaq(FaqDTO dto);
    
    // 8. 삭제
    public int deleteFaq(int faq_id);
}