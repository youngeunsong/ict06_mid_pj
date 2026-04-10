package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.InquiryDTO;
import spring.ict06team1.midpj.dto.SurveyDTO;

/*
 * @author 김다솜/ 송혜진 / 송영은
 * 최초작성일: 2026-03-23
 * 최종수정일: 2026-03-25
 * 참고 코드: None
 * ----------------------------------
 * v260325
 * 기간내 사용자 만족도 표 조회 기능 추가 (송영은)
 * ----------------------------------
 */

public interface AdDashboardDAO {

    // 금일 KPI
	public Map<String, Object> getTodayKpiSummary(Map<String, Object> map);

    // 기간별 KPI 카드
	public Map<String, Object> getPeriodKpiSummary(Map<String, Object> map);

    // 만족도 차트용 데이터
	public List<Map<String, Object>> getSatisfactionTrend(Map<String, Object> map);

    // NPS 분포 도넛차트용 데이터
	public List<Map<String, Object>> getNpsDistribution(Map<String, Object> map);

    // 만족도 통계값 조회
	public List<Map<String, Object>> getSatisfactionStats(Map<String, Object> map);

    // 워드클라우드용 서술형 원문
	public List<String> getSubjectiveSurveyAnswers(Map<String, Object> map);
	
	// 기간내 만족도 표 
	public List<Map<String, Object>> getSatisfactionList(Map<String, Object> map);
	
	// 기간내 만족도 표 총 개수 
	public int getSurveyCount(Map<String, Object> map);

    // 금일 만족도 표 | 현 메서드 미사용/ 추후 작업 중 필요 시 사용하기 위해 파일만 유지
	public List<SurveyDTO> getTodaySurveyList(Map<String, Object> map);

    // 금일 만족도 표 총 개수 | 현 메서드 미사용/ 추후 작업 중 필요 시 사용하기 위해 파일만 유지
	public int getTodaySurveyCount(Map<String, Object> map);

    // 미답변 문의 최근 10건
	public List<InquiryDTO> getPendingInquiryTop10();
}