package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.NoticeDTO;

public interface AdNoticeDAO {

	//1. 목록 조회
	public List<NoticeDTO> getNoticeList(Map<String,Object> map);

	//2. 상세 조회+조회수 증가
	public NoticeDTO getNoticeDetail(int noticeId);
	public int increaseViewCount(int noticeId);
	
	//3. 전체 건수 조회(페이징용)
	public int getNoticeCount(Map<String,Object> map);
	
	//4. 등록
	public int insertNotice(NoticeDTO dto);
	
	//5. 수정
	public int updateNotice(NoticeDTO dto);
	
	//6. 삭제
	public int deleteNotice(int noticeId);
}
