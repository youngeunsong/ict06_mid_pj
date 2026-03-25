package spring.ict06team1.midpj.service;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import spring.ict06team1.midpj.dao.AccommodationDAO;
import spring.ict06team1.midpj.dao.FestivalDAO;
import spring.ict06team1.midpj.dao.ReservationDAO;
import spring.ict06team1.midpj.dao.RestaurantDAO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;

@Service
public class ReservationServiceImpl implements ReservationService {

	@Autowired
	public ReservationDAO resDao;
	@Autowired
	public RestaurantDAO restDao;
	@Autowired
	public AccommodationDAO accDao;
	@Autowired
	public FestivalDAO festDao;
	
	// 네이버페이 승인 API 호출에 필요한 설정값
	@Value("${naverpay.client-id}")
	private String naverPayClientId;

	@Value("${naverpay.client-secret}")
	private String naverPayClientSecret;

	@Value("${naverpay.chain-id}")
	private String naverPayChainId;

	@Value("${naverpay.approve-url}")
	private String naverPayApproveUrl;

	// 1-1. 축제 예약 페이지에 필요한 데이터 조회
	// place_id를 기준으로 축제 정보, 장소 정보, 티켓 목록을 묶어서 반환
	@Override
	public FestivalDTO getFestivalTickets(int place_id) {
		System.out.println("[ReservationServiceImpl - getFestival()]");
		
		// 현재 구조에서는 place_id와 festival_id를 같은 값으로 사용
		int festival_id = place_id;
		
		// 축제 정보, 장소 정보 조회
		FestivalDTO festDto = resDao.getFestivalDetail(festival_id);
		PlaceDTO placeDto = resDao.getPlaceDetail(place_id);
		
		// 티켓 목록 조회
		List<FestivalTicketDTO> ticketList = resDao.getFestivalTickets(festival_id);
		
		// 조회한 데이터를 FestivalDTO에 묶어서 반환
		festDto.setPlaceDTO(placeDto);
		festDto.setTicketList(ticketList);
		
		return festDto;
	}
	
	// 2. 예약 + 결제 예정 정보 저장
	// 예약 생성과 결제 예정 데이터 저장을 하나의 트랜잭션으로 처리
	@Override
	@Transactional
	public Map<String, Object> createReservation(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[ReservationServiceImpl - createReservation()]");
		
		ReservationDTO dto = new ReservationDTO();
		String placeType = request.getParameter("place_type");
		
		// 공통 요청값 DTO에 세팅
		dto.setPlace_id(Integer.parseInt(request.getParameter("place_id")));
		dto.setGuest_count(Integer.parseInt(request.getParameter("guest_count")));
		dto.setRequest_note(request.getParameter("request_note"));
		
		// 로그인한 사용자 id 세팅
		String user_id = (String)request.getSession().getAttribute("sessionID");
		dto.setUser_id(user_id);
		
		// 기본 유효성 검사
		if(user_id == null) {
			throw new RuntimeException("로그인한 회원만 예약할 수 있음");
		}
		
		if(dto.getGuest_count() <= 0) {
			throw new RuntimeException("인원 수 확인");
		}
		
		int totalAmount = 0;
		
		//장소종류별 추가 요청값 세팅
		//축제: ticket_id, visit_date
		if("FEST".equals(placeType)) {
			dto.setTicket_id(Integer.parseInt(request.getParameter("ticket_id")));
			dto.setCheck_in(Date.valueOf(request.getParameter("visit_date")));
			
			int price = resDao.getTicketPrice(dto.getTicket_id());
			totalAmount = price * dto.getGuest_count();
			if(totalAmount <= 0)
				throw new RuntimeException("결제 금액 오류");
		}
		//숙소: check_in, check_out
		else if("ACC".equals(placeType)) {
			dto.setCheck_in(Date.valueOf(request.getParameter("check_in")));
			dto.setCheck_out(Date.valueOf(request.getParameter("check_out")));

			int price = resDao.getAccommodationPrice(dto.getPlace_id());
			long nights = (dto.getCheck_out().getTime() - dto.getCheck_in().getTime()) / (1000*60*60*24);
			totalAmount = price * (int)nights;
			if(totalAmount <= 0)
				throw new RuntimeException("결제 금액 오류");
		}
		//맛집: visit_date, visit_time
		else if("REST".equals(placeType)) {
		    dto.setCheck_in(Date.valueOf(request.getParameter("visit_date")));
		    dto.setVisit_time(request.getParameter("visit_time"));

		    // 맛집은 노쇼 방지 예약금: 인원수 * 1000원
		    totalAmount = dto.getGuest_count() * 1000;

		    if(totalAmount < 10) {
		        throw new RuntimeException("맛집 예약금 금액 오류");
		    }
		}
		
		//예약 저장
		if("FEST".equals(placeType)) {
			resDao.insertFestReservation(dto);
		}
		else if("ACC".equals(placeType)) {
			resDao.insertAccReservation(dto);
		}
		if("REST".equals(placeType)) {
			resDao.insertRestReservation(dto);
		}

		//결제 예정 정보 저장(무료예약도 amount=0으로 저장)
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", dto.getUser_id());
		map.put("reservation_id", dto.getReservation_id());
		map.put("amount", totalAmount);
		map.put("payment_method", "CARD");
		
		resDao.insertPayment(map);
		dto.setPayment_id((String)map.get("payment_id"));
		
		//프론트에 반환할 값 구성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("reservation_id", dto.getReservation_id());
		result.put("payment_id", dto.getPayment_id());
		result.put("msg", "예약 완료");
		
		return result;
	}
	
