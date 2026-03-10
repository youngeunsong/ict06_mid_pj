package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.AdPlaceDAO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.page.Paging;

@Service
public class AdPlaceServiceImpl implements AdPlaceService{

	@Autowired
	private AdPlaceDAO dao; 
	
	// 축제 목록 조회
	@Override
	public void getFestivalList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdPlaceServiceImpl - getFestivalList()]");
		
		//1) parameter값 수집(검색어, 예약상태) TODO: 상황에 맞게 수정 
		String keyword = request.getParameter("keyword");
		String status = request.getParameter("status");
		String pageNum = request.getParameter("pageNum");
		String sortType = request.getParameter("sortType");
		
		//페이징 객체 생성
		Paging paging = new Paging(pageNum);
		
		//검색조건 담을 map 생성
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", status);
		map.put("keyword", keyword);
		map.put("sortType",sortType != null ? sortType : "created_at_desc");
		
		//전체 건수 조회
		int totalCount = dao.getFestivalCount(map); 
		paging.setTotalCount(totalCount);
		
		//페이징 범위 추가
		map.put("startRow", paging.getStartRow());
        map.put("endRow", paging.getEndRow());
        
		//목록 조회
		List<FestivalDTO> list = dao.getFestivalList(map); 
		System.out.println("전체 데이터 수: " + (list != null ? list.size() : 0));
		
		//Model에 담아서 jsp로 전달
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("status", status);
		model.addAttribute("keyword", keyword);
		model.addAttribute("sortType", sortType);
	}

	// 축제 상세 정보 조회
	@Override
	public void getFestivalDetail(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdPlaceServiceImpl - getFestivalDetail()]");
	}

	// 축제 정보 수정
	@Override
	public void modifyFestival(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdPlaceServiceImpl - modifyFestival()]");
	}

	// 신규 축제 등록
	@Override
	public void insertFestival(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdPlaceServiceImpl - insertFestival()]");
	}
	
	// 축제 정보 삭제 
	@Override
	public void deleteFestival(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdPlaceServiceImpl - deleteFestival()]");
	}

}
