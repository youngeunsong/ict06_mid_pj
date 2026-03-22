package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.ui.Model;
import spring.ict06team1.midpj.dto.AccommodationDTO;

public interface AccommodationService {
	
	// 내 위치 기준 근방 숙소 리스트 조회  
	public void getNearbyAccommodationAjax(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	// 숙소 리스트를 JSON 형태로 응답
    public List<AccommodationDTO> getNearbyMarkersAjaxAcc(HttpServletRequest request, HttpServletResponse response)
    		throws ServletException, IOException;

    // 즐겨찾기 여부 확인
    boolean isFavorite(String userId, int place_id);

    // 즐겨찾기 토글
    boolean toggleFavorite(String userId, int place_id);

}
