package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.ReservationDTO;

public interface AdReservationDAO {

	//1. 예약 조회
	//1-1. 예약목록 조회
	public List<ReservationDTO> getReservationList(Map<String,Object> map);
	
	//1-2. 예약 상세페이지 조회
	public ReservationDTO getReservationDetail(String reservation_id); 
	
	//1-3. 전체 예약건수 조회(페이징용)
	public int getReservationCount(Map<String,Object> map);
	
	//2. 예약 변경
	//2-1. 예약 수정
	public int modifyReservation(ReservationDTO dto);
	
	//2-2. 예약 취소
	public int cancelReservation(String reservation_id);
	
	//3. 통계
	//3-1. KPI(기간별 집계)
	public Map<String, Object> getDashboardKPI();
	
	//3-2. 월별 예약 추이(최근 6개월)
	public List<Map<String, Object>> getMonthlyTrend();

	//3-3. 예약 상태별 비율
	public List<Map<String, Object>> getStatusRatio();
	
	//3-4. 장소 분류별 비율
	public List<Map<String, Object>> getPlaceTypeRatio();
	
	//3-5. 요일별 예약 분포
	public List<Map<String, Object>> getDayOfWeekStats();
	
	//3-6. 미처리(PENDING) 목록
	public List<ReservationDTO> getPendingList();
	
	//3-7. 최근 예약 5건
	public List<ReservationDTO> getRecentReservations();
	
	//미처리 예약 건수 조회
	public int getPendingCount();
	
	//페이징된 미처리 목록 조회(매개변수로 Map 전달 추천)
	public List<ReservationDTO> getPendingListPage(Map<String, Object> map);
}
