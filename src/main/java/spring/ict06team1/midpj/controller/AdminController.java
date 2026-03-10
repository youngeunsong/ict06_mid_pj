package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.Map;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import spring.ict06team1.midpj.service.AdminService;

@Controller
public class AdminController {
	
	@Autowired
	private AdminService adminService;
	
	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

	// 0. ADMIN HOME
	@RequestMapping("/adminHome.ad")
	public String adminHome(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminHome.ad]");
//		return "admin/home";
		return "admin/adminHome";
	}
	
	// Sample page 테스트
	@RequestMapping("/adminSample.ad")
	public String adminSample(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /adminSample.ad]");
		return "admin/adminSample";
	}
	
	@GetMapping("/restaurant.ad")
	public String restaurant(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
			logger.info("<<< url => /restaurant.ad >>>");
			adminService.getRestaurant_list(request, response, model);
			return "admin/place/restaurant";
	}
	
	@RequestMapping("/restaurantArea.ad")
	@ResponseBody // Java 객체를 JSON으로 자동 변환 (Jackson)
	public Map<String, Object> restaurantArea(
	        @RequestParam(value="areacode", required=false) String areacode,
	        @RequestParam(value="pageNum", defaultValue="1") String pageNum) {
	    // 1. 서비스 호출 (나중에 만드실 부분)
	    // areacode가 없거나 빈 값일 때의 처리 로직을 서비스에 맡기거나 여기서 분기합니다.
		Map<String, Object> resultMap = adminService.getRestaurantArea(areacode,pageNum);
		resultMap.put("areacode", areacode);
	    // 2. 결과 반환 (Jackson 라이브러리에 의해 자동으로 JSON 포맷으로 변환됨)
	    return resultMap; 
	}
	
	@GetMapping("/restaurantInsert.ad")
	public String restaurantInsert(HttpServletRequest request, HttpServletResponse response,Model model)
		throws ServletException, IOException {
		logger.info("<<< url => /restaurantInsert.ad >>>");
		return "admin/place/restaurantInsert";
	}
	
	@PostMapping("/restaurantInsertAction.ad")
	public String restaurantInsertAction(MultipartHttpServletRequest request, HttpServletResponse response,Model model)
		throws ServletException, IOException {
		logger.info("<<< url => /restaurantInsertAction.ad >>>");
		adminService.getRestaurantInsert(request, response, model);
		return "admin/place/restaurantInsertAction";
	}
	
	@GetMapping("/restaurantModify.ad")
	public String restaurantModify(HttpServletRequest request, HttpServletResponse response,Model model)
		throws ServletException, IOException {
		logger.info("<<< url => /restaurantModify.ad >>>");
		adminService.getRestaurantDetail(request, response, model);
		return "admin/place/restaurantModify";
	}
	
	@PostMapping("/restaurantModifyAction.ad")
	public String restaurantModifyAction(MultipartHttpServletRequest request, HttpServletResponse response,Model model)
		throws ServletException, IOException {
		logger.info("<<< url => /restaurantModifyAction.ad >>>");
		adminService.getRestaurantUpdateAction(request, response, model);
		adminService.getRestaurantDetail(request, response, model);
		return "admin/place/restaurantModifyAction";
	}
	
	@RequestMapping("/start_1.ad")
	public String start_1(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => mapTest >>> ");
		return"admin/place/start_1";
	}
	
	@ResponseBody
	@RequestMapping("/start_1_test.ad")
	public String start_1_test(HttpServletRequest request, HttpServletResponse response, Model model) 
	        throws ServletException, IOException {
	    
	    // 서비스 하나가 목록 저장 + 이미지 저장까지 다 하도록 시킵니다.
	    adminService.testRegister(request, response, model);
	    
	    return String.valueOf(model.asMap().get("countPlace"));
	}
}
