package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import spring.ict06team1.midpj.dto.RestaurantDTO;

@Service
public interface AdminService {
	
	public void getRestaurant_list(HttpServletRequest request, HttpServletResponse response, Model model);
	
	/*
	 * public Map<String, Object> getRestaurantArea(String areaCode, String
	 * pageNum);
	 */
	
	public void getRestaurantInsert(MultipartHttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException;
	
	public void getRestaurantDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	public void getRestaurantUpdateAction(MultipartHttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	//맛집 정보 삭제
	public void getRestaurantDeleteAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	public void testRegister(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	public void testRegisterIntro(String contentId, RestaurantDTO rdto);
	
	public void testRegisterDetail(String contentId, RestaurantDTO rdto); 
}
