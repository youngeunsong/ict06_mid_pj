package spring.ict06team1.midpj.dao;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.CommunityCommentDTO;

@Repository
public class CommunityCommentDAOImpl implements CommunityCommentDAO {
	
	@Autowired
    private SqlSession sqlSession;

	// 댓글 목록
	@Override
	public List<CommunityCommentDTO> getCommentList(int post_id) {
		System.out.println("[CommunityCommentDAOImpl - getCommentList()]");
    	
		CommunityCommentDAO dao = sqlSession.getMapper(CommunityCommentDAO.class);
		List<CommunityCommentDTO> commentList = dao.getCommentList(post_id);
    	
        return commentList;
	}
	
	// 댓글 등록
    @Override
    public void insertComment(CommunityCommentDTO dto) {
        System.out.println("[CommunityCommentDAOImpl - insertComment()]");

        CommunityCommentDAO dao = sqlSession.getMapper(CommunityCommentDAO.class);
        dao.insertComment(dto);
    }
    
    // 작성자 검증
    @Override
    public CommunityCommentDTO getCommentDetail(int comment_id) {
    	System.out.println("[CommunityCommentDAOImpl - getCommentDetail()]");

        CommunityCommentDAO dao = sqlSession.getMapper(CommunityCommentDAO.class);
        CommunityCommentDTO dto = dao.getCommentDetail(comment_id);
    	
        return dto;
    }

    // 댓글 삭제
	@Override
	public void deleteComment(int comment_id) {
		System.out.println("[CommunityCommentDAOImpl - deleteComment()]");

        CommunityCommentDAO dao = sqlSession.getMapper(CommunityCommentDAO.class);
        dao.deleteComment(comment_id);
	}

	

}
