package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import spring.ict06team1.midpj.dto.FaqDTO;
import spring.ict06team1.midpj.dto.InquiryDTO;

@Repository
public class SupportDAOImpl implements SupportDAO {

    @Autowired
    private SqlSession sqlSession;

    // 매퍼의 namespace와 동일하게 설정 (풀 패키지명)
    private static final String NAMESPACE = "spring.ict06team1.midpj.dao.SupportDAO";

    // ===========================================================
    // 1. FAQ (자주 묻는 질문) 관련 메서드
    // ===========================================================

    // [사용자/공통] 카테고리별 조회수 Top 5 가져오기
    @Override
    public List<FaqDTO> getFaqTop5ByCtg(String category) {
        return sqlSession.selectList(NAMESPACE + ".getFaqTop5ByCtg", category);
    }

    // [사용자/공통] 전체 FAQ 중 조회수 Top 10 가져오기 (사이드바용)
    @Override
    public List<FaqDTO> getFaqTop10Global() {
        return sqlSession.selectList(NAMESPACE + ".getFaqTop10Global");
    }

    // [사용자/공통] 검색어로 FAQ 리스트 찾기 (복구 완료!)
    @Override
    public List<FaqDTO> searchFaqList(String keyword) {
        return sqlSession.selectList(NAMESPACE + ".searchFaqList", keyword);
    }

    // [공통] FAQ 상세 내용 보기
    @Override
    public FaqDTO getFaqDetail(int faq_id) {
        return sqlSession.selectOne(NAMESPACE + ".getFaqDetail", faq_id);
    }

    // [공통] FAQ 조회수 증가 로직
    @Override
    public int updateFaqViewCount(int faq_id) {
        return sqlSession.update(NAMESPACE + ".updateFaqViewCount", faq_id);
    }


    // ===========================================================
    // 2. INQUIRY (1:1 문의) 관련 메서드
    // ===========================================================

    // [관리자/사용자 공통] 조건에 맞는 문의글 개수 세기 (페이징/검색용)
    @Override
    public int getInquiryCount(Map<String, Object> map) {
        return sqlSession.selectOne(NAMESPACE + ".getInquiryCount", map);
    }

    // [사용자] 1:1 문의글 등록하기
    @Override
    public int insertInquiry(InquiryDTO dto) {
        return sqlSession.insert(NAMESPACE + ".insertInquiry", dto);
    }

}