package spring.ict06team1.midpj.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;

public interface ReservationService {
	
	// 1. 축제 예약 페이지용 데이터 조회
	// 축제 정보 + 장소 정보 + 티켓 목록을 묶어서 가져올 때 사용
	public FestivalDTO getFestivalTickets(int place_id);
	
	// 2. 예약 + 결제 예정 정보 저장
	// 예약 정보를 저장하고, 결제 예정 데이터까지 함께 저장한 뒤 예약번호를 반환
	Map<String, Object> createReservation(HttpServletRequest request, HttpServletResponse response, Model model);
	
	// 3. 예약 1건 조회
	// 예약 확인 페이지나 결제 승인 처리 시 필요한 예약 1건 조회
	ReservationDTO getReservationById(String reservation_id);
	
	// 4. 네이버페이 승인 처리
	// 네이버페이 paymentId로 승인 API를 호출하고 성공 시 DB 상태를 변경
	Map<String, Object> approveNaverPay(String paymentId, String reservationId);
	
	List<Map<String, Object>> getRestTimeReservationCount(int place_id, String visit_date);

	int countRestReservationByDateTime(int place_id, String visit_date, String visit_time);
}