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

	//2. festival 상세 정보
	@Override
	public FestivalDTO getFestivalDetail(int festival_id) {
		System.out.println("[ReservationDAOImpl - getFestivalDetail()]");
		return sqlSession.getMapper(ReservationDAO.class).getFestivalDetail(festival_id);
	}

	//3. place 정보
	@Override
	public PlaceDTO getPlaceDetail(int place_id) {
		System.out.println("[ReservationDAOImpl - getPlaceDetail()]");
		return sqlSession.getMapper(ReservationDAO.class).getPlaceDetail(place_id);
	}

	//4. 티켓 리스트 조회
	@Override
	public List<FestivalTicketDTO> getFestivalTickets(int festival_id) {
		System.out.println("[ReservationDAOImpl - getFestivalTickets()]");
		return sqlSession.getMapper(ReservationDAO.class).getFestivalTickets(festival_id);
	}
	
	//5. 티켓 가격 조회
	@Override
	public int getTicketPrice(int ticket_id) {
		System.out.println("[ReservationDAOImpl - getTicketPrice()]");
		return sqlSession.getMapper(ReservationDAO.class).getTicketPrice(ticket_id);
	}

	//6. 예약 처리
	@Override
	public int insertReservation(ReservationDTO dto) {
		System.out.println("[ReservationDAOImpl - insertReservation()]");
		return sqlSession.getMapper(ReservationDAO.class).insertReservation(dto);
	}

	//7. 결제 처리
	@Override
	public int insertPayment(Map<String, Object> map) {
		System.out.println("[ReservationDAOImpl - insertPayment()]");
		return sqlSession.getMapper(ReservationDAO.class).insertPayment(map);
	}

}
