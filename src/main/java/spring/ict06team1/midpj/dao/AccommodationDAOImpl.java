package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.AccommodationDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

@Repository
public class AccommodationDAOImpl implements AccommodationDAO {
	
	@Autowired
	private SqlSession sqlSession;

	//숙소 상세
	//1단계: Place, Review 함께 조회
	@Override
	public PlaceDTO selectPlaceDetail(int place_id) {
		System.out.println("[AccommodationDAOImpl - selectPlaceDetail()]");
		return sqlSession.getMapper(AccommodationDAO.class).selectPlaceDetail(place_id);
	}

	//2단계: AccommodationDTO 조회
	@Override
	public AccommodationDTO getAccommodationDetail(int accommodation_id) {
		System.out.println("[AccommodationDAOImpl - getAccommodationDetail()]");
		return sqlSession.getMapper(AccommodationDAO.class).getAccommodationDetail(accommodation_id);
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
		return sqlSession.getMapper(AccommodationDAO.class).getReviewsPaged(map);
	}

	//리뷰 총 개수
	@Override
	public int getReviewCount(int place_id) {
		System.out.println("[AccommodationDAOImpl - getReviewCount()]");
		return sqlSession.getMapper(AccommodationDAO.class).getReviewCount(place_id);
	}

	//즐겨찾기 여부 확인
	@Override
	public int isFavorite(Map<String, Object> map) {
		System.out.println("[AccommodationDAOImpl - isFavorite()]");
		return sqlSession.getMapper(AccommodationDAO.class).isFavorite(map);
	}

	// 즐겨찾기 추가
	@Override
	public int insertFavorite(Map<String, Object> map) {
		System.out.println("[AccommodationDAOImpl - insertFavorite()]");
		return sqlSession.getMapper(AccommodationDAO.class).insertFavorite(map);
	}

	// 즐겨찾기 삭제
	@Override
	public int deleteFavorite(Map<String, Object> map) {
		System.out.println("[AccommodationDAOImpl - deleteFavorite()]");
		return sqlSession.getMapper(AccommodationDAO.class).deleteFavorite(map);
	}

	// 숙소 총 갯수
	@Override
	public int getAccommodationCount() {
		System.out.println("[AccommodationDAOImpl - getAccommodationCount()]");
		return sqlSession.getMapper(AccommodationDAO.class).getAccommodationCount();
	}

	// 숙소 페이지 리스트
	@Override
	public List<AccommodationDTO> getAccommodationPageList(Map<String, Object> map) {
		System.out.println("[AccommodationDAOImpl - getAccommodationPageList()]");
		return sqlSession.getMapper(AccommodationDAO.class).getAccommodationPageList(map);
	}
}
