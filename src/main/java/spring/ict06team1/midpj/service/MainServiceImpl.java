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
import spring.ict06team1.midpj.dto.PlaceDTO;

@Service
public class MainServiceImpl implements MainService {
	
	@Autowired
	private MainDAO dao;

	//맛집 TOP10
	@Override
	public List<PlaceDTO> getTop10ByREST() {
	    System.out.println("[MainServiceImpl - getTop10ByREST()]");
	    List<PlaceDTO> getTop10RESTlist = dao.getTop10ByREST();
	    
	    return getTop10RESTlist;
	}
	
	//숙소 TOP10
	@Override
	public List<AccommodationDTO> getTop10ByACC() {
	    System.out.println("[MainServiceImpl - getTop10ByACC()]");
	    List<AccommodationDTO> getTop10ACClist = dao.getTop10ByACC();
	    
	    return getTop10ACClist;
	}

	//각 플레이스 별 리뷰 카운트
	@Override
    public Map<Integer, Integer> getReviewCountMap(List<Integer> placeIds) {
		System.out.println("[MainServiceImpl - getReviewCountMap()]");

        Map<Integer, Integer> reviewCountMap = new HashMap<Integer, Integer>();

        if (placeIds == null || placeIds.isEmpty()) return reviewCountMap;
        
        List<Map<String, Object>> statsList = dao.getPlaceReviewStatsByIds(placeIds);

        for (Map<String, Object> row : statsList) {
            Integer placeId = ((Number) row.get("PLACE_ID")).intValue();
            Integer reviewCount = 0;

            if (row.get("REVIEW_COUNT") != null) {
                reviewCount = ((Number) row.get("REVIEW_COUNT")).intValue();
            }
            reviewCountMap.put(placeId, reviewCount);
        }

        return reviewCountMap;
    }

	//각 플레이스 리뷰 평균
	@Override
    public Map<Integer, Double> getAvgRatingMap(List<Integer> placeIds) {
		System.out.println("[MainServiceImpl - getAvgRatingMap()]");

        Map<Integer, Double> avgRatingMap = new HashMap<>();

        if (placeIds == null || placeIds.isEmpty()) return avgRatingMap;

        List<Map<String, Object>> statsList = dao.getPlaceReviewStatsByIds(placeIds);

        for (Map<String, Object> row : statsList) {
            Integer placeId = ((Number) row.get("PLACE_ID")).intValue();
            Double avgRating = 0.0;

            if (row.get("AVG_RATING") != null) {
                avgRating = ((Number) row.get("AVG_RATING")).doubleValue();
            }

            avgRatingMap.put(placeId, avgRating);
        }

        return avgRatingMap;
    }
	
	//즐겨찾기
	public List<Integer> getFavoritePlaceIds(HttpServletRequest request) {
		System.out.println("[MainServiceImpl - getFavoritePlaceIds()]");
		
	    String user_id = (String) request.getSession().getAttribute("sessionID");
	    
	    if (user_id == null || user_id.trim().isEmpty()) {
	        return new ArrayList<>();
	    }
	    
	    List<Integer> favoriteList = dao.getFavoritePlaceIds(user_id);
	    
	    return favoriteList;
	}

	//이달의 추천 국내 축제
	@Override
	public List<FestivalDTO> getTop8ThisMonthFestival() {
		System.out.println("[MainServiceImpl - getTop8ThisMonthFestival()]");
		List<FestivalDTO> Top8ThisMonthFestival = dao.getTop8ThisMonthFestival();
		
		return Top8ThisMonthFestival;
	}

	//BEST 추천 - 전체 탭 우측 4개
	@Override
	public List<Map<String, Object>> getBestAllTop4() {
		System.out.println("[MainServiceImpl - getBestAllTop4()]");
		
		List<Map<String, Object>> BestAllTop4 = dao.getBestAllTop4();
	    return BestAllTop4;
	}

	//BEST 추천 - 맛집 5개
	@Override
	public List<PlaceDTO> getBestRestTop5() {
		System.out.println("[MainServiceImpl - getBestRestTop5()]");
		
		List<PlaceDTO> BestRestTop5 = dao.getBestRestTop5();
	    return BestRestTop5;
	}

	//BEST 추천 - 숙소 5개
	@Override
	public List<AccommodationDTO> getBestAccTop5() {
		System.out.println("[MainServiceImpl - getBestAccTop5()]");
		
		List<AccommodationDTO> BestAccTop5 = dao.getBestAccTop5();
	    return BestAccTop5;
	}

	//BEST 추천 - 축제 5개
	@Override
	public List<FestivalDTO> getBestFestTop5() {
		System.out.println("[MainServiceImpl - getBestFestTop5()]");
		
		List<FestivalDTO> BestFestTop5 = dao.getBestFestTop5();
	    return BestFestTop5;
	}
}