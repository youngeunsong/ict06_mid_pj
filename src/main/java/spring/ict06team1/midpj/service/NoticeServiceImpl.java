package spring.ict06team1.midpj.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.NoticeDAO;
import spring.ict06team1.midpj.dto.NoticeDTO;

@Service
public class NoticeServiceImpl implements NoticeService {
	
	@Autowired
	private NoticeDAO dao;

	@Override
	public void getNoticeList(HttpServletRequest request, Model model) {
		System.out.println("[NoticeServiceImpl - getNoticeList()]");
		
		List<NoticeDTO> topNoticeList = dao.getTopNoticeList();
        List<NoticeDTO> noticeList = dao.getNoticeList();

        model.addAttribute("topNoticeList", topNoticeList);
        model.addAttribute("noticeList", noticeList);
	}

	@Override
	public void getEventList(HttpServletRequest request, Model model) {
		System.out.println("[NoticeServiceImpl - getEventList()]");
		
		List<NoticeDTO> topEventList = dao.getTopEventList();
        List<NoticeDTO> eventList = dao.getEventList();

        model.addAttribute("topEventList", topEventList);
        model.addAttribute("eventList", eventList);
		
	}

	@Override
	public void getNoticeDetail(HttpServletRequest request, Model model) {
		System.out.println("[NoticeServiceImpl - getNoticeDetail()]");
		
		String notice_id = request.getParameter("notice_id");

        if (notice_id != null && !notice_id.trim().isEmpty()) {
            NoticeDTO noticeDTO = dao.getNoticeDetail(Integer.parseInt(notice_id));
            model.addAttribute("noticeDTO", noticeDTO);
        }
		
	}

}
