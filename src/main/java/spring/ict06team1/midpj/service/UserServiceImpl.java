package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.UserDAO;
import spring.ict06team1.midpj.dto.MemberDTO;



@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDAO dao;
	
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
	    dto.setPassword(password);
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
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", user_id);
		map.put("password", password);
		
		int selectCnt = dao.loginCheck(map);
		
		// 세션ID 설정(중요)
		if(selectCnt == 1) {
			request.getSession().setAttribute("sessionID", user_id);
			//브라우저 종료 시 세션 무효화(자동 로그아웃 처리. 30분=1800초 기준)
			request.getSession().setMaxInactiveInterval(1800);	
			
			// 권한 정보 가져오기
	        MemberDTO dto = dao.getUserDetail(user_id); 
	        if(dto != null) {
	            // 세션에 role(ADMIN 또는 USER)
	            request.getSession().setAttribute("userRole", dto.getRole());
	        }
		}
		model.addAttribute("selectCnt", selectCnt);
		request.setAttribute("user_id", user_id);
		request.setAttribute("selectCnt", selectCnt);
	}

    // 4. 회원정보 인증처리 및 탈퇴(논리삭제 방식)
	@Override
	public void deleteUserAction(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
		System.out.println("UserServiceImpl - deleteUserAction()");
		
		String sessionID =(String)request.getSession().getAttribute("sessionID");
		String password = request.getParameter("password");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", sessionID);
		map.put("password", password);
		
		// 회원정보 인증처리
		int selectCnt = dao.loginCheck(map);
		int deleteCnt = 0;
		if(selectCnt == 1) {
			
			deleteCnt = dao.deleteUser(sessionID);
			
			if(deleteCnt == 1) {
	            request.getSession().invalidate();
	        }
		}
		model.addAttribute("selectCnt", selectCnt);
		model.addAttribute("deleteCnt", deleteCnt);
	}

	// 5. 회원정보 인증처리 및 상세페이지 조회(마이페이지에서 사용)
	@Override
	public void modifyDetailPage(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
		System.out.println("UserServiceImpl - modifyDetailPage()");
		
		String sessionID =(String)request.getSession().getAttribute("sessionID");
		String password = request.getParameter("password");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", sessionID);
		map.put("password", password);
		
		int selectCnt = dao.loginCheck(map);
		
		MemberDTO dto = null;
		// 회원정보 인증 성공시
		if(selectCnt == 1) {
			// 회원 상세 페이지	
		 dto = dao.getUserDetail(sessionID);
		 
		 model.addAttribute("dto", dto);
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
		dto.setPassword(password);
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
}
