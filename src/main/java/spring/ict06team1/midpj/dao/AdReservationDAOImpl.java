package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.ReservationDTO;

@Repository
public class AdReservationDAOImpl implements AdReservationDAO {

	@Autowired
	private SqlSession sqlSession;
	
	//namespace 경로 상수로 선언
	private static final String namespace = "spring.ict06team1.midpj.dao.AdReservationDAO.";

	//1. 예약 조회
	//1-1. 예약목록 전체 조회, 검색/필터
	@Override
	public List<ReservationDTO> getReservationList(Map<String, Object> map) {
		System.out.println("[AdReservationDAOImpl - getReservationList()]");
		//AdReservationDAO dao = sqlSession.getMapper(AdReservationDAO.class);
		//List<ReservationDTO> list = dao.getReservationList(map);
		//return list;
		return sqlSession.getMapper(AdReservationDAO.class).getReservationList(map);
	}

	//1-2. 예약 상세페이지 조회
	@Override
	public ReservationDTO getReservationDetail(String reservation_id) {
		System.out.println("[AdReservationDAOImpl - getReservationDetail()]");
		
		return sqlSession.getMapper(AdReservationDAO.class).getReservationDetail(reservation_id);
	}

	//1-3. 전체 예약건수 조회(페이징용)
	@Override
	public int getReservationCount(Map<String, Object> map) {
		System.out.println("[AdReservationDAOImpl - getReservationCount()]");
		return sqlSession.getMapper(AdReservationDAO.class).getReservationCount(map);
	}
	
	//2. 예약 변경
	//2-1. 예약 수정
	@Override
	public int modifyReservation(ReservationDTO dto) {
		System.out.println("[AdReservationDAOImpl - getReservationDetail()]");
		
		return sqlSession.getMapper(AdReservationDAO.class).modifyReservation(dto);
	}

	//2-2. 예약 취소
	@Override
	public int cancelReservation(String reservation_id) {
		System.out.println("[AdReservationDAOImpl - cancelReservation()]");
		
		return sqlSession.getMapper(AdReservationDAO.class).cancelReservation(reservation_id);
	}
	
	//3. 통계
	//3-1. KPI(기간별 집계)
	@Override
	public Map<String, Object> getDashboardKPI() {
		// TODO Auto-generated method stub
		return sqlSession.getMapper(AdReservationDAO.class).getDashboardKPI();
	}

	//3-2. 월별 예약 추이(최근 6개월)
	@Override
	public List<Map<String, Object>> getMonthlyTrend() {
		// TODO Auto-generated method stub
		return sqlSession.getMapper(AdReservationDAO.class).getMonthlyTrend();
	}

	//3-3. 예약 상태별 비율
	@Override
	public List<Map<String, Object>> getStatusRatio() {
		// TODO Auto-generated method stub
		return sqlSession.getMapper(AdReservationDAO.class).getStatusRatio();
	}

	//3-4. 장소 분류별 비율
	@Override
	public List<Map<String, Object>> getPlaceTypeRatio() {
		// TODO Auto-generated method stub
		return sqlSession.getMapper(AdReservationDAO.class).getPlaceTypeRatio();
	}

	//3-5. 요일별 예약 분포
	@Override
	public List<Map<String, Object>> getDayOfWeekStats() {
		// TODO Auto-generated method stub
		return sqlSession.getMapper(AdReservationDAO.class).getDayOfWeekStats();
	}

	//3-6. 미처리(PENDING) 목록
	@Override
	public List<ReservationDTO> getPendingList() {
		// TODO Auto-generated method stub
		return sqlSession.getMapper(AdReservationDAO.class).getPendingList();
	}

	//3-7. 최근 예약 5건
	@Override
	public List<ReservationDTO> getRecentReservations() {
		// TODO Auto-generated method stub
		return sqlSession.getMapper(AdReservationDAO.class).getRecentReservations();
	}

}
