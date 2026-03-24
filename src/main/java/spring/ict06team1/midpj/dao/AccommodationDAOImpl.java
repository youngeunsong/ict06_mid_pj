package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.AccommodationDTO;
/*
 * @author 송영은
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: RestaurantsDAOImpl
 * 변경사항: 
 * v260324: 숙소 랭킹 관련 메서드 구현
*/
@Repository
public class AccommodationDAOImpl implements AccommodationDAO {

	@Autowired
    private SqlSession session;
	
	// [MyBatis Mapper namespace]
    // PlaceMapper.xml에 정의된 SQL id와 연결할 때 공통 prefix로 사용
    private static final String NAMESPACE = "AccommodationMapper.";
	
	// 숙소 랭킹 목록 조회
	@Override
	public List<AccommodationDTO> getBestAccommodationList() {
		System.out.println("AccommodationDAOImpl - getBestAccommodationList()");
		return session.selectList(NAMESPACE + "getBestAccommodationList"); // 숙소 랭킹 전체 목록 조회용
	}

	// 별점 평균
	@Override
	public double getAvgRating(int place_id) {
		System.out.println("AccommodationDAOImpl - getAvgRating()");
		Double result = session.selectOne(NAMESPACE + "getAvgRating", place_id);
        return result == null ? 0.0 : result; // 평균 별점이 null일 경우 0.0으로 보정
	}

	// 숙소 총 갯수
	@Override
	public int getBestAccommodationCount(Map<String, Object> map) {
		System.out.println("AccommodationDAOImpl - getBestAccommodationCount()");
		return session.selectOne(NAMESPACE + "getBestAccommodationCount", map); // 지역 조건에 맞는 전체 맛집 수 조회
	}

	// 숙소 페이지 리스트
	@Override
	public List<AccommodationDTO> getBestAccommodationPageList(Map<String, Object> map) {
		System.out.println("AccommodationDAOImpl - getBestAccommodationPageList()");
		return session.selectList(NAMESPACE + "getBestAccommodationPageList", map); // 랭킹 기본 리스트 및 더보기 구간 조회
	}

	// 숙소 랭킹 top5
	@Override
	public List<AccommodationDTO> getBestAccommodationTop5(Map<String, Object> map) {
		System.out.println("AccommodationDAOImpl - getBestAccommodationTop5()");
		return session.selectList(NAMESPACE + "getBestAccommodationTop5", map); // 랭킹 상단 TOP5 조회
	}
	
}
