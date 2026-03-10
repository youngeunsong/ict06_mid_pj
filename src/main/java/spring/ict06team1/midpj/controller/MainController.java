package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.service.MainServiceImpl;

@Controller
public class MainController {
	
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	private MainServiceImpl mainService;
	
	@RequestMapping("/main.do")
	public String main(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {

	    logger.info("<<< url => /main.do >>>");
	

	    List<PlaceDTO> RESTtop10 = mainService.getTop10ByREST(); //맛집 TOP10
	    List<AccommodationDTO> ACCtop10 = mainService.getTop10ByACC(); //숙소 TOP10

	    List<Integer> placeIds = new ArrayList<>();

	    for (PlaceDTO dto : RESTtop10) {
	        placeIds.add(dto.getPlace_id());
	    }

	    for (AccommodationDTO dto : ACCtop10) {
	        placeIds.add(dto.getPlaceDTO().getPlace_id());
	    }

	    model.addAttribute("RESTtop10", RESTtop10);
	    model.addAttribute("ACCtop10", ACCtop10);
	    
	    logger.info("RESTtop10 => " + RESTtop10);
	    logger.info("ACCtop10 => " + ACCtop10);

	    model.addAttribute("reviewCountMap", mainService.getReviewCountMap(placeIds));
	    model.addAttribute("avgRatingMap", mainService.getAvgRatingMap(placeIds));
	    model.addAttribute("favoritePlaceIds", mainService.getFavoritePlaceIds(request));

	    return "common/main";
	}
}