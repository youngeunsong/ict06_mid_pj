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
	@GetMapping("/restaurant.ad")
	public String restaurant(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurant.ad>>>");
		adResService.getRestaurant_list(request, response, model);
		return "admin/place/restaurant";
	}
	
	//관리자 맛집 등록페이지
	@GetMapping("/restaurantInsert.ad")
	public String restaurantInsert(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantInsert.ad >>>");
		return "admin/place/restaurantInsert";
	}
	
	//관리자 맛집 등록 -> DB저장
	@PostMapping("/restaurantInsertAction.ad")
	public String restaurantInsertAction(MultipartHttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantInsertAction.ad >>>");
		adResService.getRestaurantInsert(request, response, model);
		return "admin/place/restaurantInsertAction";
	}
	
	//관리자 맛집 수정페이지
	@GetMapping("/restaurantModify.ad")
	public String restaurantModify(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantModify.ad >>>");
		adResService.getRestaurantDetail(request, response, model);
		return "admin/place/restaurantModify";
	}
	
	//관리자 맛집 수정 -> DB저장
	@PostMapping("/restaurantModifyAction.ad")
	public String restaurantModifyAction(MultipartHttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /restaurantModifyAction.ad >>>");
		adResService.getRestaurantUpdateAction(request, response, model);
		adResService.getRestaurantDetail(request, response, model);
		return "admin/place/restaurantModifyAction";
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
	    // 3. [해결사] redirect를 사용하여 목록 컨트롤러(/restaurant.ad)를 다시 실행하게 함
	    // 이렇게 하면 주소창이 정화되어 페이징 오류가 사라지고, 리스트도 다시 불러옵니다.
	    return "redirect:/restaurant.ad?pageNum=" + pageNum + "&areaCode=" + areaCode;
	}
	
	//-----------------------------------------------------------------------------------------------------------------
	//관리자 맛집 정보 입력
	
	//관리자 맛집 정보 입력 하는곳
	@RequestMapping("/start_1.ad")
	public String start_1(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => mapTest >>> ");
		return"admin/place/restaurant_publicdata";
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
