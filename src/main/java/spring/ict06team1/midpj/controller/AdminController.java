package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.List;
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

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.service.AdminService;

@Controller
public class AdminController {

	@Autowired
	private AdminService adminService;

	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

	//0. ADMIN HOME
//	@GetMapping("/admin/home")
	@RequestMapping("/adminHome.ad")
	public String adminHome() {
		logger.info("[url => /adminHome.ad]");
		return "admin/home";
	}
	
	//1. 예약 조회
	//1-1. 예약목록 전체 조회, 검색/필터
//	@GetMapping("/admin/reservation/list")
	@RequestMapping("/getReservationList.ad")
	public String getReservationList(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
//		logger.info("[url => /admin/reservation/list]");
		logger.info("[url => /getReservationList.ad]");
		adminService.getReservationList(request, response, model);
		return "admin/reservation/list";
	}
	
	//1-2. 예약 상세페이지 조회
//	@GetMapping("/admin/reservation/detail")
	@RequestMapping("/getReservationDetail.ad")
	//페이지 이동 없이 데이터 바로 리턴
	@ResponseBody
	public ReservationDTO getReservationDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
//		logger.info("[url => /admin/reservation/detail]");
		logger.info("[url => /getReservationDetail.ad]");
		adminService.getReservationDetail(request, response, model);
		ReservationDTO dto = (ReservationDTO)request.getAttribute("dto");
			
		return dto;
	}
	
	//2. 예약 변경
	//2-1. 예약상태 변경
//	@PostMapping("/admin/reservation/updateStatus")
	@PostMapping("/updateReservationStatus.ad")
	@ResponseBody
	public String updateReservationStatus(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
//			logger.info("[url => /admin/reservation/updateStatus]");
			logger.info("[url => /updateReservationStatus.ad]");
			adminService.modifyReservationStatus(request, response, model);
			
			int result = (Integer)request.getAttribute("result");
			
			return (result > 0) ? "success" : "fail";
	}
	
	//2-2. 예약 취소
	@GetMapping("/resCancel.ad")
	public String cancelReservation(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
			logger.info("<<< url => /resCancel.ad >>>");
			adminService.cancelReservation(request, response, model);
			
			return "redirect:/admin/reservation/reslist.ad";
	}
	
	//3. 통계
	//3-1. 대시보드(기간별 집계)
	@GetMapping("/adminDashboard.ad")
	public String getDashboard(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
			logger.info("<<< url => /adminDashboard.ad >>>");
			adminService.getReservationStatistics(request, response, model);
			
			return "admin/reservation/dashboard";
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
