package spring.ict06team1.midpj.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import spring.ict06team1.midpj.dto.SearchHistoryDTO;

public interface SearchService {

	// 검색 키워드 결과 가져오기(최근 검색어 추가 | 키워드(맛집/ 숙소/ 축제) 별 리스트 | 리뷰 갯수 + 리뷰 통계 조회 | 즐겨찾기 조회)
	public void getSearchList(HttpServletRequest request, HttpServletResponse response, Model model);
	
	// 즐겨찾기(여부체크/삭제/추가)
	public Map<String, Object> toggleFavorite(HttpServletRequest request);
	
	// AJAX(키워드 선택 시 보여지는 AJAX 화면)
	public Map<String, Object> getSearchAjax(String keyword, String type, String sort, int page);
	
	// 자동완성 10개
	public List<String> getAutoComplete(String keyword);
	
	// 최근 검색어 5개 조회
	public List<SearchHistoryDTO> getRecentKeywords(HttpServletRequest request);
	
	// 최근 검색어 삭제/추가
	public void insertSearchHistory(String userId, String keyword);
	
	
	
}
