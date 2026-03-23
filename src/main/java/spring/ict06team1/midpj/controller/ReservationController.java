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

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.service.ReservationService;

@Controller
public class ReservationController {

	@Autowired
	private ReservationService resService;
	
	private static final Logger logger = LoggerFactory.getLogger(RestaurantController.class);
	
	//[Reservation] ----------------------------------------------------------------------------------------
	//[Restaurant_Reservation] 식당 예약 페이지로 이동
	@RequestMapping("/restReservation.rv")
	public String restReservation(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => restReservation.rv>>>");
		
		return "user/reservation/restReservation";
	}
	
	//[Accommodation_Reservation] 숙소 예약 페이지로 이동
	@RequestMapping("/accReservation.rv")
	public String accReservation(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => accReservation.rv>>>");
		
		return "user/reservation/accReservation";
	}
	
	//[Festival_Reservation] 축제 예약 페이지로 이동
	@RequestMapping("/festReservation.rv")
	public String festReservation(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => festReservation.rv>>>");
		
		int place_id = Integer.parseInt(request.getParameter("place_id"));
		FestivalDTO festDto = resService.getFestivalTickets(place_id);
		
		model.addAttribute("festival", festDto);
		
		return "user/reservation/festReservation";
	}
	
	//[Reservation] 예약 실행 페이지로 이동
	@RequestMapping("/reservationAction.rv")	
	public String reservationAction(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => reservationAction.rv>>>");

		resService.createReservation(request, response, model);
		return "user/reservation/reservationAction";
	}
	
	//[Reservation] 만족도 설문/리뷰 및 별점 작성 페이지로 이동
	@RequestMapping("/surveyReview.rv")	
	public String surveyReview(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => surveyReview.rv>>>");
		
		return "user/reservation/surveyReview";
	}
	
	//[Reservation] 만족도 설문/리뷰 및 별점 제출 페이지로 이동
	@RequestMapping("/surveyReviewAction.rv")	
	public String surveyReviewAction(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => surveyReviewAction.rv>>>");
		
		return "user/reservation/surveyReviewAction";
	}
}
