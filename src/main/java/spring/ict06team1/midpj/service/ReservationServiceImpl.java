package spring.ict06team1.midpj.service;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.AccommodationDAO;
import spring.ict06team1.midpj.dao.FestivalDAO;
import spring.ict06team1.midpj.dao.ReservationDAO;
import spring.ict06team1.midpj.dao.RestaurantDAO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;

@Service
public class ReservationServiceImpl implements ReservationService {

	@Autowired
	public ReservationDAO resDao;
	@Autowired
	public RestaurantDAO restDao;
	@Autowired
	public AccommodationDAO accDao;
	@Autowired
	public FestivalDAO festDao;

	//1. 축제 티켓 리스트 불러오기
	@Override
	public FestivalDTO getFestivalTickets(int place_id) {
		System.out.println("[ReservationServiceImpl - getFestival()]");
		
		//0단계: festival_id 찾기
		int festival_id = place_id;
		
		//장소, 축제 조회
		FestivalDTO festDto = resDao.getFestivalDetail(festival_id);
		PlaceDTO placeDto = resDao.getPlaceDetail(place_id);
		
		//티켓 리스트 조회
		List<FestivalTicketDTO> ticketList = resDao.getFestivalTickets(festival_id);
		
		festDto.setPlaceDTO(placeDto);
		festDto.setTicketList(ticketList);
		
		return festDto;
	}
	
	//2. 예약+결제 처리(Transaction)
	@Override
	@Transactional
	public void createReservation(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[ReservationServiceImpl - createReservation()]");
		
		ReservationDTO dto = new ReservationDTO();
		
		dto.setPlace_id(Integer.parseInt(request.getParameter("place_id")));
		dto.setTicket_id(Integer.parseInt(request.getParameter("ticket_id")));
		dto.setGuest_count(Integer.parseInt(request.getParameter("guest_count")));
		dto.setRequest_note(request.getParameter("request_note"));
		
		//날짜 변환
		dto.setCheck_in(Date.valueOf(request.getParameter("visit_date")));
		
		String user_id = (String)request.getSession().getAttribute("sessionID");
		dto.setUser_id(user_id);
		
		//유효성 체크
		if(user_id == null) {
			throw new RuntimeException("로그인한 회원만 예약할 수 있음");
		}
		
		if(dto.getGuest_count() <= 0) {
			throw new RuntimeException("인원 수 확인");
		}

		//1. 티켓 가격 조회
		int price = resDao.getTicketPrice(dto.getTicket_id());
		
		//총액 계산
		int totalAmount = price * dto.getGuest_count();
		if(totalAmount <= 0)
			throw new RuntimeException("결제 금액 오류");
		
		//2. 예약 처리
		resDao.insertReservation(dto);
		
		//결제 처리
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", dto.getUser_id());
		map.put("reservation_id", dto.getReservation_id());
		map.put("amount", totalAmount);
		//결제방법은 결제 담당자가 수정 바람!
		map.put("payment_method", "CARD");
		
		//결제 처리
		resDao.insertPayment(map);
		dto.setPayment_id((String)map.get("payment_id"));
		
		model.addAttribute("msg", "예약 완료");
	}

}
