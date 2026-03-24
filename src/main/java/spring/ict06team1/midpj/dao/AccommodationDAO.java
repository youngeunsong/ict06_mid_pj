package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.AccommodationDTO;

/*
 * @author 송영은
 * 최초 작성일: 26.03.10
 * 최종 수정일: 26.03.24
 * 업데이트 사항:
 * v260324: 랭킹 관련 메서드 구현 
 */

public interface AccommodationDAO {

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
