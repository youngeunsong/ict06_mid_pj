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

        Map<Integer, Integer> reviewCountMap = new HashMap<>();

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
}