package spring.ict06team1.midpj.controller;

import java.io.IOException;
import java.net.URLEncoder;

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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import spring.ict06team1.midpj.service.AdAccommodationService;

@Controller
public class AdAccommodationController {
	
	@Autowired
	private AdAccommodationService adAccService;
	
	private static final Logger logger = LoggerFactory.getLogger(AdAccommodationController.class);
	
	// 관리자 숙소 목록 
	@GetMapping("/accommodation.adac")
	public String accommodation(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /accommodation.adac>>>");
		adAccService.getAccommodation_list(request, response, model);
		return "admin/place/accommodation/accommodation";
	}
	
	// 관리자 숙소명 또는 place_id 검색
	@GetMapping("/accommodationSearch.adac") 
	public String accommodationSearch(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /accommodationSearch>>>");
		adAccService.getAccommodationSearch(request, response, model);
		return "admin/place/accommodation/accommodation";
	}
	
	// 관리자 숙소 등록페이지로 가기
	@GetMapping("/accommodationInsert.adac")
	public String accommodationInsert(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /accommodationInsert.adac >>>");
		return "admin/place/accommodation/accommodationInsert";
	}
	
	// 관리자 숙소 등록 -> DB저장
	@PostMapping("/accommodationInsertAction.adac")
	public String accommodationInsertAction(MultipartHttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /accommodationInsertAction.adac >>>");
		adAccService.getAccommodationInsert(request, response, model);
		return "admin/place/accommodation/accommodationInsertAction";
	}
	
	// 관리자 숙소 수정페이지로 가기
	@GetMapping("/accommodationModify.adac")
	public String accommodationModify(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /accommodationModify.adac >>>");
		adAccService.getAccommodationDetail(request, response, model);
		return "admin/place/accommodation/accommodationModify";
	}
	
	//관리자 숙소 수정 -> DB저장
	@PostMapping("/accommodationModifyAction.adac")
	public String accommodationModifyAction(MultipartHttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => /accommodationModifyAction.adac >>>");
		adAccService.getAccommodationUpdateAction(request, response, model);
		adAccService.getAccommodationDetail(request, response, model);
		return "admin/place/accommodation/accommodationModifyAction";
	}
	
	// 관리자 맛집 삭제
	@GetMapping("/accommodationDeleteAction.adac")
	public String accommodationDeleteAction(HttpServletRequest request, Model model) 
	        throws ServletException, IOException {
	    logger.info("<<< url => /accommodationDeleteAction.adac >>>");
	    
	    // 1. 삭제 서비스 호출 (여기서 model에 담아준 값을 나중에 꺼내 씁니다)
	    adAccService.getAccommodationDeleteAction(request, null, model);
	    // 2. 서비스에서 model에 담아둔 파라미터 꺼내기
	    String pageNum = (String) model.asMap().get("pageNum");
	    String areaCode = (String) model.asMap().get("areaCode");
	    String category = (String) model.asMap().get("category");
	    String keyword = (String) model.asMap().get("keyword"); // 서비스에서 담아준 keyword 꺼내기
	    // 3. 키워드 유무에 따른 리다이렉트 분기
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        // 검색 중이었을 경우 -> 검색 컨트롤러로 이동
	        return "redirect:/accommodationSearch.adac?pageNum=" + pageNum 
	             + "&areaCode=" + areaCode 
	             + "&category=" + category 
	             + "&keyword=" + URLEncoder.encode(keyword, "UTF-8"); 
	             // ※ 한글 키워드일 경우 URLEncoder 사용 권장 (java.net.URLEncoder)
	    } else {
	        // 일반 목록이었을 경우 -> 전체 목록 컨트롤러로 이동
	        return "redirect:/accommodation.adac?pageNum=" + pageNum 
	             + "&areaCode=" + areaCode; 
	    }
	}
	//-----------------------------------------------------------------------------------------------------------------
	// 관리자 숙소 정보 입력 받는 곳 - 공공 데이터 활용
	// 관리자 숙소 정보 입력 하는곳
	@RequestMapping("/startAcc_1.adac")
	public String startAcc_1(HttpServletRequest request, HttpServletResponse response,Model model)
			throws ServletException, IOException {
		logger.info("<<< url => startAcc_1.adac >>> ");
		return"admin/place/accommodation/accommodation_publicdata";
	}
	
	// 관리자 숙소 정보 입력
	@ResponseBody
	@RequestMapping("/startAcc_1_action.adac")
	public String startAcc_1_action(HttpServletRequest request, HttpServletResponse response, Model model) 
	        throws ServletException, IOException {
		logger.info("<<< url => startAcc_1_action.adac >>> ");
	    // 서비스 하나가 목록 저장 + 이미지 저장까지 다 하도록 시킵니다.
		adAccService.register(request, response, model);
	    return String.valueOf(model.asMap().get("countPlace"));
	}
}