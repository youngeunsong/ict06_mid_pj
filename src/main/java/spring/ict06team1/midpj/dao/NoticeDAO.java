package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.NoticeDTO;

public interface NoticeDAO {

	/* ==========================================
		공지사항
	========================================== */
	// 상단 고정 공지
	public List<NoticeDTO> getTopNoticeList();

	// 일반 공지
	public List<NoticeDTO> getNoticeList(Map<String, Object> map);

    // 공지 페이징
	public int getNoticeCount(Map<String, Object> map);

	/* ==========================================
		이벤트
	========================================== */
    // 진행중인 이벤트
	public List<NoticeDTO> getOngoingEventList();

    // 종류 이벤트
	public List<NoticeDTO> getEndEventList(Map<String, Object> map);

    // 이벤트 페이징
	public int getEndEventCount(Map<String, Object> map);

	/* ==========================================
		공지/ 이벤트 상세
	========================================== */
	public NoticeDTO getNoticeDetail(int notice_id);
	
	// 조회수 증가
	public void increaseViewCount(int notice_id);
}