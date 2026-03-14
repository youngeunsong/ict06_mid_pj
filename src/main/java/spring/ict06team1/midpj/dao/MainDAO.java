package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;

public interface MainDAO {
	
	// 맛집 TOP10
	public List<PlaceDTO> getTop10ByREST();
	
	//숙소 TOP10
	public List<AccommodationDTO> getTop10ByACC();
	
	//각 플레이스 별 리뷰
	public List<Map<String, Object>> getPlaceReviewStatsByIds(List<Integer> placeIds);

	//즐겨찾기
	public List<Integer> getFavoritePlaceIds(String user_id);
	
	//이달의 추천 국내 축제
	public List<FestivalDTO> getTop8ThisMonthFestival();
	
	//BEST 추천 - 전체 탭 우측 4개
	public List<Map<String, Object>> getBestAllTop4();
	
	//BEST 추천 - 맛집 5개
	public List<PlaceDTO> getBestRestTop5();
	
	//BEST 추천 - 숙소 5개
	public List<AccommodationDTO> getBestAccTop5();
	
	//BEST 추천 - 축제 5개
	public List<FestivalDTO> getBestFestTop5();
	

}