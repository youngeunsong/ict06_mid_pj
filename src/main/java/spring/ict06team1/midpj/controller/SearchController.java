package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.service.SearchServiceImpl;

@Controller
public class SearchController {
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@Autowired
	private SearchServiceImpl searchService;
	
	/* ================================================== 
	   검색바 > 검색 결과 페이지
	   결과 페이지 + AJAX 필터화면 + 즐겨찾기
	================================================== */
	// 결과 페이지
	@RequestMapping("/search.do")
	public String executeSearch(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		
		logger.info("<<< url => search.do>>>");
		
		searchService.getSearchList(request, response, model);
		
		return "user/search/search";
	}
	
	// AJAX 필터화면
	@RequestMapping("/search/ajax")
	public String searchAjax(
			@RequestParam String keyword,
			@RequestParam(defaultValue = "ALL") String type,      // ALL / REST / ACC / FEST
			@RequestParam(defaultValue  = "popular") String sort, // popular(조회순) / latest(최신순)
			@RequestParam(defaultValue = "1") int page,
			Model model){
		
		logger.info("<<< url => search/ajax >>>");
		
		Map<String, Object> data = searchService.getSearchAjax(keyword, type, sort, page);
		
		model.addAttribute("keyword", keyword);       // 검색 키워드
		model.addAttribute("type", data.get("type")); // ALL / REST / ACC / FEST
		
		model.addAttribute("restList", data.get("restList")); // 키워드 식당 리스트
		model.addAttribute("accList", data.get("accList"));   // 키워드 숙소 리스트
		model.addAttribute("festList", data.get("festList")); // 키워드 축제 리스트
		
	    model.addAttribute("totalCnt", data.get("totalCnt"));     // 페이징 전체 검색 수
	    model.addAttribute("totalPages", data.get("totalPages")); // 페이징 전체 페이지 수
	    
	    model.addAttribute("currentPage", data.get("currentPage"));
	    
	    model.addAttribute("reviewCountMap", data.get("reviewCountMap"));     // 리뷰 수
		model.addAttribute("avgRatingMap", data.get("avgRatingMap"));         // 리뷰 평균
		model.addAttribute("favoritePlaceIds", data.get("favoritePlaceIds")); // 북마크
		
		return "user/search/search_fragment";
	}

	// 즐겨찾기
	@RequestMapping("/favorite/toggle")
	@ResponseBody
	public Map<String, Object> toggleFavorite(HttpServletRequest request) {
		logger.info("<<< url => /favorite/toggle>>>");
		
		return searchService.toggleFavorite(request);
	}
	
	/* ================================================== 
	   검색바
	   자동완성 + 최근 검색어
	================================================== */
	// 자동완성
	@RequestMapping("/search/autocomplete")
	@ResponseBody
	public java.util.List<String> getAutoComplete(@RequestParam String keyword) {
	    logger.info("<<< url => /search/autocomplete >>>");
	    logger.info("[Controller] keyword => {}", keyword);
	    return searchService.getAutoComplete(keyword);
	}

	// 최근 검색어
	@RequestMapping("/search/recent")
	@ResponseBody
	public java.util.List<spring.ict06team1.midpj.dto.SearchHistoryDTO> getRecentKeywords(HttpServletRequest request) {
	    logger.info("<<< url => /search/recent >>>");
	    return searchService.getRecentKeywords(request);
	}
}
