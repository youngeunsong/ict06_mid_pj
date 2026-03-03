package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.SearchDAO;
import spring.ict06team1.midpj.dto.PlaceDTO;

@Service
public class SearchServiceImpl implements SearchService {

	@Autowired
	private SearchDAO dao;

	@Override
	public void getSearchList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[SearchServiceImpl - getSearchList()]");
		
		String keyword = request.getParameter("keyword");
		String status = request.getParameter("status");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", (keyword != null && !keyword.trim().isEmpty() ? keyword : null));
		map.put("status", (status != null && !status.equals("ALL")) ? status : null);
		
		List<PlaceDTO> list = dao.getSearchList(map);
		
		model.addAttribute("placeList", list);
		model.addAttribute("keyword", keyword);
		model.addAttribute("status", status);
		
		System.out.println("검색 결과 " + (list != null ? list.size() : 0) + "건");
	}
}
