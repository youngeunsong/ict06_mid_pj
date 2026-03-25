package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface AdDashboardService {

    // 관리자 홈 메인 대시보드
    public void getAdminHomeDashboard(HttpServletRequest request, HttpServletResponse response, Model model);

    // 금일 사용자 만족도 표
    public void getTodaySurveyStatus(HttpServletRequest request, HttpServletResponse response, Model model);
}