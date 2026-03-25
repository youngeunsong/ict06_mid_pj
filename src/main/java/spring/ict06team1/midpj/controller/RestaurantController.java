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
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.service.RestaurantServiceImpl;

@Controller
public class RestaurantController {

    private static final Logger logger = LoggerFactory.getLogger(RestaurantController.class);

    @Autowired
    private RestaurantServiceImpl service;

    // [맛집 메인 페이지 이동]
    // 맛집 관련 메인 화면으로 이동할 때 사용하는 기본 요청
    @RequestMapping("/restaurant.rs")
    public String restaurant(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => restaurant.rs>>>");
        return "user/restaurant/restaurant";
    }

    // [맛집 랭킹 페이지 첫 진입]
    // 실시간 인기 탭을 기본값으로 하여 TOP5와 더보기 초기 리스트를 함께 세팅하기 위해 사용
    @RequestMapping("/bestRestaurants.rs")
    public String bestRestaurants(Model model) {

        int limit = 12; // 더보기 1회 요청 시 불러올 카드 수

        List<RestaurantDTO> topList = service.getBestRestaurantTop5(null, "ALL"); // 기본: 전체 지역 + 전체 카테고리
        List<RestaurantDTO> pageList = service.getBestRestaurantPageList(5, 17, null, "ALL"); // TOP5 다음 구간(6위~17위)

        if (topList == null) topList = new ArrayList<RestaurantDTO>(); // JSP 반복문 오류 방지용 빈 리스트 처리
        if (pageList == null) pageList = new ArrayList<RestaurantDTO>();

        int totalCount = service.getBestRestaurantCount(null, "ALL");
        int remainCount = Math.max(totalCount - 5, 0); // TOP5 제외 후 남은 데이터 수 계산

        model.addAttribute("topList", topList);
        model.addAttribute("pageList", pageList);
        model.addAttribute("favoritePlaceIds", new ArrayList<Integer>()); // 현재 구조에서는 즐겨찾기 목록 비워서 전달

        model.addAttribute("limit", limit);
        model.addAttribute("nextOffset", 17); // 첫 더보기 클릭 시 18위부터 이어서 조회할 수 있도록 기준값 전달
        model.addAttribute("remainCount", remainCount);
        model.addAttribute("currentTab", "realtime");
        model.addAttribute("currentRegion", "all");
        model.addAttribute("currentCategory", "ALL");

        return "user/restaurant/bestRestaurants";
    }

    // [랭킹 페이지 더보기 AJAX]
    // 현재 선택된 탭/지역/카테고리 상태를 유지한 채 추가 랭킹 데이터를 JSON으로 반환하기 위해 사용
    @RequestMapping("/bestRestaurantsMore.rs")
    @ResponseBody
    public List<RestaurantDTO> bestRestaurantsMore(
            @RequestParam(value = "tab", defaultValue = "realtime") String tab,
            @RequestParam(value = "region", defaultValue = "all") String region,
            @RequestParam(value = "category", defaultValue = "ALL") String category,
            @RequestParam("offset") int offset,
            @RequestParam(value = "limit", defaultValue = "12") int limit) {

        int start = offset; // 현재까지 출력된 마지막 위치 기준 시작값
        int end = offset + limit; // limit만큼 다음 구간 조회

        if ("realtime".equals(tab)) {
            return service.getBestRestaurantPageList(start, end, null, "ALL");
        } else if ("region".equals(tab)) {
            return service.getBestRestaurantPageList(start, end, region, "ALL");
        } else if ("recommend".equals(tab)) {
            return service.getBestRestaurantPageList(start, end, region, category);
        }

        return new ArrayList<RestaurantDTO>(); // 잘못된 탭 값이 들어와도 프론트 오류가 나지 않도록 빈 리스트 반환
    }

    // [지역별 랭킹 페이지 이동]
    // 예전 또는 별도 페이지 구조를 위한 매핑으로 보이며 현재는 탭 방식과 병행 사용 가능
    @RequestMapping("/bestRestaurantsRegion.rs")
    public String bestRestaurantsRegion(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => bestRestaurantsRegion.rs>>>");
        return "user/restaurant/bestRestaurantsRegion";
    }

    // [테마/추천 랭킹 페이지 이동]
    // 예전 또는 별도 페이지 구조를 위한 매핑으로 보이며 현재는 탭 방식과 병행 사용 가능
    @RequestMapping("/bestRestaurantsTheme.rs")
    public String bestRestaurantsTheme(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => bestRestaurantsTheme.rs>>>");
        return "user/restaurant/bestRestaurantsTheme";
    }

