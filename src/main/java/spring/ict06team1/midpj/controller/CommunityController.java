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

import spring.ict06team1.midpj.service.CommunityService;

@Controller
public class CommunityController {

	private static final Logger logger = LoggerFactory.getLogger(UserController.class);

	@Autowired
	private CommunityService service;

	// [community]
	// ----------------------------------------------------------------------------------------
	// [community] 커뮤니티 홈
	@RequestMapping("/community.co")
	public String community(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => community.co >>>");

		return "user/community/community";
	}

	// [community] 커뮤니티 게시글 작성
	@RequestMapping("/createBoard.co")
	public String createBoard(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => createBoard.co >>>");

		return "user/community/createBoard";
	}

	// [community] 커뮤니티 게시글 작성 처리
	@RequestMapping("/createBoardAction.co")
	public String createBoardAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => createBoardAction.co >>>");

		return "user/community/createBoardAction";
	}

	// [community] 커뮤니티 게시글 상세 조회
	@RequestMapping("/boardDetail.co")
	public String boardDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => boardDetail.co >>>");

		return "user/community/boardDetail";
	}

	// [community] 커뮤니티 게시글 수정
	@RequestMapping("/modifyBoard.co")
	public String modifyBoard(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => modifyBoard.co >>>");

		return "user/community/modifyBoard";
	}

	// [community] 커뮤니티 게시글 수정 처리
	@RequestMapping("/modifyBoardAction.co")
	public String modifyBoardAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => modifyBoardAction.co >>>");

		return "user/community/modifyBoardAction";
	}

}
