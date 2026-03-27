package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

@Repository
public class ReservationDAOImpl implements ReservationDAO {

	@Autowired
	private SqlSession sqlSession;

	// 1. 장소 정보 조회
	// mapper의 getPlaceDetail 쿼리를 실행
	@Override
	public PlaceDTO getPlaceDetail(int place_id) {
		System.out.println("[ReservationDAOImpl - getPlaceDetail()]");
		return sqlSession.getMapper(ReservationDAO.class).getPlaceDetail(place_id);
	}

	// 2-1. 축제 상세 정보 조회
	// mapper의 getFestivalDetail 쿼리를 실행
	@Override
	public FestivalDTO getFestivalDetail(int festival_id) {
		System.out.println("[ReservationDAOImpl - getFestivalDetail()]");
		return sqlSession.getMapper(ReservationDAO.class).getFestivalDetail(festival_id);
	}

	// 2-2. 숙소 상세 정보 조회
	// mapper의 getAccommodationDetail 쿼리를 실행
	@Override
	public AccommodationDTO getAccommodationDetail(int accommodation_id) {
		System.out.println("[ReservationDAOImpl - getAccommodationDetail()]");
		return sqlSession.getMapper(ReservationDAO.class).getAccommodationDetail(accommodation_id);
	}

	// 2-3. 맛집 상세 정보 조회
	// mapper의 getRestaurantDetail 쿼리를 실행
	@Override
	public RestaurantDTO getRestaurantDetail(int restaurant_id) {
		System.out.println("[ReservationDAOImpl - getRestaurantDetail()]");
		return sqlSession.getMapper(ReservationDAO.class).getRestaurantDetail(restaurant_id);
	}

	// 3. 축제 티켓 목록 조회
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

	// 5. 숙소 가격 조회
	// 예약 시 선택한 숙소의 가격을 조회할 때 사용
	@Override
	public int getAccommodationPrice(int place_id) {
		System.out.println("[ReservationDAOImpl - getAccommodationPrice()]");
		return sqlSession.getMapper(ReservationDAO.class).getAccommodationPrice(place_id);
	}

	// 6-1. 축제 예약 저장
	// 축제 예약 데이터를 RESERVATION 테이블에 insert
	@Override
	public int insertFestReservation(ReservationDTO dto) {
		System.out.println("[ReservationDAOImpl - insertFestReservation()]");
		return sqlSession.getMapper(ReservationDAO.class).insertFestReservation(dto);
	}

	// 6-2. 숙소 예약 저장
	// 숙소 예약 데이터를 RESERVATION 테이블에 insert
	@Override
	public int insertAccReservation(ReservationDTO dto) {
		System.out.println("[ReservationDAOImpl - insertAccReservation()]");
		return sqlSession.getMapper(ReservationDAO.class).insertAccReservation(dto);
	}

	// 6-3. 맛집 예약 저장
	// 맛집 예약 데이터를 RESERVATION 테이블에 insert
	@Override
	public int insertRestReservation(ReservationDTO dto) {
		System.out.println("[ReservationDAOImpl - insertRestReservation()]");
		return sqlSession.getMapper(ReservationDAO.class).insertRestReservation(dto);
	}

	// 7. 결제 정보 저장
	// 결제 예정 데이터를 PAYMENT 테이블에 insert
	@Override
	public int insertPayment(Map<String, Object> map) {
		System.out.println("[ReservationDAOImpl - insertPayment()]");
		return sqlSession.getMapper(ReservationDAO.class).insertPayment(map);
	}

	// 8. 예약 1건 조회
	// 예약 확인 페이지용 예약 1건 조회
	@Override
	public ReservationDTO getReservationById(String reservation_id) {
		System.out.println("[ReservationDAOImpl - getReservationById()]");
		return sqlSession.getMapper(ReservationDAO.class).getReservationById(reservation_id);
	}

	// 9. 결제 상태 변경
	// reservation_id 기준으로 PAYMENT.payment_status를 변경
	@Override
	public int updatePaymentStatusPaid(String reservationId) {
		return sqlSession.update("spring.ict06team1.midpj.dao.ReservationDAO.updatePaymentStatusPaid", reservationId);
	}

	// 10. 예약 상태 변경
	// reservation_id 기준으로 RESERVATION.status를 변경
	@Override
	public int updateReservationStatusConfirmed(String reservationId) {
		return sqlSession.update("spring.ict06team1.midpj.dao.ReservationDAO.updateReservationStatusConfirmed",
				reservationId);
	}
	
	@Override
	public List<Map<String, Object>> getRestTimeReservationCount(Map<String, Object> map) {
	    return sqlSession.getMapper(ReservationDAO.class).getRestTimeReservationCount(map);
	}

	@Override
	public int countRestReservationByDateTime(Map<String, Object> map) {
	    return sqlSession.getMapper(ReservationDAO.class).countRestReservationByDateTime(map);
	}

}