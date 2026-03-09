package spring.ict06team1.midpj.service;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import spring.ict06team1.midpj.dto.MemberDTO;

public interface UserService {

	// 1. 아이디 중복 확인 (AJAX 사용, 중복이면 1 아니면 0 반환)
    public void idCheck(HttpServletRequest request, HttpServletResponse response, Model model)
    	throws ServletException, IOException;
	
    // 2. 회원가입 처리
    public void joinAction(HttpServletRequest request, HttpServletResponse response, Model model)
    	throws ServletException, IOException;
    
    // 3. 로그인 처리 / 회원정보 인증 (아이디와 비번을 받아 일치하는 회원이 있는지 확인)
    public void loginAction(HttpServletRequest request, HttpServletResponse response, Model model)
    	throws ServletException, IOException;
    
    // 4. 회원정보 인증처리 및 탈퇴
    public void deleteUserAction(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException;
        
    // 5. 회원정보 인증처리 및 상세페이지 조회(마이페이지에서 사용)
    public void modifyDetailPage(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException;

    // 6. 회원정보 수정 
    public int modifyUserAction(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException;
    
    // 7. 전체 회원 목록 조회 (관리자 페이지용)
    public List<MemberDTO> getUserList(HttpServletRequest request, HttpServletResponse response, Model model)
		throws ServletException, IOException;
    

    
}
