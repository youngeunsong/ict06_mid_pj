package spring.ict06team1.midpj.service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import spring.ict06team1.midpj.dto.RestaurantDTO;

public interface AdRestaurantService {
	
	//맛집 목록 조회
	public void getRestaurant_list(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//맛집 정보 등록
	public void getRestaurantInsert(MultipartHttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException;
	
	//맛집 상세 정보 조회
	public void getRestaurantDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	//맛집 정보 수정
	public void getRestaurantUpdateAction(MultipartHttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	//맛집 정보 삭제
	public void getRestaurantDeleteAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	//공공데이터 open API 활용 맛집 정보 내려받기
	//---------------------------------------------------------------------------------------------------------------------
	
	//맛집 정보 등록-공공데이터를 통해서(place 테이블쪽)
	public void testRegister(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	//맛집 정보 등록-공공데이터를 통해서(restaurant 테이블쪽)
	public void testRegisterIntro(String contentId, RestaurantDTO rdto);
	
	//맛집 정보 등록-공공데이터를 통해서(restaurant 테이블쪽)
	public void testRegisterDetail(String contentId, RestaurantDTO rdto); 
}
