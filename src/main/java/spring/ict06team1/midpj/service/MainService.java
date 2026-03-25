package spring.ict06team1.midpj.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.NoticeDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

public interface MainService {

	//맛집 TOP10
	public List<RestaurantDTO> getTop10ByREST();

    //숙소 TOP10
	public List<AccommodationDTO> getTop10ByACC();
    
    //각 플레이스 별 리뷰 카운트
	public Map<String, Integer> getReviewCountMap(List<Integer> placeIds);

    //각 플레이스 별 리뷰 평균
	public Map<String, Double> getAvgRatingMap(List<Integer> placeIds);

    //즐겨찾기
	public List<Integer> getFavoritePlaceIds(HttpServletRequest request);
	
	//이달의 추천 국내 축제
	public List<FestivalDTO> getTop8ThisMonthFestival();
	
	//BEST 추천 - 전체 탭 우측 4개
	public List<Map<String, Object>> getBestAllTop4();
	
	//BEST 추천 - 맛집 5개
	public List<RestaurantDTO> getBestRestTop5();
	
	//BEST 추천 - 숙소 5개
	public List<AccommodationDTO> getBestAccTop5();
	
	//BEST 추천 - 축제 5개
	public List<FestivalDTO> getBestFestTop5();
	
	//최하단 공지 리스트
	public List<NoticeDTO> getMainNoticeList();

	//최하단 이벤트 리스트
	public List<NoticeDTO> getMainEventList();
	
}