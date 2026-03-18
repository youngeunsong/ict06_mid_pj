package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface AdMemberService{

	//1. 전체 회원 목록
	public void getMemberList(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//2. 제재 회원 목록
	public void getBannedList(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//3. 작성자 제재(status='BANNED')
	public void banUser(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//4. 작성자 제재 해제(status='ACTIVE')
	public void unbanUser(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//5. 전체 제재
	public void bulkBan(HttpServletRequest request, HttpServletResponse response, Model model);

	//6. 전체 제재 해제
	public void bulkUnban(HttpServletRequest request, HttpServletResponse response, Model model);

}
