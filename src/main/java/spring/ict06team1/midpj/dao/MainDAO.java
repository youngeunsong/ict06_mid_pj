package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;

public interface MainDAO {
	
	
	//각 플레이스 별 리뷰
	public List<Map<String, Object>> getPlaceReviewStatsByIds(List<Integer> placeIds);

	//즐겨찾기
	public List<Integer> getFavoritePlaceIds(String user_id);

}
