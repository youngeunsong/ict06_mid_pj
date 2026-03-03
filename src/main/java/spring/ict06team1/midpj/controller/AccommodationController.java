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
import org.springframework.web.bind.annotation.RequestMapping;

import spring.ict06team1.midpj.service.AccommodationServiceImpl;

@Controller
public class AccommodationController {
	
	private static final Logger logger = LoggerFactory.getLogger(RestaurantController.class);
	
	@Autowired
	private AccommodationServiceImpl service;
	
	//[accommodation] ----------------------------------------------------------------------------------------
	//[accommodation] 숙소 페이지로 이동
	@RequestMapping("/accommodation.ac")	
	public String accommodation(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => accommodation.ac>>>");
		
		return "user/accommodation/accommodation";
	}
	
	//[restaurant] 실시간 베스트 맛집 페이지로 이동
		@RequestMapping("/bestAccommodations.ac")	
		public String bestRestaurants(HttpServletRequest request, HttpServletResponse response, Model model) 
				throws ServletException, IOException {
			logger.info("<<< url => bestRestaurants.rs>>>");
			
			return "user/accommodation/bestAccommodations";
		}
		
		//[restaurant] 지역별 베스트 맛집 페이지로 이동
		@RequestMapping("/bestAccommodationRegion.ac")	
		public String bestRestaurantsRegion(HttpServletRequest request, HttpServletResponse response, Model model) 
				throws ServletException, IOException {
			logger.info("<<< url => bestRestaurantsRegion.rs>>>");
			
			return "user/accommodation/bestAccommodationRegion";
		}
		
		//[restaurant] 레스토랑 상세 & 예약 페이지로 이동
		@RequestMapping("/accommodationDetail.ac")	
		public String restaurantDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
				throws ServletException, IOException {
			logger.info("<<< url => restaurantDetail.rs>>>");
			
			return "user/accommodation/accommodationDetail";
		}
		
		//[restaurant] 지도에서 레스토랑 위치 보기
		@RequestMapping("/accommodationMap.ac")	
		public String restaurantMap(HttpServletRequest request, HttpServletResponse response, Model model) 
				throws ServletException, IOException {
			logger.info("<<< url => restaurantMap.rs>>>");
			
			return "user/accommodation/accommodationMap";
		}
	}


