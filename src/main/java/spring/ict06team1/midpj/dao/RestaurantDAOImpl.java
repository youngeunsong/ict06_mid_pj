package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

@Repository
public class RestaurantDAOImpl implements RestaurantDAO {

    @Autowired
    private SqlSession session;

    // [MyBatis Mapper namespace]
    // PlaceMapper.xml에 정의된 SQL id와 연결할 때 공통 prefix로 사용
    private static final String NAMESPACE = "PlaceMapper.";
    
    // 주변 맛집의 총 개수를 조회 (페이징 계산용)
    @Override
	public int selectNearbyRestaurantCount(Map<String, Object> map) {
    	int totalCount = session.selectOne("PlaceMapper.selectNearbyRestaurantCount", map);
    	return totalCount;
	}
    
    // 조건에 맞는 맛집 리스트 조회 (6개씩 끊어서 가져오기)
    @Override
	public List<RestaurantDTO> selectNearbyRestaurantList(Map<String, Object> map) {
    	// 실제 맛집 리스트 구하기 (결과가 여러 줄이므로 selectList 사용)
        List list = session.selectList("PlaceMapper.selectNearbyRestaurantList", map);
        return list;
	}
    
    // 조건에 맞는 맛집 마커 불러오기 (전부 가져오기)
    @Override
	public List<RestaurantDTO> selectNearbyMarkersAjax(Map<String, Object> map) {
    	List list = session.selectList("PlaceMapper.selectNearbyMarkersAjax", map);
		return list;
	}

    @Override
    public PlaceDTO getRestaurantDetail(int place_id) {
        return session.selectOne(NAMESPACE + "selectPlaceDetail", place_id); // 맛집 상세 1건 조회
    }

    @Override
    public void increaseViewCount(int place_id) {
        session.update(NAMESPACE + "increaseViewCount", place_id); // 상세 페이지 진입 시 조회수 증가
    }

    @Override
    public List<ReviewDTO> getReviewsPaged(Map<String, Object> map) {
        return session.selectList(NAMESPACE + "selectReviewsPaged", map); // 리뷰 더보기용 페이징 조회
    }

    @Override
    public int getReviewCount(int place_id) {
        return session.selectOne(NAMESPACE + "getReviewCount", place_id); // 해당 맛집의 전체 리뷰 수 조회
    }

    @Override
    public int isFavorite(Map<String, Object> map) {
        return session.selectOne(NAMESPACE + "isFavorite", map); // 로그인 사용자의 즐겨찾기 여부 확인
    }

    @Override
    public int insertFavorite(Map<String, Object> map) {
        return session.insert(NAMESPACE + "insertFavorite", map); // 즐겨찾기 추가
    }

    @Override
    public int deleteFavorite(Map<String, Object> map) {
        return session.delete(NAMESPACE + "deleteFavorite", map); // 즐겨찾기 해제
    }
    
    @Override
    public List<RestaurantDTO> getBestRestaurantList() {
        return session.selectList(NAMESPACE + "getBestRestaurantList"); // 맛집 랭킹 전체 목록 조회용
    }

    @Override
    public double getAvgRating(int place_id) {
        Double result = session.selectOne(NAMESPACE + "getAvgRating", place_id);
        return result == null ? 0.0 : result; // 평균 별점이 null일 경우 0.0으로 보정
    }
    
    @Override
    public int getBestRestaurantCount(Map<String, Object> map) {
        return session.selectOne(NAMESPACE + "getBestRestaurantCount", map); // 지역/카테고리 조건에 맞는 전체 맛집 수 조회
    }
    
    @Override
    public List<RestaurantDTO> getBestRestaurantPageList(Map<String, Object> map) {
        return session.selectList(NAMESPACE + "getBestRestaurantPageList", map); // 랭킹 기본 리스트 및 더보기 구간 조회
    }

    @Override
    public List<RestaurantDTO> getBestRestaurantTop5(Map<String, Object> map) {
        return session.selectList(NAMESPACE + "getBestRestaurantTop5", map); // 랭킹 상단 TOP5 조회
    }
}