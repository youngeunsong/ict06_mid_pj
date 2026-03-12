package spring.ict06team1.midpj.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import spring.ict06team1.midpj.service.AdFestivalServiceImpl;

@Controller
public class AdFestivalController {

private static final Logger logger = LoggerFactory.getLogger(AdPlaceController.class);
	
	@Autowired 
	private AdFestivalServiceImpl adFestService; 
	
	// 축제 관리 --------------------------------------------------------------------------------------------
	// [관리자 - 장소 관리] 등록된 축제 목록 전체 조회, 검색/필터
	@RequestMapping("/festivalList.adfe")
	public String festivalList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /festivalList.adfe]");
		adFestService.getFestivalList(request, response, model); 
		return "admin/place/festival/festivalList";
	}
	
	// [관리자 - 장소 관리] 새로운 축제 등록
	@RequestMapping("/createFestival.adfe")
	public String createFestival(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /createFestival.adfe]");
		return "admin/place/festival/createFestival";
	}
	
	// [관리자 - 장소 관리] 새로운 축제 등록 액션
	// 오류가 날 경우 SQL에서 SEQ_PLACE의 최댓값이 최대 place_id와 동일한지 확인. SEQ_PLACE 재설정 필요. 
	// @RequestMapping("/createFestivalAction.adfe")
	@PostMapping("/createFestivalAction.adfe")
	public String createFestivalAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /createFestivalAction.adfe]");
		adFestService.insertFestival(request, response, model); 
		return "admin/place/festival/createFestivalAction";
	}
	
	// [관리자 - 장소 관리] 축제 1건 상세 조회
	@RequestMapping("/showFestivalDetail.adfe")
	public String showFestivalDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /showFestivalDetail.adfe]");
		adFestService.getFestivalDetail(request, response, model); 
		return "admin/place/festival/showFestivalDetail";
	}
}
