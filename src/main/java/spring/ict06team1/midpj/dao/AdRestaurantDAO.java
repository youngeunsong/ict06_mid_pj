package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

public interface AdRestaurantDAO {
		
	// 관리자 맛집 목록 갯수 구하기
	int placeCnt(Map<String, Object> map);
	
	// 관리자 맛집 목록 조회
	public List<Map<String, Object>> placeList(Map<String, Object> map);
	
	//관리자 맛집 정보 검색-(keyowrd -> int일 경우)
	public List<Map<String, Object>> getRestaurantSearchInt(Map<String, Object> map);
		
	//관리자 맛집 정보 검색-(keyowrd -> String일 경우)
	public List<Map<String, Object>> getRestaurantSearchString(Map<String, Object> map);
	
	// 관리자 맛집 등록(place 테이블)
	public int getPlaceInsert(PlaceDTO pdto);
	
	// 관리자 맛집 등록(restaurant 테이블) 
	public int getRestaurantInsert(RestaurantDTO rdto);
	
	// 관리자 맛집 상세 조회 
	public PlaceDTO getPlaceDetail(int place_id);
	
	// 관리자 맛집 상세 조회
	public RestaurantDTO getRestaurantDetail(int place_id);
	
	// 관리자 맛집 플레이스 테이블 수정
	public int getPlaceUpdateAction(PlaceDTO pDto);
	
	// 관리자 맛집 레스토랑 테이블 수정
	public int getRestaurantUpdateAction(RestaurantDTO rDto);
	
	// 관리자 맛집 정보 삭제
	public int getRestaurantDeleteAction(int place_id);
	
	// 공공데이터 활용 맛집 정보 레스토랑 테이블 등록
	public int testInsertRes(RestaurantDTO rdto);
	
	// 공공데이터 활용 맛집 정보 플레이스 테이블 등록
	public int testInsertPlace(PlaceDTO pdto);
	
	// 공공데이터 활용 데이터 중복 확인  
	public int checkDuplicate(String test_id);
}