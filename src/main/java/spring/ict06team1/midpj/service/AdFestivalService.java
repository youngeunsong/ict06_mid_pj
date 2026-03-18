package spring.ict06team1.midpj.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import spring.ict06team1.midpj.dto.FestivalDTO;

public interface AdFestivalService {

	// 축제 목록 조회
	public void getFestivalList(HttpServletRequest request, HttpServletResponse response, Model model);

	// 축제 상세 정보 조회
	public void getFestivalDetail(HttpServletRequest request, HttpServletResponse response, Model model);

	// 축제 상세 정보 조회 - Ajax용
	public FestivalDTO getFestivalDetailAjax(int festival_id);
	
	// 축제 정보 수정
	public int modifyFestival(HttpServletRequest request, HttpServletResponse response, Model model);

	// 신규 축제 등록
	public void insertFestival(HttpServletRequest request, HttpServletResponse response, Model model);
	
	// 축제 정보 삭제 
	public int deleteFestival(HttpServletRequest request, HttpServletResponse response, Model model);

	// 오픈 API로 축제 정보 가져오기
	public String bringFestivalFromAPI(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception;
	
	// 오픈API로 가져온 정보 DB에 넣기 
	public void insertFestivalsFromApi(String json)
			throws Exception;

}
