package spring.ict06team1.midpj.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.CommunityDTO;

@Repository
public class AdCommunityDAOImpl implements AdCommunityDAO {

	@Autowired
	private SqlSession sqlSession;

	//1. 전체 게시글 목록(숨김 포함)
	@Override
	public List<CommunityDTO> getAdPostList() {
		System.out.println("[AdCommunityDAOImpl - getAdPostList()]");
		return sqlSession.getMapper(AdCommunityDAO.class).getAdPostList();
	}

	//2. 게시글 상세보기
	@Override
	public CommunityDTO getAdPostDetail(int post_id) {
		System.out.println("[AdCommunityDAOImpl - getAdPostDetail()]");
		return sqlSession.getMapper(AdCommunityDAO.class).getAdPostDetail(post_id);
	}
	
	//3. 게시글 숨김(status='HIDDEN')
	@Override
	public int hidePost(int post_id) {
		System.out.println("[AdCommunityDAOImpl - hidePost()]");
		return sqlSession.getMapper(AdCommunityDAO.class).hidePost(post_id);
	}

	//4. 게시글 숨김 해제(status='DISPLAY')
	@Override
	public int showPost(int post_id) {
		System.out.println("[AdCommunityDAOImpl - showPost()]");
		return sqlSession.getMapper(AdCommunityDAO.class).showPost(post_id);
	}

	//5. 게시글 삭제(status='DELETED')
	@Override
	public int deletePost(int post_id) {
		System.out.println("[AdCommunityDAOImpl - deletePost()]");
		return sqlSession.getMapper(AdCommunityDAO.class).deletePost(post_id);
	}

}
