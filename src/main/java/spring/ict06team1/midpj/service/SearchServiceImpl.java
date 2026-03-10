package spring.ict06team1.midpj.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import spring.ict06team1.midpj.dao.SearchDAO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;

@Service
public class SearchServiceImpl implements SearchService {

	@Autowired
	private SearchDAO dao;

	//1. 검색 키워드 별 [맛집, 숙소, 축제] 리스트 + 리뷰 통계 조회
	@Override
	public void getSearchList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[SearchServiceImpl - getSearchList()]");
		
		String keyword = request.getParameter("keyword");
		System.out.println("keyword: " + keyword);
		
		// keyword로 전체 값 가져오기
		List<PlaceDTO> list = dao.getSearchList(keyword);
		
		// placeType에 맞춰 리스트로 묶기
		List<PlaceDTO> restList = new ArrayList<>();
	    List<PlaceDTO> accList = new ArrayList<>();

	    for (PlaceDTO dto : list) {
	        String type = dto.getPlace_type();

	        if ("REST".equals(type)) {
	            restList.add(dto);
	        } else if ("ACC".equals(type)) {
	            accList.add(dto);
	        }
	    }
		
	    // 리뷰 통계 조회
	    List<Map<String, Object>> reviewStatsList = dao.getPlaceReviewStats(keyword);
		
		Map<Integer, Integer> reviewCountMap = new HashMap<>();
		Map<Integer, Double> avgRatingMap = new HashMap<>();

		//각 카테고리에 맞는 리스트에 담기
		for(Map<String, Object> row : reviewStatsList) {
			int placeId = ((Number) row.get("PLACE_ID")).intValue();
			
			Integer reviewCount = 0;
			if(row.get("REVIEW_COUNT") != null) {
				reviewCount = ((Number) row.get("REVIEW_COUNT")).intValue();
			}
			
			Double avgRating = 0.0;
			if(row.get("AVG_RATING") != null) {
				avgRating = ((Number) row.get("AVG_RATING")).doubleValue();
			}
			
			reviewCountMap.put(placeId, reviewCount);
			avgRatingMap.put(placeId, avgRating);
		}
		
		// 로그인 사용자의 즐겨찾기 place_id 목록
		String user_id = (String) request.getSession().getAttribute("sessionID");
		List<Integer> favoritePlaceIds = new ArrayList<>();

		if (user_id != null && !user_id.trim().isEmpty()) {
			favoritePlaceIds = dao.getFavoritePlaceIds(user_id);
		}
		
		//카테고리 별 리스트 화면 전달
		model.addAttribute("keyword", keyword);
		model.addAttribute("list", list);         // 전체
		model.addAttribute("restList", restList); // 맛집
		model.addAttribute("accList", accList);   // 숙소
		
		//"검색결과 n개" => 건수
		model.addAttribute("listCnt", list.size());         // 전체 건수
		model.addAttribute("restListCnt", restList.size()); // 맛집 건수
		model.addAttribute("accListCnt", accList.size());   // 숙소 건수
		
		//리뷰 갯수 + 평점 평균
		model.addAttribute("reviewCountMap", reviewCountMap); // 리뷰 숫자
	    model.addAttribute("avgRatingMap", avgRatingMap);     // 리뷰 평균
	    
	    //즐겨찾기 정보
	    model.addAttribute("favoritePlaceIds", favoritePlaceIds);
		
		// 축제 정보 가져오기
		List<FestivalDTO> festList = dao.getFestList(keyword);
		model.addAttribute("festList", festList); // 축제
		model.addAttribute("festListCnt", festList.size());// 축제 건수
	}
	
	//[즐겨찾기]
	@Override
	public Map<String, Object> toggleFavorite(HttpServletRequest request) {
		System.out.println("[SearchServiceImpl - toggleFavorite()]");

	    Map<String, Object> result = new HashMap<>();
	    
	    //로그인 여부 확인하기
	    String user_id = (String) request.getSession().getAttribute("sessionID");

	    if (user_id == null || user_id.trim().isEmpty()) {
	        result.put("status", "logout");
	        return result;
	    }
	    
	    int place_id = Integer.parseInt(request.getParameter("place_id"));
	    
	    Map<String, Object> checkFavorite = new HashMap<>();
	    checkFavorite.put("user_id", user_id);
	    checkFavorite.put("place_id", place_id);

	    int exist = dao.checkFavorite(checkFavorite);

	    if (exist > 0) {
	        dao.deleteFavorite(checkFavorite);
	        result.put("status", "removed");
	    }
	    else {
	        dao.addFavorite(checkFavorite);
	        result.put("status", "added");
	    }
	    return result;
	}

	//AJAX
	@Override
	public Map<String, Object> getSearchAjax(String keyword, String type, String sort, int page) {
		System.out.println("[SearchServiceImpl - getSearchAjax()]");
		
		int pageSize = 12;
		int startRow = (page - 1) * pageSize;   // 0,12,24...
		int endRow   = page * pageSize;         // 12,24,36...
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("keyword", keyword);
		param.put("type", type);
		param.put("sort", sort);
		param.put("startRow", startRow);
		param.put("endRow", endRow);
		param.put("pageSize", pageSize);
		
		List<PlaceDTO> list = dao.getSearchAjax(param);
		int totalCnt = dao.getSearchAjaxCount(param);
		int totalPages = (int) Math.ceil((double)totalCnt/ pageSize); //Math.ceil(소수점 올림)
		
		// AJAX용 리뷰 통계
		List<Map<String, Object>> statsList = dao.getSearchAjaxReviewStats(param);

		Map<Integer, Integer> reviewCountMap = new LinkedHashMap<>();
		Map<Integer, Double> avgRatingMap = new LinkedHashMap<>();

		for (Map<String, Object> row : statsList) {
			Integer placeId = ((Number) row.get("PLACE_ID")).intValue();

			Integer reviewCount = 0;
			if (row.get("REVIEW_COUNT") != null) {
				reviewCount = ((Number) row.get("REVIEW_COUNT")).intValue();
			}

			Double avgRating = 0.0;
			if (row.get("AVG_RATING") != null) {
				avgRating = ((Number) row.get("AVG_RATING")).doubleValue();
			}

			reviewCountMap.put(placeId, reviewCount);
			avgRatingMap.put(placeId, avgRating);
		}
		
		// AJAX용 즐겨찾기 목록
		HttpServletRequest request =
			((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();

		String user_id = (String) request.getSession().getAttribute("sessionID");
		List<Integer> favoritePlaceIds = new ArrayList<>();

		if (user_id != null && !user_id.trim().isEmpty()) {
			favoritePlaceIds = dao.getFavoritePlaceIds(user_id);
		}

		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		result.put("totalCnt", totalCnt);
		result.put("totalPages", totalPages);
		result.put("currentPage", page);
		result.put("reviewCountMap", reviewCountMap);
		result.put("avgRatingMap", avgRatingMap);
		result.put("favoritePlaceIds", favoritePlaceIds);

		return result;
	}


	
}
