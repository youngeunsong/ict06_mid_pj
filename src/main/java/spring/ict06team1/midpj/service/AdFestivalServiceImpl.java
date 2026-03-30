/**
 * @author 송영은
 * 최초작성일: 26.03.10
 * 최종수정일: 26.03.30
 * 한 메서드 안에서 여러 개의 sql 쿼리가 반드시 순차적으로 일어나야 할 경우 @Transaction 추가 
 * 
 * 코드 변경사항
 * v260318: 
 *    	오픈 API로 받아온 정보를 DB에 추가하는 기능 구현 완료. 
 * 		기존 신규 축제 등록 방법 변경. 축제 이름, 주소, 시작일이 일치 시 중복 등록 안 되게 설정.  
 * v260330: 
 * 		다양한 티켓 유형 대응할 수 있게 수정. 
 * 		축제 수정 시 기존 티켓 유형 삭제 및 추가 가능하게 수정
 */

package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
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
		
		Map<String, FestivalTicketDTO> ticketMap = new HashMap<String, FestivalTicketDTO>();

		for(FestivalTicketDTO ticket : ticketList){
		    ticketMap.put(ticket.getTicket_type(), ticket);
		}
		
		// 2-3) FestivalDTO에 세팅
		festivalDTO.setTicketList(ticketList);
		
		// 3) Model에 담아서 jsp로 전달
		model.addAttribute("festivalDTO", festivalDTO); 
//		model.addAttribute("freeTicket", ticketMap.get("Free"));
//		model.addAttribute("oneDayTicket", ticketMap.get("OneDay"));
//		model.addAttribute("twoDayTicket", ticketMap.get("TwoDay"));
//		model.addAttribute("allDayTicket", ticketMap.get("AllDay"));
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
	@Transactional
	public int modifyFestival(FestivalDTO festivalDTO) {

	    System.out.println("[AdFestivalServiceImpl - modifyFestival()]");

	    int festival_id = festivalDTO.getFestival_id();
	    
	    // ===============================
	    // 1. 장소 수정
	    // ===============================
	    PlaceDTO placeDTO = festivalDTO.getPlaceDTO();
	    
	    if(placeDTO == null){
	        throw new RuntimeException("placeDTO is null");
	    }
	    
	    placeDTO.setPlace_id(festival_id);

	    // 1) 장소 수정
	    int placeUpdateCnt = dao.updatePlace(placeDTO);

	    // ===============================
	    // 2. 축제 수정
	    // ===============================
	    int festivalUpdateCnt = dao.modifyFestival(festivalDTO);

	    // ===============================
	    // 3. 티켓 처리
	    // ===============================
	    List<FestivalTicketDTO> newTicketList = festivalDTO.getTicketList();
	    
	    // 기존 DB 티켓 조회
	    List<FestivalTicketDTO> oldTicketList =
	            dao.getTicketsByFestivalId(festival_id);
	    
	    Map<Integer, FestivalTicketDTO> oldTicketMap = new HashMap<Integer, FestivalTicketDTO>();
	    for(FestivalTicketDTO oldTicket : oldTicketList){
	        oldTicketMap.put(oldTicket.getTicket_id(), oldTicket);
	    }
	    
	    int ticketCnt = 1;

	    if(newTicketList != null){
	    	Set<String> typeSet = new HashSet<String>();

	        for(FestivalTicketDTO ticket : newTicketList){
	        	
	        	// 중복 티켓 유형 방지 
	        	if(typeSet.contains(ticket.getTicket_type())){
	                throw new RuntimeException("duplicate ticket_type");
	            }

	            typeSet.add(ticket.getTicket_type());

	            // 티켓의 축제 아이디 가져오기
	        	ticket.setFestival_id(festival_id);

	            // 신규 티켓
	            if(ticket.getTicket_id() == 0){

	                int insertResult = dao.insertTicket(ticket);

	                if(insertResult == 0){
	                    ticketCnt = 0;
	                    break;
	                }
	            } 
	            // 기존 티켓 정보 변경 시 티켓 정보 수정
	            else{
	            	int updateResult = dao.updateTicket(ticket);
	            	
	            	if(updateResult == 0){
	                    ticketCnt = 0;
	                    break;
	                }

	                oldTicketMap.remove(ticket.getTicket_id());
	            }
	        }
	    }
	    
	    // ===============================
	    // 4. 삭제 처리 : 수정하면서 삭제되는 티켓 정보
	    // ===============================
	    for(Integer deleteId : oldTicketMap.keySet()){
	        int deleteResult = dao.deleteTicket(deleteId);

	        if(deleteResult == 0){
	            ticketCnt = 0;
	            break;
	        }
	    }
	    
	    // ===============================
	    // 5. 결과
	    // ===============================

	    if(placeUpdateCnt>0 && festivalUpdateCnt>0 && ticketCnt >0){
	        return 1;
	    }else{
	        return 0;
	    }
	}

	// 신규 축제 등록
	@Override
	@Transactional
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
		
		// 기존 DB에 있는 축제인지 확인
		Integer placeId = dao.checkDuplication(dto);
		System.out.println("placeId : "+ placeId);
		int insertCntPlace = 0; 
		if(placeId == null){
	        // 새로운 장소 DB에 추가
			insertCntPlace = dao.insertPlace(plDto);
	    	placeId = plDto.getPlace_id();
		
	    	// Place 테이블에 먼저 추가 시도하여 성공 시 
			dto.setFestival_id(placeId);
			int insertFestivalCnt = dao.insertFestival(dto);
			
			// Festival 테이블에 추가 시도하여 성공 시
			if(insertFestivalCnt > 0) {
				int insertCnt = 0; 
				
				// FestivalTicketDTO에 담을 변수 
				String[] ticket_types = {"Free", "OneDay", "TwoDay", "AllDay"}; // 무료, 1일권, 2일권, 전일권 구분  
				
				for(int i = 0; i < ticket_types.length; i++) {
					FestivalTicketDTO ticketDTO = new FestivalTicketDTO();
					
					ticketDTO.setFestival_id(placeId);
					
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
			System.out.println("이미 등록된 축제");
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
	public void insertFestivalsFromApi(String json, HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException  {
		List<FestivalDTO> list = parseFestivalJson(json);

		int successCnt = 0; 
		
		for(FestivalDTO dto : list){
		    PlaceDTO place = dto.getPlaceDTO();
		    Integer placeId = dao.checkDuplication(dto);

		    if(placeId == null){
		        // 새로운 장소
		    	dao.insertPlace(place);
		    	
		    	// 새로 추가한 장소의 place_id 받아오기 
		    	placeId = place.getPlace_id();
		    	
		    	dto.setFestival_id(placeId);
			    int insertCnt = dao.insertFestival(dto);
			    
			    if(insertCnt > 0) {
			    	successCnt++; 
			    }
		    }
		}
		System.out.println("successCnt: " + successCnt);
		
		model.addAttribute("successCnt", successCnt); 
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
