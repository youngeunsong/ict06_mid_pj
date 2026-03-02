package spring.ict06team1.midpj.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ReservationController {

	private static final Logger logger = LoggerFactory.getLogger(RestaurantController.class);
	
	//[Reservation] ----------------------------------------------------------------------------------------
	//[Reservation] 예약 페이지로 이동
	@RequestMapping("/reservation.rv")	
	public String reservation(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => reservation.rv>>>");
		
		return "user/reservation/reservation";
	}
	
	//[Reservation] 예약 실행 페이지로 이동
	@RequestMapping("/reservationAction.rv")	
	public String reservationAction(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => reservationAction.rv>>>");
		
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
