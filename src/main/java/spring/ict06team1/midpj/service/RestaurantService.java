package spring.ict06team1.midpj.service;

import java.util.List;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

public interface RestaurantService {

    // 맛집 상세
    PlaceDTO getRestaurantDetail(int place_id);

    // 리뷰 페이징
    List<ReviewDTO> getReviewsPaged(int place_id, int offset, int limit);

    // 리뷰 총 개수
    int getReviewCount(int place_id);

    // 즐겨찾기 여부 확인
    boolean isFavorite(String userId, int place_id);

    // 즐겨찾기 토글
    boolean toggleFavorite(String userId, int place_id);
    
    // 맛집 랭킹 목록 조회
    List<RestaurantDTO> getBestRestaurantList();
    
    // 별점 평균
    double getAvgRating(int place_id);
    
    // 맛집 총 갯수
    int getBestRestaurantCount(String region, String category);
    
    // 맛집 페이지 리스트
    List<RestaurantDTO> getBestRestaurantPageList(int start, int end, String region, String category);
    
    // 맛집 top 5
    List<RestaurantDTO> getBestRestaurantTop5(String region, String category);
}