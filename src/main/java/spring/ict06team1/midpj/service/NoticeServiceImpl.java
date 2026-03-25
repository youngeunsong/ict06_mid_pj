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

    /* ==========================================
		공지사항(상단 고정 공지 | 일반 공지 | 페이징)
	========================================== */
    @Override
    public void getNoticeList(HttpServletRequest request, Model model) {
        System.out.println("[NoticeServiceImpl - getNoticeList()]");

        String searchType = request.getParameter("searchType");       // 제목 / 내용 / 제목+내용
        String searchKeyword = request.getParameter("searchKeyword"); // 검색어
        String pageNum = request.getParameter("pageNum");             // 페이징

        // 데이터 존재 여부 체크
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

        // 페이징을 위한 공지 전체 갯수
        int count = dao.getNoticeCount(countMap);

        Paging paging = new Paging(pageNum);
        paging.setTotalCount(count);

        Map<String, Object> map = new HashMap<>();
        map.put("searchType", searchType);
        map.put("searchKeyword", searchKeyword);
        map.put("start", paging.getStartRow());
        map.put("end", paging.getEndRow());

        //상단 고정 공지 | 일반 공지
        List<NoticeDTO> topNoticeList = dao.getTopNoticeList();
        List<NoticeDTO> noticeList = dao.getNoticeList(map);

        model.addAttribute("topNoticeList", topNoticeList);
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchKeyword", searchKeyword);
    }

    /* ==========================================
		이벤트(진행중인 이벤트 | 종류 이벤트 | 페이징)
	========================================== */
    @Override
    public void getEventList(HttpServletRequest request, Model model) {
        System.out.println("[NoticeServiceImpl - getEventList()]");

        String searchType = request.getParameter("searchType");       // 제목 / 내용 / 제목+내용
        String searchKeyword = request.getParameter("searchKeyword"); // 검색어
        String pageNum = request.getParameter("pageNum");             // 페이징

        // 데이터 존재 여부 체크
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

        // 페이징을 위한 이벤트 전체 갯수
        int count = dao.getEndEventCount(countMap);

        Paging paging = new Paging(pageNum);
        paging.setTotalCount(count);

        Map<String, Object> map = new HashMap<>();
        map.put("searchType", searchType);
        map.put("searchKeyword", searchKeyword);
        map.put("start", paging.getStartRow());
        map.put("end", paging.getEndRow());

        // 진행중인 이벤트 | 종류 이벤트
        List<NoticeDTO> ongoingEventList = dao.getOngoingEventList();
        List<NoticeDTO> endedEventList = dao.getEndEventList(map);

        model.addAttribute("ongoingEventList", ongoingEventList);
        model.addAttribute("endedEventList", endedEventList);
        model.addAttribute("paging", paging);
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchKeyword", searchKeyword);
    }

    /* ==========================================
		상세(공지/ 이벤트 공통 활용)
	========================================== */
    @Override
    public void getNoticeDetail(HttpServletRequest request, Model model) {
        System.out.println("[NoticeServiceImpl - getNoticeDetail()]");

        // 공지/ 이벤트 아이디 가져오기
        String noticeIdStr = request.getParameter("notice_id");

        // 데이터 존재 여부 체크 + 공지/ 이벤트 아이디 띄어쓰기 제거
        if (noticeIdStr == null || noticeIdStr.trim().isEmpty()) {
            model.addAttribute("noticeDTO", null);
            return;
        }

        // 실제로 사용되는 공지/ 이벤트 아이디
        int notice_id = Integer.parseInt(noticeIdStr);

        NoticeDTO noticeDTO = dao.getNoticeDetail(notice_id);

        model.addAttribute("noticeDTO", noticeDTO);
    }
}