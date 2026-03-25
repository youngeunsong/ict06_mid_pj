package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import spring.ict06team1.midpj.dao.ReservationDAO;
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
public class SurveyServiceImpl implements SurveyService {

	@Autowired
	public ReservationDAO resDao;

	// 설문 등록
	@Override
	@Transactional
	public Map<String, Object> insertSurvey(SurveyDTO dto) {
	    System.out.println("[SurveyServiceImpl - insertSurvey()]");
	    
	    Map<String, Object> result = new HashMap<String, Object>();
		return null;
	}

	// 설문 대상 조회
	@Override
	public List<ReservationDTO> getSurveyTargetList(String user_id) {
	    System.out.println("[SurveyServiceImpl - getSurveyTargetList()]");
		return null;
	}
}
