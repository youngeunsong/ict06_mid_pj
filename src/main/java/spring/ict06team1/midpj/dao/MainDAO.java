package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.AccommodationDTO;
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

}
