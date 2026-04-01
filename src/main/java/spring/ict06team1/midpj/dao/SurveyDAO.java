package spring.ict06team1.midpj.dao;

import java.util.List;
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
 * 설문 응답 후 리뷰/별점 등록 기능을 위한 메서드 추가(insertReview, checkReviewExists)
 * ----------------------------------
 */
public interface SurveyDAO {

    // 설문 등록
    int insertSurvey(SurveyDTO dto);
    
    //해당 예약 설문 존재 여부(중복 방지)
    int checkSurveyExists(String reservation_id);
    
    //설문 대상 예약 조회(마이페이지용)
    List<ReservationDTO> getSurveyTargetList(String user_id);
    
    //리뷰 등록
    int insertReview(ReviewDTO dto);
    
    //리뷰 중복 체크
    int checkReviewExists(String reservation_id);

	// 설문 작성 완료 여부 확인(예약목록 버튼 전환용)
	int checkSurveyWritten(String reservation_id);
}
