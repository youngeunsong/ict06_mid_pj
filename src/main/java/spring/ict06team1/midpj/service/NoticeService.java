package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface NoticeService {

    // 공지사항 목록
    void getNoticeList(HttpServletRequest request, Model model);

    // 이벤트 목록
    void getEventList(HttpServletRequest request, Model model);

    // 공지/이벤트 상세
    void getNoticeDetail(HttpServletRequest request, Model model);
}