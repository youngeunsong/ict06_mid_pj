package spring.ict06team1.midpj.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.CommunityDTO;

@Repository
public class CommunityDAOImpl implements CommunityDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String namespace = "spring.ict06team1.midpj.dao.CommunityDAO.";

    // 자유게시판 목록(카테고리 필터)
    @Override
    public List<CommunityDTO> getFreeBoardList(String category) {
        System.out.println("[CommunityDAOImpl - getFreeBoardList()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        List<CommunityDTO> freeBoardList = dao.getFreeBoardList(category);
        
        return freeBoardList;
    }

    // 인기글 TOP3
    @Override
    public List<CommunityDTO> getPopularBoardList() {
        System.out.println("[CommunityDAOImpl - getPopularBoardList()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        List<CommunityDTO> popularBoardList = dao.getPopularBoardList();
        
        return popularBoardList;
    }

    // 게시글 상세
    @Override
    public CommunityDTO getBoardDetail(int post_id) {
        System.out.println("[CommunityDAOImpl - getBoardDetail()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        CommunityDTO dto = dao.getBoardDetail(post_id);
        
        return dto;
    }

    // 조회수 증가
    @Override
    public void increaseViewCount(int post_id) {
        System.out.println("[CommunityDAOImpl - increaseViewCount()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        dao.increaseViewCount(post_id);
    }

    // 게시글 등록
    @Override
    public void insertBoard(CommunityDTO dto) {
        System.out.println("[CommunityDAOImpl - insertBoard()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        dao.insertBoard(dto);
    }

    // 게시글 삭제
    @Override
    public void deleteBoard(int post_id) {
        System.out.println("[CommunityDAOImpl - deleteBoard()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        dao.deleteBoard(post_id);
    }

    // 게시글 수정
	@Override
	public void updateBoard(CommunityDTO dto) {
		System.out.println("[CommunityDAOImpl - updateBoard()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        dao.updateBoard(dto);
	}
}