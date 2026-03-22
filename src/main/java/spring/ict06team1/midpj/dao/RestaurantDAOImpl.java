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
        return session.selectOne(NAMESPACE + "selectPlaceDetail", place_id);
    }

    @Override
    public void increaseViewCount(int place_id) {
        session.update(NAMESPACE + "increaseViewCount", place_id);
    }

    @Override
    public List<ReviewDTO> getReviewsPaged(Map<String, Object> map) {
        return session.selectList(NAMESPACE + "selectReviewsPaged", map);
    }

    @Override
    public int getReviewCount(int place_id) {
        return session.selectOne(NAMESPACE + "getReviewCount", place_id);
    }

    @Override
    public int isFavorite(Map<String, Object> map) {
        return session.selectOne(NAMESPACE + "isFavorite", map);
    }

    @Override
    public int insertFavorite(Map<String, Object> map) {
        return session.insert(NAMESPACE + "insertFavorite", map);
    }

    @Override
    public int deleteFavorite(Map<String, Object> map) {
        return session.delete(NAMESPACE + "deleteFavorite", map);
    }
}