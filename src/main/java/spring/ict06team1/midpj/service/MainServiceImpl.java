package spring.ict06team1.midpj.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import spring.ict06team1.midpj.dao.MainDAO;
import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.NoticeDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

@Service
public class MainServiceImpl implements MainService {
	
	@Autowired
	private MainDAO dao;

	//맛집 TOP10
	@Override
	public List<RestaurantDTO> getTop10ByREST() {
	    System.out.println("[MainServiceImpl - getTop10ByREST()]");
	    List<RestaurantDTO> RESTtop10 = dao.top10ByREST();
	    
	    System.out.println("RESTtop10 =>" + RESTtop10);
	    return RESTtop10;
	}
	
	//숙소 TOP10
	@Override
	public List<AccommodationDTO> getTop10ByACC() {
	    System.out.println("[MainServiceImpl - getTop10ByACC()]");
	    List<AccommodationDTO> Top10ACClist = dao.top10ByACC();
	    
	    System.out.println("Top10ACClist =>" + Top10ACClist);
	    return Top10ACClist;
	}

	//플레이스 별 리뷰 갯수 및 평균 조회
	@Override
	public Map<String, Integer> getReviewCountMap(List<Integer> placeIds) {
	    System.out.println("[MainServiceImpl - getReviewCountMap()]");

	    Map<String, Integer> reviewCountMap = new HashMap<String, Integer>();

	    if (placeIds == null || placeIds.isEmpty()) return reviewCountMap;

	    List<Map<String, Object>> statsList = dao.placeReviewStatsByIds(placeIds);
	    System.out.println("statsList => " + statsList);

	    for (Map<String, Object> row : statsList) {
	        Integer placeId = ((Number) row.get("PLACE_ID")).intValue();
	        Integer reviewCount = 0;

	        if (row.get("REVIEW_COUNT") != null) {
	            reviewCount = ((Number) row.get("REVIEW_COUNT")).intValue();
	        }

	        reviewCountMap.put(String.valueOf(placeId), reviewCount);
	    }

	    System.out.println("reviewCountMap => " + reviewCountMap);
	    return reviewCountMap;
	}

	//각 플레이스 리뷰 평균
	@Override
	public Map<String, Double> getAvgRatingMap(List<Integer> placeIds) {
	    System.out.println("[MainServiceImpl - getAvgRatingMap()]");

	    Map<String, Double> avgRatingMap = new HashMap<String, Double>();

	    if (placeIds == null || placeIds.isEmpty()) return avgRatingMap;

	    List<Map<String, Object>> statsList = dao.placeReviewStatsByIds(placeIds);
	    System.out.println("statsList => " + statsList);

	    for (Map<String, Object> row : statsList) {
	        Integer placeId = ((Number) row.get("PLACE_ID")).intValue();
	        Double avgRating = 0.0;

	        if (row.get("AVG_RATING") != null) {
	            avgRating = ((Number) row.get("AVG_RATING")).doubleValue();
	        }

	        avgRatingMap.put(String.valueOf(placeId), avgRating);
	    }

	    System.out.println("avgRatingMap => " + avgRatingMap);
	    return avgRatingMap;
	}
	
	//즐겨찾기
	@Override
	public List<Integer> getFavoritePlaceIds(HttpServletRequest request) {
		System.out.println("[MainServiceImpl - getFavoritePlaceIds()]");
		
	    String user_id = (String) request.getSession().getAttribute("sessionID");
	    
	    if (user_id == null || user_id.trim().isEmpty()) {
	        return new ArrayList<Integer>();
	    }
	    
	    List<Integer> favoriteList = dao.favoritePlaceIds(user_id);
	    
	    return favoriteList;
	}

	//이달의 추천 국내 축제
	@Override
	public List<FestivalDTO> getTop8ThisMonthFestival() {
		System.out.println("[MainServiceImpl - getTop8ThisMonthFestival()]");
		List<FestivalDTO> Top8ThisMonthFestival = dao.top8ThisMonthFestival();
		
		return Top8ThisMonthFestival;
	}

	//BEST 추천 - 전체 탭 우측 4개
	@Override
	public List<Map<String, Object>> getBestAllTop4() {
		System.out.println("[MainServiceImpl - getBestAllTop4()]");
		
		List<Map<String, Object>> BestAllTop4 = dao.bestAllTop4();
	    return BestAllTop4;
	}

	//BEST 추천 - 맛집 5개
	@Override
	public List<RestaurantDTO> getBestRestTop5() {
		System.out.println("[MainServiceImpl - getBestRestTop5()]");
		
		List<RestaurantDTO> BestRestTop5 = dao.bestRestTop5();
	    return BestRestTop5;
	}

	//BEST 추천 - 숙소 5개
	@Override
	public List<AccommodationDTO> getBestAccTop5() {
		System.out.println("[MainServiceImpl - getBestAccTop5()]");
		
		List<AccommodationDTO> BestAccTop5 = dao.bestAccTop5();
	    return BestAccTop5;
	}

	//BEST 추천 - 축제 5개
	@Override
	public List<FestivalDTO> getBestFestTop5() {
		System.out.println("[MainServiceImpl - getBestFestTop5()]");
		
		List<FestivalDTO> BestFestTop5 = dao.bestFestTop5();
	    return BestFestTop5;
	}
	
	//최하단 공지 리스트
	@Override
	public List<NoticeDTO> getMainNoticeList() {
	    System.out.println("[MainServiceImpl - getMainNoticeList()]");
	    
	    List<NoticeDTO> mainNoticeList = dao.getMainNoticeList();
	    
	    return mainNoticeList;
	}

	//최하단 이벤트 리스트
	@Override
	public List<NoticeDTO> getMainEventList() {
	    System.out.println("[MainServiceImpl - getMainEventList()]");
	    
	    List<NoticeDTO> mainEventList = dao.getMainEventList();
	    
	    return mainEventList;
	}
}