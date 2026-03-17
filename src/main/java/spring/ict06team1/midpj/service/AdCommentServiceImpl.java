package spring.ict06team1.midpj.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.AdCommentDAO;
import spring.ict06team1.midpj.dto.CommunityCommentDTO;

@Service
public class AdCommentServiceImpl implements AdCommentService {

	@Autowired
	private AdCommentDAO adCmtDao;
	
	//1. 전체 댓글 목록(숨김 포함)
	@Override
	public void getAdCommentList(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommentServiceImpl - getAdCommentList()]");
		
		List<CommunityCommentDTO> commentList = adCmtDao.getAdCommentList();
		model.addAttribute("commentList", commentList);
	}

	//2. 댓글 숨김
	@Override
	public void hideComment(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommentServiceImpl - hideComment()]");
		
		int comment_id = Integer.parseInt(request.getParameter("comment_id"));
		int result = adCmtDao.hideComment(comment_id);
		request.setAttribute("result", result);
	}
	
	//3. 댓글 숨김 해제
	@Override
	public void showComment(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommentServiceImpl - showComment()]");
		
		int comment_id = Integer.parseInt(request.getParameter("comment_id"));
		int result = adCmtDao.showComment(comment_id);
		request.setAttribute("result", result);
	}

	//4. 댓글 삭제
	@Override
	public void deleteComment(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommentServiceImpl - deleteComment()]");
		
		int comment_id = Integer.parseInt(request.getParameter("comment_id"));
		int result = adCmtDao.deleteComment(comment_id);
		request.setAttribute("result", result);
	}

	//5. 일괄 처리
	@Override
	public void bulkAction(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("[AdCommentServiceImpl - bulkAction()]");
	
		String action = request.getParameter("action");
		String[] comment_ids = request.getParameterValues("comment_ids");
		
		int successCount = 0;
		int totalCount = comment_ids != null ? comment_ids.length : 0;
		
		if(comment_ids != null) {
			for(String id:comment_ids) {
				int comment_id = Integer.parseInt(id);
				int result = 0;
				if("hide".equals(action)) {
					result = adCmtDao.hideComment(comment_id);
				} else if("show".equals(action)) {
					result = adCmtDao.showComment(comment_id);
				} else if("delete".equals(action)) {
					result = adCmtDao.deleteComment(comment_id);
				}
				if(result > 0) successCount++;
			}
		}
		request.setAttribute("successCount", successCount);
		request.setAttribute("totalCount", totalCount);
	}
}
