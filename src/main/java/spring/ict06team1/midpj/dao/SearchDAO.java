package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.dto.SearchHistoryDTO;

public interface SearchDAO {
	
    /* ==========================================
		검색 키워드 결과 가져오기
		키워드(맛집/ 숙소/ 축제) 별 리스트 | 리뷰 갯수 + 리뷰 통계 조회
	========================================== */
	//키워드(맛집) 리스트
	public List<RestaurantDTO> getRestList(String keyword);
	
	//키워드(숙소) 리스트
	List<AccommodationDTO> getAccList(String keyword);
	
	//키워드(축제) 리스트
	public List<FestivalDTO> getFestList(String keyword);

	//리뷰 갯수 + 리뷰 통계 조회
	public List<Map<String,Object>> getPlaceReviewStats(String keyword);
	
	/* ==========================================
		즐겨찾기(여부체크/ 삭제/ 추가/ 조회)
	========================================== */
	//즐겨찾기 여부체크
	public int checkFavorite (Map<String, Object> checkFavorite);
	
	//즐겨찾기 추가
	public int addFavorite (Map<String, Object> addFavorite);

	//즐겨찾기 삭제
	public int deleteFavorite (Map<String, Object> deleteFavorite);
	
	//즐겨찾기 조회
	public List<Integer> getFavoritePlaceIds(String user_id);
	
    /* ==========================================
		AJAX 화면
		키워드(맛집/ 숙소/ 축제) 별 리스트+페이징 | 리뷰 갯수 + 리뷰 통계 조회
	========================================== */
	//AJAX 맛집 리스트+페이징/ 건수
	public List<RestaurantDTO> getRestAjaxList(Map<String, Object> param);
	public int getRestAjaxCount(Map<String, Object> param);

	// AJAX 숙소 리스트+페이징/ 건수
	public List<AccommodationDTO> getAccAjaxList(Map<String, Object> param);
	public int getAccAjaxCount(Map<String, Object> param);

	// AJAX 축제 리스트+페이징/ 건수
	public List<FestivalDTO> getFestAjaxList(Map<String, Object> param);
	public int getFestAjaxCount(Map<String, Object> param);
	
	// AJAX 리뷰 갯수 + 리뷰 통계 조회
	public List<Map<String, Object>> getPlaceReviewStatsByIds(List<Integer> placeIds);
	
	/* ================================================== 
	   검색바
	   자동완성 10개 + 최근 검색어 5개 조회/ 추가
	================================================== */
	//자동완성 10개
	public List<String> getAutoComplete(String keyword);

	//최근 검색어 5개 조회
	public List<SearchHistoryDTO> getRecentKeywords(String login_userId);
	
	//중복 된다면 최근 검색어 삭제
	public int deleteSameKeyword(Map<String, Object> searchMap);
	
	//최근 검색어 추가
	public int insertSearchHistory(Map<String, Object> searchMap);
	
}
