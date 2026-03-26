package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.service.FestivalServiceImpl;

/*
 * @author 송영은
 * 최초작성일: 2026-03-17
 * 최종수정일: 2026-03-22
 * 참고 코드: RestaurantController.java
 */

@Controller
public class FestivalController {
	
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private FestivalServiceImpl service;
	
	// [festival] ----------------------------------------------------------------------------------------
	@RequestMapping("/festival.fe")	
	public String festival(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => /festival.fe >>>");
		
		return "user/festival/festival";
	}
	
	// [festival] 지도 페이지 ---------------------------------------
	// [festival] 축제 리스트 보여주기
    @RequestMapping("/festivalAjax.fe")
    public String festivalAjax(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => festivalAjax.fe>>>");
        service.getNearbyFestivalAjax(request, response, model);
        // return "user/festival/festivalCard";
        return "user/festival/festivalCard_map";
    }
    
    // JSP로 이동하지 않고 데이터를 직접 리턴함
    @ResponseBody
    // 축제 페이지로 이동
    @RequestMapping("/getNearbyFeMarkersAjax.fe")
    public List<FestivalDTO> getNearbyFeMarkersAjax(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => getNearbyFeMarkersAjax.fe>>>");
        List<FestivalDTO> list = service.getNearbyFeMarkersAjax(request, response);
        return list;
    }
    
    
    // [festival] 랭킹 페이지 ---------------------------------------
	// [festival] 축제 랭킹 - 상위 5개 축제 강조 
	@RequestMapping("/bestFestivals.fe")
	public String bestFestivals(HttpServletRequest request, HttpServletResponse response, Model model) {

		logger.info("<<< url => /bestFestivals.fe >>>");
        int limit = 12; // 더보기 1회 요청 시 불러올 카드 수

        List<FestivalDTO> topList = service.getBestFestivalTop5(); // TOP5
        List<FestivalDTO> pageList = service.getBestFestivalPageList(5, 17); // TOP5 다음 구간(6위~17위)

        if (topList == null) topList = new ArrayList<FestivalDTO>(); // JSP 반복문 오류 방지용 빈 리스트 처리
        if (pageList == null) pageList = new ArrayList<FestivalDTO>();

        int totalCount = service.getBestFestivalCount();
        int remainCount = Math.max(totalCount - 5, 0); // TOP5 제외 후 남은 데이터 수 계산

        model.addAttribute("topList", topList);
        model.addAttribute("pageList", pageList);
        model.addAttribute("favoritePlaceIds", new ArrayList<Integer>()); // 현재 구조에서는 즐겨찾기 목록 비워서 전달

        model.addAttribute("limit", limit);
        model.addAttribute("nextOffset", 17); // 첫 더보기 클릭 시 18위부터 이어서 조회할 수 있도록 기준값 전달
        model.addAttribute("remainCount", remainCount);
        model.addAttribute("currentTab", "realtime");

        return "user/festival/bestFestivals";
    }
	
	// [festival] 축제 랭킹 - [랭킹 페이지 더보기 AJAX]
    @RequestMapping("/bestFestivalsMore.fe")
    @ResponseBody
    public List<FestivalDTO> bestFestivalsMore(
            @RequestParam("offset") int offset,
            @RequestParam(value = "limit", defaultValue = "12") int limit) {

        int start = offset; // 현재까지 출력된 마지막 위치 기준 시작값
        int end = offset + limit; // limit만큼 다음 구간 조회
        return service.getBestFestivalPageList(start, end);
    }
	
    // [festival] 축제 상세 페이지 --------------------------------------------------------------
	// [festival] 축제 상세 & 예약 페이지로 이동
	@RequestMapping("/festivalDetail.fe")	
	public String festivalDetail(@RequestParam("place_id") int place_id, HttpSession session, Model model) 
            		throws ServletException, IOException {
		logger.info("<<< url => festivalDetail.fe >>>");
		System.out.println("place_id: " + place_id); // 제대로 들어오는 지 확인 
		FestivalDTO festival = service.getFestivalDetail(place_id);
		// System.out.println("festival: " + festival);

        if (festival == null) {
            return "redirect:/main.do";
        }

        List<ReviewDTO> reviews = service.getReviewsPaged(place_id, 0, 5);
        int reviewTotalCount = service.getReviewCount(place_id);

        String loginUserId = getLoginUserId(session);
        boolean favorite = service.isFavorite(loginUserId, place_id);

        model.addAttribute("festival", festival);
        model.addAttribute("reviews", reviews);
        model.addAttribute("place_id", place_id);
        model.addAttribute("reviewNextOffset", reviews.size());
        model.addAttribute("reviewTotalCount", reviewTotalCount);
        model.addAttribute("isFavorite", favorite);

		return "user/festival/festivalDetail";
	}
	
	// [festival] 리뷰 더 보기로 이동
	@RequestMapping("/festivalReviewMore.fe")
    @ResponseBody
    public List<ReviewDTO> festivalReviewMore(
            @RequestParam("place_id") int place_id,
            @RequestParam("offset") int offset,
            @RequestParam(value = "limit", defaultValue = "5") int limit) 
            		throws ServletException, IOException{
		logger.info("<<< url => festivalReviewMore.fe >>>");
        return service.getReviewsPaged(place_id, offset, limit);
    }
	
	// [festival] 즐겨찾기 토글
    @RequestMapping("/favoriteToggle.fe")
    @ResponseBody
    public Map<String, Object> favoriteToggle(@RequestParam("place_id") int place_id, HttpSession session) 
		  throws ServletException, IOException {
    	logger.info("<<< url => favoriteToggle.fe >>>");
        Map<String, Object> result = new HashMap<String, Object>();

        String loginUserId = getLoginUserId(session);

        if (loginUserId == null || loginUserId.trim().isEmpty()) {
            result.put("ok", false);
            result.put("needLogin", true);
            return result;
        }

        boolean favorite = service.toggleFavorite(loginUserId, place_id);

        result.put("ok", true);
        result.put("needLogin", false);
        result.put("favorite", favorite);

        return result;
    }
    
    // [festival] 지도에서 축제 위치 보기
    @RequestMapping("/festivalMap.fe")
    public String restaurantMap(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => festivalMap.fe>>>");
        return "user/festival/festivalMap";
    }
	
	// 세션 키가 정확히 기억 안 날 수 있어서 후보 여러 개로 처리
    private String getLoginUserId(HttpSession session) {
        if (session == null) return null;

        Object obj = session.getAttribute("sessionID");
        if (obj == null) obj = session.getAttribute("user_id");
        if (obj == null) obj = session.getAttribute("userId");
        if (obj == null) obj = session.getAttribute("loginUserId");

        return (obj == null) ? null : String.valueOf(obj);
    }
}
