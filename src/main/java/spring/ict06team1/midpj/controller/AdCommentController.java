package spring.ict06team1.midpj.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.service.AdCommentService;

@Controller
public class AdCommentController {

	@Autowired
	private AdCommentService adCmtService;

	private static final Logger logger = LoggerFactory.getLogger(AdCommentController.class);

	// [공지/이벤트 관리]------------------------------------------
	// 1. 전체 댓글 목록(숨김 포함)
	@RequestMapping("/commentList.adco")
	public String commentList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /commentList.adco]");
		
		adCmtService.getAdCommentList(request, response, model);
		return "admin/community/commentList";
	}

	//2. 댓글 숨김(AJAX)
	@RequestMapping("/hideComment.adco")
	@ResponseBody
	public String hideComment(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /hideComment.adco]");
		
		adCmtService.hideComment(request, response, model);
		int result = (Integer)request.getAttribute("result");
		return result > 0 ? "success" : "fail";
	}

	//3. 댓글 숨김 해제(AJAX)
	@RequestMapping("/showComment.adco")
	@ResponseBody
	public String showComment(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /showComment.adco]");

		adCmtService.showComment(request, response, model);
		int result = (Integer)request.getAttribute("result");
		return result > 0 ? "success" : "fail";
	}

	//4. 댓글 삭제(AJAX)
	@RequestMapping("/deleteComment.adco")
	@ResponseBody
	public String deleteComment(HttpServletRequest request, HttpServletResponse response, HttpSession session, Model model)
			throws ServletException, IOException {
		logger.info("[url => /deleteComment.adco]");
		
		adCmtService.deleteComment(request, response, model);
		int result = (Integer)request.getAttribute("result");
		return result > 0 ? "success" : "fail";
	}

	//5. 일괄 처리(AJAX)
	@RequestMapping("/bulkCommentAction.adco")
	@ResponseBody
	public String bulkAction(HttpServletRequest request, HttpServletResponse response, HttpSession session, Model model)
			throws ServletException, IOException {
		logger.info("[url => /bulkCommentAction.adco]");
		
		adCmtService.bulkAction(request, response, model);
		int successCount = (Integer)request.getAttribute("successCount");
		int totalCount = (Integer)request.getAttribute("totalCount");
		return successCount + "/" + totalCount;
	}
}
