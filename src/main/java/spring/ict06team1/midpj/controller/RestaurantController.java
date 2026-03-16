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

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.service.RestaurantServiceImpl;

@Controller
public class RestaurantController {

    private static final Logger logger = LoggerFactory.getLogger(RestaurantController.class);

    @Autowired
    private RestaurantServiceImpl service;

    // [restaurant] 맛집 페이지로 이동
    @RequestMapping("/restaurant.rs")
    public String restaurant(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => restaurant.rs>>>");
        return "user/restaurant/restaurant";
    }

 // [restaurantRanking] ----------------------------------------------------------------------
 // [restaurantRanking] 맛집 랭킹 페이지 이동
 // TOP5 + 더보기 첫 목록을 준비해서 JSP로 이동
	 @RequestMapping("/bestRestaurants.rs")
	 public String bestRestaurants(Model model) {
	
	     // 한 번 더보기 시 가져올 개수
	     int limit = 12;
	
	     // 상단 고정 TOP5
	     List<PlaceDTO> topList = service.getBestRestaurantTop5();
	
	     // 더보기 첫 목록 (6위부터 12개)
	     List<PlaceDTO> pageList = service.getBestRestaurantPageList(5, 17);
	
	     if (topList == null) topList = new ArrayList<>();
	     if (pageList == null) pageList = new ArrayList<>();
	
	     Map<Integer, Double> avgRatingMap = new HashMap<>();
	     Map<Integer, Integer> reviewCountMap = new HashMap<>();
	
	     for (PlaceDTO place : topList) {
	         avgRatingMap.put(place.getPlace_id(), place.getAvg_rating());
	         reviewCountMap.put(place.getPlace_id(), place.getReview_count());
	     }
	
	     for (PlaceDTO place : pageList) {
	         avgRatingMap.put(place.getPlace_id(), place.getAvg_rating());
	         reviewCountMap.put(place.getPlace_id(), place.getReview_count());
	     }
	
	     int totalCount = service.getBestRestaurantCount();
	     int remainCount = Math.max(totalCount - 5, 0);
	
	     model.addAttribute("topList", topList);
	     model.addAttribute("pageList", pageList);
	     model.addAttribute("avgRatingMap", avgRatingMap);
	     model.addAttribute("reviewCountMap", reviewCountMap);
	     model.addAttribute("favoritePlaceIds", new ArrayList<Integer>());
	
	     // 더보기 관련
	     model.addAttribute("limit", limit);
	     model.addAttribute("nextOffset", 17);
	     model.addAttribute("remainCount", remainCount);
	
	     return "user/restaurant/bestRestaurants";
	 }
	 
	// [restaurantRanking] ----------------------------------------------------------------------
	// [restaurantRanking] 맛집 랭킹 더보기 AJAX
	// offset 이후 맛집 목록을 JSON으로 반환
	 @RequestMapping("/bestRestaurantsMore.rs")
	 @ResponseBody
	 public List<PlaceDTO> bestRestaurantsMore(
	         @RequestParam(value = "tab", defaultValue = "realtime") String tab,
	         @RequestParam("offset") int offset,
	         @RequestParam(value = "limit", defaultValue = "12") int limit) {

	     int start = offset;
	     int end = offset + limit;

	     if ("realtime".equals(tab)) {
	         return service.getBestRestaurantPageList(start, end);
	     } else if ("region".equals(tab)) {
	         return service.getBestRestaurantPageList(start, end);
	     } else if ("theme".equals(tab)) {
	         return service.getBestRestaurantPageList(start, end);
	     }

	     return new ArrayList<>();
	 }

    // [restaurant] 지역별 베스트 맛집 페이지로 이동
    @RequestMapping("/bestRestaurantsRegion.rs")
    public String bestRestaurantsRegion(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => bestRestaurantsRegion.rs>>>");
        return "user/restaurant/bestRestaurantsRegion";
    }

    // [restaurant] 테마별 베스트 맛집 페이지로 이동
    @RequestMapping("/bestRestaurantsTheme.rs")
    public String bestRestaurantsTheme(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => bestRestaurantsTheme.rs>>>");
        return "user/restaurant/bestRestaurantsTheme";
    }

    // [restaurant] 레스토랑 상세 & 예약 페이지로 이동
    @RequestMapping("/restaurantDetail.rs")
    public String restaurantDetail(@RequestParam("place_id") int place_id,
                                   HttpSession session,
                                   Model model) {

        PlaceDTO restaurant = service.getRestaurantDetail(place_id);

        if (restaurant == null) {
            return "common/main";
        }

        List<ReviewDTO> reviews = service.getReviewsPaged(place_id, 0, 5);
        int reviewTotalCount = service.getReviewCount(place_id);

        String loginUserId = getLoginUserId(session);
        boolean favorite = service.isFavorite(loginUserId, place_id);

        model.addAttribute("restaurant", restaurant);
        model.addAttribute("reviews", reviews);
        model.addAttribute("place_id", place_id);
        model.addAttribute("reviewNextOffset", reviews.size());
        model.addAttribute("reviewTotalCount", reviewTotalCount);
        model.addAttribute("isFavorite", favorite);

        return "user/restaurant/restaurantDetail";
    }

    @RequestMapping("/restaurantReviewMore.rs")
    @ResponseBody
    public List<ReviewDTO> restaurantReviewMore(
            @RequestParam("place_id") int place_id,
            @RequestParam("offset") int offset,
            @RequestParam(value = "limit", defaultValue = "5") int limit) {
        return service.getReviewsPaged(place_id, offset, limit);
    }

    // 즐겨찾기 토글
    @RequestMapping("/favoriteToggle.rs")
    @ResponseBody
    public Map<String, Object> favoriteToggle(@RequestParam("place_id") int place_id,
                                              HttpSession session) {

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

    // [restaurant] 지도에서 레스토랑 위치 보기
    @RequestMapping("/restaurantMap.rs")
    public String restaurantMap(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => restaurantMap.rs>>>");
        return "user/restaurant/restaurantMap";
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
    
    @RequestMapping("/bestRestaurantsTabAjax.rs")
    public String bestRestaurantsTabAjax(
            @RequestParam(value = "tab", defaultValue = "realtime") String tab,
            Model model) {

        int limit = 12;

        List<PlaceDTO> topList = new ArrayList<>();
        List<PlaceDTO> pageList = new ArrayList<>();

        if ("realtime".equals(tab)) {
            topList = service.getBestRestaurantTop5();
            pageList = service.getBestRestaurantPageList(5, 17);
        } else if ("region".equals(tab)) {
            topList = service.getBestRestaurantTop5();
            pageList = service.getBestRestaurantPageList(5, 17);
        } else if ("theme".equals(tab)) {
            topList = service.getBestRestaurantTop5();
            pageList = service.getBestRestaurantPageList(5, 17);
        }

        if (topList == null) topList = new ArrayList<>();
        if (pageList == null) pageList = new ArrayList<>();

        int totalCount = service.getBestRestaurantCount();
        int remainCount = Math.max(totalCount - 5, 0);

        model.addAttribute("topList", topList);
        model.addAttribute("pageList", pageList);
        model.addAttribute("limit", limit);
        model.addAttribute("nextOffset", 17);
        model.addAttribute("remainCount", remainCount);
        model.addAttribute("currentTab", tab);

        return "user/restaurant/bestRestaurantsContent";
    }
    
    
}