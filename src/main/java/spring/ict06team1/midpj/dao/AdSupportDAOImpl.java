package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.FaqDTO;
import spring.ict06team1.midpj.dto.InquiryDTO;

@Repository
public class AdSupportDAOImpl implements AdSupportDAO {
	
	@Autowired
	private SqlSession sqlSession;

	// ===== [1:1 문의 관리] =====
   
	// 1. 문의글 총 개수 (페이징 계산용, 카테고리 필터 포함)
	@Override
    public int getInquiryCount(Map<String, Object> map) {
        System.out.println("AdSupportDAOImpl - getInquiryCount()");
        return sqlSession.selectOne("spring.ict06team1.midpj.dao.AdSupportDAO.getInquiryCount", map);
    }

	// 2. 페이징 처리된 문의 목록 조회 (startRow, endRow 포함)
	@Override
    public List<InquiryDTO> selectInquiryList(Map<String, Object> map) {
        System.out.println("AdSupportDAOImpl - selectInquiryList()");
        return sqlSession.selectList("spring.ict06team1.midpj.dao.AdSupportDAO.selectInquiryList", map);
    }

	// 3. 문의글 상세 조회
	@Override
    public InquiryDTO inquiryDetail(int inquiry_id) {
        System.out.println("AdSupportDAOImpl - inquiryDetail()");
        return sqlSession.selectOne("spring.ict06team1.midpj.dao.AdSupportDAO.inquiryDetail", inquiry_id);
    }

	// 4. 문의 답변 등록 및 상태 업데이트
	@Override
    public int updateInquiryAnswer(InquiryDTO dto) {
        System.out.println("AdSupportDAOImpl - updateInquiryAnswer()");
        return sqlSession.update("spring.ict06team1.midpj.dao.AdSupportDAO.updateInquiryAnswer", dto);
    }

	// ===== [FAQ 관리] =====
    // 5. FAQ 목록 조회
	@Override
    public List<FaqDTO> getFaqList() {
        System.out.println("AdSupportDAOImpl - getFaqList()");
        return sqlSession.selectList("spring.ict06team1.midpj.dao.AdSupportDAO.getFaqList");
    }

	// 6. 신규 FAQ 등록
	@Override
    public int insertFaq(FaqDTO dto) {
        System.out.println("AdSupportDAOImpl - insertFaq()");
        return sqlSession.insert("spring.ict06team1.midpj.dao.AdSupportDAO.insertFaq", dto);
    }

	// 7. 수정
	@Override
    public int updateFaq(FaqDTO dto) {
        System.out.println("AdSupportDAOImpl - updateFaq()");
        return sqlSession.update("spring.ict06team1.midpj.dao.AdSupportDAO.updateFaq", dto);
    }

	// 8. 삭제
	@Override
    public int deleteFaq(int faq_id) {
        System.out.println("AdSupportDAOImpl - deleteFaq()");
        return sqlSession.delete("spring.ict06team1.midpj.dao.AdSupportDAO.deleteFaq", faq_id);
    }

}	