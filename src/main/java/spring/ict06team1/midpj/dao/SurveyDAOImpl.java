package spring.ict06team1.midpj.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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
@Repository
public class SurveyDAOImpl implements SurveyDAO {

    @Autowired
    private SqlSession sqlSession;

    // 설문 등록
	@Override
	public int insertSurvey(SurveyDTO dto) {
		System.out.println("[SurveyDAOImpl - insertSurvey()]");
		return sqlSession.getMapper(SurveyDAO.class).insertSurvey(dto);
	}

    //해당 예약 설문 존재 여부(중복 방지)
	@Override
	public int checkSurveyExists(String reservation_id) {
		System.out.println("[SurveyDAOImpl - checkSurveyExists()]");
		return sqlSession.getMapper(SurveyDAO.class).checkSurveyExists(reservation_id);
	}
	
    //설문 대상 예약 조회(마이페이지용)
	@Override
	public List<ReservationDTO> getSurveyTargetList(String user_id) {
		System.out.println("[SurveyDAOImpl - getSurveyTargetList()]");
		return sqlSession.getMapper(SurveyDAO.class).getSurveyTargetList(user_id);
	}
    

}
