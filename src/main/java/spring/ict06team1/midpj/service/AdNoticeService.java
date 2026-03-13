package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface AdNoticeService {
	
	public void getNoticeList(HttpServletRequest request, HttpServletResponse response, Model model);

	public void getNoticeDetail(HttpServletRequest request, HttpServletResponse response, Model model);

	public void insertNotice(HttpServletRequest request, HttpServletResponse response, Model model);

	public void updateNotice(HttpServletRequest request, HttpServletResponse response, Model model);

	public void deleteNotice(HttpServletRequest request, HttpServletResponse response, Model model);
	
	public void uploadImage(HttpServletRequest request, HttpServletResponse response, Model model);

}
