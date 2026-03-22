package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.AccommodationDTO;

public interface AccommodationDAO {
	
	// 주변 숙소의 총 개수를 조회 (페이징 계산용)
	public int selectNearbyAccommodationCount(Map<String, Object> map); 
	
	// 조건에 맞는 숙소 리스트 조회 (6개씩 끊어서 가져오기)
    public List<AccommodationDTO> selectNearbyAccommodationList(Map<String, Object> map);
    
    // 조건에 맞는 숙소 마커 불러오기 (전부 가져오기)
    public List<AccommodationDTO> selectNearbyMarkersAjaxAcc(Map<String, Object> map);
    
    // 즐겨찾기 여부 확인
    int isFavorite(Map<String, Object> map);

    // 즐겨찾기 추가
    int insertFavorite(Map<String, Object> map);

    // 즐겨찾기 삭제
    int deleteFavorite(Map<String, Object> map);
}
