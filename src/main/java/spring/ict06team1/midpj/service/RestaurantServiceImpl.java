package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import spring.ict06team1.midpj.SearchCriteria.Paging;
import spring.ict06team1.midpj.controller.RestaurantController;
import spring.ict06team1.midpj.dao.RestaurantDAO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

@Service
public class RestaurantServiceImpl implements RestaurantService {
	
	private static final Logger logger = LoggerFactory.getLogger(RestaurantService.class);

    @Autowired
    private RestaurantDAO dao;
    
    //맛집 리스트 보여주기
    @Override
	public void getNearbyRestaurantAjax(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
    	
    	// 1. 파라미터 수집 (JSP의 실시간 GPS 좌표 및 설정값)
        String strLat = request.getParameter("lat");
        String strLng = request.getParameter("lng");
        String strRadius = request.getParameter("radius");
        String strMinRating = request.getParameter("minRating");
        String pageNum = request.getParameter("pageNum"); 
        String keyword = request.getParameter("keyword");
        String sortType = request.getParameter("sortType");
        String category = request.getParameter("category");

        // 2. 초기 위치 및 반경 설정
        double lat = (strLat != null && !strLat.isEmpty()) ? Double.parseDouble(strLat) : 37.525; 
        double lng = (strLng != null && !strLng.isEmpty()) ? Double.parseDouble(strLng) : 126.864;
        double radius = (strRadius != null && !strRadius.isEmpty()) ? Double.parseDouble(strRadius) : 5.0;
        double minRating = (strMinRating != null && !strMinRating.isEmpty()) ? Double.parseDouble(strMinRating) : 0.0;
        
        // 3. Paging 객체 생성 및 6개 단위 설정
        Paging paging = new Paging(pageNum); // 생성자에서 pageNum null 체크 및 1페이지 설정 수행
        paging.setPageSize(6);               // [중요] 한 페이지당 게시글 수를 6개로 강제 변경
        
        // 전체 맛집 개수 조회를 위한 Map
        Map<String, Object> countMap = new HashMap<>();
        countMap.put("lat", lat);
        countMap.put("lng", lng);
        countMap.put("radius", radius);
        countMap.put("keyword", keyword);
        countMap.put("minRating", minRating);
        countMap.put("category", category);
        
        int totalCount = dao.selectNearbyRestaurantCount(countMap);
        
        // setTotalCount 호출 시 내부에서 startRow, endRow가 6개 기준으로 자동 계산됨
        paging.setTotalCount(totalCount);

        // 4. 리스트 조회를 위한 최종 Map 구성
        Map<String, Object> listMap = new HashMap<>(countMap);
        listMap.put("sortType", (sortType != null && !sortType.isEmpty()) ? sortType : "distance");
        listMap.put("start", paging.getStartRow()); // 6개 기준 시작 번호 (예: 1, 7, 13...)
        listMap.put("end", paging.getEndRow());     // 6개 기준 끝 번호 (예: 6, 12, 18...)

        // 5. DB 데이터 조회 (RestaurantDTO + PlaceDTO 조인)
        List<RestaurantDTO> restaurantList = dao.selectNearbyRestaurantList(listMap);

        // 6. 서비스단에서 Model에 직접 데이터 바인딩
        model.addAttribute("restaurantList", restaurantList); // restaurantCard.jsp의 items와 매칭 
        model.addAttribute("paging", paging);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("userLat", lat);
        model.addAttribute("userLng", lng);
        model.addAttribute("mode", "search");
    }
    
    // 맛집 마커 데이터를 JSON 형태로 응답하는 서비스 메서드
    @Override
    public List<RestaurantDTO> getNearbyMarkersAjax(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
    	// 1. 파라미터 수집 및 검색용 Map 생성
        Map<String, Object> listMap = new HashMap<>();
        listMap.put("lat", Double.parseDouble(request.getParameter("lat")));
        listMap.put("lng", Double.parseDouble(request.getParameter("lng")));
        listMap.put("radius", Double.parseDouble(request.getParameter("radius")));
        listMap.put("keyword", request.getParameter("keyword"));
        listMap.put("category", request.getParameter("category"));
        String strMinRating = request.getParameter("minRating");
        double minRating = (strMinRating != null && !strMinRating.isEmpty()) ? Double.parseDouble(strMinRating) : 0.0;
        listMap.put("minRating", minRating);
        // 2. DAO 호출 (전체 마커용 데이터 조회)
        List<RestaurantDTO> restaurantList = dao.selectNearbyMarkersAjax(listMap);

        // 3. [선택사항] Jackson ObjectMapper로 데이터 확인해보기
        ObjectMapper mapper = new ObjectMapper(); 
        try {
            // 객체를 JSON 문자열로 변환 (Gson의 toJson과 동일한 역할)
            String jsonOutput = mapper.writeValueAsString(restaurantList);
            logger.info("변환된 JSON 데이터: " + jsonOutput);
        } catch (JsonProcessingException e) {
            logger.error("JSON 변환 중 에러 발생: " + e.getMessage());
        }
        // 4. 리스트 반환 (컨트롤러로 전달)
        return restaurantList;
    }

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