package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface AdCommentService {

	//1. 전체 댓글 목록(숨김 포함)
	public void getAdCommentList(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//2. 댓글 숨김
	public void hideComment(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//3. 댓글 숨김 해제
	public void showComment(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//4. 댓글 삭제
	public void deleteComment(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//5. 일괄 처리
	public void bulkAction(HttpServletRequest request, HttpServletResponse response, Model model);
	
}
