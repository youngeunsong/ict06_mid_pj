package spring.ict06team1.midpj.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.InquiryDTO;

/*
 * @author 김다솜
 * 최초작성일: 2026-03-23
 * 최종수정일: 2026-03-23
 * 참고 코드: None
 * ----------------------------------
 * v260323
 * 
 * ----------------------------------
 */

@Repository
public class AdDashboardDAOImpl implements AdDashboardDAO {

	@Autowired
	private SqlSession sqlSession;

	//1. 기간별 KPI 요약

	
	//2. 만족도 설문 wordcloud
	
		
	//3. 1:1문의 미처리
	@Override
	public List<InquiryDTO> getPendingInquiryTop10() {
		System.out.println("[AdDashboardDAOImpl - getPendingInquiryTop10()]");
		
		return sqlSession.getMapper(AdDashboardDAO.class).getPendingInquiryTop10();
	}
	
	//4. 사용자 만족도 설문 결과

}
