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

import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.service.AdminService;

@Controller
public class AdReservationController {

	@Autowired
	private AdminService adminService;

	private static final Logger logger = LoggerFactory.getLogger(AdReservationController.class);

	// [예약 관리]------------------------------------------
	// 1. 예약 조회
	// 1-1. 예약목록 전체 조회, 검색/필터
	@RequestMapping("/getReservationList.ad")
	public String getReservationList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /getReservationList.ad]");
		adminService.getReservationList(request, response, model);
		
		return "admin/reservation/reservationList";
	}

	// 1-2. 예약 상세페이지 조회
	@RequestMapping("/getReservationDetail.ad")
	// 페이지 이동 없이 데이터 바로 리턴
	@ResponseBody
	public ReservationDTO getReservationDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /getReservationDetail.ad]");
		adminService.getReservationDetail(request, response, model);
		ReservationDTO dto = (ReservationDTO) request.getAttribute("dto");

		return dto;
	}

	// 2. 예약 변경
	// 2-1. 예약상태 변경
	@PostMapping("/updateReservationStatus.ad")
	@ResponseBody
	public String updateReservationStatus(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /updateReservationStatus.ad]");
		adminService.modifyReservationStatus(request, response, model);

		int result = (Integer) request.getAttribute("result");

		return (result > 0) ? "success" : "fail";
	}

	// 2-2. 예약 취소
	@GetMapping("/resCancel.ad")
	public String cancelReservation(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /resCancel.ad >>>");
		adminService.cancelReservation(request, response, model);

		return "redirect:/admin/reservation/reslist.ad";
	}

	// 3. 통계
	// 3-1. 대시보드(기간별 집계)
	@GetMapping("/adminDashboard.ad")
	public String getDashboard(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /adminDashboard.ad >>>");
//		adminService.getReservationStatistics(request, response, model);

		return "admin/reservation/dashboard";
	}

}
