package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;

@Repository
public class ReservationDAOImpl implements ReservationDAO {

	@Autowired
	private SqlSession sqlSession;

	// 1. 축제 상세 정보 조회
	// mapper의 getFestivalDetail 쿼리를 실행
	@Override
	public FestivalDTO getFestivalDetail(int festival_id) {
		System.out.println("[ReservationDAOImpl - getFestivalDetail()]");
		return sqlSession.getMapper(ReservationDAO.class).getFestivalDetail(festival_id);
	}

	// 2. 장소 정보 조회
	// mapper의 getPlaceDetail 쿼리를 실행
	@Override
	public PlaceDTO getPlaceDetail(int place_id) {
		System.out.println("[ReservationDAOImpl - getPlaceDetail()]");
		return sqlSession.getMapper(ReservationDAO.class).getPlaceDetail(place_id);
	}

	// 3. 티켓 목록 조회
	// mapper의 getFestivalTickets 쿼리를 실행
	@Override
	public List<FestivalTicketDTO> getFestivalTickets(int festival_id) {
		System.out.println("[ReservationDAOImpl - getFestivalTickets()]");
		return sqlSession.getMapper(ReservationDAO.class).getFestivalTickets(festival_id);
	}
	
	// 4. 티켓 가격 조회
	// 예약 총액 계산 전에 선택한 티켓 가격을 가져옴
	@Override
	public int getTicketPrice(int ticket_id) {
		System.out.println("[ReservationDAOImpl - getTicketPrice()]");
		return sqlSession.getMapper(ReservationDAO.class).getTicketPrice(ticket_id);
	}

	// 5. 예약 저장
	// 예약 데이터를 RESERVATION 테이블에 insert
	@Override
	public int insertReservation(ReservationDTO dto) {
		System.out.println("[ReservationDAOImpl - insertReservation()]");
		return sqlSession.getMapper(ReservationDAO.class).insertReservation(dto);
	}

	// 6. 결제 정보 저장
	// 결제 예정 데이터를 PAYMENT 테이블에 insert
	@Override
	public int insertPayment(Map<String, Object> map) {
		System.out.println("[ReservationDAOImpl - insertPayment()]");
		return sqlSession.getMapper(ReservationDAO.class).insertPayment(map);
	}
	
	// 7. 예약 1건 조회
	// 예약 확인 페이지용 예약 1건 조회
	@Override
	public ReservationDTO getReservationById(String reservation_id) {
		System.out.println("[ReservationDAOImpl - getReservationById()]");
		return sqlSession.getMapper(ReservationDAO.class).getReservationById(reservation_id);
	}
	
	// 8. 결제 상태 변경
	// reservation_id 기준으로 PAYMENT.payment_status를 변경
	@Override
	public int updatePaymentStatusPaid(String reservationId) {
	    return sqlSession.update(
	        "spring.ict06team1.midpj.dao.ReservationDAO.updatePaymentStatusPaid",
	        reservationId
	    );
	}

	// 9. 예약 상태 변경
	// reservation_id 기준으로 RESERVATION.status를 변경
	@Override
	public int updateReservationStatusConfirmed(String reservationId) {
	    return sqlSession.update(
	        "spring.ict06team1.midpj.dao.ReservationDAO.updateReservationStatusConfirmed",
	        reservationId
	    );
	}
}