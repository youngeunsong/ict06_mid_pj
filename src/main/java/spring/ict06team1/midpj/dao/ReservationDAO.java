package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;

public interface ReservationDAO {
	
	// 1. 축제 상세 정보 조회
	// 축제 예약 페이지에 필요한 축제 기본 정보를 가져올 때 사용
	FestivalDTO getFestivalDetail(int festival_id);
	
	// 2. 장소 정보 조회
	// 축제와 연결된 place 정보(이름, 주소 등)를 가져올 때 사용
	PlaceDTO getPlaceDetail(int place_id);
	
	// 3. 티켓 목록 조회
	// 해당 축제에서 판매 중인 티켓 목록을 가져올 때 사용
	List<FestivalTicketDTO> getFestivalTickets(int festival_id);
	
	// 4. 티켓 가격 조회
	// 예약 시 선택한 티켓의 가격을 조회할 때 사용
	int getTicketPrice(int ticket_id);
	
	// 5. 예약 저장
	// 예약 기본 정보를 RESERVATION 테이블에 저장할 때 사용
	int insertReservation(ReservationDTO dto);
	
	// 6. 결제 정보 저장
	// 예약 생성 직후 결제 예정 금액과 결제 수단을 PAYMENT 테이블에 저장할 때 사용
	int insertPayment(Map<String, Object> map);
	
	// 7. 예약 1건 조회
	// 예약 확인 페이지나 결제 승인 처리 시 예약 1건을 조회할 때 사용
	ReservationDTO getReservationById(String reservation_id);
	
	// 8. 결제 상태 변경
	// 네이버페이 승인 성공 후 PAYMENT.payment_status를 변경할 때 사용
	int updatePaymentStatusPaid(String reservationId);
	
	// 9. 예약 상태 변경
	// 결제 승인 성공 후 RESERVATION.status를 변경할 때 사용
	int updateReservationStatusConfirmed(String reservationId);
}