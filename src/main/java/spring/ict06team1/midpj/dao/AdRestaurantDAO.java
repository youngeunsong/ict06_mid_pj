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

	// 관리자 맛집 등록(place 테이블)
	public int getPlaceInsert(PlaceDTO pdto);
	
	// 관리자 맛집 등록(restaurant 테이블) 
	public int getRestaurantInsert(RestaurantDTO rdto);
	
	//관리자 맛집 상세 조회 
	public PlaceDTO getPlaceDetail(int place_id);
	
	//관리자 맛집 상세 조회
	public RestaurantDTO getRestaurantDetail(int place_id);
	
	
	public int getRestaurantUpdateAction(RestaurantDTO rDto);
	
	public int getPlaceUpdateAction(PlaceDTO pDto);
	
	//맛집 정보 삭제
	public int getRestaurantDeleteAction(int place_id);
	
	public int testInsertRes(RestaurantDTO rdto);
	
	public int testInsertPlace(PlaceDTO pdto);
	
	public int checkDuplicate(String test_id);
	
}

