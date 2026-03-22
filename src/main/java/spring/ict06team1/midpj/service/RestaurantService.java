package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

public interface RestaurantService {
	
	// 내 위치 기준 근방 맛집 리스트 조회  
	public void getNearbyRestaurantAjax(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	// 맛집 리스트를 JSON 형태로 응답
    public List<RestaurantDTO> getNearbyMarkersAjax(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException;
	
    // 맛집 상세
    PlaceDTO getRestaurantDetail(int place_id);

    // 리뷰 페이징
    List<ReviewDTO> getReviewsPaged(int place_id, int offset, int limit);

    // 리뷰 총 개수
    int getReviewCount(int place_id);

    // 즐겨찾기 여부 확인
    boolean isFavorite(String userId, int place_id);

    // 즐겨찾기 토글
    boolean toggleFavorite(String userId, int place_id);
}