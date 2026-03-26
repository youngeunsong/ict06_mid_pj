package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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

@Repository
public class AdDashboardDAOImpl implements AdDashboardDAO {
	
	@Autowired
    private SqlSession sqlSession;

	// 금일 KPI
	@Override
	public Map<String, Object> getTodayKpiSummary(Map<String, Object> map) {
		System.out.println("[AdDashboardDAOImpl - getTodayKpiSummary()]");
		
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		Map<String, Object> todayKpiSummary = dao.getTodayKpiSummary(map);
		
		return todayKpiSummary;
	}

	// 기간 KPI
	@Override
	public Map<String, Object> getPeriodKpiSummary(Map<String, Object> map) {
		System.out.println("[AdDashboardDAOImpl - getPeriodKpiSummary()]");
		
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		Map<String, Object> periodKpiSummary = dao.getPeriodKpiSummary(map);
		
		return periodKpiSummary;
	}

	// 만족도 시계열
	@Override
	public List<Map<String, Object>> getSatisfactionTrend(Map<String, Object> map) {
		System.out.println("[AdDashboardDAOImpl - getSatisfactionTrend()]");
		
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		List<Map<String, Object>> satisfactionTrend = dao.getSatisfactionTrend(map);
		
		return satisfactionTrend;
	}

	// NPS 분포
	@Override
	public List<Map<String, Object>> getNpsDistribution(Map<String, Object> map) {
		System.out.println("[AdDashboardDAOImpl - getNpsDistribution()]");
		
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		List<Map<String, Object>> npsDistribution = dao.getNpsDistribution(map);
		System.out.println("npsDistribution => " + npsDistribution);
		
		return npsDistribution;
	}

	// 만족도 통계
	@Override
	public List<Map<String, Object>> getSatisfactionStats(Map<String, Object> map) {
		System.out.println("[AdDashboardDAOImpl - getSatisfactionStats()]");
		
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		List<Map<String, Object>> satisfactionStats = dao.getSatisfactionStats(map);
		
		return satisfactionStats;
	}

	// 워드클라우드용 서술형 원문
	@Override
	public List<String> getSubjectiveSurveyAnswers(Map<String, Object> map) {
		System.out.println("[AdDashboardDAOImpl - getSubjectiveSurveyAnswers()]");
		
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		List<String> subjectiveSurveyAnswers = dao.getSubjectiveSurveyAnswers(map);
		
		return subjectiveSurveyAnswers;
	}
	
	// 기간내 만족도 표 
	@Override
	public List<Map<String, Object>> getSatisfactionList(Map<String, Object> map) {
		System.out.println("[AdDashboardDAOImpl - getSatisfactionList()]");
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		List<Map<String, Object>> satisfactionList = dao.getSatisfactionList(map);
		return satisfactionList;
	}
	
	// 기간내 만족도 표 총 개수 
	@Override
	public int getSurveyCount(Map<String, Object> map) {
		System.out.println("[AdDashboardDAOImpl - getSurveyCount()]");
		
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		int surveyCount = dao.getSurveyCount(map);
		
		return surveyCount;
	}

	// 금일 만족도 표 | 현 메서드 미사용/ 추후 작업 중 필요 시 사용하기 위해 파일만 유지
	@Override
	public List<SurveyDTO> getTodaySurveyList(Map<String, Object> map) {
		System.out.println("[AdDashboardDAOImpl - getTodaySurveyList()]");
		
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		List<SurveyDTO> todaySurveyList = dao.getTodaySurveyList(map);
		
		return todaySurveyList;
	}

	// 금일 만족도 표 총 개수 | 현 메서드 미사용/ 추후 작업 중 필요 시 사용하기 위해 파일만 유지
	@Override
	public int getTodaySurveyCount(Map<String, Object> map) {
		System.out.println("[AdDashboardDAOImpl - getTodaySurveyCount()]");
		
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		int todaySurveyCount = dao.getTodaySurveyCount(map);
		
		return todaySurveyCount;
	}

	// 미답변 문의 최근 10건
	@Override
	public List<InquiryDTO> getPendingInquiryTop10() {
		System.out.println("[AdDashboardDAOImpl - getPendingInquiryTop10()]");
		
		AdDashboardDAO dao = sqlSession.getMapper(AdDashboardDAO.class);
		List<InquiryDTO> pendingInquiryTop10 = dao.getPendingInquiryTop10();
		
		return pendingInquiryTop10;
	}

	

	

}
