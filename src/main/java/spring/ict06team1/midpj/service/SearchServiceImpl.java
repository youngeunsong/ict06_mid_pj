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
import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.dto.SearchHistoryDTO;

@Service
public class SearchServiceImpl implements SearchService {

	@Autowired
	private SearchDAO dao;

	// 1. 검색 키워드 별 [맛집, 숙소, 축제] 리스트 + 리뷰 통계 조회 + 즐겨찾기
	@Override
	public void getSearchList(HttpServletRequest request, HttpServletResponse response, Model model) {
	    System.out.println("[SearchServiceImpl - getSearchList()]");

	    String keyword = request.getParameter("keyword");
	    String loginUserId = (String) request.getSession().getAttribute("sessionID");
	    System.out.println("keyword: " + keyword);

	    if (loginUserId != null && keyword != null && !keyword.trim().isEmpty()) {
	        insertSearchHistory(loginUserId, keyword);
	    }

	    // 검색어 기준 타입별 DTO 리스트 조회
	    List<RestaurantDTO> restList = dao.getRestList(keyword);
	    List<AccommodationDTO> accList = dao.getAccList(keyword);
	    List<FestivalDTO> festList = dao.getFestList(keyword);

	    // 리뷰 통계 조회
	    List<Map<String, Object>> reviewStatsList = dao.getPlaceReviewStats(keyword);

	    Map<Integer, Integer> reviewCountMap = new HashMap<Integer, Integer>();
	    Map<Integer, Double> avgRatingMap = new HashMap<Integer, Double>();

	    for (Map<String, Object> row : reviewStatsList) {
	        int placeId = ((Number) row.get("PLACE_ID")).intValue();

	        int reviewCount = 0;
	        if (row.get("REVIEW_COUNT") != null) {
	            reviewCount = ((Number) row.get("REVIEW_COUNT")).intValue();
	        }

	        double avgRating = 0.0;
	        if (row.get("AVG_RATING") != null) {
	            avgRating = ((Number) row.get("AVG_RATING")).doubleValue();
	        }

	        reviewCountMap.put(placeId, reviewCount);
	        avgRatingMap.put(placeId, avgRating);
	    }

	    // 즐겨찾기
	    String userId = (String) request.getSession().getAttribute("sessionID");
	    List<Integer> favoritePlaceIds = new ArrayList<Integer>();

	    if (userId != null && !userId.trim().isEmpty()) {
	        favoritePlaceIds = dao.getFavoritePlaceIds(userId);
	    }

	    int listCnt = restList.size() + accList.size() + festList.size();

	    model.addAttribute("keyword", keyword);

	    model.addAttribute("restList", restList);
	    model.addAttribute("accList", accList);
	    model.addAttribute("festList", festList);

	    model.addAttribute("listCnt", listCnt);
	    model.addAttribute("restListCnt", restList.size());
	    model.addAttribute("accListCnt", accList.size());
	    model.addAttribute("festListCnt", festList.size());

	    model.addAttribute("reviewCountMap", reviewCountMap);
	    model.addAttribute("avgRatingMap", avgRatingMap);
	    model.addAttribute("favoritePlaceIds", favoritePlaceIds);
	}

	// [즐겨찾기]
	@Override
	public Map<String, Object> toggleFavorite(HttpServletRequest request) {
		System.out.println("[SearchServiceImpl - toggleFavorite()]");

	    Map<String, Object> result = new HashMap<String, Object>();

	    String userId = (String) request.getSession().getAttribute("sessionID");

	    if (userId == null || userId.trim().isEmpty()) {
	        result.put("status", "logout");
	        return result;
	    }

	    int placeId = Integer.parseInt(request.getParameter("place_id"));

	    Map<String, Object> favoriteMap = new HashMap<String, Object>();
	    favoriteMap.put("user_id", userId);
	    favoriteMap.put("place_id", placeId);

	    int exist = dao.checkFavorite(favoriteMap);

	    if (exist > 0) {
	        dao.deleteFavorite(favoriteMap);
	        result.put("status", "removed");
	    } else {
	        dao.addFavorite(favoriteMap);
	        result.put("status", "added");
	    }

	    return result;
	}

