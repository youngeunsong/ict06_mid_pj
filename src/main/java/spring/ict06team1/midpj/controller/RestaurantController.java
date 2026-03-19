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
import spring.ict06team1.midpj.dto.RestaurantDTO;

@Controller
public class RestaurantController {

    private static final Logger logger = LoggerFactory.getLogger(RestaurantController.class);

    @Autowired
    private RestaurantServiceImpl service;

    // [restaurant] ���� �������� �̵�
    @RequestMapping("/restaurant.rs")
    public String restaurant(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => restaurant.rs>>>");
        return "user/restaurant/restaurant";
    }

    // [restaurantRanking] ----------------------------------------------------------------------
    // [restaurantRanking] ���� ��ŷ ������ �̵�
    @RequestMapping("/bestRestaurants.rs")
    public String bestRestaurants(Model model) {

        int limit = 12;

        List<RestaurantDTO> topList = service.getBestRestaurantTop5(null, "ALL");
        List<RestaurantDTO> pageList = service.getBestRestaurantPageList(5, 17, null, "ALL");

        if (topList == null) topList = new ArrayList<RestaurantDTO>();
        if (pageList == null) pageList = new ArrayList<RestaurantDTO>();

        int totalCount = service.getBestRestaurantCount(null, "ALL");
        int remainCount = Math.max(totalCount - 5, 0);

        model.addAttribute("topList", topList);
        model.addAttribute("pageList", pageList);
        model.addAttribute("favoritePlaceIds", new ArrayList<Integer>());

        model.addAttribute("limit", limit);
        model.addAttribute("nextOffset", 17);
        model.addAttribute("remainCount", remainCount);
        model.addAttribute("currentTab", "realtime");
        model.addAttribute("currentRegion", "all");
        model.addAttribute("currentCategory", "ALL");

        return "user/restaurant/bestRestaurants";
    }

    // [restaurantRanking] ----------------------------------------------------------------------
    // [restaurantRanking] ���� ��ŷ ������ AJAX
    @RequestMapping("/bestRestaurantsMore.rs")
    @ResponseBody
    public List<RestaurantDTO> bestRestaurantsMore(
            @RequestParam(value = "tab", defaultValue = "realtime") String tab,
            @RequestParam(value = "region", defaultValue = "all") String region,
            @RequestParam(value = "category", defaultValue = "ALL") String category,
            @RequestParam("offset") int offset,
            @RequestParam(value = "limit", defaultValue = "12") int limit) {

        int start = offset;
        int end = offset + limit;

        if ("realtime".equals(tab)) {
            return service.getBestRestaurantPageList(start, end, null, "ALL");
        } else if ("region".equals(tab)) {
            return service.getBestRestaurantPageList(start, end, region, "ALL");
        } else if ("recommend".equals(tab)) {
            return service.getBestRestaurantPageList(start, end, region, category);
        }

        return new ArrayList<RestaurantDTO>();
    }

    // [restaurant] ������ ����Ʈ ���� �������� �̵�
    @RequestMapping("/bestRestaurantsRegion.rs")
    public String bestRestaurantsRegion(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => bestRestaurantsRegion.rs>>>");
        return "user/restaurant/bestRestaurantsRegion";
    }

    // [restaurant] �׸��� ����Ʈ ���� �������� �̵�
    @RequestMapping("/bestRestaurantsTheme.rs")
    public String bestRestaurantsTheme(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => bestRestaurantsTheme.rs>>>");
        return "user/restaurant/bestRestaurantsTheme";
    }

    // [restaurant] ������� �� & ���� �������� �̵�
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

    // ���ã�� ���
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

    // [restaurant] �������� ������� ��ġ ����
    @RequestMapping("/restaurantMap.rs")
    public String restaurantMap(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => restaurantMap.rs>>>");
        return "user/restaurant/restaurantMap";
    }

    // ���� Ű�� ��Ȯ�� ��� �� �� �� �־ �ĺ� ���� ���� ó��
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
            @RequestParam(value = "region", defaultValue = "all") String region,
            @RequestParam(value = "category", defaultValue = "ALL") String category,
            Model model) {

        int limit = 12;

        List<RestaurantDTO> topList = new ArrayList<RestaurantDTO>();
        List<RestaurantDTO> pageList = new ArrayList<RestaurantDTO>();
        int totalCount = 0;

        if ("realtime".equals(tab)) {
            topList = service.getBestRestaurantTop5(null, "ALL");
            pageList = service.getBestRestaurantPageList(5, 17, null, "ALL");
            totalCount = service.getBestRestaurantCount(null, "ALL");

        } else if ("region".equals(tab)) {
            topList = service.getBestRestaurantTop5(region, "ALL");
            pageList = service.getBestRestaurantPageList(5, 17, region, "ALL");
            totalCount = service.getBestRestaurantCount(region, "ALL");

        } else if ("recommend".equals(tab)) {
            topList = service.getBestRestaurantTop5(region, category);
            pageList = service.getBestRestaurantPageList(5, 17, region, category);
            totalCount = service.getBestRestaurantCount(region, category);
        }

        if (topList == null) topList = new ArrayList<RestaurantDTO>();
        if (pageList == null) pageList = new ArrayList<RestaurantDTO>();

        int remainCount = Math.max(totalCount - 5, 0);

        model.addAttribute("topList", topList);
        model.addAttribute("pageList", pageList);
        model.addAttribute("favoritePlaceIds", new ArrayList<Integer>());
        model.addAttribute("limit", limit);
        model.addAttribute("nextOffset", 17);
        model.addAttribute("remainCount", remainCount);
        model.addAttribute("currentTab", tab);
        model.addAttribute("currentRegion", region);
        model.addAttribute("currentCategory", category);

        return "user/restaurant/bestRestaurantsContent";
    }

    private List<Map<String, Object>> wrapPlaceList(List<PlaceDTO> placeList) {
        List<Map<String, Object>> wrappedList = new ArrayList<Map<String, Object>>();

        if (placeList == null) {
            return wrappedList;
        }

        for (PlaceDTO place : placeList) {
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("placeDTO", place);
            wrappedList.add(item);
        }

        return wrappedList;
    }
}