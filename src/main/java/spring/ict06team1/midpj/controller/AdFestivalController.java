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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.service.AdFestivalServiceImpl;

/**
 * @author 송영은
 * 최초작성일: 26.03.10
 * 최종수정일: 26.03.30
 * 한 메서드 안에서 여러 개의 sql 쿼리가 반드시 순차적으로 일어나야 할 경우 @Transaction 추가 
 * 
 * 코드 변경사항
 * v260318: 
 *    	오픈 API로 받아온 정보를 DB에 추가하는 기능 구현 완료. 
 * 		기존 신규 축제 등록 방법 변경. 축제 이름, 주소, 시작일이 일치 시 중복 등록 안 되게 설정.  
 * v260330: 
 * 		다양한 티켓 유형 대응할 수 있게 수정. 
 * 		축제 수정 시 기존 티켓 유형 삭제 및 추가 가능하게 수정
 */

@Controller
public class AdFestivalController {

private static final Logger logger = LoggerFactory.getLogger(AdPlaceController.class);
	
	@Autowired 
	private AdFestivalServiceImpl adFestService; 
	
	// 축제 관리 --------------------------------------------------------------------------------------------
	// [관리자 - 장소 관리] 등록된 축제 목록 전체 조회, 검색/필터
	@RequestMapping("/festivalList.adfe")
	public String festivalLisgt(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /festivalList.adfe]");
		adFestService.getFestivalList(request, response, model); 
		return "admin/place/festival/festivalList";
	}
	
	// [관리자 - 장소 관리] 새로운 축제 등록
	@RequestMapping("/createFestival.adfe")
	public String createFestival(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /createFestival.adfe]");
		return "admin/place/festival/createFestival";
	}
	
	// [관리자 - 장소 관리] 새로운 축제 등록 액션
	// 오류가 날 경우 SQL에서 SEQ_PLACE의 최댓값이 최대 place_id와 동일한지 확인. SEQ_PLACE값이 최대 place_id보다 작다면 SEQ_PLACE 재설정 필요. 
	// @RequestMapping("/createFestivalAction.adfe")
	@PostMapping("/createFestivalAction.adfe")
	public String createFestivalAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /createFestivalAction.adfe]");
		adFestService.insertFestival(request, response, model); 
		return "admin/place/festival/createFestivalAction";
	}
	
	// [관리자 - 장소 관리] 축제 1건 상세 조회
	@RequestMapping("/showFestivalDetail.adfe")
	public String showFestivalDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /showFestivalDetail.adfe]");
		adFestService.getFestivalDetail(request, response, model); 
		return "admin/place/festival/showFestivalDetail";
	}
	
	// [관리자 - 장소 관리] 축제 1건 상세 조회 - Ajax 용
	@ResponseBody
	@RequestMapping("/getFestivalDetail.adfe")
	public FestivalDTO getFestivalDetail(@RequestParam int festival_id){
		logger.info("[url => /getFestivalDetail.adfe]");
	    return adFestService.getFestivalDetailAjax(festival_id);
	}
	
	// [관리자 - 장소 관리] 축제 수정 처리 액션 
	@ResponseBody
	@RequestMapping("/updateFestival.adfe")
	public int updateFestival(@RequestBody FestivalDTO festivalDTO) {

	    logger.info("[url => /updateFestival.adfe]");

	    return adFestService.modifyFestival(festivalDTO);
	}
	
	// [관리자 - 장소 관리] 축제 삭제
	@RequestMapping("/deleteActionFestival.adfe")
	@ResponseBody
	public int deleteActionFestival(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /deleteActionFestival.adfe]");
	    return adFestService.deleteFestival(request, response, model);
	}
	
	// [관리자 - 장소 관리] 오픈API로 축제 정보 가져오는 화면으로 이동
	@RequestMapping("/festivalImport.adfe")
	public String festivalImport(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		logger.info("[url => /festivalImport.adfe]");
		return "admin/place/festival/festivalImport";
	}
	
	// [관리자 - 장소 관리] 오픈API로 축제 정보 가져오기
	@RequestMapping("/festivalImportAction.adfe")
	public String festivalImportAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException   {
		logger.info("[url => /festivalImportAction.adfe]");
		String json = null;
		try {
			json = adFestService.bringFestivalFromAPI(request, response, model);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		// ⭐ json null 체크
	    if(json == null || json.isEmpty()) {

	        logger.error("API 호출 실패 - json null");
	        model.addAttribute("successCnt", 0);
	        model.addAttribute("errorMsg", "API 호출 실패");

	        return "admin/place/festival/festivalImportAction";
	    }
	    
		adFestService.insertFestivalsFromApi(json, request, response, model);
	    return "admin/place/festival/festivalImportAction";
	}
}
