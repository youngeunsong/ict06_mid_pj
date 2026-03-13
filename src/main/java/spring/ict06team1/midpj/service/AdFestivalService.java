package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface AdFestivalService {

	// 축제 목록 조회
	public void getFestivalList(HttpServletRequest request, HttpServletResponse response, Model model);

	// 축제 상세 정보 조회
	public void getFestivalDetail(HttpServletRequest request, HttpServletResponse response, Model model);

	// 축제 정보 수정
	public void modifyFestival(HttpServletRequest request, HttpServletResponse response, Model model);

	// 신규 축제 등록
	public void insertFestival(HttpServletRequest request, HttpServletResponse response, Model model);
	
	// 축제 정보 삭제 
	public void deleteFestival(HttpServletRequest request, HttpServletResponse response, Model model);
}
