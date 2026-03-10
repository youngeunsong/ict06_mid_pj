package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import spring.ict06team1.midpj.dao.RestaurantDAO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

@Service
public class RestaurantServiceImpl implements RestaurantService {

    @Autowired
    private RestaurantDAO dao;

    @Override
    public PlaceDTO getRestaurantDetail(int place_id) {
        dao.increaseViewCount(place_id);
        return dao.getRestaurantDetail(place_id);
    }

    @Override
    public List<ReviewDTO> getReviewsPaged(int place_id, int offset, int limit) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("placeId", place_id);
        map.put("offset", offset);
        map.put("limit", limit);

        return dao.getReviewsPaged(map);
    }

    @Override
    public int getReviewCount(int place_id) {
        return dao.getReviewCount(place_id);
    }

    @Override
    public boolean isFavorite(String userId, int place_id) {
        if (userId == null || userId.trim().isEmpty()) {
            return false;
        }

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("placeId", place_id);

        return dao.isFavorite(map) > 0;
    }

    @Override
    public boolean toggleFavorite(String userId, int place_id) {
        if (userId == null || userId.trim().isEmpty()) {
            return false;
        }

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("placeId", place_id);

        int count = dao.isFavorite(map);

        if (count > 0) {
            dao.deleteFavorite(map);
            return false;
        } else {
            dao.insertFavorite(map);
            return true;
        }
    }
}