    // [맛집 상세 페이지]
    // 상세 정보, 리뷰 일부, 즐겨찾기 상태를 한 번에 조회해서 상세 화면에 필요한 데이터를 세팅하기 위해 사용
    @RequestMapping("/restaurantDetail.rs")
    public String restaurantDetail(@RequestParam("place_id") int place_id,
                                   HttpSession session,
                                   Model model) {

        RestaurantDTO restaurant = service.getRestaurantDetail(place_id);

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

    // [상세 페이지 리뷰 더보기 AJAX]
    // 상세 페이지에서 추가 리뷰를 비동기로 불러오기 위해 JSON 리스트 형태로 반환
    @RequestMapping("/restaurantReviewMore.rs")
    @ResponseBody
    public List<ReviewDTO> restaurantReviewMore(
            @RequestParam("place_id") int place_id,
            @RequestParam("offset") int offset,
            @RequestParam(value = "limit", defaultValue = "5") int limit) {
        return service.getReviewsPaged(place_id, offset, limit);
    }

    // [즐겨찾기 토글 AJAX]
    // 로그인 여부를 먼저 확인한 뒤, 해당 맛집의 즐겨찾기 상태를 추가/해제하기 위해 사용
    @RequestMapping("/favoriteToggle.rs")
    @ResponseBody
    public Map<String, Object> favoriteToggle(@RequestParam("place_id") int place_id,
                                              HttpSession session) {

        Map<String, Object> result = new HashMap<String, Object>();

        String loginUserId = getLoginUserId(session);

        if (loginUserId == null || loginUserId.trim().isEmpty()) {
            result.put("ok", false);
            result.put("needLogin", true); // 프론트에서 로그인 유도 처리할 수 있도록 상태값 전달
            return result;
        }

        boolean favorite = service.toggleFavorite(loginUserId, place_id);

        result.put("ok", true);
        result.put("needLogin", false);
        result.put("favorite", favorite); // 변경 후 최종 즐겨찾기 상태 반환

        return result;
    }

    // [맛집 지도 페이지 이동]
    // 지도 기반 맛집 화면으로 이동할 때 사용하는 요청
    @RequestMapping("/restaurantMap.rs")
    public String restaurantMap(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => restaurantMap.rs>>>");
        return "user/restaurant/restaurantMap";
    }

    // [세션 로그인 아이디 추출]
    // 프로젝트 내 세션 키 이름이 통일되어 있지 않을 가능성을 고려해 여러 키를 순차적으로 확인
    private String getLoginUserId(HttpSession session) {
        if (session == null) return null;

        Object obj = session.getAttribute("sessionID");
        if (obj == null) obj = session.getAttribute("user_id");
        if (obj == null) obj = session.getAttribute("userId");
        if (obj == null) obj = session.getAttribute("loginUserId");

        return (obj == null) ? null : String.valueOf(obj); // 찾은 값이 있으면 문자열로 변환해서 반환
    }

    // [랭킹 탭 전환 AJAX]
    // 실시간/지역/추천 탭 변경 시 전체 페이지 이동 없이 랭킹 콘텐츠 조각만 다시 렌더링하기 위해 사용
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
        model.addAttribute("nextOffset", 17); // 탭 전환 후에도 더보기 시작 위치를 동일하게 맞춤
        model.addAttribute("remainCount", remainCount);
        model.addAttribute("currentTab", tab);
        model.addAttribute("currentRegion", region);
        model.addAttribute("currentCategory", category);

        return "user/restaurant/bestRestaurantsContent"; // 전체 페이지가 아닌 콘텐츠 조각만 반환
    }

    // [PlaceDTO 래핑 유틸]
    // placeDTO 구조로 맞춰야 하는 화면이 있을 때 사용할 수 있도록 만든 보조 메서드
    // 현재 컨트롤러에서는 직접 사용되지 않지만 데이터 구조 변환용으로 보관 가능
    private List<Map<String, Object>> wrapPlaceList(List<PlaceDTO> placeList) {
        List<Map<String, Object>> wrappedList = new ArrayList<Map<String, Object>>();

        if (placeList == null) {
            return wrappedList;
        }

        for (PlaceDTO place : placeList) {
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("placeDTO", place); // 프론트에서 rest.placeDTO 형태로 접근할 수 있도록 키 이름 고정
            wrappedList.add(item);
        }

        return wrappedList;
    }

    // 404 페이지 컨트롤러 
    @RequestMapping("/error404.do")
    public String error404() {
        return "common/error404";
    }
}