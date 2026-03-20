package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.NoticeDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

public interface MainDAO {
	
	// 맛집 TOP10
	public List<RestaurantDTO> top10ByREST();
	
	//숙소 TOP10
	public List<AccommodationDTO> top10ByACC();
	
	//플레이스 별 리뷰 조회
	public List<Map<String, Object>> placeReviewStatsByIds(List<Integer> placeIds);

	//플레이스 별 리뷰 갯수 및 평균 조회
	public List<Integer> favoritePlaceIds(String user_id);
	
	//이달의 추천 국내 축제
	public List<FestivalDTO> top8ThisMonthFestival();
	
	//BEST 추천 - 전체 탭 우측 4개
	public List<Map<String, Object>> bestAllTop4();
	
	//BEST 추천 - 맛집 5개
	public List<RestaurantDTO> bestRestTop5();
	
	//BEST 추천 - 숙소 5개
	public List<AccommodationDTO> bestAccTop5();
	
	//BEST 추천 - 축제 5개
	public List<FestivalDTO> bestFestTop5();
	
	//최하단 공지 리스트
	public List<NoticeDTO> getMainNoticeList();
	
	//최하단 공지 리스트
	public List<NoticeDTO> getMainEventList();
	

}