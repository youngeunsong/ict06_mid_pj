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
		// TODO Auto-generated method stub
		return 0;
	}

	// 2. 페이징 처리된 문의 목록 조회 (startRow, endRow 포함)
	@Override
	public List<InquiryDTO> selectInquiryList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	// 3. 문의글 상세 조회
	@Override
	public InquiryDTO inquiryDetail(int inquiry_id) {
		// TODO Auto-generated method stub
		return null;
	}

	// 4. 문의 답변 등록 및 상태 업데이트
	@Override
	public int updateInquiryAnswer(InquiryDTO dto) {
		// TODO Auto-generated method stub
		return 0;
	}

	// ===== [FAQ 관리] =====
    // 5. FAQ 목록 조회
	@Override
	public List<FaqDTO> getFaqList() {
		// TODO Auto-generated method stub
		return null;
	}

	// 6. 신규 FAQ 등록
	@Override
	public int insertFaq(FaqDTO dto) {
		// TODO Auto-generated method stub
		return 0;
	}

	// 7. 수정
	@Override
	public int updateFaq(FaqDTO dto) {
		// TODO Auto-generated method stub
		return 0;
	}

	// 8. 삭제
	@Override
	public int deleteFaq(int faq_id) {
		// TODO Auto-generated method stub
		return 0;
	}

}	