package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;

public interface SearchDAO {
	
	//1. 맛집, 숙소, 축제 리스트 가져오기
	public List<PlaceDTO> getSearchList(String keyword);
	
	//2. 축제 상세 리스트 가져오기
	public List<FestivalDTO> getFestList (String keyword);
	
	//
	public List<PlaceDTO> getSearchAjax (Map<String, Object> param);
	
	//
	public int getSearchAjaxCount (Map<String, Object> param);
	
}
