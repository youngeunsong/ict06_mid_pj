package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;

@Repository
public class AdFestivalDAOImpl implements AdFestivalDAO{

	@Autowired
	private SqlSession sqlSession;
	
	// 축제 조회 ------------------------------
	// 축제 목록 조회
	@Override
	public List<FestivalDTO> getFestivalList(Map<String, Object> map) {
		System.out.println("[AdReservationDAOImpl - getFestivalList()]");
		return sqlSession.getMapper(AdFestivalDAO.class).getFestivalList(map);
	}

	// 축제 상세 정보 조회
	@Override
	public FestivalDTO getFestivalDetail(int festival_id) {
		System.out.println("[AdReservationDAOImpl - getFestivalDetail()]");
		return null;
	}

	// 전체 축제 건수 조회(페이징용)
	@Override
	public int getFestivalCount(Map<String, Object> map) {
		System.out.println("[AdReservationDAOImpl - getFestivalCount()]");	
		return sqlSession.getMapper(AdFestivalDAO.class).getFestivalCount(map);
	}

	// 축제 정보 수정
	@Override
	public int modifyFestival(FestivalDTO dto) {
		System.out.println("[AdReservationDAOImpl - modifyFestival()]");
		return 0;
	}
	
	// (1) 신규 장소 등록 
	@Override
	public int insertPlace(PlaceDTO dto) {
		System.out.println("[AdReservationDAOImpl - insertPlace()]");
		return sqlSession.getMapper(AdFestivalDAO.class).insertPlace(dto);
	}

	// (2) 신규 축제 등록
	@Override
	public int insertFestival(FestivalDTO dto) {
		System.out.println("[AdReservationDAOImpl - insertFestival()]");
		return sqlSession.getMapper(AdFestivalDAO.class).insertFestival(dto);
	}
	
	// (3) 신규 티켓 정보 등록
	@Override
	public int insertTicket(FestivalTicketDTO dto) {
		System.out.println("[AdReservationDAOImpl - insertTicket()]");
		return sqlSession.getMapper(AdFestivalDAO.class).insertTicket(dto);
	}
	
	// 축제 정보 삭제
	@Override
	public int deleteFestival(int festival_id) {
		System.out.println("[AdReservationDAOImpl - getFestivalList()]");
		return 0;
	}
}
