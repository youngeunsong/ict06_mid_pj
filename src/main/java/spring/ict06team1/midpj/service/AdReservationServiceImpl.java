package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.SearchCriteria.Paging;
import spring.ict06team1.midpj.dao.AdReservationDAOImpl;
import spring.ict06team1.midpj.dto.ReservationDTO;

@Service
public class AdReservationServiceImpl implements AdReservationService {

	@Autowired
	private AdReservationDAOImpl adResDao;

	//1. 예약 조회
	//1-1. 예약목록 전체 조회, 검색/필터
	@Override
	public void getReservationList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminServiceImpl - getReservationList()]");
		//1) parameter값 수집(검색어, 예약상태)
		String keyword = request.getParameter("keyword");
		String status = request.getParameter("status");
		String placeType = request.getParameter("placeType");
		String pageNum = request.getParameter("pageNum");
		String sortType = request.getParameter("sortType");
		
		//페이징 객체 생성
		Paging paging = new Paging(pageNum);
		
		//검색조건 담을 map 생성
		Map<String, Object> map = new HashMap<String, Object>();
        map.put("keyword", keyword);
        map.put("status", status);
        map.put("placeType", placeType);
        map.put("sortType",sortType != null ? sortType : "created_at_desc");
        
        //전체 건수 조회
        int totalCount = adResDao.getReservationCount(map);
        paging.setTotalCount(totalCount);
        
        //페이징 범위 추가
        map.put("startRow", paging.getStartRow());
        map.put("endRow", paging.getEndRow());
        
        //목록 조회
		List<ReservationDTO> list = adResDao.getReservationList(map);
		System.out.println("전체 데이터 수: " + (list != null ? list.size() : 0));
		
		//Model에 담아서 jsp로 전달
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("status", status);
		model.addAttribute("placeType", placeType);
		model.addAttribute("keyword", keyword);
		model.addAttribute("sortType", sortType);
	}

	//1-2. 예약 상세페이지 조회
	@Override
	public void getReservationDetail(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminServiceImpl - getReservationDetail()]");
		
		String resId = request.getParameter("resId");
		ReservationDTO dto = adResDao.getReservationDetail(resId);
		request.setAttribute("dto", dto);
	}

	//2. 예약 변경
	//2-1. 예약 수정
	@Override
	public void modifyReservation(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminServiceImpl - getReservationDetail()]");
		
		String resId = request.getParameter("resId");
		String status = request.getParameter("status");
		String checkIn = request.getParameter("checkIn");
		String checkOut = request.getParameter("checkOut");
		String guestCount = request.getParameter("guestCount");
		String visitTime = request.getParameter("visitTime");
		String requestNote = request.getParameter("requestNote");
		
		ReservationDTO dto = new ReservationDTO();
		dto.setReservation_id(resId);
		dto.setStatus(status);
		dto.setRequest_note(requestNote);
		if(visitTime != null && !visitTime.isEmpty())
			dto.setVisit_time(visitTime);
		if(guestCount != null && !guestCount.isEmpty())
			dto.setGuest_count(Integer.parseInt(guestCount));
		if(checkIn != null && !checkIn.isEmpty())
			dto.setCheck_in(java.sql.Date.valueOf(checkIn));
		if(checkOut != null && !checkOut.isEmpty())
			dto.setCheck_out(java.sql.Date.valueOf(checkOut));
		
		int result = adResDao.modifyReservation(dto);
		
		request.setAttribute("result", result);
	}

	//2-2. 예약 취소
	@Override
	public void cancelReservation(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminServiceImpl - cancelReservation()]");
	}

	//3. 통계
	//3-1. 대시보드(기간별 집계)
	@Override
	public void getDashboard(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdminServiceImpl - getDashboard()]");
		
		//1. KPI
		Map<String, Object> kpi = adResDao.getDashboardKPI();
		model.addAttribute("kpi", kpi);
		
		//2. 월별 추이
		List<Map<String,Object>> monthlyTrend = adResDao.getMonthlyTrend();
		System.out.println("monthlyTrend: " + monthlyTrend);  // ← 추가
		model.addAttribute("monthlyTrend", monthlyTrend);
		
		//3. 예약 상태별 비율
		List<Map<String,Object>> statusRatio = adResDao.getStatusRatio();
		model.addAttribute("statusRatio", statusRatio);
		
		//4. 장소 분류별 비율
		List<Map<String,Object>> placeTypeRatio = adResDao.getPlaceTypeRatio();
		model.addAttribute("placeTypeRatio", placeTypeRatio);
		
		//5. 요일별 분포
		List<Map<String,Object>> dayOfWeekStats = adResDao.getDayOfWeekStats();
		model.addAttribute("dayOfWeekStats", dayOfWeekStats);
		
		//6. 미처리 목록(+페이징)
		//6-1. 페이지 사이즈 지정
		int pageSize = 5;
		String pageParam = request.getParameter("pendingPage");
		int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
		
		//6-2. 미처리 전체 건수 조회
		int totalCount = adResDao.getPendingCount();
		int totalPages = (int) Math.ceil((double) totalCount/pageSize);
		if(totalPages == 0) totalPages = 1;
		
		//6-3. DAO에 Map으로 전달
		Map<String, Object> map = new HashMap<>();
		map.put("startRow", (currentPage - 1) * pageSize + 1);
		map.put("endRow", currentPage * pageSize);
		
		//6-4. 데이터 조회 및 모델 전달
		model.addAttribute("pendingList", adResDao.getPendingListPage(map));
		model.addAttribute("pendingPage", currentPage);
		model.addAttribute("pendingTotalCount", adResDao.getPendingCount());
		model.addAttribute("pendingTotalPages", totalPages);
		
		//7. 최근 예약 5건
		List<ReservationDTO> recentList = adResDao.getRecentReservations();
		model.addAttribute("recentList", recentList);
		
		
	}
}
