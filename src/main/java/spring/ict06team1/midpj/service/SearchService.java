package spring.ict06team1.midpj.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import spring.ict06team1.midpj.dto.SearchHistoryDTO;

public interface SearchService {

	//1. 검색 키워드 별 [맛집, 숙소, 축제] 리스트
	public void getSearchList(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//2. 즐겨찾기에 추가하기
	public Map<String, Object> toggleFavorite(HttpServletRequest request);
	
	//AJAX
	public Map<String, Object> getSearchAjax(String keyword, String type, String sort, int page);
	
	//자동완성 10개
	public List<String> getAutoComplete(String keyword);
	
	//1. 최근 검색어 5~10개 조회
	public List<SearchHistoryDTO> getRecentKeywords(HttpServletRequest request);
	
	public void insertSearchHistory(String userId, String keyword);
	
	
	
}
