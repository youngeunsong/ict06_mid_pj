package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface CommunityService {

    // 자유게시판 목록
	public void getFreeBoardList(HttpServletRequest request, Model model);

    // 자유게시판 게시글 상세
    public void getBoardDetail(HttpServletRequest request, Model model);
    
    // 댓글 등록
    public void insertComment(HttpServletRequest request);
    
    // 댓글 삭제
    public void deleteComment(HttpServletRequest request);
    
    // 자유게시판 게시글 작성
    public void insertBoard(HttpServletRequest request);
    
    // 자유게시판 게시글 삭제
    public void deleteBoard(HttpServletRequest request);
    
    // 자유게시판 수정 화면 정보
    void getModifyBoardInfo(HttpServletRequest request, Model model);
    
    
    
   
}