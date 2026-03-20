package spring.ict06team1.midpj.service;

import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import spring.ict06team1.midpj.dao.FestivalDAO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
/*
 * @author 송영은
 * 최초작성일: 2026-03-17
 * 최종수정일: 2026-03-19
 * 참고 코드: RestaurantServiceImpl
 * ----------------------------------
 * v260319
 * 랭킹 기능 구현을 위한 메써드 추가 (getBestFestivalCount, getBestFestivalList, getBestFestivalPageList, getBestFestivalTop5)
 * ----------------------------------
 */
@Service
public class FestivalServiceImpl implements FestivalService {

	@Autowired
	private FestivalDAO dao;

	// 축제 상세
	@Override
	public FestivalDTO getFestivalDetail(int place_id) {
		System.out.println("FestivalServiceImpl-getFestivalDetail()");
		dao.increaseViewCount(place_id);
		
		PlaceDTO place = dao.selectPlaceDetail(place_id); 
		FestivalDTO festival = dao.getFestivalDetail(place_id); 
		List<FestivalTicketDTO> tickets = dao.getFestivalTickets(place_id); 
		
		// 티켓 목록 리스트 순서 정렬
		List<String> order = Arrays.asList("Free", "OneDay", "TwoDay", "AllDay");
		tickets.sort(Comparator.comparingInt(t -> order.indexOf(t.getTicket_type())));
		
		// festival에 place와 tickets 적용
		festival.setPlaceDTO(place);
		festival.setTicketList(tickets);
        return festival;
	}

	// 리뷰 페이징
	@Override
	public List<ReviewDTO> getReviewsPaged(int place_id, int offset, int limit) {
		System.out.println("FestivalServiceImpl-getReviewsPaged()");
		Map<String, Object> map = new HashMap<String, Object>();
        map.put("placeId", place_id);
        map.put("offset", offset);
        map.put("limit", limit);

        return dao.getReviewsPaged(map);
	}

	// 리뷰 총 개수
	@Override
	public int getReviewCount(int place_id) {
		System.out.println("FestivalServiceImpl-getReviewCount()");
		return dao.getReviewCount(place_id);
	}

	// 즐겨찾기 여부 확인
	@Override
	public boolean isFavorite(String userId, int place_id) {
		System.out.println("FestivalServiceImpl-isFavorite()");
		if (userId == null || userId.trim().isEmpty()) {
            return false;
        }

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", userId);
        map.put("placeId", place_id);

        return dao.isFavorite(map) > 0;
	}

	// 즐겨찾기 토글
	@Override
	public boolean toggleFavorite(String userId, int place_id) {
		System.out.println("FestivalServiceImpl-toggleFavorite()");
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
	
	// 축제 총 갯수 조회
	@Override
	public int getBestFestivalCount() {
		System.out.println("FestivalServiceImpl-getBestFestivalCount()");
        return dao.getBestFestivalCount();
	}

	// 축제 랭킹 전체 목록 조회
	@Override
	public List<FestivalDTO> getBestFestivalList() {
		System.out.println("FestivalServiceImpl-getBestFestivalList()");
		return dao.getBestFestivalList(); 
	}

	// 축제 페이지 리스트 (6위부터)
	@Override
	public List<FestivalDTO> getBestFestivalPageList(int start, int end) {
		System.out.println("FestivalServiceImpl-getBestFestivalPageList()");
		// start ~ end 범위와 필터 조건을 함께 전달해서 기본 리스트/더보기 구간을 공통 처리
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("start", start);
        map.put("end", end);
        return dao.getBestFestivalPageList(map);
	}

	// 축제 top 5
	@Override
	public List<FestivalDTO> getBestFestivalTop5() {
		System.out.println("FestivalServiceImpl-getBestFestivalTop5()");
		// 상위 5개 데이터를 별도 조회해서 상단 강조 영역에 사용
        return dao.getBestFestivalTop5();
	}


}
