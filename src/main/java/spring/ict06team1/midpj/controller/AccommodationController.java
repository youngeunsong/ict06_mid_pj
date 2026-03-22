package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.service.AccommodationServiceImpl;

@Controller
public class AccommodationController {
	
	private static final Logger logger = LoggerFactory.getLogger(RestaurantController.class);
	
	
	@Autowired
	private AccommodationServiceImpl service;
	
	//[accommodation] ----------------------------------------------------------------------------------------
	// 숙소 페이지로 이동
	@RequestMapping("/accommodation.ac")	
	public String accommodation(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => accommodation.ac>>>");
		return "user/accommodation/accommodation";
	}
	
	// 맛집 리스트 보여주기
    @RequestMapping("/accommodationAjax.ac")
    public String restaurantAjax(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => accommodationAjax.ac>>>");
        service.getNearbyAccommodationAjax(request, response, model);
        return "user/accommodation/accommodationCard";
    }
    
    // JSP로 이동하지 않고 데이터를 직접 리턴함
    @ResponseBody
    // 숙소 페이지로 이동
    @RequestMapping("/getNearbyMarkersAjax.ac")
    public List<PlaceDTO> getNearbyMarkersAjax(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => getNearbyMarkersAjax.ac>>>");
        List list = service.getNearbyMarkersAjaxAcc(request, response);
        return list;
    }
	
	//[restaurant] 실시간 베스트 맛집 페이지로 이동
	@RequestMapping("/bestAccommodations.ac")	
	public String bestRestaurants(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => bestRestaurants.ac>>>");
		
		return "user/accommodation/bestAccommodations";
	}
		
	//[restaurant] 지역별 베스트 맛집 페이지로 이동
	@RequestMapping("/bestAccommodationRegion.ac")	
	public String bestRestaurantsRegion(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => bestRestaurantsRegion.ac>>>");
		
		return "user/accommodation/bestAccommodationRegion";
	}
		
	//[restaurant] 레스토랑 상세 & 예약 페이지로 이동
	@RequestMapping("/accommodationDetail.ac")	
	public String restaurantDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => restaurantDetail.ac>>>");
		
		return "user/accommodation/accommodationDetail";
	}
		
	//[restaurant] 지도에서 레스토랑 위치 보기
	@RequestMapping("/accommodationMap.ac")	
	public String restaurantMap(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => restaurantMap.ac>>>");
		
		return "user/accommodation/accommodationMap";
	}
}
