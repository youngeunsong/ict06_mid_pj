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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.service.AccommodationService;
import spring.ict06team1.midpj.service.FestivalService;
import spring.ict06team1.midpj.service.ReservationService;
import spring.ict06team1.midpj.service.RestaurantService;
import spring.ict06team1.midpj.service.SurveyServiceImpl;


@Controller
public class ReservationController {

	@Autowired
	private ReservationService resService;
	@Autowired
	private RestaurantService restService;
	@Autowired
	private AccommodationService accService;
	@Autowired
	private FestivalService festService;
	@Autowired

	private static final Logger logger = LoggerFactory.getLogger(ReservationController.class);

	// [Reservation]
	// ----------------------------------------------------------------------------------------
	// [Restaurant_Reservation] 식당 예약 페이지로 이동
	@RequestMapping("/restReservation.rv")
	public String restReservation(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => restReservation.rv>>>");

		int place_id = Integer.parseInt(request.getParameter("place_id"));

		// 맛집 정보 조회
		RestaurantDTO restDto = restService.getRestaurantDetail(place_id);
		model.addAttribute("restaurant", restDto);

		return "user/reservation/restReservation";
	}

	// [Accommodation_Reservation] 숙소 예약 페이지로 이동
	@RequestMapping("/accReservation.rv")
	public String accReservation(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => accReservation.rv>>>");

		int place_id = Integer.parseInt(request.getParameter("place_id"));

		// 숙소 정보 조회
		AccommodationDTO accDto = accService.getAccommodationDetail(place_id);
		model.addAttribute("accommodation", accDto);

		return "user/reservation/accReservation";
	}

	// [Festival_Reservation] 축제 예약 페이지로 이동
	@RequestMapping("/festReservation.rv")
	public String festReservation(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => festReservation.rv>>>");

		int place_id = Integer.parseInt(request.getParameter("place_id"));
		
		// 축제 정보 조회
		FestivalDTO festDto = festService.getFestivalDetail(place_id);
		model.addAttribute("festival", festDto);

		return "user/reservation/festReservation";
	}

	// [Reservation] 예약 실행
	@ResponseBody
	@RequestMapping("/reservationAction.rv")
	public Map<String, Object> reservationAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => reservationAction.rv>>>");

		Map<String, Object> result = resService.createReservation(request, response, model);
		return result;
	}

	// [Reservation] 만족도 설문/리뷰 및 별점 작성 페이지로 이동
	@RequestMapping("/surveyReview.rv")
	public String surveyReview(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => surveyReview.rv>>>");
		return "user/reservation/surveyReview";
	}

	// [Reservation] 만족도 설문/리뷰 및 별점 제출 페이지로 이동
	@RequestMapping("/surveyReviewAction.rv")
	public String surveyReviewAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => surveyReviewAction.rv>>>");
		
		resService.surveyReviewAction(request, response, model);

		return "user/reservation/surveyReviewAction";
	}

	// [Reservation] 결제 최종 확인 페이지 이동
	@RequestMapping("/reservationConfirm.rv")
	public String reservationConfirm(@RequestParam("reservation_id") String reservation_id, Model model) {

		ReservationDTO reservation = resService.getReservationById(reservation_id);
		model.addAttribute("reservation", reservation);

		// 네이버페이 테스트용 공개값
		model.addAttribute("naverPayClientId", "HN3GGCMDdTgGUfl0kFCo");
		model.addAttribute("naverPayChainId", "TUxwbzJsVVJ4b2x");

		return "user/reservation/reservationConfirm";
	}

	// [Reservation] 네이버페이 결제 후 returnUrl 처리
	@RequestMapping("/naverPayReturn.rv")
	public String naverPayReturn(@RequestParam(value = "paymentId", required = false) String paymentId,
			@RequestParam(value = "reservation_id", required = false) String reservationId,
			@RequestParam(value = "resultCode", required = false) String resultCode, Model model) {

		System.out.println("=== naverPayReturn 진입 ===");
		System.out.println("paymentId = " + paymentId);
		System.out.println("reservationId = " + reservationId);
		System.out.println("resultCode = " + resultCode);

		Map<String, Object> result = resService.approveNaverPay(paymentId, reservationId);

		System.out.println("result = " + result);

		model.addAttribute("result", result);
		return "user/reservation/naverPayResult";
	}
}