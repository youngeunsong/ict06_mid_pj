package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

@Repository
public class RestaurantDAOImpl implements RestaurantDAO {

    @Autowired
    private SqlSession session;

    private static final String NAMESPACE = "PlaceMapper.";

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