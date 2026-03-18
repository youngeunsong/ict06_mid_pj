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

import spring.ict06team1.midpj.service.AdNoticeService;

@Controller
public class AdNoticeController {

	@Autowired
	private AdNoticeService adNoService;

	private static final Logger logger = LoggerFactory.getLogger(AdNoticeController.class);

	// [공지/이벤트 관리]------------------------------------------
	// 1. 목록 조회
	// 1-1. 공지/이벤트 목록 전체 조회, 검색/필터
	@RequestMapping("/noticeList.adnt")
	public String getNoticeList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /noticeList.adnt]");
		adNoService.getNoticeList(request, response, model);
		
		return "admin/notice/noticeList";
	}

	// 1-2. 공지/이벤트 상세 조회+조회수 증가
	@RequestMapping("/noticeDetail.adnt")
	public String getNoticeDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /noticeDetail.adnt]");
		adNoService.getNoticeDetail(request, response, model);
		
		return "admin/notice/noticeDetail";
	}

	// 2. 글 등록
	// 2-1. 등록 폼
	@RequestMapping("/noticeWrite.adnt")
	public String noticeWriteForm(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /noticeWrite.adnt]");

		return "admin/notice/noticeWrite";
	}

	// 2-2. 등록 처리
	@RequestMapping("/noticeInsert.adnt")
	public String noticeInsert(HttpServletRequest request, HttpServletResponse response, HttpSession session, Model model)
			throws ServletException, IOException {
		logger.info("[url => /noticeInsert.adnt]");
		adNoService.insertNotice(request, response, model);
		
		return "redirect:/noticeList.adnt";
	}

	// 3. 글 수정
	// 3-1. 수정 폼
	@RequestMapping("/noticeModify.adnt")
	public String noticeModifyForm(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /noticeModify.adnt]");
		adNoService.getNoticeDetail(request, response, model);

		return "admin/notice/noticeModify";
	}

	// 3-2. 수정 처리
	@RequestMapping("/noticeUpdate.adnt")
	public String noticeUpdate(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /noticeUpdate.adnt]");
		adNoService.updateNotice(request, response, model);
		
		return "redirect:/noticeList.adnt";
	}
	
	// 4. 삭제 처리
	@RequestMapping("/noticeDelete.adnt")
	@ResponseBody
	public String noticeDelete(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /noticeDelete.adnt]");
		adNoService.deleteNotice(request, response, model);
		int result = (Integer)request.getAttribute("result");
		return (result > 0) ? "success" : "fail";
	}
	
	// 5. 이미지 업로드
	@RequestMapping("/noticeImageUpload.adnt")
	@ResponseBody
	public String noticeImageUpload(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /noticeImageUpload.adnt]");
		adNoService.uploadImage(request, response, model);
		
		return "redirect:/admin/notice/list.do";
	}

}
