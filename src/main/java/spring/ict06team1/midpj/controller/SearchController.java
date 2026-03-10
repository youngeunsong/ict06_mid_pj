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
	
	//[검색바] 검색 페이지로 이동
	@RequestMapping("/search.do")
	public String executeSearch(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		
		logger.info("<<< url => search.do>>>");
		searchService.getSearchList(request, response, model);
		
		return "common/search";
	}
	
	//[검색페이지] AJAX 필터화면
	@RequestMapping("/search/ajax")
	public String searchAjax(
			@RequestParam String keyword,
			@RequestParam(defaultValue = "ALL") String type,
			@RequestParam(defaultValue  = "popular") String sort,
			@RequestParam(defaultValue = "1") int page,
			Model model){
		
		logger.info("<<< url => search/ajax>>>");
		
		Map<String, Object> data = searchService.getSearchAjax(keyword, type, sort, page);
		
		model.addAttribute("keyword", keyword);
		model.addAttribute("list", data.get("list"));
	    model.addAttribute("totalPages", data.get("totalPages"));
	    model.addAttribute("currentPage", data.get("currentPage"));
	    model.addAttribute("reviewCountMap", data.get("reviewCountMap"));
		model.addAttribute("avgRatingMap", data.get("avgRatingMap"));
		model.addAttribute("favoritePlaceIds", data.get("favoritePlaceIds")); // 즐겨찾기
		
		return "common/search_fragment";
	}

	//[즐겨찾기]
	@RequestMapping("/favorite/toggle")
	@ResponseBody
	public Map<String, Object> toggleFavorite(HttpServletRequest request) {
		logger.info("<<< url => /favorite/toggle>>>");
		
		return searchService.toggleFavorite(request);
		
	}
	

}
