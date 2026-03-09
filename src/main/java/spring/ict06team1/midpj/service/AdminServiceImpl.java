package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.AdminDAO;
import spring.ict06team1.midpj.dao.AdminDAOImpl;
import spring.ict06team1.midpj.dto.ReservationDTO;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	private AdminDAOImpl admindao;

	//1. 예약 조회
	//1-1. 예약목록 전체 조회, 검색/필터
	@Override
	public void getReservationList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminServiceImpl - getReservationList()]");
		//1) parameter값 수집(검색어, 예약상태)
		String keyword = request.getParameter("keyword");
		String status = request.getParameter("status");
		String placeType = request.getParameter("placeType");
		
		//2) DAO 호출
		//검색조건 담을 map 생성
		Map<String, Object> map = new HashMap<String, Object>();
        map.put("keyword", keyword);
        map.put("status", status);
        map.put("placeType", placeType);
		
		//전체 조회
		List<ReservationDTO> list = admindao.getReservationList(map);
		System.out.println("전체 데이터 수: " + (list != null ? list.size() : 0));
		
		//3) Model에 담아서 jsp로 전달
		model.addAttribute("list", list);
		model.addAttribute("status", status);
		model.addAttribute("placeType", placeType);
	}

	//1-2. 예약 상세페이지 조회
	@Override
	public void getReservationDetail(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminServiceImpl - getReservationDetail()]");
		
		String resId = request.getParameter("resId");
		ReservationDTO dto = admindao.getReservationDetail(resId);
		request.setAttribute("dto", dto);
	}

	//2. 예약 변경
	//2-1. 예약상태 변경
	@Override
	public void modifyReservationStatus(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminServiceImpl - getReservationDetail()]");
		
		String resId = request.getParameter("resId");
		String status = request.getParameter("status");
		ReservationDTO dto = new ReservationDTO();
		dto.setReservation_id(resId);
		dto.setStatus(status);
		
		int result = admindao.modifyReservationStatus(dto);
		
		request.setAttribute("result", result);
	}

	//2-2. 예약 취소
	@Override
	public void cancelReservation(HttpServletRequest request, HttpServletResponse response, Model model) {
		
	}

	//3. 통계
	//3-1. 대시보드(기간별 집계)
	@Override
	public void getReservationStatistics(HttpServletRequest request, HttpServletResponse response, Model model) {
		Map<String, Object> statistics = admindao.getReservationStatistics();
		model.addAttribute("statistics", statistics);
	}
}
