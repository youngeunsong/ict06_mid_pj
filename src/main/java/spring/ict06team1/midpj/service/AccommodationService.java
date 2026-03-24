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
}
/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: FestivalService
 * ----------------------------------
 * v260324
 * ----------------------------------
 */
