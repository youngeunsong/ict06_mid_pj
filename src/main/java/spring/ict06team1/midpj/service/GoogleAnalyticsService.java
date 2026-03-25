package spring.ict06team1.midpj.service;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface GoogleAnalyticsService {

	// 금일 트래픽
	public Map<String, Object> getTodayTrafficSummary();

    // 기간 별 트래픽
	public Map<String, Object> getPeriodTrafficSummary(LocalDate startDate, LocalDate endDate);
	
	// 기간별 트래픽 추이 (일자별 방문자 수 / 페이지뷰)
	public List<Map<String, Object>> getTrafficTrend(LocalDate startDate, LocalDate endDate);
}