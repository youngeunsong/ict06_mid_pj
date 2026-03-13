package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.NoticeDTO;

@Repository
public class AdNoticeDAOImpl implements AdNoticeDAO {

	@Autowired
	private SqlSession sqlSession;

	//1. 목록 조회
	@Override
	public List<NoticeDTO> getNoticeList(Map<String, Object> map) {
		System.out.println("[AdNoticeDAOImpl - getNoticeList()]");

		return sqlSession.getMapper(AdNoticeDAO.class).getNoticeList(map);
	}

	//2. 상세 조회
	@Override
	public NoticeDTO getNoticeDetail(int noticeId) {
		System.out.println("[AdNoticeDAOImpl - getNoticeDetail()]");
		return sqlSession.getMapper(AdNoticeDAO.class).getNoticeDetail(noticeId);
	}

	//2-1. 상세 조회 후 조회수 증가
	@Override
	public int increaseViewCount(int noticeId) {
		System.out.println("[AdNoticeDAOImpl - getNoticeDetail()]");
		return sqlSession.getMapper(AdNoticeDAO.class).increaseViewCount(noticeId);
	}

	//3. 전체 건수 조회(페이징용)
	@Override
	public int getNoticeCount(Map<String, Object> map) {
		System.out.println("[AdNoticeDAOImpl - getNoticeCount()]");
		return sqlSession.getMapper(AdNoticeDAO.class).getNoticeCount(map);
	}

	//4. 등록
	@Override
	public int insertNotice(NoticeDTO dto) {
		System.out.println("[AdNoticeDAOImpl - insertNotice()]");
		return sqlSession.getMapper(AdNoticeDAO.class).insertNotice(dto);
	}

	//5. 수정
	@Override
	public int updateNotice(NoticeDTO dto) {
		System.out.println("[AdNoticeDAOImpl - updateNotice()]");
		return sqlSession.getMapper(AdNoticeDAO.class).updateNotice(dto);
	}

	//6. 삭제
	@Override
	public int deleteNotice(int noticeId) {
		System.out.println("[AdNoticeDAOImpl - deleteNotice()]");
		return sqlSession.getMapper(AdNoticeDAO.class).deleteNotice(noticeId);
	}

}
