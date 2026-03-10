package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

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
	
	//------------------------------------------------------------------
	//관리자 장소 - 맛집 조회
	//1.관리자 장소 목록 갯수 구하기
	public int placeCnt();
	
	public int placeCntArea(String areacode);
	
	//2.관리자 장소 맛집 목록 조회
	public List<PlaceDTO> placeList(Map<String,Object> map);
	
	public List<PlaceDTO>getRestaurantArea(Map<String,Object> map);
	
	
	
	public int getPlaceInsert(PlaceDTO pdto);
	
	public int getRestaurantInsert(RestaurantDTO rdto);
	
	public RestaurantDTO getRestaurantDetail(int place_id);
	
	public PlaceDTO getPlaceDetail(int place_id);
	
	public int getRestaurantUpdateAction(RestaurantDTO rDto);
	
	public int getPlaceUpdateAction(PlaceDTO pDto);
	
	public int testInsertRes(RestaurantDTO rdto);
	
	public int testInsertPlace(PlaceDTO pdto);
	
	public int checkDuplicate(String test_id);
	
}
