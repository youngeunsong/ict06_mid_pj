package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.NoticeDTO;

@Repository
public class NoticeDAOImpl implements NoticeDAO {

    @Autowired
    private SqlSession sqlSession;

    /* ==========================================
		공지사항
	========================================== */
 	// 상단 고정 공지
    @Override
    public List<NoticeDTO> getTopNoticeList() {
    	System.out.println("[NoticeDAOImpl - getTopNoticeList()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	List<NoticeDTO> topNoticeList = dao.getTopNoticeList();
    	
        return topNoticeList;
    }

    // 일반 공지
    @Override
    public List<NoticeDTO> getNoticeList(Map<String, Object> map) {
    	System.out.println("[NoticeDAOImpl - getNoticeList()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	List<NoticeDTO> noticeList = dao.getNoticeList(map);
    	
        return noticeList;
    }
    
    // 공지사항 페이징
    @Override
    public int getNoticeCount(Map<String, Object> map) {
    	System.out.println("[NoticeDAOImpl - getNoticeCount()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	int noticeCount = dao.getNoticeCount(map);
    	
        return noticeCount;
    }

	/* ==========================================
		이벤트
	========================================== */
    // 진행중인 이벤트
    @Override
    public List<NoticeDTO> getOngoingEventList() {
    	System.out.println("[NoticeDAOImpl - getTopEventList()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	List<NoticeDTO> ongoingEventList = dao.getOngoingEventList();
    	
        return ongoingEventList;
    }

    // 종류 이벤트
    @Override
    public List<NoticeDTO> getEndEventList(Map<String, Object> map) {
    	System.out.println("[NoticeDAOImpl - getEndedEventList()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	List<NoticeDTO> endEventList = dao.getEndEventList(map);
    	
        return endEventList;
    }
    
    // 이벤트 페이징
    @Override
    public int getEndEventCount(Map<String, Object> map) {
    	System.out.println("[NoticeDAOImpl - getEndedEventCount()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	int endEventCount = dao.getEndEventCount(map);
    	
        return endEventCount;
    }

    // 공지/ 이벤트 상세
    @Override
    public NoticeDTO getNoticeDetail(int notice_id) {
    	System.out.println("[NoticeDAOImpl - getNoticeDetail()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	NoticeDTO noticeDTO = dao.getNoticeDetail(notice_id);
    	
        return noticeDTO;
    }
}