package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
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
		
		if(user_id != null) {	// 공백제거
	        user_id = user_id.trim();
	    }
		
		int selectCnt = dao.idCheck(user_id);
		
		model.addAttribute("selectCnt", selectCnt);
		model.addAttribute("user_id", user_id);
	}

    // 2. 회원가입 처리
	@Override
	public void joinAction(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
		System.out.println("UserServiceImpl - joinAction()");
		
		MemberDTO dto = new MemberDTO();
		dto.setUser_id(request.getParameter("user_id"));
		dto.setPassword(request.getParameter("user_password"));
		dto.setName(request.getParameter("user_name"));
		dto.setAddress(request.getParameter("address"));
		dto.setGender(request.getParameter("gender"));
		
		// 날짜 처리 (JSP의 name="birth_date"와 맞춤)
	    String strBirth = request.getParameter("birth_date");
	    if (strBirth != null && !strBirth.equals("")) {
	        dto.setBirth_date(java.sql.Date.valueOf(strBirth));
	    }
		
		String hp = "";
		String hp1 = request.getParameter("phone1");
		String hp2 = request.getParameter("phone2");
		String hp3 = request.getParameter("phone3");
		
		if(!hp1.equals("") && !hp2.equals("") && !hp3.equals("")) {
			hp = hp1 + "-" + hp2 + "-" + hp3;
		}
		dto.setPhone(hp);
		
		String email1 = request.getParameter("user_email1");
		String email2 = request.getParameter("user_email2");
		String email = email1 + "@" + email2;
		
		dto.setEmail(email);
		
		//dto.setJoinDate(new Timestamp(System.currentTimeMillis()));
		
		//dto.setPoint_balance(0);      // 신규 가입 0포인트
	    //dto.setRole("ROLE_USER");     // 기본 일반 회원
	    //dto.setStatus("ACTIVE");      // 활동 상태
		
		int insertCnt = dao.insertUser(dto);
		
		model.addAttribute("insertCnt", insertCnt);
	}

    // 3. 로그인 처리 / 회원정보 인증 (아이디와 비번을 받아 일치하는 회원이 있는지 확인)
	@Override
	public void loginAction(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
		System.out.println("UserServiceImpl - loginAction()");
		
		String user_id = request.getParameter("user_id");
		String user_password = request.getParameter("user_password");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", user_id);
		map.put("password", user_password);
		
		int selectCnt = dao.loginCheck(map);
		
		// 세션ID 설정(중요)
		if(selectCnt == 1) {
			request.getSession().setAttribute("sessionID", user_id);
			//브라우저 종료 시 세션 무효화(자동 로그아웃 처리. 30분=1800초 기준)
			request.getSession().setMaxInactiveInterval(1800);
			
		}
		model.addAttribute("selectCnt", selectCnt);
		request.setAttribute("user_id", user_id);
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
		return 0;
	}

	// 7. 전체 회원 목록 조회 (관리자 페이지용)
	@Override
	public List<MemberDTO> getUserList(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException {
		// TODO Auto-generated method stub
		return null;
	}



}
