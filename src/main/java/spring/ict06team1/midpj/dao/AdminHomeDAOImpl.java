package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.InquiryDTO;
import spring.ict06team1.midpj.dto.SurveyDTO;


@Repository
public class AdminHomeDAOImpl implements AdminHomeDAO {
	
	@Autowired
    private SqlSession sqlSession;

	// 금일 KPI
	@Override
	public Map<String, Object> getTodayKpiSummary(Map<String, Object> map) {
		System.out.println("[AdminHomeDAOImpl - getTodayKpiSummary()]");
		
		AdminHomeDAO dao = sqlSession.getMapper(AdminHomeDAO.class);
		Map<String, Object> todayKpiSummary = dao.getTodayKpiSummary(map);
		
		return todayKpiSummary;
	}

	// 기간 KPI
	@Override
	public Map<String, Object> getPeriodKpiSummary(Map<String, Object> map) {
		System.out.println("[AdminHomeDAOImpl - getPeriodKpiSummary()]");
		
		AdminHomeDAO dao = sqlSession.getMapper(AdminHomeDAO.class);
		Map<String, Object> periodKpiSummary = dao.getPeriodKpiSummary(map);
		
		return periodKpiSummary;
	}

	// 만족도 시계열
	@Override
	public List<Map<String, Object>> getSatisfactionTrend(Map<String, Object> map) {
		System.out.println("[AdminHomeDAOImpl - getSatisfactionTrend()]");
		
		AdminHomeDAO dao = sqlSession.getMapper(AdminHomeDAO.class);
		List<Map<String, Object>> satisfactionTrend = dao.getSatisfactionTrend(map);
		
		return satisfactionTrend;
	}

	// NPS 분포
	@Override
	public List<Map<String, Object>> getNpsDistribution(Map<String, Object> map) {
		System.out.println("[AdminHomeDAOImpl - getNpsDistribution()]");
		
		AdminHomeDAO dao = sqlSession.getMapper(AdminHomeDAO.class);
		List<Map<String, Object>> npsDistribution = dao.getNpsDistribution(map);
		System.out.println("npsDistribution => " + npsDistribution);
		
		return npsDistribution;
	}

	// 만족도 통계
	@Override
	public List<Map<String, Object>> getSatisfactionStats(Map<String, Object> map) {
		System.out.println("[AdminHomeDAOImpl - getSatisfactionStats()]");
		
		AdminHomeDAO dao = sqlSession.getMapper(AdminHomeDAO.class);
		List<Map<String, Object>> satisfactionStats = dao.getSatisfactionStats(map);
		
		return satisfactionStats;
	}

	// 워드클라우드용 서술형 원문
	@Override
	public List<String> getSubjectiveSurveyAnswers(Map<String, Object> map) {
		System.out.println("[AdminHomeDAOImpl - getSubjectiveSurveyAnswers()]");
		
		AdminHomeDAO dao = sqlSession.getMapper(AdminHomeDAO.class);
		List<String> subjectiveSurveyAnswers = dao.getSubjectiveSurveyAnswers(map);
		
		return subjectiveSurveyAnswers;
	}

	// 금일 만족도 표 | 현 메서드 미사용/ 추후 작업 중 필요 시 사용하기 위해 파일만 유지
	@Override
	public List<SurveyDTO> getTodaySurveyList(Map<String, Object> map) {
		System.out.println("[AdminHomeDAOImpl - getTodaySurveyList()]");
		
		AdminHomeDAO dao = sqlSession.getMapper(AdminHomeDAO.class);
		List<SurveyDTO> todaySurveyList = dao.getTodaySurveyList(map);
		
		return todaySurveyList;
	}

	// 금일 만족도 표 총 개수 | 현 메서드 미사용/ 추후 작업 중 필요 시 사용하기 위해 파일만 유지
	@Override
	public int getTodaySurveyCount(Map<String, Object> map) {
		System.out.println("[AdminHomeDAOImpl - getTodaySurveyCount()]");
		
		AdminHomeDAO dao = sqlSession.getMapper(AdminHomeDAO.class);
		int todaySurveyCount = dao.getTodaySurveyCount(map);
		
		return todaySurveyCount;
	}

	// 미답변 문의 최근 10건
	@Override
	public List<InquiryDTO> getPendingInquiryTop10() {
		System.out.println("[AdminHomeDAOImpl - getPendingInquiryTop10()]");
		
		AdminHomeDAO dao = sqlSession.getMapper(AdminHomeDAO.class);
		List<InquiryDTO> pendingInquiryTop10 = dao.getPendingInquiryTop10();
		
		return pendingInquiryTop10;
	}

}
