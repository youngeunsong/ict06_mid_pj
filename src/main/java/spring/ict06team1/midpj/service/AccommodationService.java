package spring.ict06team1.midpj.service;

import java.util.List;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

public interface AccommodationService {

    // 숙소 상세
    AccommodationDTO getAccommodationDetail(int place_id);

    // 리뷰 페이징
    List<ReviewDTO> getReviewsPaged(int place_id, int offset, int limit);

    // 리뷰 총 개수
    int getReviewCount(int place_id);

    // 즐겨찾기 여부 확인
    boolean isFavorite(String userId, int place_id);

    // 즐겨찾기 토글
    boolean toggleFavorite(String userId, int place_id);
    
 // 숙소 총 갯수
 	int getAccommodationCount();
 	
 	// [랭킹 관련 메서드] -----------------------------
 	// 숙소 랭킹 목록 조회
     List<AccommodationDTO> getBestAccommodationList();
     
     // 별점 평균
     double getAvgRating(int place_id);
     
     // 숙소 총 갯수
     int getBestAccommodationCount(String region);
     
     // 숙소 페이지 리스트
     List<AccommodationDTO> getBestAccommodationPageList(int start, int end, String region);
     
     // 숙소 top 5
     List<AccommodationDTO> getBestAccommodationTop5(String region);
}

/*
 * @author 김다솜, 송영은
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: FestivalService, RestaurantService
 * ----------------------------------
 * v260324
 * (김다솜) : 예약 관련 메서드 구현  
 * (송영은): 숙소 랭킹 관련 메서드 구현
 * ----------------------------------
 */