	// AJAX
	@Override
	public Map<String, Object> getSearchAjax(String keyword, String type, String sort, int page) {
		System.out.println("[SearchServiceImpl - getSearchAjax()]");

		int pageSize = 12;
		int startRow = (page - 1) * pageSize;   // 0,12,24...
		int endRow = page * pageSize;           // 12,24,36...

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("keyword", keyword);
		param.put("sort", sort);
		param.put("startRow", startRow);
		param.put("endRow", endRow);
		param.put("pageSize", pageSize);

		Map<String, Object> result = new HashMap<String, Object>();
		List<Integer> placeIds = new ArrayList<Integer>();
		int totalCnt = 0;

		// ALL 탭은 AJAX 대신 초기 화면 복귀 전제
		if ("REST".equals(type)) {
			List<RestaurantDTO> restList = dao.getRestAjaxList(param);
			totalCnt = dao.getRestAjaxCount(param);
			result.put("restList", restList);

			for (RestaurantDTO dto : restList) {
				if (dto.getPlaceDTO() != null) {
					placeIds.add(dto.getPlaceDTO().getPlace_id());
				}
			}

		} else if ("ACC".equals(type)) {
			List<AccommodationDTO> accList = dao.getAccAjaxList(param);
			totalCnt = dao.getAccAjaxCount(param);
			result.put("accList", accList);

			for (AccommodationDTO dto : accList) {
				if (dto.getPlaceDTO() != null) {
					placeIds.add(dto.getPlaceDTO().getPlace_id());
				}
			}

		} else if ("FEST".equals(type)) {
			List<FestivalDTO> festList = dao.getFestAjaxList(param);
			totalCnt = dao.getFestAjaxCount(param);
			result.put("festList", festList);

			for (FestivalDTO dto : festList) {
				if (dto.getPlaceDTO() != null) {
					placeIds.add(dto.getPlaceDTO().getPlace_id());
				}
			}
		}

		int totalPages = (int) Math.ceil((double) totalCnt / pageSize);

		// AJAX용 리뷰 통계
		// AJAX용 리뷰 통계
		Map<Integer, Integer> reviewCountMap = new LinkedHashMap<Integer, Integer>();
		Map<Integer, Double> avgRatingMap = new LinkedHashMap<Integer, Double>();

		if (!placeIds.isEmpty()) {
		    List<Map<String, Object>> statsList = dao.getPlaceReviewStatsByIds(placeIds);

		    for (Map<String, Object> row : statsList) {
		        int placeId = ((Number) row.get("PLACE_ID")).intValue();

		        int reviewCount = 0;
		        if (row.get("REVIEW_COUNT") != null) {
		            reviewCount = ((Number) row.get("REVIEW_COUNT")).intValue();
		        }

		        double avgRating = 0.0;
		        if (row.get("AVG_RATING") != null) {
		            avgRating = ((Number) row.get("AVG_RATING")).doubleValue();
		        }

		        reviewCountMap.put(placeId, reviewCount);
		        avgRatingMap.put(placeId, avgRating);
		    }
		}

		// AJAX용 즐겨찾기 목록
		HttpServletRequest request =
			((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();

		String userId = (String) request.getSession().getAttribute("sessionID");
		List<Integer> favoritePlaceIds = new ArrayList<Integer>();

		if (userId != null && !userId.trim().isEmpty()) {
			favoritePlaceIds = dao.getFavoritePlaceIds(userId);
		}

		result.put("type", type);
		result.put("totalCnt", totalCnt);
		result.put("totalPages", totalPages);
		result.put("currentPage", page);
		result.put("reviewCountMap", reviewCountMap);
		result.put("avgRatingMap", avgRatingMap);
		result.put("favoritePlaceIds", favoritePlaceIds);

		return result;
	}

	// 자동완성 10개
	@Override
	public List<String> getAutoComplete(String keyword) {
		System.out.println("[SearchServiceImpl - getAutoComplete()]");
		System.out.println("[SearchServiceImpl] keyword=> " + keyword);

	    List<String> resultList = new ArrayList<String>();

	    if (keyword == null || keyword.trim().isEmpty()) {
	        return resultList;
	    }

	    resultList = dao.getAutoComplete(keyword.trim());
	    return resultList;
	}

	// 1. 최근 검색어 5~10개 조회
	@Override
	public List<SearchHistoryDTO> getRecentKeywords(HttpServletRequest request) {
		System.out.println("[SearchServiceImpl - getRecentKeywords()]");

		String loginUserId = (String) request.getSession().getAttribute("sessionID");
	    List<SearchHistoryDTO> recentKeywordList = new ArrayList<SearchHistoryDTO>();

	    if (loginUserId == null || loginUserId.trim().isEmpty()) {
	        return recentKeywordList;
	    }

	    recentKeywordList = dao.getRecentKeywords(loginUserId);
	    return recentKeywordList;
	}

	// [최근 검색어] 2. 최근 검색어 추가
	@Override
	public void insertSearchHistory(String userId, String keyword) {
		System.out.println("[SearchServiceImpl - insertSearchHistory()]");

		if (userId == null || keyword == null) return;

	    keyword = keyword.trim();
	    if (keyword.isEmpty()) return;

	    Map<String, Object> searchMap = new HashMap<String, Object>();
	    searchMap.put("user_id", userId);
	    searchMap.put("keyword", keyword);

	    dao.deleteSameKeyword(searchMap);
	    dao.insertSearchHistory(searchMap);
	}
}