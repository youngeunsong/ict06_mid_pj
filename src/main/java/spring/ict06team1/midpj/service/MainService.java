package spring.ict06team1.midpj.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;

public interface MainService {

	//맛집 TOP10
	public List<PlaceDTO> getTop10ByREST();

    //숙소 TOP10
	public List<AccommodationDTO> getTop10ByACC();
    
    //각 플레이스 별 리뷰 카운트
	public Map<Integer, Integer> getReviewCountMap(List<Integer> placeIds);

    //각 플레이스 별 리뷰 평균
	public Map<Integer, Double> getAvgRatingMap(List<Integer> placeIds);

    //즐겨찾기
	public List<Integer> getFavoritePlaceIds(HttpServletRequest request);
}