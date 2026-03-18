package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import spring.ict06team1.midpj.SearchCriteria.Paging;
import spring.ict06team1.midpj.dao.AdFestivalDAO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.util.FestivalApiClient;

@Service
public class AdFestivalServiceImpl implements AdFestivalService{

	@Autowired
	private AdFestivalDAO dao; 
	
	@Autowired
    FestivalApiClient apiClient;
	
	// 축제 목록 조회
	@Override
	public void getFestivalList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdFestivalServiceImpl - getFestivalList()]");
		
		//1) parameter값 수집(검색어, 예약상태) TODO: 상황에 맞게 수정 
		String keyword = request.getParameter("keyword");
		String status = request.getParameter("status");
		String pageNum = request.getParameter("pageNum");
		String sortType = request.getParameter("sortType");
		
		//페이징 객체 생성
		Paging paging = new Paging(pageNum);
		
		//검색조건 담을 map 생성
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", status);
		map.put("keyword", keyword);
		map.put("sortType",sortType != null ? sortType : "created_at_desc");
		
		//전체 건수 조회
		int totalCount = dao.getFestivalCount(map); 
		paging.setTotalCount(totalCount);
		
		//페이징 범위 추가
		map.put("startRow", paging.getStartRow());
        map.put("endRow", paging.getEndRow());
        
		//목록 조회
		List<FestivalDTO> list = dao.getFestivalList(map); 
		System.out.println("전체 데이터 수: " + (list != null ? list.size() : 0));
		
		//Model에 담아서 jsp로 전달
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("status", status);
		model.addAttribute("keyword", keyword);
		model.addAttribute("sortType", sortType);
	}

	// 축제 상세 정보 조회
	@Override
	public void getFestivalDetail(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdFestivalServiceImpl - getFestivalDetail()]");
		
		// 1) parameter값 수집(festival_id)
		int festival_id = Integer.parseInt(request.getParameter("festival_id")); 
		
		// 2) 상세 조회
		// 2-1) FestivalDTO 조회
		FestivalDTO festivalDTO = dao.getFestivalDetail(festival_id); 
		// System.out.println("festivalDTO" + festivalDTO);
		
		// 2-2) FestivalTicketDTO 조회 
		List<FestivalTicketDTO> ticketList = dao.getFestivalTickets(festival_id); 
		System.out.println(ticketList);
		
		Map<String, FestivalTicketDTO> ticketMap = new HashMap();

		for(FestivalTicketDTO ticket : ticketList){
		    ticketMap.put(ticket.getTicket_type(), ticket);
		}
		
		// 2-3) FestivalDTO에 세팅
		festivalDTO.setTicketList(ticketList);
		
		// 3) Model에 담아서 jsp로 전달
		model.addAttribute("festivalDTO", festivalDTO); 
		model.addAttribute("freeTicket", ticketMap.get("Free"));
		model.addAttribute("oneDayTicket", ticketMap.get("OneDay"));
		model.addAttribute("twoDayTicket", ticketMap.get("TwoDay"));
		model.addAttribute("allDayTicket", ticketMap.get("AllDay"));
	}
	
	// 축제 상세 정보 조회 - Ajax용
	public FestivalDTO getFestivalDetailAjax(int festival_id){

	    FestivalDTO festivalDTO = dao.getFestivalDetail(festival_id);

	    List<FestivalTicketDTO> ticketList = dao.getFestivalTickets(festival_id);

	    festivalDTO.setTicketList(ticketList);
	    
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	    festivalDTO.setStart_date_str(sdf.format(festivalDTO.getStart_date()));
	    festivalDTO.setEnd_date_str(sdf.format(festivalDTO.getEnd_date()));

	    return festivalDTO;
	}

	// 축제 정보 수정
	@Override
	public int modifyFestival(HttpServletRequest request, HttpServletResponse response, Model model) {

	    System.out.println("[AdFestivalServiceImpl - modifyFestival()]");

	    int festival_id = Integer.parseInt(request.getParameter("festival_id"));

	    String name = request.getParameter("name");
	    String address = request.getParameter("address");
	    double latitude = parseDouble(request.getParameter("latitude"));
	    double longitude = parseDouble(request.getParameter("longitude"));
	    String image_url = request.getParameter("image_url");

	    String description = request.getParameter("description");
	    Date start_date = Date.valueOf(request.getParameter("start_date"));
	    Date end_date = Date.valueOf(request.getParameter("end_date"));

	    // Place DTO
	    PlaceDTO placeDTO = new PlaceDTO();
	    placeDTO.setPlace_id(festival_id);
	    placeDTO.setName(name);
	    placeDTO.setAddress(address);
	    placeDTO.setLatitude(latitude);
	    placeDTO.setLongitude(longitude);
	    placeDTO.setImage_url(image_url);

	    // Festival DTO
	    FestivalDTO festivalDTO = new FestivalDTO();
	    festivalDTO.setFestival_id(festival_id);
	    festivalDTO.setDescription(description);
	    festivalDTO.setStart_date(start_date);
	    festivalDTO.setEnd_date(end_date);

	    // 1️) 장소 수정
	    int placeUpdateCnt = dao.updatePlace(placeDTO);

	    // 2️) 축제 수정
	    int festivalUpdateCnt = dao.modifyFestival(festivalDTO);

	    // 3️) 티켓 수정
	    String[] ticket_types = {"Free", "OneDay", "TwoDay", "AllDay"};

	    int ticketUpdateCnt = 1;

	    for(String type : ticket_types){

	        FestivalTicketDTO ticketDTO = new FestivalTicketDTO();

	        ticketDTO.setFestival_id(festival_id);
	        ticketDTO.setTicket_type(type);
	        ticketDTO.setPrice(parseInteger(request.getParameter("price"+type)));
	        ticketDTO.setStock(parseInteger(request.getParameter("stock"+type)));
	        ticketDTO.setDescription(request.getParameter("ticketDesc"+type));

	        int result = dao.updateTicket(ticketDTO);

	        if(result == 0){
	            ticketUpdateCnt = 0;
	            break;
	        }
	    }

	    if(placeUpdateCnt>0 && festivalUpdateCnt>0 && ticketUpdateCnt>0){
	    	return 1; 
	    }else{
	    	return 0; 
	    }
	}

	// 신규 축제 등록
	@Override
	public void insertFestival(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdFestivalServiceImpl - insertFestival()]");
		
		// 1) parameter값 수집(검색어, 예약상태) 
		// PlaceDTO에 담을 변수
		String name = request.getParameter("name");
		String address = request.getParameter("address");
		double latitude = parseDouble(request.getParameter("latitude"));
		double longitude = parseDouble(request.getParameter("longitude"));
		String image_url = request.getParameter("image_url");
		
		// FestivalDTO에 담을 변수
		String description = request.getParameter("description");
		Date start_date = Date.valueOf(request.getParameter("start_date")) ;
		Date end_date = Date.valueOf(request.getParameter("end_date"));
		
		// PlaceDTO에 담기 - 장소 유형별 공통 정보
		PlaceDTO plDto = new PlaceDTO(); 
		plDto.setName(name);
		plDto.setAddress(address);
		plDto.setLatitude(latitude);
		plDto.setLongitude(longitude);
		plDto.setImage_url(image_url);
		
		// FestivalDTO에 담기
		FestivalDTO dto = new FestivalDTO();
		dto.setPlaceDTO(plDto);
		dto.setDescription(description);
		dto.setStart_date(start_date);
		dto.setEnd_date(end_date);
		
		// DAO 호출하여 DB에 데이터 추가 시도  
		int insertCntPlace = dao.insertPlace(plDto);
		
		// Place 테이블에 먼저 추가 시도하여 성공 시 
		if(insertCntPlace > 0) {
			
			int insertFestivalCnt = dao.insertFestival(dto);
			
			// Festival 테이블에 추가 시도하여 성공 시
			if(insertFestivalCnt > 0) {
				int insertCnt = 0; 
				
				// FestivalTicketDTO에 담을 변수 
				String[] ticket_types = {"Free", "OneDay", "TwoDay", "AllDay"}; // 무료, 1일권, 2일권, 전일권 구분  
				
				for(int i = 0; i < ticket_types.length; i++) {
					FestivalTicketDTO ticketDTO = new FestivalTicketDTO();
					ticketDTO.setTicket_type(ticket_types[i]);			
					ticketDTO.setPrice(parseInteger(request.getParameter("price" + ticket_types[i])));
					ticketDTO.setStock(parseInteger(request.getParameter("stock" + ticket_types[i])));
					ticketDTO.setDescription(request.getParameter("ticketDesc" + ticket_types[i]));
					int insertTicketCnt = dao.insertTicket(ticketDTO); 
					
					// 한 번이라도 티켓 정보 등록 실패하면 축제 정보 등록 실패
					if(insertTicketCnt == 0) {
						model.addAttribute("insertCnt", 0);
						break; 
					}
				}
				// 모든 티켓 등록 성공 후 Model에 담아서 jsp로 전달
				model.addAttribute("insertCnt", 1); 
			}
			// Festival 테이블에 추가 실패 시 
			else {
				model.addAttribute("insertCnt", 0);
			}
		} 
		// Place 테이블에 추가 실패 시 
		else {
			//Model에 담아서 jsp로 전달
			model.addAttribute("insertCnt", 0); 
		}
	}
	
	// 축제 정보 삭제 
	@Override
	@Transactional
	public int deleteFestival(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdFestivalServiceImpl - deleteFestival()]");
		// 1) parameter값 수집(place_id, pageNum) 
		int festival_id = Integer.parseInt(request.getParameter("festival_id")); 
		System.out.println("festival_id : " + festival_id);
		// DAO 호출하여 DB에 데이터 삭제 시도
		// 1) FestivalTicket 테이블에서 먼저 삭제
		dao.deleteFestivalTickets(festival_id);
		
		// 2) Festival 테이블에서 삭제 (Place 테이블에서는 삭제 안 함. 다른 테이블과 연관이 크기 때문) 
		int deleteCnt = dao.deleteFestival(festival_id);
		
		return deleteCnt; 
	}
	
	// int, Double 형 데이터의 Null 값 처리
	// int의 null 처리 
	private int parseInteger(String value){
	    if(value == null || value.trim().isEmpty()){
	        return 0;
	    }
	    return Integer.parseInt(value);
	}

	// Double의 null 처리 
	private double parseDouble(String value){
	    if(value == null || value.trim().isEmpty()){
	        return 0;
	    }
	    return Double.parseDouble(value);
	}

	// 전국문화축제표준데이터 오픈 API로 축제 정보 가져오기
	@Override
	public String bringFestivalFromAPI(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		int page = Integer.parseInt(request.getParameter("pageNo"));
		int numOfRows = Integer.parseInt(request.getParameter("numOfRows"));
		String json = apiClient.callAPI(page, numOfRows);
		return json; 
	}
	
	// 오픈API로 가져온 정보 DB에 넣기 
	@Override
	@Transactional
	public void insertFestivalsFromApi(String json) 
			throws Exception {
		List<FestivalDTO> list = parseFestivalJson(json);

		for(FestivalDTO dto : list){
		    PlaceDTO place = dto.getPlaceDTO();
		    Integer placeId = dao.findPlaceIdByNameAndAddress(place);

		    if(placeId == null){
		        // 새로운 장소
		    	dao.insertPlace(place);
		    	placeId = place.getPlace_id();
		    }
		    
		    dto.setFestival_id(placeId);
		    dao.insertFestival(dto);
		}
	}
	
	// JSON 파싱 메서드 : 오픈 API 데이터 파싱
	private List<FestivalDTO> parseFestivalJson(String json) {

	    List<FestivalDTO> list = new ArrayList<>();

	    ObjectMapper mapper = new ObjectMapper();

	    try {

	        JsonNode root = mapper.readTree(json);

	        JsonNode items = root
	                .path("response")
	                .path("body")
	                .path("items");

	        for(JsonNode item : items){

	            FestivalDTO dto = new FestivalDTO();
	            PlaceDTO placeDto = new PlaceDTO();

	            placeDto.setPlace_type("FEST");
	            
	            // item.path("전국문화축제표준데이터 오픈API에서 제공하는 변수명")
	            placeDto.setName(item.path("fstvlNm").asText());
	            placeDto.setAddress(item.path("rdnmadr").asText());
	            placeDto.setLatitude(item.path("latitude").asDouble());
	            placeDto.setLongitude(item.path("longitude").asDouble());
	            placeDto.setImage_url(item.path("image_url").asText());
	            
	            dto.setPlaceDTO(placeDto);
	            
	            dto.setDescription(item.path("fstvlCo").asText());

	            // 날짜 보정
	            String startStr = item.path("fstvlStartDate").asText();
	            String endStr = item.path("fstvlEndDate").asText();

	            Date startDate = null;
	            Date endDate = null;

	            try{
	                if(startStr != null && !startStr.trim().isEmpty()){
	                    startDate = Date.valueOf(startStr);
	                }
	            }catch(Exception e){}

	            try{
	                if(endStr != null && !endStr.trim().isEmpty()){
	                    endDate = Date.valueOf(endStr);
	                }
	            }catch(Exception e){}

	            // NULL 보정
	            if(startDate == null && endDate == null){
	                Date today = new Date(System.currentTimeMillis());
	                startDate = today;
	                endDate = today;
	            }
	            else if(startDate == null){
	                startDate = endDate;
	            }
	            else if(endDate == null){
	                endDate = startDate;
	            }

	            // 날짜 역전 방지 (매우 중요)
	            if(startDate.after(endDate)){
	                Date temp = startDate;
	                startDate = endDate;
	                endDate = temp;
	            }

	            dto.setStart_date(startDate);
	            dto.setEnd_date(endDate);
	            
	            list.add(dto);
	        }

	    } catch(Exception e){
	        e.printStackTrace();
	    }

	    return list;
	}
}