	// 3. 예약 1건 조회
	// 예약 확인 페이지나 결제 승인 처리에 사용할 예약 1건 조회
	@Override
	public ReservationDTO getReservationById(String reservation_id) {
		System.out.println("[ReservationServiceImpl - getReservationById()]");
		return resDao.getReservationById(reservation_id);
	}
	
	// 4. 네이버페이 승인 처리
	// paymentId로 네이버페이 승인 API를 호출하고, 성공 시 결제/예약 상태를 변경
	@Override
	@Transactional
	public Map<String, Object> approveNaverPay(String paymentId, String reservationId) {
	    Map<String, Object> result = new HashMap<>();

	    try {
	        System.out.println("=== approveNaverPay 시작 ===");
	        System.out.println("paymentId = " + paymentId);
	        System.out.println("reservationId = " + reservationId);

	        // 예약 정보 조회
	        ReservationDTO reservation = resDao.getReservationById(reservationId);
	        System.out.println("reservation = " + reservation);

	        // 예약이 없는 경우 실패 처리
	        if (reservation == null) {
	            result.put("success", false);
	            result.put("msg", "예약 정보를 찾을 수 없습니다.");
	            result.put("reservationId", reservationId);
	            result.put("paymentId", paymentId);
	            return result;
	        }

	        // 이미 승인 완료된 예약인지 확인
	        // 현재 상태값 구조상 RESERVED로 바꾸는 게 더 자연스러움
	        if ("CONFIRMED".equals(reservation.getStatus())) {
	            result.put("success", true);
	            result.put("msg", "이미 승인 완료된 예약입니다.");
	            result.put("reservationId", reservationId);
	            result.put("paymentId", paymentId);
	            return result;
	        }

	        // 네이버페이 승인 API 호출
	        Map<String, Object> approveResponse = callNaverPayApproveApi(paymentId, reservation);
	        System.out.println("approveResponse = " + approveResponse);

	        boolean apiSuccess = Boolean.TRUE.equals(approveResponse.get("success"));

	        // 승인 실패 시 결과 반환
	        if (!apiSuccess) {
	            result.put("success", false);
	            result.put("msg", "네이버페이 승인 실패");
	            result.put("reservationId", reservationId);
	            result.put("paymentId", paymentId);
	            result.put("apiResponse", approveResponse);
	            return result;
	        }

	        // 승인 성공 시 PAYMENT / RESERVATION 상태 변경
	        int paymentUpdateCnt = resDao.updatePaymentStatusPaid(reservationId);
	        int reservationUpdateCnt = resDao.updateReservationStatusConfirmed(reservationId);

	        if (paymentUpdateCnt == 0 || reservationUpdateCnt == 0) {
	            throw new RuntimeException("DB 상태 변경 실패");
	        }

	        // 최종 성공 결과 반환
	        result.put("success", true);
	        result.put("msg", "결제 승인 및 예약 확정 완료");
	        result.put("reservationId", reservationId);
	        result.put("paymentId", paymentId);
	        result.put("apiResponse", approveResponse);

	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("success", false);
	        result.put("msg", "승인 처리 중 오류 발생");
	        result.put("reservationId", reservationId);
	        result.put("paymentId", paymentId);
	        result.put("error", e.getClass().getName() + " : " + e.getMessage());
	    }

	    return result;
	}

	// 5. 네이버페이 승인 API 호출
	// paymentId를 네이버페이에 보내 최종 승인 요청을 수행
	private Map<String, Object> callNaverPayApproveApi(String paymentId, ReservationDTO reservation) {
	    Map<String, Object> result = new HashMap<>();

	    try {
	        String clientId = naverPayClientId;
	        String clientSecret = naverPayClientSecret;
	        String chainId = naverPayChainId;
	        String approveUrl = naverPayApproveUrl;

	        System.out.println("=== callNaverPayApproveApi 시작 ===");
	        System.out.println("approveUrl = " + approveUrl);
	        System.out.println("paymentId = " + paymentId);
	        System.out.println("reservationId = " + reservation.getReservation_id());
	        System.out.println("amount = " + reservation.getAmount());
	        System.out.println("clientId = " + clientId);
	        System.out.println("chainId = " + chainId);

	        RestTemplate restTemplate = new RestTemplate();

	        // 네이버페이 승인 요청 헤더 구성
	        HttpHeaders headers = new HttpHeaders();
	        headers.set("X-Naver-Client-Id", clientId);
	        headers.set("X-Naver-Client-Secret", clientSecret);
	        headers.set("X-NaverPay-Chain-Id", chainId);
	        headers.set("X-NaverPay-Idempotency-Key", UUID.randomUUID().toString());
	        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

	        // 요청 바디에는 paymentId를 담아서 전송
	        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
	        body.add("paymentId", paymentId);

	        HttpEntity<MultiValueMap<String, String>> requestEntity =
	                new HttpEntity<>(body, headers);

	        // 네이버페이 승인 API 호출
	        ResponseEntity<String> response =
	                restTemplate.postForEntity(approveUrl, requestEntity, String.class);

	        System.out.println("response status = " + response.getStatusCodeValue());
	        System.out.println("response body = " + response.getBody());

	        // 응답 결과 저장
	        result.put("success", response.getStatusCode().is2xxSuccessful());
	        result.put("status", response.getStatusCodeValue());
	        result.put("body", response.getBody());

	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("success", false);
	        result.put("error", e.getClass().getName() + " : " + e.getMessage());
	    }

	    return result;
	}
}