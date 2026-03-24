package spring.ict06team1.midpj.service;

import java.util.List;

import spring.ict06team1.midpj.dto.AccommodationDTO;

public interface AccommodationService {

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
