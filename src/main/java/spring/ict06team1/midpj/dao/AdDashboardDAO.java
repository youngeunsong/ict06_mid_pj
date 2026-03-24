package spring.ict06team1.midpj.dao;

import java.util.List;

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

public interface AdDashboardDAO {

	//1. 기간별 KPI 요약

	
	//2. 만족도 설문 wordcloud
	
	
	//3. 1:1문의 미처리
	public List<InquiryDTO> getPendingInquiryTop10();
	
	//4. 사용자 만족도 설문 결과
}
