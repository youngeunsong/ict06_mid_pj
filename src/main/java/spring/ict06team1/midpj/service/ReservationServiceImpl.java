package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
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
import spring.ict06team1.midpj.dao.UserDAO;
import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.dto.ReviewDTO;
import spring.ict06team1.midpj.dto.SurveyDTO;

@Service
public class ReservationServiceImpl implements ReservationService {

	@Autowired
	private SurveyServiceImpl svService;
    @Autowired
    public ReservationDAO resDao;
    @Autowired
    public RestaurantDAO restDao;
    @Autowired
    public AccommodationDAO accDao;
    @Autowired
    public FestivalDAO festDao;
    @Autowired
    public PointService pointService;
    @Autowired
    private org.apache.ibatis.session.SqlSession sqlSession;
    @Autowired
    private UserDAO userDao;

    @Value("${naverpay.client-id}")
    private String naverPayClientId;

    @Value("${naverpay.client-secret}")
    private String naverPayClientSecret;

    @Value("${naverpay.chain-id}")
    private String naverPayChainId;

    @Value("${naverpay.approve-url}")
    private String naverPayApproveUrl;
    

    // 1-1. 축제 예약 페이지에 필요한 데이터 조회
    @Override
    public FestivalDTO getFestivalTickets(int place_id) {
        System.out.println("[ReservationServiceImpl - getFestival()]");

        int festival_id = place_id;

        FestivalDTO festDto = resDao.getFestivalDetail(festival_id);
        PlaceDTO placeDto = resDao.getPlaceDetail(place_id);
        List<FestivalTicketDTO> ticketList = resDao.getFestivalTickets(festival_id);

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
 		String placeIdStr = request.getParameter("place_id");
 		String guestCountStr = request.getParameter("guest_count");
 		
 		System.out.println("place_id:" + placeIdStr);
 		System.out.println("guest_count:" + guestCountStr);
 		
 		if(placeIdStr == null || placeIdStr.trim().isEmpty()) {
 			throw new RuntimeException("place_id 없음");
 		}

 		if(guestCountStr == null || guestCountStr.trim().isEmpty()) {
 			throw new RuntimeException("guest_count 없음");
 		}
 		
 		dto.setPlace_id(Integer.parseInt(placeIdStr.trim()));
 		dto.setGuest_count(Integer.parseInt(guestCountStr.trim()));
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
 			String ticketIdStr = request.getParameter("ticket_id");
 			String visitDateStr = request.getParameter("visit_date");

 			if(visitDateStr == null || visitDateStr.trim().isEmpty()) {
 				throw new RuntimeException("방문일 없음");
 			}
 			
 			dto.setCheck_in(Date.valueOf(visitDateStr));

 			if(ticketIdStr != null && !ticketIdStr.trim().isEmpty()) {
 				//티켓 있는 축제 -> 선택 필수
 				if(ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
 					throw new RuntimeException("티켓 선택 필수");
 				}
 				
 				dto.setTicket_id(Integer.parseInt(ticketIdStr));
 				int price = resDao.getTicketPrice(dto.getTicket_id());
 				totalAmount = price * dto.getGuest_count();
 			}
 			else {
 				//무료 축제
 				totalAmount = 0;
 			}

 			if(totalAmount < 0)
 				throw new RuntimeException("결제 금액 오류");
 		}
 		//숙소: check_in, check_out
 		else if("ACC".equals(placeType)) {
 			String checkInStr = request.getParameter("check_in");
 			String checkOutStr = request.getParameter("check_out");
 			
 			if(checkInStr == null || checkInStr.trim().isEmpty()) {
 				throw new RuntimeException("체크인 날짜 없음");
 			}
 			if(checkOutStr == null || checkOutStr.trim().isEmpty()) {
 				throw new RuntimeException("체크아웃 날짜 없음");
 			}
 			
 			dto.setCheck_in(Date.valueOf(checkInStr));
 			dto.setCheck_out(Date.valueOf(checkOutStr));
 			
 			if(dto.getCheck_out().before(dto.getCheck_in())) {
 				throw new RuntimeException("체크아웃 날짜 오류");
 			}

 			int price = resDao.getAccommodationPrice(dto.getPlace_id());
 			long nights = (dto.getCheck_out().getTime() - dto.getCheck_in().getTime()) / (1000*60*60*24);
 			if(nights <= 0) {
 				throw new RuntimeException("숙박일수 오류");
 			}
 			
 			totalAmount = price * (int)nights;
 			if(totalAmount <= 0)
 				throw new RuntimeException("결제 금액 오류");
 		}
 		//맛집: visit_date, visit_time
 		else if("REST".equals(placeType)) {
 			String visitDateStr = request.getParameter("visit_date");
 			String visitTimeStr = request.getParameter("visit_time");
 			
 			if(visitDateStr == null || visitDateStr.trim().isEmpty()) {
 				throw new RuntimeException("방문일 없음");
 			}
 			if(visitTimeStr == null || visitTimeStr.trim().isEmpty()) {
 				throw new RuntimeException("방문시간 없음");
 			}

 			dto.setCheck_in(Date.valueOf(visitDateStr));
 		    dto.setVisit_time(visitTimeStr);

 		    // 맛집은 노쇼 방지 예약금: 인원수 * 1000원
 		    totalAmount = dto.getGuest_count() * 1000;

 		    if(totalAmount < 10) {
 		        throw new RuntimeException("맛집 예약금 금액 오류");
 		    }
 		}
 		
