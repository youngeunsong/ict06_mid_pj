package spring.ict06team1.midpj.controller;

import java.io.IOException;
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

    // [restaurant] 실시간 베스트 맛집 페이지로 이동
    @RequestMapping("/bestRestaurants.rs")
    public String bestRestaurants(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => bestRestaurants.rs>>>");
        return "user/restaurant/bestRestaurants";
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
}