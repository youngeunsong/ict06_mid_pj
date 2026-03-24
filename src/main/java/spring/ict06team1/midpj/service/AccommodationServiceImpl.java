package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import spring.ict06team1.midpj.dao.AccommodationDAO;
import spring.ict06team1.midpj.dto.AccommodationDTO;
/*
 * @author 송영은
 * 최초 작성일: 26.03.10
 * 최종 수정일: 26.03.24
 * 업데이트 사항:
 * v260324: 랭킹 관련 메서드 구현 
 */

@Service
public class AccommodationServiceImpl implements AccommodationService {
	
	@Autowired
	private AccommodationDAO dao;

	// [숙소 랭킹 관련 메서드] ----------------------------------------------------------
	// 숙소 랭킹 목록 조회
	@Override
	public List<AccommodationDTO> getBestAccommodationList() {
		System.out.println("AccommodationServiceImpl - getBestAccommodationList()");
		return dao.getBestAccommodationList(); // 맛집 랭킹 전체 목록 조회
	}

	// 별점 평균
	@Override
	public double getAvgRating(int place_id) {
		System.out.println("AccommodationServiceImpl - getAvgRating()");
		return dao.getAvgRating(place_id); // 특정 숙소 평균 별점 조회
	}

	// 숙소 총 갯수
	@Override
	public int getBestAccommodationCount(String region) {
		System.out.println("AccommodationServiceImpl - getBestAccommodationCount()");	
		// [랭킹 전체 개수 조회]
        // 지역/카테고리 필터 조건을 map으로 전달해서 더보기 가능 여부 계산에 사용
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("region", region);
        return dao.getBestAccommodationCount(map);
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
        return dao.getBestAccommodationPageList(map);
	}

	// 숙소 top 5
	@Override
	public List<AccommodationDTO> getBestAccommodationTop5(String region) {
		// [랭킹 TOP5 조회]
		// 현재 탭/필터 조건에 맞는 상위 5개 데이터를 별도 조회해서 상단 강조 영역에 사용
		System.out.println("AccommodationServiceImpl - getBestAccommodationTop5()");
		
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("region", region);
        return dao.getBestAccommodationTop5(map);
	}
	
}
