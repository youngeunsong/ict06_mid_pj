package spring.ict06team1.midpj.dao;

import java.util.List;

import spring.ict06team1.midpj.dto.NoticeDTO;

public interface NoticeDAO {

    // 공지사항 상단 고정
    List<NoticeDTO> getTopNoticeList();

    // 공지사항 일반 목록
    List<NoticeDTO> getNoticeList();

    // 이벤트 상단 고정
    List<NoticeDTO> getTopEventList();

    // 이벤트 일반 목록
    List<NoticeDTO> getEventList();

    // 공지/이벤트 상세
    NoticeDTO getNoticeDetail(int notice_id);
}