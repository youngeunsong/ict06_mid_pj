package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.SearchCriteria.Paging;
import spring.ict06team1.midpj.dao.UserDAO;
import spring.ict06team1.midpj.dto.InquiryDTO;
import spring.ict06team1.midpj.dto.MemberDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;



@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDAO dao;
	
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	
	// 1. 아이디 중복 확인 (AJAX 사용, 중복이면 1 아니면 0 반환)
	@Override
	public void idCheck(HttpServletRequest request, HttpServletResponse response, Model model)
	    throws ServletException, IOException {
	    System.out.println("UserServiceImpl - idCheck()");
	    
	    String user_id = request.getParameter("user_id");
	    
	    if(user_id != null) {
	        user_id = user_id.trim();
	    }
	    
	    int selectCnt = 0;
	    
	    // 유효성 검사: 아이디가 null이거나 6자 미만인 경우
	    if (user_id == null || user_id.length() < 6) {
	        // DB를 조회하지 않고 바로 '사용 불가(1)' 상태로 반환
	        selectCnt = 1; 
	    } else {
	        // 6자 이상일 때만 실제 DB 중복 체크 진행
	        selectCnt = dao.idCheck(user_id);
	    }
	    
	    model.addAttribute("selectCnt", selectCnt);
	    model.addAttribute("user_id", user_id);
	}
    // 2. 회원가입 처리
	@Override
	public void joinAction(HttpServletRequest request, HttpServletResponse response, Model model)
	    throws ServletException, IOException {
	    System.out.println("UserServiceImpl - joinAction(보안강화)");

	    // 1. 값 가져오기 
	    String user_id = request.getParameter("user_id");
	    String password = request.getParameter("password");
	    String name = request.getParameter("name");
	    String birth_date = request.getParameter("birth_date");
	    String gender = request.getParameter("gender");
	    String address = request.getParameter("address");

	    // 2-1. 아이디에 'admin'이 포함되어 있는지 확인 (소문자로 변환해서 체크)
	    if (user_id != null && user_id.toLowerCase().contains("admin")) {
	    	// 아이디에 admin이 포함되면 가입 절차를 진행하지 않고 중단
	        System.out.println("중단: 관리자 키워드가 포함된 아이디입니다.");
	        model.addAttribute("errorMsg", "사용할 수 없는 아이디입니다.");
	        return;
	    }
	    
	    // 2-2. [핵심 보안] 서버에서 한 번 더 검사 (입구 컷)
	    // 아이디가 없거나 비밀번호가 너무 짧으면 DB에 넣지 않고 바로 리턴!
	    if (user_id == null || user_id.length() < 6) {
	        model.addAttribute("insertCnt", -1); // 아이디가 너무 짧음
	        return;
	    }
	    
	    // 아이디 중복 확인 (DB를 다시 조회해서 진짜 없는지 확인)
	    int idCheckCnt = dao.idCheck(user_id);
	    if (idCheckCnt > 0) {
	        model.addAttribute("insertCnt", -2); // 이미 존재하는 아이디
	        return;
	    }

	    if (password == null || password.length() < 8) {
	        model.addAttribute("insertCnt", -3); // 비밀번호가 너무 짧음
	        return;
	    }

	    // 3. DTO 객체 생성 및 데이터 세팅
	    MemberDTO dto = new MemberDTO();
	    dto.setUser_id(user_id);
	    dto.setPassword(bcryptPasswordEncoder.encode(password));
	    dto.setName(name);
	    dto.setGender(gender);
	    
	    // 주소가 없으면 '미입력'으로 채워주기 (NULL 처리)
	    if (address == null || address.equals("")) {
	        dto.setAddress("미입력");
	    } else {
	        dto.setAddress(address);
	    }

	    // 날짜 처리
	    if (birth_date != null && !birth_date.equals("")) {
	        dto.setBirth_date(java.sql.Date.valueOf(birth_date));
	    }

	    // 전화번호 합치기
	    String hp1 = request.getParameter("phone1");
	    String hp2 = request.getParameter("phone2");
	    String hp3 = request.getParameter("phone3");
	    if (hp1 != null && !hp1.equals("")) {
	        dto.setPhone(hp1 + "-" + hp2 + "-" + hp3);
	    }

	    // 이메일 합치기
	    String email1 = request.getParameter("email1");
	    String email2 = request.getParameter("email2");
	    dto.setEmail(email1 + "@" + email2);

	    // 4. 기본값 설정 (비즈니스 로직)
	    dto.setPoint_balance(0);      // 신규 가입은 0포인트
	    dto.setRole("ROLE_USER");     // 무조건 일반 유저로 가입 (관리자 조작 방지)
	    dto.setStatus("ACTIVE");      // 가입 즉시 활동 상태

	    // 5. DB에 저장
	    int insertCnt = dao.insertUser(dto);
	    
	    // 결과 전달 (1이면 성공, 0이면 실패)
	    model.addAttribute("insertCnt", insertCnt);
	}

	// 3. 로그인 처리 / 회원정보 인증 (아이디와 비번을 받아 일치하는 회원이 있는지 확인)
	@Override
	public void loginAction(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
		System.out.println("UserServiceImpl - loginAction()");
		
		String user_id = request.getParameter("user_id");
		String password = request.getParameter("password");
		
		int selectCnt = 0;
		
		/*
		 * Map<String, Object> map = new HashMap<String, Object>(); map.put("user_id",
		 * user_id); map.put("password", password); int idExist = dao.loginCheck(map);
		 */
		
		//ID 존재 여부 확인
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", user_id);
		int idExist = dao.loginCheck(map);
		
		if(idExist == 1) {
			MemberDTO dto = dao.getUserDetail(user_id);
			//BCrypt로 비밀번호 검증
			if(bcryptPasswordEncoder.matches(password, dto.getPassword())) {
				selectCnt = 1;
				request.getSession().setAttribute("sessionID", user_id);
				//세션 무효화 설정(30분=1800초 기준)
				//30분 지나거나 브라우저 종료 시 세션 무효화 됨
				request.getSession().setMaxInactiveInterval(1800);
				request.getSession().setAttribute("userRole", dto.getRole());
			}
		}
		
		/*
		 * // 권한 정보 가져오기 MemberDTO dto = dao.getUserDetail(user_id); if(dto != null) {
		 * // 세션에 role(ADMIN 또는 USER) request.getSession().setAttribute("userRole",
		 * dto.getRole()); } }
		 */
		
		model.addAttribute("selectCnt", selectCnt);
		request.setAttribute("user_id", user_id);
		request.setAttribute("selectCnt", selectCnt);
	}
	
	// 3-1. 비밀번호 찾기
	@Override
	public void findPasswordAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("UserServiceImpl - findPasswordAction()");
		
		//ID, 이름, 이메일로 정보 확인
		String user_id = request.getParameter("user_id");
		String name = request.getParameter("name");
		
		String email1 = request.getParameter("email1");
		String email2 = request.getParameter("email2");
		String email = email1 + "@" + email2;
		
		System.out.println("user_id:" + user_id);
		System.out.println("name:" + name);
		System.out.println("email:" + email);
		
		//정보 일치하는 회원 확인
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", user_id);
		map.put("name", name);
		map.put("email", email);
		
		int cnt = dao.findPasswordCheck(map);
		
		if(cnt == 1) {
			//임시 비밀번호 생성(영문+숫자 8자리)
			String tempPassword = generateTempPassword();
			
			//BCrypt 암호화 후 DB 업데이트
			String encodedPassword = bcryptPasswordEncoder.encode(tempPassword);
			Map<String, Object> updateMap = new HashMap<String, Object>();
			updateMap.put("user_id", user_id);
			updateMap.put("password", encodedPassword);
			
			dao.updatePassword(updateMap);
			
			model.addAttribute("result", "success");
			model.addAttribute("tempPassword", tempPassword); //임시 발급된 비밀번호가 화면에 표시됨
		} else {
			model.addAttribute("result", "fail");
		}
	}
	
	//임시 비밀번호 생성
	private String generateTempPassword() {
		String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		StringBuilder sb = new StringBuilder();
		Random random = new Random();
		
		for(int i=0; i<8; i++) {
			sb.append(chars.charAt(random.nextInt(chars.length())));
		}
		return sb.toString();
	}

    // 4. 회원정보 인증처리 및 탈퇴(논리삭제 방식)
	@Override
	public void deleteUserAction(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
		System.out.println("UserServiceImpl - deleteUserAction()");
		
		String sessionID =(String)request.getSession().getAttribute("sessionID");
		String password = request.getParameter("password");
		
		MemberDTO memberDto = dao.getUserDetail(sessionID);
		int selectCnt = 0;
		int deleteCnt = 0;
		
		if(memberDto != null && bcryptPasswordEncoder.matches(password, memberDto.getPassword())) {
			selectCnt = 1;
			deleteCnt = dao.deleteUser(sessionID);
			if(deleteCnt == 1) {
				request.getSession().invalidate();
			}
		}
		model.addAttribute("selectCnt", selectCnt);
		model.addAttribute("deleteCnt", deleteCnt);
		
		/*
		 * Map<String, Object> map = new HashMap<String, Object>(); map.put("user_id",
		 * sessionID); map.put("password", password);
		 * 
		 * // 회원정보 인증처리 int selectCnt = dao.loginCheck(map); int deleteCnt = 0;
		 * if(selectCnt == 1) {
		 * 
		 * deleteCnt = dao.deleteUser(sessionID);
		 * 
		 * if(deleteCnt == 1) { request.getSession().invalidate(); } }
		 * model.addAttribute("selectCnt", selectCnt); model.addAttribute("deleteCnt",
		 * deleteCnt);
		 */
	}

	// 5. 회원정보 인증처리 및 상세페이지 조회(마이페이지에서 사용)
	@Override
	public void modifyDetailPage(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
		System.out.println("UserServiceImpl - modifyDetailPage()");
		
		String sessionID =(String)request.getSession().getAttribute("sessionID");
		String password = request.getParameter("password");
		
		MemberDTO memberDto = dao.getUserDetail(sessionID);
		int selectCnt = 0;
		
		if(memberDto != null && bcryptPasswordEncoder.matches(password, memberDto.getPassword())) {
			selectCnt = 1;
		/*
		 * HashMap<String, Object>(); map.put("user_id", sessionID); map.put("password",
		 * password);
		 * 
		 * int selectCnt = dao.loginCheck(map);
		 * 
		 * MemberDTO dto = null; // 회원정보 인증 성공시 if(selectCnt == 1) { // 회원 상세 페이지 dto =
		 * dao.getUserDetail(sessionID);
		 */
		 
		 model.addAttribute("dto", memberDto);
		}
		model.addAttribute("selectCnt", selectCnt);
	}

	// 6. 회원정보 수정
	@Override
	public int modifyUserAction(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
		System.out.println("UserServiceImpl - modifyUserAction()");
		
		//1. DTO 객체 생성
		MemberDTO dto = new MemberDTO();

		// 1. jsp에서 보낸 파라미터 받기
		String user_id = request.getParameter("user_id");
		String password = request.getParameter("password");
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String gender = request.getParameter("gender");
		String strBirth = request.getParameter("birth_date");
		
		// 2. dto 객체 생성 및 데이터 세팅
		dto.setUser_id(user_id);
		dto.setPassword(bcryptPasswordEncoder.encode(password));
		dto.setName(name);
		dto.setEmail(email);
		dto.setPhone(phone);
		dto.setAddress(address);
		dto.setGender(gender);
		
		// 3. 날짜 처리 (문자열 -> java.sql.Date)
	    if (strBirth != null && !strBirth.equals("")) {
	        try {
	            dto.setBirth_date(java.sql.Date.valueOf(strBirth));
	        } catch (IllegalArgumentException e) {
	            System.out.println("날짜 형식 오류: " + strBirth);
	        }
	    }

	    // 4. DAO 호출하여 DB 업데이트 실행
	    int updateCnt = dao.updateUser(dto);
	    
	    // 5. 결과 반환 (1이면 성공, 0이면 실패)
	    return updateCnt;
	}
	
	// 7. 나의 즐겨찾기 목록 조회
	@Override
	public void viewBookmarksAction(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {
	    System.out.println("UserServiceImpl - viewBookmarksAction()");

	    // 1. 세션에서 아이디 꺼내기
	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    // 2. 필터값(category) 받기
	    String category = request.getParameter("category");

	    // 3. 기본값 처리
	    if (category == null || category.trim().equals("")) {
	        category = "all";
	    }

	    // 4. 페이지 번호 받기
	    String pageNum = request.getParameter("pageNum");

	    // 5. 페이징 객체 생성
	    Paging paging = new Paging(pageNum);
	    paging.setPageSize(8);   // 한 페이지당 카드 8개

	    // 6. DAO 전달용 map
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("user_id", sessionID);
	    map.put("category", category);

	    // 7. 전체 개수 조회
	    int count = dao.getFavoriteListCount(map);

	    // 8. 페이징 계산
	    paging.setTotalCount(count);

	    // 9. startRow, endRow 추가
	    map.put("start", paging.getStartRow());
	    map.put("end", paging.getEndRow());

	    // 10. 목록 조회
	    List<PlaceDTO> list = dao.getFavoriteList(map);

	    // 11. jsp 전달
	    model.addAttribute("list", list);
	    model.addAttribute("paging", paging);
	    model.addAttribute("category", category);
	}
	
	// 마이페이지 홈 카운트
	@Override
	public void myPageHomeAction(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {
	    System.out.println("UserServiceImpl - myPageHomeAction()");

	    String sessionID = (String) request.getSession().getAttribute("sessionID");
	    
	    // 회원정보 조회
	    MemberDTO dto = dao.getUserDetail(sessionID);
	    
	    // 각 활동 수 조회
	    int bookmarkCount = dao.getFavoriteCount(sessionID);
	    int inquiryCount = dao.getInquiryCount(sessionID);
	    int reservationCount = dao.getReservationCount(sessionID);

	    model.addAttribute("bookmarkCount", bookmarkCount);
	    model.addAttribute("inquiryCount", inquiryCount);
	    model.addAttribute("reservationCount", reservationCount);
	    
	    // =================================================
	    // 마이페이지 홈 하단 카테고리별 top3
	    
	    // 공통 파라미터 map 생성
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("user_id", sessionID);

	    // 맛집 TOP3 (REST)
	    map.put("category", "REST");
	    List<PlaceDTO> topRestList = dao.getFavoriteTop3ByCategory(map);

	    // 숙소 TOP3 (ACC)
	    map.put("category", "ACC");
	    List<PlaceDTO> topAccList = dao.getFavoriteTop3ByCategory(map);

	    // 축제 TOP3 (FEST)
	    map.put("category", "FEST");
	    List<PlaceDTO> topFestList = dao.getFavoriteTop3ByCategory(map);

	    // JSP 전달
	    model.addAttribute("dto",dto);
	    model.addAttribute("topRestList", topRestList);
	    model.addAttribute("topAccList", topAccList);
	    model.addAttribute("topFestList", topFestList);
	}
	
	// 나의 문의 목록 조회
	@Override
	public void viewInquiriesAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("UserServiceImpl - viewInquiriesAction()");
		
		// 1. 세션에서 아이디 꺼내기
		String sessionID = (String)request.getSession().getAttribute("sessionID");
		
		// 2. 파라미터 받기 (현재 페이지 번호, 필터링할 상태값)
		String pageNum = request.getParameter("pageNum");
		String status = request.getParameter("status");
		
		// 3. 상태값이 없을 경우 기본값 'all'로 설정(에러방지)
		if (status == null || status.equals("")) {
			status = "all";
		}
		
		// 4. 페이징 객체 생성 및 전체 문의글 개수 조회
		spring.ict06team1.midpj.SearchCriteria.Paging paging = new spring.ict06team1.midpj.SearchCriteria.Paging(pageNum);
		
		// DAO에 던질 파라미터 묶기 (아이디와 필터링 상태)
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", sessionID);
		map.put("status", status);
		
		// 내 조건에 맞는 전체 글 개수 가져오기
		int totalCount = dao.selectMyInquiryCount(map);
		System.out.println("전체 문의 개수 => " + totalCount);
		
		// 5. 페이징 계산 실행 (이걸 호출해야 startRow, endRow가 계산됨)
		paging.setTotalCount(totalCount);
		
		// 6. 계산된 시작번호와 끝번호를 다시 map에 담기
		map.put("start", paging.getStartRow());
		map.put("end", paging.getEndRow());
		
		// 7. 실제 목록 조회 실행
		List<InquiryDTO> list = dao.selectMyInquiryList(map);
		
		// 8. JSP로 보낼 데이터들 모델에 담기
		model.addAttribute("MyInquiryList", list);         // 문의 목록 리스트
		model.addAttribute("paging", paging);     // 페이징 계산 객체
		model.addAttribute("status", status);     // 선택한 필터 상태 유지용
		model.addAttribute("totalCount", totalCount); // 전체 개수 표시용
		
		System.out.println("조회된 총 개수: " + totalCount);
		System.out.println("시작 번호(start): " + paging.getStartRow());
		System.out.println("끝 번호(end): " + paging.getEndRow());
		
	}
	
	// 나의 문의 상세
	@Override
	public void inquiryDetailAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("UserServiceImpl - inquiryDetailAction()");
		
		String sessionID = (String)request.getSession().getAttribute("sessionID");
		int inquiry_id = Integer.parseInt(request.getParameter("inquiryId"));
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", sessionID);
		map.put("inquiry_id", inquiry_id);
		
		InquiryDTO dto = dao.selectMyInquiryDetail(map);
		System.out.println("sessionID => [" + sessionID + "]");
		
		model.addAttribute("dto", dto);
	}
	// 나의 예약 목록
	@Override
	public void viewMyReservationsAction(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {
	    System.out.println("UserServiceImpl - viewMyReservationsAction()");

	    String sessionID = (String) request.getSession().getAttribute("sessionID");
	    String pageNum = request.getParameter("pageNum");
	    String status = request.getParameter("status");

	    // 상태값 기본 처리
	    if (status == null || status.trim().equals("")) {
	        status = "all";
	    }
	    
	    Paging paging = new Paging(pageNum);
	    paging.setPageSize(5);   // 카드형이라 5개
	    
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("user_id", sessionID);
	    map.put("status", status);

	    int totalCount = dao.selectMyReservationCount(map);
	    paging.setTotalCount(totalCount);

	    map.put("start", paging.getStartRow());
	    map.put("end", paging.getEndRow());

	    List<ReservationDTO> list = dao.selectMyReservationList(map);

	    model.addAttribute("list", list);
	    model.addAttribute("paging", paging);
	    model.addAttribute("reservationCount", totalCount);
	    model.addAttribute("status", status);

	    System.out.println("예약 총 개수: " + totalCount);
	    System.out.println("start: " + paging.getStartRow());
	    System.out.println("end: " + paging.getEndRow());
	    System.out.println("status : " + status);
	}
	// 나의 예약 상세
	@Override
	public void myReservationDetailAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("UserServiceImpl - myReservationDetailAction()");
		
		String sessionID = (String)request.getSession().getAttribute("sessionID");
		String reservation_id = request.getParameter("reservation_id");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", sessionID);
		map.put("reservation_id", reservation_id);
		
		ReservationDTO dto = dao.selectMyReservationDetail(map);
		
		model.addAttribute("dto", dto);
	}
	
	//------------------------------
	//관리자 상세 정보 조회
	@Override
	public MemberDTO getAdminDetail(String user_id) {
		System.out.println("UserServiceImpl - getAdminDetail()");
			
		return dao.getUserDetail(user_id);
	}
	
	//관리자 정보 수정
	@Override
	public int modifyAdminAction(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
		System.out.println("UserServiceImpl - modifyAdminAction()");
		
		String sessionID = (String)request.getSession().getAttribute("sessionID");
		String currentPassword = request.getParameter("currentPassword");
		
		//현재 비밀번호 검증
		MemberDTO memberDto = dao.getUserDetail(sessionID);
		//비밀번호 불일치 시
		if(memberDto == null || !bcryptPasswordEncoder.matches(currentPassword, memberDto.getPassword())) {
			return -1;
		}
		
		MemberDTO dto = new MemberDTO();
		dto.setUser_id(sessionID);
		dto.setName(request.getParameter("name"));
		dto.setEmail(request.getParameter("email"));
		dto.setPhone(request.getParameter("phone"));
		
		//새 비밀번호 검증
		String newPassword = request.getParameter("newPassword");
		String newPasswordConfirm = request.getParameter("newPasswordConfirm");
		
		if(newPassword != null && !newPassword.isEmpty()) {
			//새 비밀번호 불일치
			if(!newPassword.equals(newPasswordConfirm)) {
				return -2;
			}
			dto.setPassword(bcryptPasswordEncoder.encode(newPassword));
		} else {
			//기존 비밀번호 유지
			dto.setPassword(memberDto.getPassword());
		}
		return dao.updateAdmin(dto);
	}
	
	
}
