package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.CommunityCommentDTO;

@Repository
public class AdCommentDAOImpl implements AdCommentDAO {

	@Autowired
	private SqlSession sqlSession;
	
	//1. 전체 댓글 목록(숨김 포함)
	@Override
	public List<CommunityCommentDTO> getAdCommentList(Map<String, Object> map) {
		System.out.println("[AdCommentDAOImpl - getAdCommentList()]");
		return sqlSession.getMapper(AdCommentDAO.class).getAdCommentList(map);
	}
	
	//1-1. 전체 댓글 수
	@Override
	public int getAdCommentCount(Map<String, Object> map) {
		System.out.println("[AdCommentDAOImpl - getAdCommentCount()]");
		return sqlSession.getMapper(AdCommentDAO.class).getAdCommentCount(map);
	}

	//2. 댓글 숨김
	@Override
	public int hideComment(int comment_id) {
		System.out.println("[AdCommentDAOImpl - hideComment()]");
		return sqlSession.getMapper(AdCommentDAO.class).hideComment(comment_id);
	}

	//3. 댓글 숨김 해제
	@Override
	public int showComment(int comment_id) {
		System.out.println("[AdCommentDAOImpl - showComment()]");
		return sqlSession.getMapper(AdCommentDAO.class).showComment(comment_id);
	}

	//4. 댓글 삭제
	@Override
	public int deleteComment(int comment_id) {
		System.out.println("[AdCommentDAOImpl - deleteComment()]");
		return sqlSession.getMapper(AdCommentDAO.class).deleteComment(comment_id);
	}

}