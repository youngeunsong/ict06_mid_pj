package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

public interface RestaurantDAO {

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