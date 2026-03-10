package spring.ict06team1.midpj.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AdPlaceController {

	private static final Logger logger = LoggerFactory.getLogger(AdPlaceController.class);

	// [관리자 - 장소 관리] 홈
	@RequestMapping("/placeHome.adpl")
	public String placeHome(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /placeHome.adpl]");
		return "admin/place/placeHome";
	}
	
	// [관리자 - 장소 관리] 등록된 맛집 목록
	@RequestMapping("/restaurantList.adpl")
	public String restaurantList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /restaurantList.adpl]");
		return "admin/place/restaurantList";
	}
	
	// [관리자 - 장소 관리] 등록된 숙소 목록
	@RequestMapping("/accommodationList.adpl")
	public String accommodationList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /accommodationList.adpl]");
		return "admin/place/accommodationList";
	}
	
	// [관리자 - 장소 관리] 등록된 축제 목록
	@RequestMapping("/festivalList.adpl")
	public String festivalList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /festivalList.adpl]");
		return "admin/place/festivalList";
	}
}
