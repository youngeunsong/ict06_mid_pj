package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;


import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

public interface AccommodationDAO {

    // 숙소 상세
    AccommodationDTO getAccommodationDetail(int place_id);

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
/*
 * @author 김다솜, 송영은 , 송창범
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: RestaurantsDAO, FestivalDAO
 * 변경사항: 
 * v260324
<<<<<<< HEAD
 * ----------------------------------
 */

