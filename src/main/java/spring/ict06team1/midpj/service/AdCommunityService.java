package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface AdCommunityService{

	//1. 전체 게시글 목록(숨김 포함)
	public void getAdPostList(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//2. 게시글 상세보기
	public void getAdPostDetail(HttpServletRequest request, HttpServletResponse response, Model model);

	//3. 게시글 숨김/제재(status='BANNED')
	public void hidePost(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//4. 게시글 숨김 해제(status='DISPLAY')
	public void showPost(HttpServletRequest request, HttpServletResponse response, Model model);
	
	//5. 게시글 삭제(status='HIDDEN')
	public void deletePost(HttpServletRequest request, HttpServletResponse response, Model model);

	//6. 일괄 처리
	public void bulkAction(HttpServletRequest request, HttpServletResponse response, Model model);

}
