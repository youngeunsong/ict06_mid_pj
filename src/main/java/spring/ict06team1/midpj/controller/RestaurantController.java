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

import spring.ict06team1.midpj.service.RestaurantServiceImpl;

@Controller
public class RestaurantController {

	private static final Logger logger = LoggerFactory.getLogger(RestaurantController.class);
	
	@Autowired
	private RestaurantServiceImpl service;
	
	//[restaurant] ----------------------------------------------------------------------------------------
	//[restaurant] 맛집 페이지로 이동
	@RequestMapping("/restaurant.rs")	
	public String restaurant(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => restaurant.rs>>>");
		
		return "user/restaurant/restaurant";
	}
	
	//[restaurant] 실시간 베스트 맛집 페이지로 이동
	@RequestMapping("/bestRestaurants.rs")	
	public String bestRestaurants(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => bestRestaurants.rs>>>");
		
		return "user/restaurant/bestRestaurants";
	}
	
	//[restaurant] 지역별 베스트 맛집 페이지로 이동
	@RequestMapping("/bestRestaurantsRegion.rs")	
	public String bestRestaurantsRegion(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => bestRestaurantsRegion.rs>>>");
		
		return "user/restaurant/bestRestaurantsRegion";
	}
	
	//[restaurant] 테마별 베스트 맛집 페이지로 이동
	@RequestMapping("/bestRestaurantsTheme.rs")	
	public String bestRestaurantsTheme(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => bestRestaurantsTheme.rs>>>");
		
		return "user/restaurant/bestRestaurantsTheme";
	}
	
	//[restaurant] 레스토랑 상세 & 예약 페이지로 이동
	@RequestMapping("/restaurantDetail.rs")	
	public String restaurantDetail(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => restaurantDetail.rs>>>");
		
		return "user/restaurant/restaurantDetail";
	}
	
	//[restaurant] 지도에서 레스토랑 위치 보기
	@RequestMapping("/restaurantMap.rs")	
	public String restaurantMap(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => restaurantMap.rs>>>");
		
		return "user/restaurant/restaurantMap";
	}
}
