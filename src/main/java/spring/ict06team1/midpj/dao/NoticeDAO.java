package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.NoticeDTO;

public interface NoticeDAO {

    // 공지사항 =========================
	// 공지사항 - 상단 고정 공지
	public List<NoticeDTO> getTopNoticeList();

	// 공지사항 - 일반 공지
	public List<NoticeDTO> getNoticeList(Map<String, Object> map);

    // 공지사항 - 페이징
	public int getNoticeCount(Map<String, Object> map);

    // 이벤트 =========================
    // 이벤트 - 진행중인 이벤트
	public List<NoticeDTO> getOngoingEventList();

    // 이벤트 - 종류 이벤트
	public List<NoticeDTO> getEndEventList(Map<String, Object> map);

    // 이벤트 - 페이징
	public int getEndEventCount(Map<String, Object> map);

    // 상세 =========================
    // 공지/ 이벤트 공통 활용
	public NoticeDTO getNoticeDetail(int notice_id);
}