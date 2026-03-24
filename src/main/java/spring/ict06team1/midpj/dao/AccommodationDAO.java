package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

/*
 * @author 김다솜, 송영은
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: RestaurantsDAO, FestivalDAO
 * 변경사항: 
 * v260324
 * (김다솜) : 예약 관련 메서드 구현  
 * (송영은): 숙소 랭킹 관련 메서드 구현
*/

public interface AccommodationDAO {
	//숙소 상세
	//1단계: Place, Review 함께 조회
	PlaceDTO selectPlaceDetail(int place_id);
	
	//2단계: AccommodationDTO 조회
	AccommodationDTO getAccommodationDetail(int accommodation_id);
	
	//조회수 증가
	void increaseViewCount(int place_id);
	
	//리뷰 페이징
	List<ReviewDTO> getReviewsPaged(Map<String, Object> map);
	
	//리뷰 총 개수
	int getReviewCount(int place_id);
	
	//즐겨찾기 여부 확인
	int isFavorite(Map<String, Object> map);
	
	// 즐겨찾기 추가
	int insertFavorite(Map<String, Object> map);

	// 즐겨찾기 삭제
	int deleteFavorite(Map<String, Object> map);
    
	// 숙소 총 갯수
	int getAccommodationCount();
    
	// 숙소 페이지 리스트
	List<AccommodationDTO> getAccommodationPageList(Map<String, Object> map);
	
	// [숙소 랭킹 관련 메서드] ----------------------------------------------------------
	// 숙소 랭킹 목록 조회
    List<AccommodationDTO> getBestAccommodationList();
    
    // 별점 평균
    double getAvgRating(int place_id);
    
    // 숙소 총 갯수
    int getBestAccommodationCount(Map<String, Object> map);
    
    // 숙소 페이지 리스트
    List<AccommodationDTO> getBestAccommodationPageList(Map<String, Object> map);
    
    // 숙소 랭킹 top5
    List<AccommodationDTO> getBestAccommodationTop5(Map<String, Object> map);
}
