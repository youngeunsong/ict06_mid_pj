package spring.ict06team1.midpj.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.service.AdCommunityServiceImpl;

@Controller
public class AdCommunityController {

	private static final Logger logger = LoggerFactory.getLogger(AdCommunityController.class);
	
	@Autowired
	private AdCommunityServiceImpl adComService;

	//1. [관리자 - 커뮤니티 관리] 홈 (게시글 목록-숨김 포함)
	@RequestMapping("/communityHome.adco")
	public String communityHome(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /communityHome.adco]");
		adComService.getAdPostList(request, response, model);
		return "admin/community/communityHome";
	}
	
	//2. 게시글 상세보기
	@RequestMapping("/communityDetail.adco")
	public String communityDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /communityDetail.adco]");
		adComService.getAdPostDetail(request, response, model);
		return "admin/community/communityDetail";
	}
	
	//3. 게시글 숨김(AJAX)
	@ResponseBody
	@RequestMapping("/hidePost.adco")
	public String hidePost(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /hidePost.adco]");
		adComService.hidePost(request, response, model);
		
		int result = (Integer)request.getAttribute("result");
		
		return result > 0 ? "success" : "fail";
	}

	//4. 게시글 숨김 해제(AJAX)
	@ResponseBody
	@RequestMapping("/showPost.adco")
	public String showPost(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /showPost.adco]");
		adComService.showPost(request, response, model);
		
		int result = (Integer)request.getAttribute("result");
		
		return result > 0 ? "success" : "fail";
	}
	
	//5. 게시글 삭제(AJAX)
	@ResponseBody
	@RequestMapping("/deletePost.adco")
	public String deletePost(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /deletePost.adco]");
		adComService.deletePost(request, response, model);
		
		int result = (Integer)request.getAttribute("result");
		
		return result > 0 ? "success" : "fail";
	}
	
	//6. 일괄 처리(AJAX)
	@ResponseBody
	@RequestMapping("/bulkAction.adco")
	public String bulkAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /bulkAction.adco]");
		adComService.bulkAction(request, response, model);
		
		int successCount = (Integer)request.getAttribute("successCount");
		int totalCount = (Integer)request.getAttribute("totalCount");
		return successCount + "/" + totalCount;
	}
}
