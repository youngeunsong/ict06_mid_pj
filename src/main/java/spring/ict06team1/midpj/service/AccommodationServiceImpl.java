package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import spring.ict06team1.midpj.dao.AccommodationDAO;
import spring.ict06team1.midpj.dto.AccommodationDTO;

import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;

/*
 * @author 김다솜, 송영은
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: FestivalServiceImpl, RestaurantServiceImpl 
 * ----------------------------------
 * v260324
 * (김다솜) : 예약 관련 메서드 구현  
 * (송영은): 숙소 랭킹 관련 메서드 구현
 * ----------------------------------
 */
@Service
public class AccommodationServiceImpl implements AccommodationService {

	@Autowired
	private AccommodationDAO accDao;

	// [예약 관련 메서드] ------------------------------------------------------------
	// 숙소 상세
	@Override
	public AccommodationDTO getAccommodationDetail(int place_id) {
		System.out.println("[AccommodationServiceImpl-getAccommodationDetail()]");
		
		accDao.increaseViewCount(place_id);
		
		PlaceDTO place = accDao.selectPlaceDetail(place_id);
		AccommodationDTO accDto = accDao.getAccommodationDetail(place_id);
		
		accDto.setPlaceDTO(place);
		return accDto;
	}

	// 리뷰 페이징
	@Override
	public List<ReviewDTO> getReviewsPaged(int place_id, int offset, int limit) {
		System.out.println("[AccommodationServiceImpl-getAccommodationDetail()]");
		return null;
	}

	// 리뷰 총 개수
	@Override
	public int getReviewCount(int place_id) {
		System.out.println("[AccommodationServiceImpl-getReviewCount()]");
		return 0;
	}

	// 즐겨찾기 여부 확인
	@Override
	public boolean isFavorite(String userId, int place_id) {
		System.out.println("[AccommodationServiceImpl-isFavorite()]");
		return false;
	}

	// 즐겨찾기 토글
	@Override
	public boolean toggleFavorite(String userId, int place_id) {
		System.out.println("[AccommodationServiceImpl-toggleFavorite()]");
		return false;
	}

	// 숙소 총 갯수
	@Override
	public int getAccommodationCount() {
		System.out.println("[AccommodationServiceImpl-getAccommodationCount()]");
		return 0;
	}

	// [숙소 랭킹 관련 메서드] ----------------------------------------------------------
	// 숙소 랭킹 목록 조회
	@Override
	public List<AccommodationDTO> getBestAccommodationList() {
		System.out.println("AccommodationServiceImpl - getBestAccommodationList()");
		return accDao.getBestAccommodationList(); // 맛집 랭킹 전체 목록 조회
	}

	// 별점 평균
	@Override
	public double getAvgRating(int place_id) {
		System.out.println("AccommodationServiceImpl - getAvgRating()");
		return accDao.getAvgRating(place_id); // 특정 숙소 평균 별점 조회
	}

	// 숙소 총 갯수
	@Override
	public int getBestAccommodationCount(String region) {
		System.out.println("AccommodationServiceImpl - getBestAccommodationCount()");	
		// [랭킹 전체 개수 조회]
        // 지역/카테고리 필터 조건을 map으로 전달해서 더보기 가능 여부 계산에 사용
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("region", region);
        return accDao.getBestAccommodationCount(map);
	}

	// 숙소 페이지 리스트
	@Override
	public List<AccommodationDTO> getBestAccommodationPageList(int start, int end, String region) {
		// [랭킹 목록 구간 조회]
        // start ~ end 범위와 필터 조건을 함께 전달해서 기본 리스트/더보기 구간을 공통 처리
		System.out.println("AccommodationServiceImpl - getBestAccommodationPageList()");
		
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("start", start);
        map.put("end", end);
        map.put("region", region);
        return accDao.getBestAccommodationPageList(map);
	}

	// 숙소 top 5
	@Override
	public List<AccommodationDTO> getBestAccommodationTop5(String region) {
		// [랭킹 TOP5 조회]
		// 현재 탭/필터 조건에 맞는 상위 5개 데이터를 별도 조회해서 상단 강조 영역에 사용
		System.out.println("AccommodationServiceImpl - getBestAccommodationTop5()");
		
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("region", region);
        return accDao.getBestAccommodationTop5(map);
	}
	
}
