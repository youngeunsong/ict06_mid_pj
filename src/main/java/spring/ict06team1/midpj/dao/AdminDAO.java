package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

public interface AdminDAO {

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
