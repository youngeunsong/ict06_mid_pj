package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.service.AccommodationServiceImpl;

@Controller
public class AccommodationController {
	
	private static final Logger logger = LoggerFactory.getLogger(AccommodationController.class);
	
	@Autowired
	private AccommodationServiceImpl service;
	
	@RequestMapping("/accommodation.ac")	
	public String accommodation(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => accommodation.ac >>>");
		return "user/accommodation/accommodation";
	}
	
	@RequestMapping("/bestAccommodations.ac")	
	public String bestAccommodations(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => bestAccommodations.ac >>>");
		return "user/accommodation/bestAccommodations";
	}
		
	@RequestMapping("/bestAccommodationRegion.ac")	
	public String bestAccommodationRegion(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => bestAccommodationRegion.ac >>>");
		return "user/accommodation/bestAccommodationRegion";
	}
		
	@RequestMapping("/accommodationDetail.ac")	
	public String accommodationDetail(@RequestParam("place_id") int place_id,
			HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => accommodationDetail.ac >>>");
		
		AccommodationDTO accommodation = service.getAccommodationDetail(place_id);
		List<ReviewDTO> reviews = service.getReviewsPaged(place_id, 0, 5);
		int reviewCount = service.getReviewCount(place_id);

		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("sessionID");

		boolean isFavorite = service.isFavorite(userId, place_id);

		model.addAttribute("accommodation", accommodation);
		model.addAttribute("reviews", reviews);
		model.addAttribute("reviewCount", reviewCount);
		model.addAttribute("reviewNextOffset", reviews.size());
		model.addAttribute("isFavorite", isFavorite);

		return "user/accommodation/accommodationDetail";
	}
	
	@RequestMapping("/accommodationReviewMore.ac")
	@ResponseBody
	public List<ReviewDTO> accommodationReviewMore(
	        @RequestParam("place_id") int place_id,
	        @RequestParam("offset") int offset,
	        @RequestParam(value="limit", defaultValue="5") int limit) {
	    logger.info("<<< url => accommodationReviewMore.ac >>> place_id=" + place_id
	            + ", offset=" + offset
	            + ", limit=" + limit);
	    return service.getReviewsPaged(place_id, offset, limit);
	}
		
	@RequestMapping("/accommodationMap.ac")	
	public String accommodationMap(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => accommodationMap.ac >>>");
		return "user/accommodation/accommodationMap";
	}
}