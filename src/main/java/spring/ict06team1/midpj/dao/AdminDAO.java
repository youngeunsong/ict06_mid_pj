package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.ReservationDTO;

public interface AdminDAO {

	//1. 예약 조회
	//1-1. 예약목록 조회
	public List<ReservationDTO> getReservationList(Map<String,Object> map);
	
	//1-2. 예약 상세페이지 조회
	public ReservationDTO getReservationDetail(String reservation_id); 
	
	//2. 예약 변경
	//2-1. 예약상태 변경
	public int modifyReservationStatus(ReservationDTO dto); 
	
	//3. 통계
	//3-1. 대시보드(기간별 집계)
	public Map<String, Object> getReservationStatistics();
	
}
