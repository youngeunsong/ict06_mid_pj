package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestParam;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
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
	    List<FestivalDTO> festivalList = mainService.getTop8ThisMonthFestival(); //
	    
	    List<Integer> placeIds = new ArrayList<Integer>();

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
	    model.addAttribute("festivalList", festivalList);
	    
	    return "common/main";
	}
	
	// =========================
	// [추가] BEST 추천 AJAX
	// type: ALL / REST / ACC / FEST
	// =========================
	@RequestMapping("/main/best/ajax")
	public String getBestAjax(@RequestParam(defaultValue = "ALL") String type,
	                          HttpServletRequest request,
	                          Model model) {

	    logger.info("<<< url => /main/best/ajax >>>");
	    logger.info("type => {}", type);

	    model.addAttribute("bestType", type);
	    model.addAttribute("favoritePlaceIds", mainService.getFavoritePlaceIds(request));

	    List<Integer> placeIds = new ArrayList<Integer>();

	    if ("REST".equals(type)) {
	        List<PlaceDTO> bestRestList = mainService.getBestRestTop5();
	        model.addAttribute("bestRestList", bestRestList);

	        for (PlaceDTO dto : bestRestList) {
	            placeIds.add(dto.getPlace_id());
	        }

	    } else if ("ACC".equals(type)) {
	        List<AccommodationDTO> bestAccList = mainService.getBestAccTop5();
	        model.addAttribute("bestAccList", bestAccList);

	        for (AccommodationDTO dto : bestAccList) {
	            placeIds.add(dto.getPlaceDTO().getPlace_id());
	        }

	    } else if ("FEST".equals(type)) {
	        List<FestivalDTO> bestFestList = mainService.getBestFestTop5();
	        model.addAttribute("bestFestList", bestFestList);

	        for (FestivalDTO dto : bestFestList) {
	            placeIds.add(dto.getPlaceDTO().getPlace_id());
	        }

	    } else {
	        List<Map<String, Object>> bestAllList = mainService.getBestAllTop4();
	        model.addAttribute("bestAllList", bestAllList);

	        for (Map<String, Object> row : bestAllList) {
	            placeIds.add(((Number) row.get("PLACE_ID")).intValue());
	        }
	    }

	    model.addAttribute("reviewCountMap", mainService.getReviewCountMap(placeIds));
	    model.addAttribute("avgRatingMap", mainService.getAvgRatingMap(placeIds));

	    return "common/card/best_fragment";
	}
	
	
}