package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.List;

import java.util.ArrayList;

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

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.service.AccommodationServiceImpl;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

/*
 * @author 송영은
 * 최초 작성일: 26.03.10
 * 최종 수정일: 26.03.24
 * 업데이트 사항:
 * v260324: 랭킹 관련 메서드 구현 
 */
@Controller
public class AccommodationController {
	
	private static final Logger logger = LoggerFactory.getLogger(AccommodationController.class);
	
	@Autowired
	private AccommodationServiceImpl service;
	
	@RequestMapping("/accommodation.ac")	
	public String accommodation(Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => accommodation.ac>>>");
		return "user/accommodation/accommodation";
	}
	
	// 숙소 리스트 보여주기
    @RequestMapping("/accommodationAjax.ac")
    public String restaurantAjax(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => accommodationAjax.ac>>>");
        service.getNearbyAccommodationAjax(request, response, model);
        return "user/accommodation/accommodationCard";
    }
    
    // JSP로 이동하지 않고 데이터를 직접 리턴함
    @ResponseBody
    // 숙소 페이지로 이동
    @RequestMapping("/getNearbyMarkersAjax.ac")
    public List<PlaceDTO> getNearbyMarkersAjax(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => getNearbyMarkersAjax.ac>>>");
        List list = service.getNearbyMarkersAjaxAcc(request, response);
        return list;
    }
	
	
	// 랭킹 관련 메서드 시작------------------------------------------------------
	//[accommodation] 실시간 베스트 맛집 페이지로 이동
	@RequestMapping("/bestAccommodations.ac")	
	public String bestAccommodations(HttpServletRequest request, HttpServletResponse response, Model model) {
		logger.info("<<< url => bestAccommodations.ac>>>");
		int limit = 12; // 더보기 1회 요청 시 불러올 카드 수

        List<AccommodationDTO> topList = service.getBestAccommodationTop5(null); // 기본: 전체 지역 
        List<AccommodationDTO> pageList = service.getBestAccommodationPageList(5, 17, null); // TOP5 다음 구간(6위~17위)

        if (topList == null) topList = new ArrayList<AccommodationDTO>(); // JSP 반복문 오류 방지용 빈 리스트 처리
        if (pageList == null) pageList = new ArrayList<AccommodationDTO>();

        int totalCount = service.getBestAccommodationCount(null);
        int remainCount = Math.max(totalCount - 5, 0); // TOP5 제외 후 남은 데이터 수 계산

        System.out.println(topList);
        System.out.println(pageList);
        model.addAttribute("topList", topList);
        model.addAttribute("pageList", pageList);
        model.addAttribute("favoritePlaceIds", new ArrayList<Integer>()); // 현재 구조에서는 즐겨찾기 목록 비워서 전달

        model.addAttribute("limit", limit);
        model.addAttribute("nextOffset", 17); // 첫 더보기 클릭 시 18위부터 이어서 조회할 수 있도록 기준값 전달
        model.addAttribute("remainCount", remainCount);
        model.addAttribute("currentTab", "realtime");
        model.addAttribute("currentRegion", "all");
        
		return "user/accommodation/bestAccommodations";
	}
	
	// [랭킹 페이지 더보기 AJAX]
    // 현재 선택된 탭/지역/카테고리 상태를 유지한 채 추가 랭킹 데이터를 JSON으로 반환하기 위해 사용
    @RequestMapping("/bestAccommodationsMore.ac")
    @ResponseBody
    public List<AccommodationDTO> bestAccommodationsMore(
            @RequestParam(value = "tab", defaultValue = "realtime") String tab,
            @RequestParam(value = "region", defaultValue = "all") String region,
            @RequestParam("offset") int offset,
            @RequestParam(value = "limit", defaultValue = "12") int limit) {

        int start = offset; // 현재까지 출력된 마지막 위치 기준 시작값
        int end = offset + limit; // limit만큼 다음 구간 조회

        if ("realtime".equals(tab)) {
            return service.getBestAccommodationPageList(start, end, null);
        } else if ("region".equals(tab)) {
            return service.getBestAccommodationPageList(start, end, region);
        } 

        return new ArrayList<AccommodationDTO>(); // 잘못된 탭 값이 들어와도 프론트 오류가 나지 않도록 빈 리스트 반환
    }

    // [지역별 랭킹 페이지 이동]
    // 예전 또는 별도 페이지 구조를 위한 매핑으로 보이며 현재는 탭 방식과 병행 사용 가능
    @RequestMapping("/bestAccommodationsRegion.ac")
    public String bestAccommodationsRegion(HttpServletRequest request, HttpServletResponse response, Model model)
            throws ServletException, IOException {
        logger.info("<<< url => bestAccommodationsRegion.ac>>>");
        return "user/accommodation/bestAccommodationsRegion";
    }
    
    // [랭킹 탭 전환 AJAX]
    // 실시간/지역 탭 변경 시 전체 페이지 이동 없이 랭킹 콘텐츠 조각만 다시 렌더링하기 위해 사용
    @RequestMapping("/bestAccommodationsTabAjax.ac")
    public String bestAccommodationsTabAjax(
            @RequestParam(value = "tab", defaultValue = "realtime") String tab,
            @RequestParam(value = "region", defaultValue = "all") String region,
            Model model) {

        int limit = 12;

        List<AccommodationDTO> topList = new ArrayList<AccommodationDTO>();
        List<AccommodationDTO> pageList = new ArrayList<AccommodationDTO>();
        int totalCount = 0;

        if ("realtime".equals(tab)) {
            topList = service.getBestAccommodationTop5(null);
            pageList = service.getBestAccommodationPageList(5, 17, null);
            totalCount = service.getBestAccommodationCount(null);

        } else if ("region".equals(tab)) {
            topList = service.getBestAccommodationTop5(region);
            pageList = service.getBestAccommodationPageList(5, 17, region);
            totalCount = service.getBestAccommodationCount(region);
        } 

        if (topList == null) topList = new ArrayList<AccommodationDTO>();
        if (pageList == null) pageList = new ArrayList<AccommodationDTO>();

        int remainCount = Math.max(totalCount - 5, 0);

        model.addAttribute("topList", topList);
        model.addAttribute("pageList", pageList);
        model.addAttribute("favoritePlaceIds", new ArrayList<Integer>());
        model.addAttribute("limit", limit);
        model.addAttribute("nextOffset", 17); // 탭 전환 후에도 더보기 시작 위치를 동일하게 맞춤
        model.addAttribute("remainCount", remainCount);
        model.addAttribute("currentTab", tab);
        model.addAttribute("currentRegion", region);

        return "user/accommodation/bestAccommodationsContent"; // 전체 페이지가 아닌 콘텐츠 조각만 반환
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

	// 랭킹 관련 메서드 끝 ------------------------------------------------------

		
	@RequestMapping("/accommodationMap.ac")	
	public String accommodationMap(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => accommodationMap.ac >>>");
		return "user/accommodation/accommodationMap";
	}
}