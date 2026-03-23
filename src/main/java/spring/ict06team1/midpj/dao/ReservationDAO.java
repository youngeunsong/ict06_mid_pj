package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;

public interface ReservationDAO {
	
	//1. festival 상세 정보
	FestivalDTO getFestivalDetail(int festival_id);
	
	//2. place 정보
	PlaceDTO getPlaceDetail(int place_id);
	
	//3. 티켓 리스트 조회
	List<FestivalTicketDTO> getFestivalTickets(int festival_id);
	
	//4. 티켓 가격 조회
	int getTicketPrice(int ticket_id);
	
	//5. 예약 처리
	int insertReservation(ReservationDTO dto);
	
	//6. 결제 처리
	int insertPayment(Map<String, Object> map);
}
