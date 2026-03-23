package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import spring.ict06team1.midpj.dao.RestaurantDAO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

@Service
public class RestaurantServiceImpl implements RestaurantService {

    @Autowired
    private RestaurantDAO dao;

    @Override
    public RestaurantDTO getRestaurantDetail(int place_id) {
        dao.increaseViewCount(place_id); // 상세 페이지 진입 시 조회수를 먼저 증가
        return dao.getRestaurantDetail(place_id); // 증가된 조회수를 포함한 상세 정보 반환
    }

    @Override
    public List<ReviewDTO> getReviewsPaged(int place_id, int offset, int limit) {
        // [리뷰 페이징 조회]
        // DAO/Mapper에서 사용하기 쉽도록 place_id, offset, limit 값을 map으로 묶어서 전달
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("placeId", place_id);
        map.put("offset", offset);
        map.put("limit", limit);

        return dao.getReviewsPaged(map);
    }

    @Override
    public int getReviewCount(int place_id) {
        return dao.getReviewCount(place_id); // 해당 맛집의 전체 리뷰 수 조회
    }

    @Override
    public boolean isFavorite(String userId, int place_id) {
        // [즐겨찾기 여부 확인]
        // 로그인 정보가 없으면 즐겨찾기 대상이 될 수 없으므로 false 반환
        if (userId == null || userId.trim().isEmpty()) {
            return false;
        }

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("placeId", place_id);

        return dao.isFavorite(map) > 0; // count 결과를 boolean 형태로 변환해서 반환
    }

    @Override
    public boolean toggleFavorite(String userId, int place_id) {
        // [즐겨찾기 토글 처리]
        // 이미 있으면 삭제, 없으면 추가하는 방식으로 버튼 한 개로 상태를 전환하기 위해 사용
        if (userId == null || userId.trim().isEmpty()) {
            return false;
        }

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("placeId", place_id);

        int count = dao.isFavorite(map); // 현재 즐겨찾기 등록 여부 확인

        if (count > 0) {
            dao.deleteFavorite(map);
            return false; // 삭제 후 상태는 "즐겨찾기 아님"
        } else {
            dao.insertFavorite(map);
            return true; // 추가 후 상태는 "즐겨찾기 됨"
        }
    }
    
    @Override
    public List<RestaurantDTO> getBestRestaurantList() {
        return dao.getBestRestaurantList(); // 맛집 랭킹 전체 목록 조회
    }

    @Override
    public double getAvgRating(int place_id) {
        return dao.getAvgRating(place_id); // 특정 맛집 평균 별점 조회
    }
    
    @Override
    public int getBestRestaurantCount(String region, String category) {
        // [랭킹 전체 개수 조회]
        // 지역/카테고리 필터 조건을 map으로 전달해서 더보기 가능 여부 계산에 사용
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("region", region);
        map.put("category", category);
        return dao.getBestRestaurantCount(map);
    }

    @Override
    public List<RestaurantDTO> getBestRestaurantPageList(int start, int end, String region, String category) {
        // [랭킹 목록 구간 조회]
        // start ~ end 범위와 필터 조건을 함께 전달해서 기본 리스트/더보기 구간을 공통 처리
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("start", start);
        map.put("end", end);
        map.put("region", region);
        map.put("category", category);
        return dao.getBestRestaurantPageList(map);
    }
    
    @Override
    public List<RestaurantDTO> getBestRestaurantTop5(String region, String category) {
        // [랭킹 TOP5 조회]
        // 현재 탭/필터 조건에 맞는 상위 5개 데이터를 별도 조회해서 상단 강조 영역에 사용
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("region", region);
        map.put("category", category);
        return dao.getBestRestaurantTop5(map);
    }
}