 		if("FEST".equals(placeType)) {
 			resDao.insertFestReservation(dto);
 		}
 		else if("ACC".equals(placeType)) {
 			resDao.insertAccReservation(dto);
 		}
 		else if("REST".equals(placeType)) {
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
    @Override
    public ReservationDTO getReservationById(String reservation_id) {
        System.out.println("[ReservationServiceImpl - getReservationById()]");
        return resDao.getReservationById(reservation_id);
    }

    // 4. 네이버페이 승인 처리
    @Override
    @Transactional
    public Map<String, Object> approveNaverPay(String paymentId, String reservationId, int usedPoint) {
        Map<String, Object> result = new HashMap<>();

        try {
            System.out.println("=== approveNaverPay 시작 ===");
            System.out.println("paymentId = " + paymentId);
            System.out.println("reservationId = " + reservationId);
            System.out.println("usedPoint = " + usedPoint);

            ReservationDTO reservation = resDao.getReservationById(reservationId);
            System.out.println("reservation = " + reservation);

            if (reservation == null) {
                result.put("success", false);
                result.put("msg", "예약 정보를 찾을 수 없습니다.");
                result.put("reservationId", reservationId);
                result.put("paymentId", paymentId);
                return result;
            }

            if ("RESERVED".equals(reservation.getStatus())) {
                result.put("success", true);
                result.put("msg", "이미 승인 완료된 예약입니다.");
                result.put("reservationId", reservationId);
                result.put("paymentId", paymentId);
                return result;
            }

            int originalAmount = reservation.getAmount();
            int finalAmount = originalAmount - usedPoint;
            if (finalAmount < 0) {
                finalAmount = 0;
            }

            Map<String, Object> approveResponse = callNaverPayApproveApi(paymentId, reservation);
            System.out.println("approveResponse = " + approveResponse);

            boolean apiSuccess = Boolean.TRUE.equals(approveResponse.get("success"));

            if (!apiSuccess) {
                result.put("success", false);
                result.put("msg", "네이버페이 승인 실패");
                result.put("reservationId", reservationId);
                result.put("paymentId", paymentId);
                result.put("apiResponse", approveResponse);
                return result;
            }

            // 포인트 차감
            if (usedPoint > 0) {
                boolean pointResult = pointService.usePoint(reservation.getUser_id(), usedPoint, reservationId);
                if (!pointResult) {
                    throw new RuntimeException("포인트 차감 실패");
                }
            }

            // 최종 결제금액 반영
            Map<String, Object> amountMap = new HashMap<String, Object>();
            amountMap.put("reservation_id", reservationId);
            amountMap.put("amount", finalAmount);

            int amountUpdateCnt = resDao.updatePaymentAmount(amountMap);

            // 기존 상태 변경 로직 유지
            int paymentUpdateCnt = resDao.updatePaymentStatusPaid(reservationId);
            int reservationUpdateCnt = resDao.updateReservationStatusConfirmed(reservationId);

            if (amountUpdateCnt == 0 || paymentUpdateCnt == 0 || reservationUpdateCnt == 0) {
                throw new RuntimeException("DB 상태 변경 실패");
            }

            result.put("success", true);
            result.put("msg", "결제 승인 및 예약 확정 완료");
            result.put("reservationId", reservationId);
            result.put("paymentId", paymentId);
            result.put("usedPoint", usedPoint);
            result.put("finalAmount", finalAmount);
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
    public Map<String, Object> callNaverPayApproveApi(String paymentId, ReservationDTO reservation) {
        Map<String, Object> result = new HashMap<String, Object>();

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

            HttpHeaders headers = new HttpHeaders();
            headers.set("X-Naver-Client-Id", clientId);
            headers.set("X-Naver-Client-Secret", clientSecret);
            headers.set("X-NaverPay-Chain-Id", chainId);
            headers.set("X-NaverPay-Idempotency-Key", UUID.randomUUID().toString());
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            MultiValueMap<String, String> body = new LinkedMultiValueMap<String, String>();
            body.add("paymentId", paymentId);

            HttpEntity<MultiValueMap<String, String>> requestEntity =
                    new HttpEntity<MultiValueMap<String, String>>(body, headers);

            ResponseEntity<String> response =
                    restTemplate.postForEntity(approveUrl, requestEntity, String.class);

            System.out.println("response status = " + response.getStatusCodeValue());
            System.out.println("response body = " + response.getBody());

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
	
	@Override
	public List<Map<String, Object>> getRestTimeReservationCount(int place_id, String visit_date) {
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("place_id", place_id);
	    map.put("visit_date", Date.valueOf(visit_date));
	    return resDao.getRestTimeReservationCount(map);
	}

	@Override
	public int countRestReservationByDateTime(int place_id, String visit_date, String visit_time) {
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("place_id", place_id);
	    map.put("visit_date", Date.valueOf(visit_date));
	    map.put("visit_time", visit_time);
	    return resDao.countRestReservationByDateTime(map);
	}

	// 설문 + 리뷰 등록 처리
	@Override
	public void surveyReviewAction(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {
	    System.out.println("ReservationServiceImpl - surveyReviewAction()");

	    // 1. 세션 아이디 확인
	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    if (sessionID == null) {
	        model.addAttribute("result", 0);
	        model.addAttribute("msg", "로그인 후 이용 가능합니다.");
	        return;
	    }

	    // 2. 파라미터 받기
	    String reservation_id = request.getParameter("reservation_id");
	    String strSatisfaction = request.getParameter("page_satisfaction_score");
	    String strNps = request.getParameter("page_nps_score");
	    String strReliability = request.getParameter("page_info_reliability_score");
	    String inconvenience = request.getParameter("inconvenience");
	    String improvements = request.getParameter("improvements");
	    String strRating = request.getParameter("page_rating");
	    String content = request.getParameter("content");
	    
	    System.out.println("reservation_id = " + reservation_id);
	    System.out.println("strSatisfaction = [" + strSatisfaction + "]");
	    System.out.println("strNps = [" + strNps + "]");
	    System.out.println("strReliability = [" + strReliability + "]");
	    System.out.println("strRating = [" + strRating + "]");
	    System.out.println("content = [" + content + "]");
	    
	    // 2-1. 필수값 체크
	    if (reservation_id == null || reservation_id.trim().isEmpty()) {
	        model.addAttribute("result", 0);
	        model.addAttribute("msg", "예약 정보가 누락되었습니다.");
	        return;
	    }

	    if (strSatisfaction == null || strSatisfaction.trim().isEmpty()
	            || strNps == null || strNps.trim().isEmpty()
	            || strReliability == null || strReliability.trim().isEmpty()
	            || strRating == null || strRating.trim().isEmpty()) {
	        model.addAttribute("result", 0);
	        model.addAttribute("msg", "필수 평가 항목을 모두 입력해주세요.");
	        return;
	    }

	    if (content == null || content.trim().isEmpty()) {
	        model.addAttribute("result", 0);
	        model.addAttribute("msg", "리뷰 내용을 입력해주세요.");
	        return;
	    }

	    // 3. SurveyDTO 세팅
	    SurveyDTO surveyDto = new SurveyDTO();
	    surveyDto.setUser_id(sessionID);
	    surveyDto.setReservation_id(reservation_id);
	    surveyDto.setSatisfaction_score(Integer.parseInt(strSatisfaction));
	    surveyDto.setNps_score(Integer.parseInt(strNps));
	    surveyDto.setInfo_reliability_score(Integer.parseInt(strReliability));
	    surveyDto.setInconvenience(inconvenience);
	    surveyDto.setImprovements(improvements);

	    // 4. ReviewDTO 세팅
	    ReviewDTO reviewDto = new ReviewDTO();
	    reviewDto.setUser_id(sessionID);
	    reviewDto.setReservation_id(reservation_id);
	    reviewDto.setRating(Integer.parseInt(strRating));
	    reviewDto.setContent(content);

	    // 5. 설문 저장
	    Map<String, Object> surveyResult = svService.insertSurvey(surveyDto);

	    if (!(Boolean) surveyResult.get("success")) {
	        model.addAttribute("result", 0);
	        model.addAttribute("msg", surveyResult.get("msg"));
	        return;
	    }

	    // 6. 리뷰 저장
	    Map<String, Object> reviewResult = svService.insertReview(reviewDto, reservation_id);

	    if (!(Boolean) reviewResult.get("success")) {
	        model.addAttribute("result", 0);
	        model.addAttribute("msg", reviewResult.get("msg"));
	        return;
	    }
	    
	    // 7. 포인트 지급
	    Map<String, Object> pointMap = new HashMap<String, Object>();
	    pointMap.put("userId", sessionID);
	    pointMap.put("policyKey", "EARN_SURVEY&REVIEW");
	    pointMap.put("description", "리뷰/설문 작성 적립 - 예약번호: " + reservation_id);

	    int pointCnt = resDao.insertReviewPoint(pointMap);

	    System.out.println("pointCnt = " + pointCnt);
	    // 8. 성공 처리
	    model.addAttribute("result", 1);
	    model.addAttribute("msg", "리뷰와 설문이 정상 등록되었습니다.");
	    
	}
}