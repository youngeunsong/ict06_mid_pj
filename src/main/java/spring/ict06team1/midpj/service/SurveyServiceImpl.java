package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import spring.ict06team1.midpj.dao.ReservationDAO;
import spring.ict06team1.midpj.dao.SurveyDAO;
import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.dto.SurveyDTO;

/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: None
 * ----------------------------------
 * v260325
 * 리뷰/별점 등록 기능을 위한 메서드 추가(insertReview)
 * ----------------------------------
 */
@Service
public class SurveyServiceImpl implements SurveyService {

	@Autowired
	public SurveyDAO svDao;
	@Autowired
	public ReservationDAO resDao;

	// 설문 등록
	@Override
	@Transactional
	public Map<String, Object> insertSurvey(SurveyDTO dto) {
	    System.out.println("[SurveyServiceImpl - insertSurvey()]");
	    
	    Map<String, Object> result = new HashMap<String, Object>();
	    
	    try {
	    	//1. 예약 존재 여부 체크
	    	ReservationDTO resDto = resDao.getReservationById(dto.getReservation_id());
	    	
	    	if(resDto == null) {
	    		throw new RuntimeException("존재하지 않는 예약");
	    	}
	    	
	    	//2. 본인 예약인지 체크
	    	if(!dto.getUser_id().equals(resDto.getUser_id())) {
	    		throw new RuntimeException("본인 예약만 설문 가능");
	    	}
	    	
	    	//3. 이용 완료 상태인지 체크
	    	if(!"COMPLETED".equals(resDto.getStatus())) {
	    		throw new RuntimeException("이용 완료된 예약만 설문 가능");
	    	}
	    	
	    	//4. 이미 설문 작성했는지 체크
	    	if(svDao.checkSurveyExists(resDto.getReservation_id()) > 0) {
	    		throw new RuntimeException("이미 설문 작성함");
	    	}
	    	
	    	//5. 설문 저장
	    	svDao.insertSurvey(dto);
	    	
	    	// ===============================
			// 추가: 김재원 2026-03-26
			// 설문조사 참여 시 포인트 지급 
	    	// 6. 포인트 지급
	    	
	    	Map<String, Object> pointMap = new HashMap<>();
	    	pointMap.put("userId", dto.getUser_id());
	        pointMap.put("policyKey", "EARN_SURVEY");           
	        pointMap.put("description", "설문 조사 참여 포인트 적립");
            svDao.insertPoint(pointMap);
	    	// =================================
            
	    	result.put("success", true);
	    	result.put("msg", "설문 등록 완료");
	    } catch(Exception e) {
	    	e.printStackTrace();
	    	result.put("success", false);
	    	result.put("msg", e.getMessage());
	    }
		return result;
	}

	// 설문 대상 조회
	@Override
	public List<ReservationDTO> getSurveyTargetList(String user_id) {
	    System.out.println("[SurveyServiceImpl - getSurveyTargetList()]");
		
	    return svDao.getSurveyTargetList(user_id);
	}

	//리뷰 등록
	@Override
	public Map<String, Object> insertReview(ReviewDTO dto, String reservation_id) {
	    System.out.println("[SurveyServiceImpl - insertReview()]");
	    
	    Map<String, Object> result = new HashMap<String, Object>();
	    
	    try {
	    	//1. 예약 존재 여부 체크
	    	ReservationDTO resDto = resDao.getReservationById(reservation_id);
	    	if(resDto == null)
	    		throw new RuntimeException("존재하지 않는 예약");

	    	if(!dto.getUser_id().equals(resDto.getUser_id()))
	    		throw new RuntimeException("본인 예약만 리뷰 가능");
	    	
	    	if(!"COMPLETED".equals(resDto.getStatus()))
	    		throw new RuntimeException("이용 완료된 예약만 리뷰 가능");
	    	
	    	if(svDao.checkReviewExists(reservation_id) > 0)
	    		throw new RuntimeException("이미 리뷰 작성함");
	    	
	    	// 예약정보를 기준으로 place_id, reservation_id를 확정 세팅
	    	dto.setPlace_id(resDto.getPlace_id());
	    	dto.setReservation_id(reservation_id);
	    	
	    	// 리뷰 등록
	    	svDao.insertReview(dto);
	    	
	    	// ===============================
			// 추가: 김재원 2026-03-26
			// 리뷰 참여 시 포인트 지급
	    	// 6. 포인트 지급
            Map<String, Object> pointMap = new HashMap<>();
	    	pointMap.put("userId", dto.getUser_id());
	        pointMap.put("policyKey", "EARN_REVIEW");           
	        pointMap.put("description", "리뷰 작성 포인트 적립");
            svDao.insertPoint(pointMap);
            // ===============================
            
	    	result.put("success", true);
	    	result.put("msg", "리뷰 등록 완료");
	    } catch(Exception e) {
	    	e.printStackTrace();
	    	result.put("success", false);
	    	result.put("msg", e.getMessage());
	    }
		return result;
	}
}
