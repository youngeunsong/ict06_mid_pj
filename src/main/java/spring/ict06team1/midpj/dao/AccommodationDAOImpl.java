package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
/*
 * @author 김다솜, 송영은
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: RestaurantsDAOImpl
 * 변경사항: 
 * v260324
 * (김다솜) : 예약 관련 메서드 구현  
 * (송영은): 숙소 랭킹 관련 메서드 구현
*/
@Repository
public class AccommodationDAOImpl implements AccommodationDAO {

	@Autowired
    private SqlSession session;
	
	// [MyBatis Mapper namespace]
    // PlaceMapper.xml에 정의된 SQL id와 연결할 때 공통 prefix로 사용
    private static final String NAMESPACE = "AccommodationMapper.";
    
    // 예약 기능 구현 시 필요 메서드 -----------------------------------------------------
    //숙소 상세
  	//1단계: Place, Review 함께 조회
  	@Override
  	public PlaceDTO selectPlaceDetail(int place_id) {
  		System.out.println("[AccommodationDAOImpl - selectPlaceDetail()]");
  		return session.getMapper(AccommodationDAO.class).selectPlaceDetail(place_id);
  	}

  	//2단계: AccommodationDTO 조회
  	@Override
  	public AccommodationDTO getAccommodationDetail(int accommodation_id) {
  		System.out.println("[AccommodationDAOImpl - getAccommodationDetail()]");
  		return session.getMapper(AccommodationDAO.class).getAccommodationDetail(accommodation_id);
  	}

  	//조회수 증가
  	@Override
  	public void increaseViewCount(int place_id) {
  		System.out.println("[AccommodationDAOImpl - increaseViewCount()]");
  	}

  	//리뷰 페이징
  	@Override
  	public List<ReviewDTO> getReviewsPaged(Map<String, Object> map) {
  		System.out.println("[AccommodationDAOImpl - getReviewsPaged()]");
  		return session.getMapper(AccommodationDAO.class).getReviewsPaged(map);
  	}

  	//리뷰 총 개수
  	@Override
  	public int getReviewCount(int place_id) {
  		System.out.println("[AccommodationDAOImpl - getReviewCount()]");
  		return session.getMapper(AccommodationDAO.class).getReviewCount(place_id);
  	}

  	//즐겨찾기 여부 확인
  	@Override
  	public int isFavorite(Map<String, Object> map) {
  		System.out.println("[AccommodationDAOImpl - isFavorite()]");
  		return session.getMapper(AccommodationDAO.class).isFavorite(map);
  	}

  	// 즐겨찾기 추가
  	@Override
  	public int insertFavorite(Map<String, Object> map) {
  		System.out.println("[AccommodationDAOImpl - insertFavorite()]");
  		return session.getMapper(AccommodationDAO.class).insertFavorite(map);
  	}

  	// 즐겨찾기 삭제
  	@Override
  	public int deleteFavorite(Map<String, Object> map) {
  		System.out.println("[AccommodationDAOImpl - deleteFavorite()]");
  		return session.getMapper(AccommodationDAO.class).deleteFavorite(map);
  	}

  	// 숙소 총 갯수
  	@Override
  	public int getAccommodationCount() {
  		System.out.println("[AccommodationDAOImpl - getAccommodationCount()]");
  		return session.getMapper(AccommodationDAO.class).getAccommodationCount();
  	}

  	// 숙소 페이지 리스트
  	@Override
  	public List<AccommodationDTO> getAccommodationPageList(Map<String, Object> map) {
  		System.out.println("[AccommodationDAOImpl - getAccommodationPageList()]");
  		return session.getMapper(AccommodationDAO.class).getAccommodationPageList(map);
  	}
  	
  	// [랭킹용 메서드] -------------------------------------------------------
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
