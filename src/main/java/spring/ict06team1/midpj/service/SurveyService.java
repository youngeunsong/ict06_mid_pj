package spring.ict06team1.midpj.service;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.dto.SurveyDTO;

/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-25
 * 참고 코드: None
 * ----------------------------------
 * v260325
 * 리뷰/별점 등록 기능을 위한 메서드 추가(insertReview)
 * ----------------------------------
 */
public interface SurveyService {

	// 설문 등록
	Map<String, Object> insertSurvey(SurveyDTO dto);
	
	// 설문 대상 조회
	List<ReservationDTO> getSurveyTargetList(String user_id);
	
	//리뷰 등록
	public Map<String, Object> insertReview(ReviewDTO dto, String reservation_id);
}
