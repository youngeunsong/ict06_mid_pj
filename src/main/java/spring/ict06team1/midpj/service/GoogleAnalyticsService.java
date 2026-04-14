package spring.ict06team1.midpj.service;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

// Google Analytics Data API를 통해 외부에서 웹 트래픽 데이터 조회
// 서비스 계정 키 위치 : C:\DEV06\기타\secret
public interface GoogleAnalyticsService {

	// 금일 트래픽
	public Map<String, Object> getTodayTrafficSummary();

    // 기간 트래픽
	public Map<String, Object> getPeriodTrafficSummary(LocalDate startDate, LocalDate endDate);
	
	// 기간별 트래픽 추이(시계열 그래프) - 일자별 방문자 수 / 페이지뷰
	public List<Map<String, Object>> getTrafficTrend(LocalDate startDate, LocalDate endDate);
}