package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

public interface AdAccommodationDAO {
	
	// 관리자 숙소 목록 갯수 구하기
	int placeCnt(Map<String, Object> map);
		
	// 관리자 숙소 목록 조회
	public List<Map<String, Object>> placeList(Map<String, Object> map);
		
	// 관리자 숙소 정보 검색-(keyowrd -> int일 경우)
	public List<Map<String, Object>> getAccommodationSearchInt(Map<String, Object> map);
			
	// 관리자 숙소 정보 검색-(keyowrd -> String일 경우)
	public List<Map<String, Object>> getAccommodationSearchString(Map<String, Object> map);
	
	// 관리자 숙소 등록(place 테이블)
	public int getPlaceInsert(PlaceDTO pDto);
		
	// 관리자 숙소 등록(accommodation 테이블) 
	public int getAccommodationInsert(AccommodationDTO aDto);
	
	// 관리자 숙소 상세 조회 
	public PlaceDTO getPlaceDetail(int place_id);
		
	// 관리자 숙소 상세 조회
	public AccommodationDTO getAccommodationDetail(int place_id);
	
	// 관리자 숙소 플레이스 테이블 수정
	public int getPlaceUpdateAction(PlaceDTO pDto);
	
	// 관리자 숙소 레스토랑 테이블 수정
	public int getAccommodationUpdateAction(AccommodationDTO aDto);
	
	// 관리자 숙소 정보 삭제
	public int getAccommodationDeleteAction(int place_id);
	
	// 공공데이터 활용 숙소 정보 플레이스 테이블 등록
	public int insertPlace(PlaceDTO pDto);
		
	// 공공데이터 활용 숙소 정보 레스토랑 테이블 등록
	public int insertAcc(AccommodationDTO aDto);
	
	// 공공데이터 활용 데이터 중복 확인  
	public int checkDuplicate(String place_id);
}
