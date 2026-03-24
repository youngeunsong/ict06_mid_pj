package spring.ict06team1.midpj.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.AdDashboardDAO;
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

@Service
public class AdDashboardServiceImpl implements AdDashboardService {

	@Autowired
	private AdDashboardDAO adDashDao;

	@Override
	public void getDashboardData(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdDashboardServiceImpl - getDashboardData()]");	
		
		//1. 기간별 KPI 요약

		//2. 만족도 설문 wordcloud
			
		//3. 1:1문의 미처리
		List<InquiryDTO> pendingInquiryList = adDashDao.getPendingInquiryTop10();
		model.addAttribute("pendingInquiryList", pendingInquiryList);

		//4. 사용자 만족도 설문 결과
	}

}
