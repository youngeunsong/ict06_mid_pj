package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.ReservationDTO;

@Repository
public class AdminDAOImpl implements AdminDAO {

	@Autowired
	private SqlSession sqlSession;
	
	//namespace 경로 상수로 선언
	private static final String namespace = "spring.ict06team1.midpj.dao.AdminDAO.";

	@Override
	public List<ReservationDTO> getReservationList(Map<String, Object> map) {
		System.out.println("[AdminDAOImpl - getReservationList()]");
		//AdminDAO dao = sqlSession.getMapper(AdminDAO.class);
		//List<ReservationDTO> list = dao.getReservationList(map);
		//return list;
		return sqlSession.getMapper(AdminDAO.class).getReservationList(map);
	}

	@Override
	public ReservationDTO getReservationDetail(String reservation_id) {
		System.out.println("[AdminDAOImpl - getReservationDetail()]");
		
		return sqlSession.getMapper(AdminDAO.class).getReservationDetail(reservation_id);
	}

	@Override
	public int modifyReservationStatus(ReservationDTO dto) {
		System.out.println("[AdminDAOImpl - getReservationDetail()]");
		
		return sqlSession.getMapper(AdminDAO.class).modifyReservationStatus(dto);
	}

	@Override
	public Map<String, Object> getReservationStatistics() {
		return sqlSession.selectOne(namespace + "getReservationStatistics");
	}
}
