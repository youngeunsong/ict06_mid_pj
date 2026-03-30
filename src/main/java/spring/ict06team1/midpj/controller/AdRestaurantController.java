package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import spring.ict06team1.midpj.service.AdRestaurantService;

@Controller
public class AdRestaurantController {
	
	@Autowired
	private AdRestaurantService adResService;
	
	private static final Logger logger = LoggerFactory.getLogger(AdRestaurantController.class);
	
	//관리자 맛집 목록 
	@GetMapping("/restaurantList.adre")
	public String restaurant(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurant.adre>>>");
		adResService.getRestaurant_list(request, response, model);
		return "admin/place/restaurant/restaurant";
	}
	
	//관리자 맛집명 또는 place_id 검색
	@GetMapping("/restaurantSearch.adre") 
	public String restaurantSearch(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantSearch.adre>>>");
		adResService.getRestaurantSearch(request, response, model);
		return "admin/place/restaurant/restaurant";
	}
	
	//관리자 맛집 등록페이지로 가기
	@GetMapping("/restaurantInsert.adre")
	public String restaurantInsert(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantInsert.adre >>>");
		return "admin/place/restaurant/restaurantInsert";
	}
	
	//관리자 맛집 등록 -> DB저장
	@PostMapping("/restaurantInsertAction.adre")
	public String restaurantInsertAction(MultipartHttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantInsertAction.adre >>>");
		adResService.getRestaurantInsert(request, response, model);
		return "admin/place/restaurant/restaurantInsertAction";
	}
	
	//관리자 맛집 수정페이지로 가기
	@GetMapping("/restaurantModify.adre")
	public String restaurantModify(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantModify.adre >>>");
		adResService.getRestaurantDetail(request, response, model);
		return "admin/place/restaurant/restaurantModify";
	}
	
	//관리자 맛집 수정 -> DB저장
	@PostMapping("/restaurantModifyAction.adre")
	public String restaurantModifyAction(MultipartHttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantModifyAction.adre >>>");
		adResService.getRestaurantUpdateAction(request, response, model);
		adResService.getRestaurantDetail(request, response, model);
		return "admin/place/restaurant/restaurantModifyAction";
	}
	
	//관리자 맛집 삭제
	@GetMapping("/restaurantDeleteAction.adre")
	public String restaurantDeleteAction(HttpServletRequest request, Model model) 
	        throws ServletException, IOException {
		logger.info("<<< url => /restaurantDeleteAction.adre >>>");

	    adResService.getRestaurantDeleteAction(request, null, model);

	    String pageNum  = (String) model.asMap().get("pageNum");
	    String areaCode = (String) model.asMap().get("areaCode");
	    String category = (String) model.asMap().get("category");
	    String keyword  = (String) model.asMap().get("keyword");

	    // null 방지
	    if (pageNum  == null || pageNum.isEmpty())  pageNum  = "1";
	    if (areaCode == null) areaCode = "";
	    if (category == null) category = "";
	    if (keyword  == null) keyword  = "";

	    // areaCode, category 도 인코딩 처리
	    String encodedAreaCode = URLEncoder.encode(areaCode, "UTF-8");
	    String encodedCategory = URLEncoder.encode(category, "UTF-8");
	    String encodedKeyword  = URLEncoder.encode(keyword,  "UTF-8");

	    // RedirectAttributes 대신 직접 URL 조립 (model 자동 추가 방지)
	    if (!keyword.isEmpty()) {
	        return "redirect:/restaurantSearch.adre?pageNum=" + pageNum
	             + "&areaCode=" + encodedAreaCode
	             + "&category=" + encodedCategory
	             + "&keyword="  + encodedKeyword;
	    } else {
	        return "redirect:/restaurantList.adre?pageNum=" + pageNum
	             + "&areaCode=" + encodedAreaCode
	             + "&category=" + encodedCategory;
	    }
	}
	//-----------------------------------------------------------------------------------------------------------------
	//관리자 맛집 정보 입력 - 공공 데이터 활용
	//관리자 맛집 정보 입력 하는곳
	@RequestMapping("/start_1.adre")
	public String start_1(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => mapTest.adre >>> ");
		return"admin/place/restaurant/restaurant_publicdata";
	}
	
	//관리자 맛집 정보 입력 실행
	@ResponseBody
	@RequestMapping("/start_1_test.adre")
	public String start_1_test(HttpServletRequest request, HttpServletResponse response, Model model) 
	        throws ServletException, IOException {
		logger.info("<<< url => start_1_test.adre >>> ");
	    // 서비스 하나가 목록 저장 + 이미지 저장까지 다 하도록 시킵니다.
		adResService.testRegister(request, response, model);
	    return String.valueOf(model.asMap().get("countPlace"));
	}
}