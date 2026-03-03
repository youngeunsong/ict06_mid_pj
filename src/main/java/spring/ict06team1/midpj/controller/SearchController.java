package spring.ict06team1.midpj.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import spring.ict06team1.midpj.service.AccommodationServiceImpl;
import spring.ict06team1.midpj.service.SearchServiceImpl;

@Controller
public class SearchController {
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@Autowired
	private SearchServiceImpl searchService;
	
	@RequestMapping("/search.do")
	public String executeSearch(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		logger.info("<<< url => executeSearch.se>>>");
		
		String keyword = request.getParameter("keyword");
		searchService.getSearchList(request, response, model);
		
		return "user/search/list";
	}
	
	//[accommodation] ----------------------------------------------------------------------------------------
	//[accommodation] 숙소 페이지로 이동
}
