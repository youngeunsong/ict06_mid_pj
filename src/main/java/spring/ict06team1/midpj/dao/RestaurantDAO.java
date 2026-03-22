package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

public interface RestaurantDAO {
	
	// 주변 맛집의 총 개수를 조회 (페이징 계산용)
	public int selectNearbyRestaurantCount(Map<String, Object> map); 
	
	// 조건에 맞는 맛집 리스트 조회 (6개씩 끊어서 가져오기)
    public List<RestaurantDTO> selectNearbyRestaurantList(Map<String, Object> map);
    
    // 조건에 맞는 맛집 마커 불러오기 (전부 가져오기)
    public List<RestaurantDTO> selectNearbyMarkersAjax(Map<String, Object> map);
    
    // 맛집 상세
    PlaceDTO getRestaurantDetail(int place_id);

    // 조회수 증가
    void increaseViewCount(int place_id);

    // 리뷰 페이징
    List<ReviewDTO> getReviewsPaged(Map<String, Object> map);

    // 리뷰 총 개수
    int getReviewCount(int place_id);

    // 즐겨찾기 여부 확인
    int isFavorite(Map<String, Object> map);

    // 즐겨찾기 추가
    int insertFavorite(Map<String, Object> map);

    // 즐겨찾기 삭제
    int deleteFavorite(Map<String, Object> map);
}