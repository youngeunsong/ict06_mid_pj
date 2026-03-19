package spring.ict06team1.midpj.controller;

import java.io.IOException;
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
		logger.info("<<< url => /restaurant.ad>>>");
		adResService.getRestaurant_list(request, response, model);
		return "admin/place/restaurant/restaurant";
	}
	
	//관리자 맛집 또는 place_id 검색
	@GetMapping("/restaurantSearch.ad") 
	public String restaurantSearch(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantSearch>>>");
		adResService.getRestaurantSearch(request, response, model);
		return "admin/place/restaurant/restaurant";
	}
	
	//관리자 맛집 등록페이지로 가기
	@GetMapping("/restaurantInsert.ad")
	public String restaurantInsert(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantInsert.ad >>>");
		return "admin/place/restaurant/restaurantInsert";
	}
	
	//관리자 맛집 등록 -> DB저장
	@PostMapping("/restaurantInsertAction.ad")
	public String restaurantInsertAction(MultipartHttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantInsertAction.ad >>>");
		adResService.getRestaurantInsert(request, response, model);
		return "admin/place/restaurant/restaurantInsertAction";
	}
	
	//관리자 맛집 수정페이지로 가기
	@GetMapping("/restaurantModify.ad")
	public String restaurantModify(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantModify.ad >>>");
		adResService.getRestaurantDetail(request, response, model);
		return "admin/place/restaurant/restaurantModify";
	}
	
	//관리자 맛집 수정 -> DB저장
	@PostMapping("/restaurantModifyAction.ad")
	public String restaurantModifyAction(MultipartHttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantModifyAction.ad >>>");
		adResService.getRestaurantUpdateAction(request, response, model);
		adResService.getRestaurantDetail(request, response, model);
		return "admin/place/restaurant/restaurantModifyAction";
	}
	
	//관리자 맛집 삭제
	@GetMapping("/restaurantDeleteAction.ad")
	public String restaurantDeleteAction(HttpServletRequest request, Model model) 
	        throws ServletException, IOException {
	    logger.info("<<< url => /restaurantDeleteAction.ad >>>");
	    
	    // 1. 삭제 서비스 호출 (여기서 model에 담아준 값을 나중에 꺼내 씁니다)
	    adResService.getRestaurantDeleteAction(request, null, model);
	    // 2. 서비스에서 model에 담아둔 파라미터 꺼내기
	    String pageNum = (String) model.asMap().get("pageNum");
	    String areaCode = (String) model.asMap().get("areaCode");
	    String category = (String) model.asMap().get("category");
	    String keyword = (String) model.asMap().get("keyword"); // 서비스에서 담아준 keyword 꺼내기
	    // 3. 키워드 유무에 따른 리다이렉트 분기
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        // 검색 중이었을 경우 -> 검색 컨트롤러로 이동
	        return "redirect:/restaurantSearch.ad?pageNum=" + pageNum 
	             + "&areaCode=" + areaCode 
	             + "&category=" + category 
	             + "&keyword=" + URLEncoder.encode(keyword, "UTF-8"); 
	             // ※ 한글 키워드일 경우 URLEncoder 사용 권장 (java.net.URLEncoder)
	    } else {
	        // 일반 목록이었을 경우 -> 전체 목록 컨트롤러로 이동
	        return "redirect:/restaurant.ad?pageNum=" + pageNum 
	             + "&areaCode=" + areaCode; 
	    }
	}
	//-----------------------------------------------------------------------------------------------------------------
	//관리자 맛집 정보 입력 - 공공 데이터 활용
	//관리자 맛집 정보 입력 하는곳
	@RequestMapping("/start_1.ad")
	public String start_1(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => mapTest >>> ");
		return"admin/place/restaurant/restaurant_publicdata";
	}
	
	//관리자 맛집 정보 입력 실행
	@ResponseBody
	@RequestMapping("/start_1_test.ad")
	public String start_1_test(HttpServletRequest request, HttpServletResponse response, Model model) 
	        throws ServletException, IOException {
	    // 서비스 하나가 목록 저장 + 이미지 저장까지 다 하도록 시킵니다.
		adResService.testRegister(request, response, model);
	    return String.valueOf(model.asMap().get("countPlace"));
	}
}