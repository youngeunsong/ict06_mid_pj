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

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.service.FestivalServiceImpl;

/*
 * @author 송영은
 * 최초작성일: 2026-03-17
 * 최종수정일: 2026-03-17
 * 참고 코드: RestaurantController.java
 */

@Controller
public class FestivalController {
	
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private FestivalServiceImpl service;
	
	//[festival] ----------------------------------------------------------------------------------------
	@RequestMapping("/festival.fe")	
	public String festival(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => festival.fe >>>");
		
		return "user/festival/festival";
	}
	
	// [festival] 축제 상세 & 예약 페이지로 이동
	@RequestMapping("/festivalDetail.fe")	
	public String festivalDetail(@RequestParam("place_id") int place_id, HttpSession session, Model model) 
            		throws ServletException, IOException {
		logger.info("<<< url => festivalDetail.fe >>>");
		// System.out.println("place_id: " + place_id); 제대로 들어오는 지 확인 
		FestivalDTO festival = service.getFestivalDetail(place_id);
		System.out.println("festival: " + festival);

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
