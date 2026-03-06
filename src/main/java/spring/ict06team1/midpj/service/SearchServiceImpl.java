package spring.ict06team1.midpj.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.SearchDAO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;

@Service
public class SearchServiceImpl implements SearchService {

	@Autowired
	private SearchDAO dao;

	//1. 검색 키워드 별 [맛집, 숙소, 축제] 리스트
	@Override
	public void getSearchList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[SearchServiceImpl - getSearchList()]");
		
		String keyword = request.getParameter("keyword");
		System.out.println("keyword: " + keyword);
		
		List<PlaceDTO> list = dao.getSearchList(keyword);
		
		// place_type : REST: 맛집, ACC: 숙소, FEST: 축제
		List<PlaceDTO> restList = new ArrayList<>();
		List<PlaceDTO> accList = new ArrayList<>();
		
		//각 카테고리에 맞는 리스트에 담기
		for(PlaceDTO dto : list) {
			String type = dto.getPlace_type();
			
			if("REST".equals(type)) {
				restList.add(dto);
			}
			else if("ACC".equals(type)) {
				accList.add(dto);
			}
		}
		
		//카테고리 별 리스트 화면 전달
		model.addAttribute("keyword", keyword);
		model.addAttribute("list", list);         // 전체
		model.addAttribute("restList", restList); // 맛집
		model.addAttribute("accList", accList);   // 숙소
		
		//"검색결과 n개" => 건수
		model.addAttribute("listCnt", list.size());         // 전체 건수
		model.addAttribute("restListCnt", restList.size()); // 맛집 건수
		model.addAttribute("accListCnt", accList.size());   // 숙소 건수
		
		// 축제 정보 가져오기
		List<FestivalDTO> festList = dao.getFestList(keyword);
		model.addAttribute("festList", festList); // 축제
		model.addAttribute("festListCnt", festList.size());// 축제 건수
		
		
	}

	//
	@Override
	public Map<String, Object> getSearchAjax(String keyword, String type, String sort, int page) {
		System.out.println("[SearchServiceImpl - getSearchAjax()]");
		
		int pageSize = 12;
		int startRow = (page - 1) * pageSize;   // 0,12,24...
		int endRow   = page * pageSize;         // 12,24,36...
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("keyword", keyword);
		param.put("type", type);
		param.put("sort", sort);
		param.put("startRow", startRow);
		param.put("endRow", endRow);
		param.put("pageSize", pageSize);
		
		List<PlaceDTO> list = dao.getSearchAjax(param);
		int totalCnt = dao.getSearchAjaxCount(param);
		int totalPages = (int) Math.ceil((double)totalCnt/ pageSize); //Math.ceil(소수점 올림)
		
		Map<String, Object> result = new HashMap<>();
	    result.put("list",        list);
	    result.put("totalCnt",    totalCnt);
	    result.put("totalPages",  totalPages);
	    result.put("currentPage", page);
		
		return result;
	}

	
	
	
	
}
