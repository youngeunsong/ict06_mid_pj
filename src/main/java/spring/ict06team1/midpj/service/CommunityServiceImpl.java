package spring.ict06team1.midpj.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.CommunityCommentDAO;
import spring.ict06team1.midpj.dao.CommunityDAO;
import spring.ict06team1.midpj.dto.CommunityCommentDTO;
import spring.ict06team1.midpj.dto.CommunityDTO;

@Service
public class CommunityServiceImpl implements CommunityService {
	
	@Autowired
	private CommunityDAO dao;
	
	@Autowired
	private CommunityCommentDAO commentDao;

	// 자유게시판 목록
	@Override
	public void getFreeBoardList(HttpServletRequest request, Model model) {
	    System.out.println("[CommunityServiceImpl - getFreeBoardList()]");

	    String category = request.getParameter("category");
	    System.out.println("category = " + category);

	    // 아래 목록용
	    List<CommunityDTO> freeBoardList = dao.getFreeBoardList(category);

	    // 상단 인기글 TOP3용 (항상 전체 기준)
	    List<CommunityDTO> popularBoardList = dao.getPopularBoardList();

	    System.out.println("category : " + category);
	    System.out.println("freeBoardList size : " + freeBoardList.size());
	    System.out.println("popularBoardList size : " + popularBoardList.size());

	    model.addAttribute("freeBoardList", freeBoardList);
	    model.addAttribute("popularBoardList", popularBoardList);
	}

	// 자유게시판 게시글 상세
	@Override
	public void getBoardDetail(HttpServletRequest request, Model model) {
	    System.out.println("[CommunityServiceImpl - getBoardDetail()]");

	    int post_id = Integer.parseInt(request.getParameter("post_id"));

	    dao.increaseViewCount(post_id);

	    CommunityDTO dto = dao.getBoardDetail(post_id);
	    List<CommunityCommentDTO> commentList = commentDao.getCommentList(post_id);

	    model.addAttribute("dto", dto);
	    model.addAttribute("commentList", commentList);
	}
	
	// 댓글 등록
	@Override
	public void insertComment(HttpServletRequest request) {
	    System.out.println("[CommunityServiceImpl - insertComment()]");

	    int post_id = Integer.parseInt(request.getParameter("post_id"));
	    String content = request.getParameter("content");
	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    CommunityCommentDTO dto = new CommunityCommentDTO();
	    dto.setPost_id(post_id);
	    dto.setUser_id(sessionID);
	    dto.setContent(content);

	    commentDao.insertComment(dto);
	}
	
	// 댓글 삭제
	@Override
	public void deleteComment(HttpServletRequest request) {
	    System.out.println("[CommunityServiceImpl - deleteComment()]");

	    int comment_id = Integer.parseInt(request.getParameter("comment_id"));
	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    CommunityCommentDTO comment = commentDao.getCommentDetail(comment_id);

	    if (comment != null && sessionID != null && sessionID.equals(comment.getUser_id())) {
	        commentDao.deleteComment(comment_id);
	    }
	}
	
	// 자유게시판 게시글 작성
	@Override
	public void insertBoard(HttpServletRequest request) {
	    System.out.println("[CommunityServiceImpl - insertBoard()]");

	    String title = request.getParameter("title");
	    String content = request.getParameter("content");
	    String category = request.getParameter("category");
	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    System.out.println("title : " + title);
	    System.out.println("content : " + content);
	    System.out.println("category : " + category);
	    System.out.println("sessionID : " + sessionID);

	    CommunityDTO dto = new CommunityDTO();
	    dto.setTitle(title);
	    dto.setContent(content);
	    dto.setCategory(category);
	    dto.setUser_id(sessionID);

	    dao.insertBoard(dto);
	}
	
	// 자유게시판 게시글 삭제
	@Override
	public void deleteBoard(HttpServletRequest request) {
	    System.out.println("[CommunityServiceImpl - deleteBoard()]");

	    int post_id = Integer.parseInt(request.getParameter("post_id"));
	    String sessionID = (String) request.getSession().getAttribute("sessionID");

	    CommunityDTO dto = dao.getBoardDetail(post_id);

	    if (dto != null && sessionID != null && sessionID.equals(dto.getUser_id())) {
	        dao.deleteBoard(post_id);
	    }
	}

	// 게시글 수정 화면 정보
	@Override
	public void getModifyBoardInfo(HttpServletRequest request, Model model) {
		System.out.println("[CommunityServiceImpl - getModifyBoardInfo()]");
		
		String post_id = request.getParameter("post_id");

        if (post_id != null && !post_id.isEmpty()) {
            CommunityDTO commumityDTO = dao.getBoardDetail(Integer.parseInt(post_id));
            model.addAttribute("commumityDTO", commumityDTO);
        }
	}
}