package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface CommunityService {

    // 자유게시판 목록(자유게시판 목록 or 자유게시판 검색 목록)
	public void getFreeBoardList(HttpServletRequest request, Model model);

	// 게시글 1건 조회(조회 + 조회수 증가 + 댓글 정보)
    public void getBoardDetail(HttpServletRequest request, Model model);
    
    // 댓글 등록
    public void insertComment(HttpServletRequest request);
    
    // 댓글 삭제
    public void deleteComment(HttpServletRequest request);
    
    // 좋아요(좋아요 여부 체크 + 게시글 좋아요/COMMUNITY_LIKE 테이블 +1 or -1)
    public String toggleLike(HttpServletRequest request);
    
    // 게시글 작성(등록)(게시글 내 내용 + 대표 이미지 등록)
    public void insertBoard(MultipartHttpServletRequest request);
    
    // 게시글 삭제
    public void deleteBoard(HttpServletRequest request);
    
    // 게시글 수정(등록)
    public void updateBoard(MultipartHttpServletRequest request);
    

    
}