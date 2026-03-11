package spring.ict06team1.midpj.service;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.AdFestivalDAO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.page.Paging;

@Service
public class AdFestivalServiceImpl implements AdFestivalService{

	@Autowired
	private AdFestivalDAO dao; 
	
	// 축제 목록 조회
	@Override
	public void getFestivalList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdFestivalServiceImpl - getFestivalList()]");
		
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
		System.out.println("[AdFestivalServiceImpl - getFestivalDetail()]");
		
	}

	// 축제 정보 수정
	@Override
	public void modifyFestival(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdFestivalServiceImpl - modifyFestival()]");
	}

	// 신규 축제 등록
	@Override
	public void insertFestival(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdFestivalServiceImpl - insertFestival()]");
		
		// 1) parameter값 수집(검색어, 예약상태) TODO: 상황에 맞게 수정 
		String name = request.getParameter("name");
		String address = request.getParameter("address");
		double latitude = Double.parseDouble(request.getParameter("latitude"));
		double longitude = Double.parseDouble(request.getParameter("longitude"));
		String image_url = request.getParameter("image_url");
		String description = request.getParameter("description");
		Date start_date = Date.valueOf(request.getParameter("start_date")) ;
		Date end_date = Date.valueOf(request.getParameter("end_date"));
		
		// PlaceDTO에 담기 - 장소 유형별 공통 정보
		PlaceDTO plDto = new PlaceDTO(); 
		plDto.setName(name);
		plDto.setAddress(address);
		plDto.setLatitude(latitude);
		plDto.setLongitude(longitude);
		plDto.setImage_url(image_url);
		
		// FestivalDTO에 담기
		FestivalDTO dto = new FestivalDTO();
		dto.setPlaceDTO(plDto);
		dto.setDescription(description);
		dto.setStart_date(start_date);
		dto.setEnd_date(end_date);
		
		// DAO 호출하여 DB에 데이터 추가 시도  
		int insertCntPlace = dao.insertPlace(plDto);
		
		// Place 테이블에 먼저 추가 시도하여 성공 시 
		if(insertCntPlace > 0) {
			int insertCnt = dao.insertFestival(dto);
			
			//Model에 담아서 jsp로 전달
			model.addAttribute("insertCnt", insertCnt); 
		} 
		// Place 테이블에 추가 실패 시 
		else {
			//Model에 담아서 jsp로 전달
			model.addAttribute("insertCnt", 0); 
		}
		
		
	}
	
	// 축제 정보 삭제 
	@Override
	public void deleteFestival(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdFestivalServiceImpl - deleteFestival()]");
	}
}
