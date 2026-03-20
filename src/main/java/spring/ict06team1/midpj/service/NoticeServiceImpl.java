package spring.ict06team1.midpj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import spring.ict06team1.midpj.dao.NoticeDAO;
import spring.ict06team1.midpj.dto.NoticeDTO;
import spring.ict06team1.midpj.SearchCriteria.Paging;

@Service
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private NoticeDAO dao;

    // =========================
    // 공지사항 목록
    // =========================
    @Override
    public void getNoticeList(HttpServletRequest request, Model model) {
        System.out.println("[NoticeServiceImpl - getNoticeList()]");

        String searchType = request.getParameter("searchType");
        String searchKeyword = request.getParameter("searchKeyword");
        String pageNum = request.getParameter("pageNum");

        if (searchType == null || searchType.trim().isEmpty()) {
            searchType = "title";
        }

        if (searchKeyword == null) {
            searchKeyword = "";
        } else {
            searchKeyword = searchKeyword.trim();
        }

        Map<String, Object> countMap = new HashMap<>();
        countMap.put("searchType", searchType);
        countMap.put("searchKeyword", searchKeyword);

        int count = dao.getNoticeCount(countMap);

        Paging paging = new Paging(pageNum);
        paging.setTotalCount(count);

        Map<String, Object> map = new HashMap<>();
        map.put("searchType", searchType);
        map.put("searchKeyword", searchKeyword);
        map.put("start", paging.getStartRow());
        map.put("end", paging.getEndRow());

        List<NoticeDTO> topNoticeList = dao.getTopNoticeList();
        List<NoticeDTO> noticeList = dao.getNoticeList(map);

        model.addAttribute("topNoticeList", topNoticeList);
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchKeyword", searchKeyword);
    }

    // =========================
    // 이벤트 목록
    // =========================
    @Override
    public void getEventList(HttpServletRequest request, Model model) {
        System.out.println("[NoticeServiceImpl - getEventList()]");

        String searchType = request.getParameter("searchType");
        String searchKeyword = request.getParameter("searchKeyword");
        String pageNum = request.getParameter("pageNum");

        if (searchType == null || searchType.trim().isEmpty()) {
            searchType = "title";
        }

        if (searchKeyword == null) {
            searchKeyword = "";
        } else {
            searchKeyword = searchKeyword.trim();
        }

        Map<String, Object> countMap = new HashMap<>();
        countMap.put("searchType", searchType);
        countMap.put("searchKeyword", searchKeyword);

        int count = dao.getEndEventCount(countMap);

        Paging paging = new Paging(pageNum);
        paging.setTotalCount(count);

        Map<String, Object> map = new HashMap<>();
        map.put("searchType", searchType);
        map.put("searchKeyword", searchKeyword);
        map.put("start", paging.getStartRow());
        map.put("end", paging.getEndRow());

        List<NoticeDTO> ongoingEventList = dao.getOngoingEventList();
        List<NoticeDTO> endedEventList = dao.getEndEventList(map);

        model.addAttribute("ongoingEventList", ongoingEventList);
        model.addAttribute("endedEventList", endedEventList);
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchKeyword", searchKeyword);
    }

    // =========================
    // 공지 / 이벤트 상세
    // =========================
    @Override
    public void getNoticeDetail(HttpServletRequest request, Model model) {
        System.out.println("[NoticeServiceImpl - getNoticeDetail()]");

        String noticeIdStr = request.getParameter("notice_id");

        if (noticeIdStr == null || noticeIdStr.trim().isEmpty()) {
            model.addAttribute("noticeDTO", null);
            return;
        }

        int notice_id = Integer.parseInt(noticeIdStr);

        NoticeDTO noticeDTO = dao.getNoticeDetail(notice_id);

        model.addAttribute("noticeDTO", noticeDTO);
    }
}