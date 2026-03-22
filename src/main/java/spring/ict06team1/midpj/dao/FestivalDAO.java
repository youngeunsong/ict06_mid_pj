package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
/*
 * @author 송영은
 * 최초작성일: 2026-03-17
 * 최종수정일: 2026-03-19
 * 참고 코드: RestaurantDAO
 * ----------------------------------
 * v260319
 * 랭킹 기능 구현을 위한 메써드 추가 (getBestFestivalCount, getBestFestivalList, getBestFestivalPageList, getBestFestivalTop5)
 * ----------------------------------
 */
public interface FestivalDAO {
	// 축제 상세
	// 1단계: Place, Review 함께 조회
    PlaceDTO selectPlaceDetail(int place_id);

    // 2단계: FestivalDTO 조회
    FestivalDTO getFestivalDetail(int festival_id);
    
    // 3단계: FestivalTicketDTO 조회
    List<FestivalTicketDTO> getFestivalTickets(int festival_id); 
    
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
    
    // 축제 랭킹 목록 조회
    List<FestivalDTO> getBestFestivalList();
    
    // 축제 총 갯수
    int getBestFestivalCount();
    
    // 축제 페이지 리스트
    List<FestivalDTO> getBestFestivalPageList(Map<String, Object> map);
    
    // 축제 랭킹 top5
    List<FestivalDTO> getBestFestivalTop5();
}
