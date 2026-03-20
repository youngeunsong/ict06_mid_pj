package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.service.MainServiceImpl;

@Controller
public class MainController {

	private static final Logger logger = LoggerFactory.getLogger(MainController.class);

	@Autowired
	private MainServiceImpl mainService;
	
	/* ================================================== 
	   user 메인화면
	   TOP10 + BEST 추천 초기 세팅 + 이달의 추천 국내 축제 + 즐겨찾기 + 최하단 공지 & 이벤트
	================================================== */
	@RequestMapping("/main.do")
	public String main(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /main.do >>>");

		/* [ TOP10 ] ------------------------------------------------------------------ */
		List<RestaurantDTO> RESTtop10 = mainService.getTop10ByREST();
		List<AccommodationDTO> ACCtop10 = mainService.getTop10ByACC();

		// TOP10 리뷰/평점 map 생성용 place_id 수집
		List<Integer> placeIds = new ArrayList<Integer>();
		
		for (RestaurantDTO dto : RESTtop10) {
			if (dto.getPlaceDTO() != null) {
				placeIds.add(dto.getPlaceDTO().getPlace_id());
			}
		}

		for (AccommodationDTO dto : ACCtop10) {
			if (dto.getPlaceDTO() != null) {
				placeIds.add(dto.getPlaceDTO().getPlace_id());
			}
		}
		
		logger.info("placeIds => " + placeIds);
		
		/* [ BEST 추천 ] 초기 렌더링용 (ALL) --------------------------------------------------------- */
		List<Map<String, Object>> bestAllList = mainService.getBestAllTop4();
		
		/* [ 이달의 추천 국내 축제 ] ------------------------------------------------------------------ */
		// 이달의 추천 국내 축제
		List<FestivalDTO> festivalList = mainService.getTop8ThisMonthFestival();
		
		/* [ 즐겨찾기 ] ------------------------------------------------------------------ */
		List<Integer> favoritePlaceIds = mainService.getFavoritePlaceIds(request);
		

		/* [ 결과 전달 ] ------------------------------------------------------------------ */
		// TOP10
		model.addAttribute("RESTtop10", RESTtop10);
		model.addAttribute("ACCtop10", ACCtop10);
		
		logger.info("RESTtop10 => {}", RESTtop10);
		logger.info("ACCtop10 => {}", ACCtop10);
		
		// BEST 추천 - 초기 렌더링용 (ALL)
		model.addAttribute("bestType", "ALL");
		model.addAttribute("bestAllList", bestAllList);
		
		// 이달의 추천 국내 축제
		model.addAttribute("festivalList", festivalList);
		
		// 즐겨찾기
		model.addAttribute("favoritePlaceIds", favoritePlaceIds);
		
		//최하단 공지 & 이벤트
		model.addAttribute("mainNoticeList", mainService.getMainNoticeList());
		model.addAttribute("mainEventList", mainService.getMainEventList());

		return "common/main";
	}

	/* ================================================== 
	   BEST 추천 AJAX
	   type: ALL / REST / ACC / FEST
	================================================== */
	@GetMapping("/main/best/ajax")
	public String bestAjax(@RequestParam(defaultValue = "ALL") String type, HttpServletRequest request, Model model) {
		logger.info("[MainController - bestAjax()] type: {}", type);
		
		/* [ AJAX에서 보여줄 type 구분하기 ] ------------------------------------------------------------------ */
		// 구분할 type 수집
		model.addAttribute("bestType", type);

		// 리뷰/평점 map 생성용 place_id 수집
		List<Integer> placeIds = new ArrayList<Integer>();
		
		// 카드 전체 정보 : type 별 정보 + 리뷰/평점
		if ("ALL".equals(type)) {         // type: ALL
			List<Map<String, Object>> bestAllList = mainService.getBestAllTop4();
			model.addAttribute("bestAllList", bestAllList);

		} else if ("REST".equals(type)) { // type: REST
			List<RestaurantDTO> bestRestList = mainService.getBestRestTop5();
			model.addAttribute("bestRestList", bestRestList);

			for (RestaurantDTO dto : bestRestList) {
				if (dto.getPlaceDTO() != null) {
					placeIds.add(dto.getPlaceDTO().getPlace_id());
				}
			}

		} else if ("ACC".equals(type)) { // type: ACC
			List<AccommodationDTO> bestAccList = mainService.getBestAccTop5();
			model.addAttribute("bestAccList", bestAccList);

			for (AccommodationDTO dto : bestAccList) {
				if (dto.getPlaceDTO() != null) {
					placeIds.add(dto.getPlaceDTO().getPlace_id());
				}
			}

		} else if ("FEST".equals(type)) { // type: FEST
			List<FestivalDTO> bestFestList = mainService.getBestFestTop5();
			model.addAttribute("bestFestList", bestFestList);

			for (FestivalDTO dto : bestFestList) {
				if (dto.getPlaceDTO() != null) {
					placeIds.add(dto.getPlaceDTO().getPlace_id());
				}
			}
		}

		// REST / ACC / FEST 카드에서만 사용 (주의!!! 다른 jsp 파일에서는 사용하지 않음)
		if (!placeIds.isEmpty()) {
			model.addAttribute("reviewCountMap", mainService.getReviewCountMap(placeIds));
			model.addAttribute("avgRatingMap", mainService.getAvgRatingMap(placeIds));
		} else {
			model.addAttribute("reviewCountMap", new HashMap<Integer, Integer>());
			model.addAttribute("avgRatingMap", new HashMap<Integer, Double>());
		}
		
		/* [ 즐겨찾기 ] ------------------------------------------------------------------ */
		List<Integer> favoritePlaceIds = mainService.getFavoritePlaceIds(request);
		model.addAttribute("favoritePlaceIds", favoritePlaceIds);

		return "common/card/best_fragment";
	}
}