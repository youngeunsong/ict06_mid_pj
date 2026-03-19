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
		System.out.println("[AdFestivalDAOImpl - getFestivalList()]");
		return sqlSession.getMapper(AdFestivalDAO.class).getFestivalList(map);
	}

	// 축제 상세 정보 조회
	@Override
	public FestivalDTO getFestivalDetail(int festival_id) {
		System.out.println("[AdFestivalDAOImpl - getFestivalDetail()]");
		return sqlSession.getMapper(AdFestivalDAO.class).getFestivalDetail(festival_id);
	}
	
	// 티켓 상세 정보 조회
	@Override
	public List<FestivalTicketDTO> getFestivalTickets(int festival_id){
		System.out.println("[AdFestivalDAOImpl - getTicketDetail()]");
		return sqlSession.getMapper(AdFestivalDAO.class).getFestivalTickets(festival_id);
	}

	// 전체 축제 건수 조회(페이징용)
	@Override
	public int getFestivalCount(Map<String, Object> map) {
		System.out.println("[AdFestivalDAOImpl - getFestivalCount()]");	
		return sqlSession.getMapper(AdFestivalDAO.class).getFestivalCount(map);
	}

	// 축제 정보 수정 : 3단계
	// (1) 장소 수정
	@Override
	public int updatePlace(PlaceDTO dto) {
		System.out.println("[AdFestivalDAOImpl - updatePlace()]");	
		return sqlSession.getMapper(AdFestivalDAO.class).updatePlace(dto);
	}
	
	// (2) 축제 수정
	@Override
	public int modifyFestival(FestivalDTO dto) {
		System.out.println("[AdFestivalDAOImpl - modifyFestival()]");
		return sqlSession.getMapper(AdFestivalDAO.class).modifyFestival(dto);
	}
	
	// (3) 티켓 수정 
	@Override
	public int updateTicket(FestivalTicketDTO dto) {
		System.out.println("[AdFestivalDAOImpl - updateTicket()]");	
		return sqlSession.getMapper(AdFestivalDAO.class).updateTicket(dto);
	}
	
	// 신규 축제 등록: 3단계
	// (0) 기존 테이블에 있는 데이터인지 확인
	@Override
	public Integer checkDuplication(FestivalDTO dto) {
		System.out.println("[AdFestivalDAOImpl - updateTicket()]");	
		return sqlSession.getMapper(AdFestivalDAO.class).checkDuplication(dto);
	}
	
	// 신규 축제 등록: 3단계
	// (1) 신규 장소 등록 
	@Override
	public int insertPlace(PlaceDTO dto) {
		System.out.println("[AdFestivalDAOImpl - insertPlace()]");
		return sqlSession.getMapper(AdFestivalDAO.class).insertPlace(dto);
	}

	// (2) 신규 축제 등록
	@Override
	public int insertFestival(FestivalDTO dto) {
		System.out.println("[AdFestivalDAOImpl - insertFestival()]");
		return sqlSession.getMapper(AdFestivalDAO.class).insertFestival(dto);
	}
	
	// (3) 신규 티켓 정보 등록
	@Override
	public int insertTicket(FestivalTicketDTO dto) {
		System.out.println("[AdFestivalDAOImpl - insertTicket()]");
		return sqlSession.getMapper(AdFestivalDAO.class).insertTicket(dto);
	}
	
	// 축제 정보 삭제 - 2단계 
	// (1) 축제 티켓 정보 삭제
	@Override
	public int deleteFestivalTickets(int festival_id) {
		System.out.println("[AdFestivalDAOImpl - deleteFestivalTickets()]");
		return sqlSession.getMapper(AdFestivalDAO.class).deleteFestivalTickets(festival_id);
	}
	
	// (2) 축제 정보 삭제
	@Override
	public int deleteFestival(int festival_id) {
		System.out.println("[AdFestivalDAOImpl - deleteFestival()]");
		return sqlSession.getMapper(AdFestivalDAO.class).deleteFestival(festival_id);
	}

	// 공공축제 데이터 넣기
	@Override
	public void insertFestivalBatch(List<FestivalDTO> list) {
		for(FestivalDTO dto : list){
			PlaceDTO placeDTO = dto.getPlaceDTO();
			
			// 1단계: 신규 장소 등록
			sqlSession.getMapper(AdFestivalDAO.class).insertPlace(placeDTO);
			
			// 2단계: 신규 축제 등록
			sqlSession.getMapper(AdFestivalDAO.class).insertFestival(dto);
	    }
	}
}
