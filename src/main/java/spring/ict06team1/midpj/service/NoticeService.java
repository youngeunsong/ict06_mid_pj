package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface NoticeService {

	// 공지사항(상단 고정 공지 | 일반 공지 | 페이징)
	public void getNoticeList(HttpServletRequest request, Model model);

	// 이벤트(진행중인 이벤트 | 종류 이벤트 | 페이징)
	public void getEventList(HttpServletRequest request, Model model);

	// 상세(공지/ 이벤트 공통 활용)
	public void getNoticeDetail(HttpServletRequest request, Model model);
	
	// 
}