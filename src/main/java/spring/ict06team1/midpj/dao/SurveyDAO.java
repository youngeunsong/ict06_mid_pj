package spring.ict06team1.midpj.dao;

import java.util.List;

import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.dto.SurveyDTO;

/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: None
 * ----------------------------------
 * v260324
 * ----------------------------------
 */
public interface SurveyDAO {

    // 설문 등록
    int insertSurvey(SurveyDTO dto);
    
    //해당 예약 설문 존재 여부(중복 방지)
    int checkSurveyExists(String reservation_id);
    
    //설문 대상 예약 조회(마이페이지용)
    List<ReservationDTO> getSurveyTargetList(String user_id);
}
