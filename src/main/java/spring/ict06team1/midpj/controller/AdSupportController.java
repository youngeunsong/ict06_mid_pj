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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.dto.ReservationDTO;
import spring.ict06team1.midpj.service.AdminService;

@Controller
public class AdSupportController {

	private static final Logger logger = LoggerFactory.getLogger(AdSupportController.class);

	// [고객지원]------------------------------------------
	// [고객지원] Home
	@RequestMapping("/supportHome.adsp")
	public String supportHome(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /supportHome.adsp]");
		return "admin/supportHome";
	}
	
	// [고객지원] - 1:1 문의 목록, FAQ 목록
	@RequestMapping("/inquiryFaqList.adsp")
	public String inquiryFaqList(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /inquiryFaqList.adsp]");
		return "admin/inquiryFaqList";
	}

	// [고객지원] 1:1 문의 상세
	@RequestMapping("/inquiryDetail.adsp")
	public String inquiryDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /inquiryDetail.adsp]");
		return "admin/inquiry/inquiryDetail";
	}

	// [고객지원] 1:1 문의 처리

	// [고객지원] 1:1 문의 사용자 알림

	// [고객지원] FAQ 분류/검색

	// [고객지원] FAQ 상세/수정

	// [고객지원] FAQ 등록

	// [고객지원] FAQ 분류/검색
	
	// [고객지원] FAQ, 1:1 문의 노출 수정
	
	// [고객지원] FAQ, 1:1 문의 목록 정렬

}
