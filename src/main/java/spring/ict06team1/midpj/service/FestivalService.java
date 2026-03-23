package spring.ict06team1.midpj.service;

import java.util.List;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
/*
 * @author 송영은
 * 최초작성일: 2026-03-17
 * 최종수정일: 2026-03-19
 * 참고 코드: RestaurantService
 * ----------------------------------
 * v260319
 * 랭킹 기능 구현을 위한 메써드 추가 (getBestFestivalCount, getBestFestivalList, getBestFestivalPageList, getBestFestivalTop5)
 * ----------------------------------
 */
public interface FestivalService {

	 // 축제 상세
	FestivalDTO getFestivalDetail(int place_id);

    // 리뷰 페이징
    List<ReviewDTO> getReviewsPaged(int place_id, int offset, int limit);

    // 리뷰 총 개수
    int getReviewCount(int place_id);

    // 즐겨찾기 여부 확인
    boolean isFavorite(String userId, int place_id);

    // 즐겨찾기 토글
    boolean toggleFavorite(String userId, int place_id);
    
    // 축제 총 갯수
    int getBestFestivalCount();
    
    // 축제 랭킹 목록 조회
    List<FestivalDTO> getBestFestivalList();
    
    // 축제 페이지 리스트 (6위부터)
    List<FestivalDTO> getBestFestivalPageList(int start, int end);
    
    // 축제 top 5
    List<FestivalDTO> getBestFestivalTop5();
}
