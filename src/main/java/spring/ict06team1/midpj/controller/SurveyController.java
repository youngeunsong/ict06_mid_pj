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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.dto.SurveyDTO;
import spring.ict06team1.midpj.service.SurveyServiceImpl;

/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: None
 * ----------------------------------
 * v260325
 * 설문 응답 후 리뷰/별점 등록 기능을 위한 메서드 추가(insertReview, checkReviewExists)
 * ----------------------------------
 */
@Controller
public class SurveyController {

	private static final Logger logger = LoggerFactory.getLogger(SurveyController.class);
	
	@Autowired
	private SurveyServiceImpl svService;

	//1. 설문 대상 조회(AJAX)
	@ResponseBody
	@RequestMapping("/surveyList.sv")
	public List<ReservationDTO> surveyList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /surveyList.sv]");
		String user_id = (String)request.getSession().getAttribute("sessionID");
		
		if(user_id == null) {
			return null;
		}
		return svService.getSurveyTargetList(user_id);
	}
	
	//2. 설문 등록
	@ResponseBody
	@RequestMapping("/surveyInsert.sv")
	public Map<String, Object> surveyInsert(SurveyDTO dto, HttpServletRequest request)
			throws ServletException, IOException {
		logger.info("[url => /surveyInsert.sv]");
		
		String user_id = (String)request.getSession().getAttribute("sessionID");
		dto.setUser_id(user_id);

		return svService.insertSurvey(dto);
	}
	
	//3. 리뷰 등록
	@ResponseBody
	@RequestMapping("/reviewInsert.sv")
	public Map<String, Object> reviewInsert(ReviewDTO dto, HttpServletRequest request)
			throws ServletException, IOException {
		logger.info("[url => /reviewInsert.sv]");
		
		String user_id = (String)request.getSession().getAttribute("sessionID");
		String reservation_id = request.getParameter("reservation_id");
		dto.setUser_id(user_id);
		
		return svService.insertReview(dto, reservation_id);
	}
	

}
