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
}

/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: FestivalDAO
 * ----------------------------------
 * v260324
 * ----------------------------------
 */

