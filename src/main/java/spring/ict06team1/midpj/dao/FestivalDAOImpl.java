package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
/*
 * @author 송영은
 * 최초작성일: 2026-03-17
 * 최종수정일: 2026-03-19
 * 참고 코드: RestaurantDAOImpl
 * ----------------------------------
 * v260319
 * 랭킹 기능 구현을 위한 메써드 추가 (getBestFestivalCount, getBestFestivalList, getBestFestivalPageList, getBestFestivalTop5)
 * ----------------------------------
 */
@Repository
public class FestivalDAOImpl implements FestivalDAO {
	
	@Autowired
	private SqlSession session;
	
	private static final String NAMESPACE = "FestivalMapper.";

	// 축제 지도 페이지용 메서드 ---------------------------------------
	// 주변 맛집의 총 개수를 조회 (페이징 계산용)
	@Override
	public int selectNearbyFestivalCount(Map<String, Object> map) {
		System.out.println("FestivalDAOImpl-selectNearbyFestivalCount()");
		return session.selectOne(NAMESPACE + "selectNearbyFestivalCount");
	}
	
	// 조건에 맞는 맛집 리스트 조회 (6개씩 끊어서 가져오기)
	@Override
	public List<FestivalDTO> selectNearbyFestivalList(Map<String, Object> map) {
		System.out.println("FestivalDAOImpl-selectNearbyFestivalList()");
		return session.selectList(NAMESPACE + "selectNearbyFestivalList");
	}

	// 조건에 맞는 맛집 마커 불러오기 (전부 가져오기)
	@Override
	public List<FestivalDTO> selectNearbyFeMarkersAjax(Map<String, Object> map) {
		System.out.println("FestivalDAOImpl-selectNearbyFeMarkersAjax()");
		return session.selectList(NAMESPACE + "selectNearbyFeMarkersAjax");
	}
	
	// 축제 상세 페이지용 메서드 ---------------------------------------
	// 축제 상세
	// 1단계: Place, Review 함께 조회
	@Override
	public PlaceDTO selectPlaceDetail(int place_id) {
		System.out.println("FestivalDAOImpl-selectPlaceDetail()");
		return session.selectOne(NAMESPACE + "selectPlaceDetail", place_id);
	}
	
	// 2단계: FestivalDTO 조회
	@Override
	public FestivalDTO getFestivalDetail(int festival_id) {
		System.out.println("FestivalDAOImpl-getFestivalDetail()");
		return session.selectOne(NAMESPACE + "getFestivalDetail", festival_id);
	}

	// 3단계: FestivalTicketDTO 조회
	@Override
	public List<FestivalTicketDTO> getFestivalTickets(int festival_id) {
		System.out.println("FestivalDAOImpl-getFestivalTickets()");
		return session.selectList(NAMESPACE + "getFestivalTickets", festival_id);
	}

	// 조회수 증가
	@Override
	public void increaseViewCount(int place_id) {
		System.out.println("FestivalDAOImpl-increaseViewCount()");
		session.update(NAMESPACE + "increaseViewCount", place_id);
	}

	// 리뷰 페이징
	@Override
	public List<ReviewDTO> getReviewsPaged(Map<String, Object> map) {
		System.out.println("FestivalDAOImpl-getReviewsPaged()");
		return session.selectList(NAMESPACE + "selectReviewsPaged", map);
	}

	// 리뷰 총 개수
	@Override
	public int getReviewCount(int place_id) {
		System.out.println("FestivalDAOImpl-getReviewCount()");
		return session.selectOne(NAMESPACE + "getReviewCount", place_id);
	}

	// 즐겨찾기 여부 확인
	@Override
	public int isFavorite(Map<String, Object> map) {
		System.out.println("FestivalDAOImpl-isFavorite()");
		return session.selectOne(NAMESPACE + "isFavorite", map);
	}

	// 즐겨찾기 추가
	@Override
	public int insertFavorite(Map<String, Object> map) {
		System.out.println("FestivalDAOImpl-insertFavorite()");
		return session.insert(NAMESPACE + "insertFavorite", map);
	}

	// 즐겨찾기 삭제
	@Override
	public int deleteFavorite(Map<String, Object> map) {
		System.out.println("FestivalDAOImpl-deleteFavorite()");
		return session.delete(NAMESPACE + "deleteFavorite", map);
	}

	// 축제 랭킹 페이지용 메서드 ---------------------------------------
	// 축제 랭킹 목록 조회
	@Override
	public List<FestivalDTO> getBestFestivalList() {
		System.out.println("FestivalDAOImpl-getBestFestivalList()");
		// return session.selectList(NAMESPACE + "getBestFestivalList");
		return null; 
	}

	// 축제 총 갯수
	@Override
	public int getBestFestivalCount() {
		System.out.println("FestivalDAOImpl-getBestFestivalCount()");
		return session.selectOne(NAMESPACE + "getBestFestivalCount");
	}

	// 축제 페이지 리스트
	@Override
	public List<FestivalDTO> getBestFestivalPageList(Map<String, Object> map) {
		System.out.println("FestivalDAOImpl-getBestFestivalPageList()");
		return session.selectList(NAMESPACE + "getBestFestivalPageList", map);
	}

	// 축제 랭킹 top5
	@Override
	public List<FestivalDTO> getBestFestivalTop5() {
		System.out.println("FestivalDAOImpl-getBestFestivalTop5()");
		return session.selectList(NAMESPACE + "getBestFestivalTop5");
	}





}
