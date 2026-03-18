package spring.ict06team1.midpj.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.NoticeDTO;

@Repository
public class NoticeDAOImpl implements NoticeDAO {

    @Autowired
    private SqlSession sqlSession;

    // 공지사항 상단 고정
    @Override
    public List<NoticeDTO> getTopNoticeList() {
    	System.out.println("[NoticeDAOImpl - getTopNoticeList()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	List<NoticeDTO> topNoticeList = dao.getTopNoticeList();
    	
        return topNoticeList;
    }

    // 공지사항 일반 목록
    @Override
    public List<NoticeDTO> getNoticeList() {
    	System.out.println("[NoticeDAOImpl - getNoticeList()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	List<NoticeDTO> noticeList = dao.getNoticeList();
    	
        return noticeList;
    }

    // 이벤트 상단 고정
    @Override
    public List<NoticeDTO> getTopEventList() {
    	System.out.println("[NoticeDAOImpl - getTopEventList()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	List<NoticeDTO> topEventList = dao.getTopEventList();
    	
        return topEventList;
    }

    // 이벤트 일반 목록
    @Override
    public List<NoticeDTO> getEventList() {
    	System.out.println("[NoticeDAOImpl - getEventList()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	List<NoticeDTO> eventList = dao.getEventList();
    	
        return eventList;
    }

    // 공지/이벤트 상세
    @Override
    public NoticeDTO getNoticeDetail(int notice_id) {
    	System.out.println("[NoticeDAOImpl - getNoticeDetail()]");
    	
    	NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
    	NoticeDTO noticeDTO = dao.getNoticeDetail(notice_id);
    	
        return noticeDTO;
    }
}