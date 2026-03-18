package spring.ict06team1.midpj.service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import spring.ict06team1.midpj.dto.AccommodationDTO;

public interface AdAccommodationService {
	
	
	// 숙소 목록 조회
	public void getAccommodation_list(HttpServletRequest request, HttpServletResponse response, Model model);
	
	// 숙소 목록 검색
	public void getAccommodationSearch(HttpServletRequest request, HttpServletResponse response, Model model);
	
	// 숙소 정보 등록
	public void getAccommodationInsert(MultipartHttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException;
	
	// 숙소 상세 정보 조회
	public void getAccommodationDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	// 숙소 정보 수정
	public void getAccommodationUpdateAction(MultipartHttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	// 숙소 정보 삭제
	public void getAccommodationDeleteAction(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
	
	
	//공공데이터 open API 활용 숙소 정보 내려받기
	//---------------------------------------------------------------------------------------------------------------------
		
	//숙소 정보 등록-공공데이터를 통해서(place 테이블쪽)
	public void register(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException;
		
	//숙소 정보 등록-공공데이터를 통해서(accommodation 테이블쪽)
	public void registerDetail(String contentId, AccommodationDTO aDto);
}
