package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import spring.ict06team1.midpj.SearchCriteria.Paging;
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
	
	// 축제 지도 페이지용 메서드 ---------------------------------------
	// 내 위치 기준 근방 축제 리스트 조회
	@Override
	public void getNearbyFestivalAjax(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("FestivalServiceImpl-getNearbyFestivalAjax()");
		
		// 1. 파라미터 수집 (JSP의 실시간 GPS 좌표 및 설정값)
        String strLat = request.getParameter("lat");
        String strLng = request.getParameter("lng");
        String strRadius = request.getParameter("radius");
        String strMinRating = request.getParameter("minRating");
        String pageNum = request.getParameter("pageNum"); 
        String keyword = request.getParameter("keyword");
        String sortType = request.getParameter("sortType");
//        String category = request.getParameter("category");// 축제에 필요없을 것으로 예상

        // 2. 초기 위치 및 반경 설정
        double lat = (strLat != null && !strLat.isEmpty()) ? Double.parseDouble(strLat) : 37.525; 
        double lng = (strLng != null && !strLng.isEmpty()) ? Double.parseDouble(strLng) : 126.864;
        double radius = (strRadius != null && !strRadius.isEmpty()) ? Double.parseDouble(strRadius) : 5.0;
        double minRating = (strMinRating != null && !strMinRating.isEmpty()) ? Double.parseDouble(strMinRating) : 0.0;
        
        // 3. Paging 객체 생성 및 6개 단위 설정
        Paging paging = new Paging(pageNum); // 생성자에서 pageNum null 체크 및 1페이지 설정 수행
        paging.setPageSize(6);               // [중요] 한 페이지당 게시글 수를 6개로 강제 변경
        
        // 전체 축제 개수 조회를 위한 Map
        Map<String, Object> countMap = new HashMap<>();
        countMap.put("lat", lat);
        countMap.put("lng", lng);
        countMap.put("radius", radius);
        countMap.put("keyword", keyword);
        countMap.put("minRating", minRating);
//        countMap.put("category", category); // 축제에 필요없을 것으로 예상
        
        int totalCount = dao.selectNearbyFestivalCount(countMap);
        
        // setTotalCount 호출 시 내부에서 startRow, endRow가 6개 기준으로 자동 계산됨
        paging.setTotalCount(totalCount);

        // 4. 리스트 조회를 위한 최종 Map 구성
        Map<String, Object> listMap = new HashMap<>(countMap);
        listMap.put("sortType", (sortType != null && !sortType.isEmpty()) ? sortType : "distance");
        listMap.put("start", paging.getStartRow()); // 6개 기준 시작 번호 (예: 1, 7, 13...)
        listMap.put("end", paging.getEndRow());     // 6개 기준 끝 번호 (예: 6, 12, 18...)

        // 5. DB 데이터 조회 (FestivalDTO + PlaceDTO 조인)
        List<FestivalDTO> festivalList = dao.selectNearbyFestivalList(listMap);

        // 6. 서비스단에서 Model에 직접 데이터 바인딩
        model.addAttribute("festivalList", festivalList); // restaurantCard.jsp의 items와 매칭 
        model.addAttribute("paging", paging);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("userLat", lat);
        model.addAttribute("userLng", lng);
        model.addAttribute("mode", "search");
	}

	// 축제 마커 리스트를 JSON 형태로 응답
	@Override
	public List<FestivalDTO> getNearbyFeMarkersAjax(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("FestivalServiceImpl-getNearbyFeMarkersAjax()");
		
		// 1. 파라미터 수집 및 검색용 Map 생성
        Map<String, Object> listMap = new HashMap<>();
        listMap.put("lat", Double.parseDouble(request.getParameter("lat")));
        listMap.put("lng", Double.parseDouble(request.getParameter("lng")));
        listMap.put("radius", Double.parseDouble(request.getParameter("radius")));
        listMap.put("keyword", request.getParameter("keyword"));
//        listMap.put("category", request.getParameter("category"));// 축제에 필요없을 것으로 예상
        String strMinRating = request.getParameter("minRating");
        double minRating = (strMinRating != null && !strMinRating.isEmpty()) ? Double.parseDouble(strMinRating) : 0.0;
        listMap.put("minRating", minRating);
        
        // 2. DAO 호출 (전체 마커용 데이터 조회)
        List<FestivalDTO> festivalList = dao.selectNearbyFeMarkersAjax(listMap);

        // 3. [선택사항] Jackson ObjectMapper로 데이터 확인해보기
        ObjectMapper mapper = new ObjectMapper(); 
        try {
            // 객체를 JSON 문자열로 변환 (Gson의 toJson과 동일한 역할)
            String jsonOutput = mapper.writeValueAsString(festivalList);
//            logger.info("변환된 JSON 데이터: " + jsonOutput);
            System.out.println("변환된 JSON 데이터: " + jsonOutput);
        } catch (JsonProcessingException e) {
//            logger.error("JSON 변환 중 에러 발생: " + e.getMessage());
            System.out.println("JSON 변환 중 에러 발생: " + e.getMessage());
        }
        // 4. 리스트 반환 (컨트롤러로 전달)
        return festivalList;
	}

	// 축제 상세 페이지용 메서드 ---------------------------------------
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
	
	// 축제 랭킹 페이지용 메서드 ---------------------------------------
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
