package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

public interface RestaurantDAO {

    // 맛집 상세
	RestaurantDTO getRestaurantDetail(int place_id);

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
    
    // 맛집 랭킹 목록 조회
    List<RestaurantDTO> getBestRestaurantList();
    
    // 별점 평균
    double getAvgRating(int place_id);
    
    // 맛집 총 갯수
    int getBestRestaurantCount(Map<String, Object> map);
    
    // 맛집 페이지 리스트
    List<RestaurantDTO> getBestRestaurantPageList(Map<String, Object> map);
    
    // 맛집 랭킹 top5
    List<RestaurantDTO> getBestRestaurantTop5(Map<String, Object> map);
}