package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

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

public interface AdDashboardService {

	//1. 기간별 KPI 요약

	
	//2. 만족도 설문 wordcloud
	
	
	//3. 1:1문의 미처리
	public void getDashboardData(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//4. 사용자 만족도 설문 결과
}
