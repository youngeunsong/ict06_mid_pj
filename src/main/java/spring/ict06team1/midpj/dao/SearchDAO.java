package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.SearchHistoryDTO;

public interface SearchDAO {
	
	
	// [검색 결과] -----------------------------------------------------------
	// 1. 검색어 기준 장소 목록
	public List<PlaceDTO> getSearchList(String keyword);
	
	// 2. 검색어 기준 축제 목록
	public List<FestivalDTO> getFestList (String keyword);

	// 3. 검색어 기준 장소별 리뷰 통계
	public List<Map<String,Object>> getPlaceReviewStats(String keyword);
	
	// [즐겨찾기] -----------------------------------------------------------
	// 1. 즐겨찾기 여부 확인
	public int checkFavorite (Map<String, Object> checkFavorite);
	
	// 2. 즐겨찾기 추가
	public int addFavorite (Map<String, Object> addFavorite);

	// 3. 즐겨찾기 삭제
	public int deleteFavorite (Map<String, Object> deleteFavorite);
	
	// 4. 즐겨찾기 한 정보 끌고오기
	public List<Integer> getFavoritePlaceIds(String user_id);
	
	// [AJAX] -----------------------------------------------------------
	// 1. AJAX 카드 목록
	public List<PlaceDTO> getSearchAjax (Map<String, Object> param);
	
	// 2. AJAX 전체 건수
	public int getSearchAjaxCount (Map<String, Object> param);
	
	// 3. AJAX 목록 대상 장소들의 리뷰 통계
	List<Map<String, Object>> getSearchAjaxReviewStats(Map<String, Object> param);
	
	// [자동완성] -----------------------------------------------------------
	//자동완성 10개
	public List<String> getAutoComplete(String keyword);
	
	// [최근 검색어] -----------------------------------------------------------
	// 1. 최근 검색어 5~10개 조회
	public List<SearchHistoryDTO> getRecentKeywords(String login_userId);
	
	// 2. 최근 검색어 추가 전, 이미 db에 있다면 중복 방지를 위한 삭제
	public int deleteSameKeyword(Map<String, Object> searchMap);
	
	// 3. 최근 검색어 추가
	public int insertSearchHistory(Map<String, Object> searchMap);
	
}
