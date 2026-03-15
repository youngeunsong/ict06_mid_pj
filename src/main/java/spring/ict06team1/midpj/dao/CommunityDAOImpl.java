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
        return sqlSession.selectList(namespace + "getFreeBoardList", category);
    }

    // 인기글 TOP3
    @Override
    public List<CommunityDTO> getPopularBoardList() {
        System.out.println("[CommunityDAOImpl - getPopularBoardList()]");
        return sqlSession.selectList(namespace + "getPopularBoardList");
    }

    // 게시글 상세
    @Override
    public CommunityDTO getBoardDetail(int post_id) {
        System.out.println("[CommunityDAOImpl - getBoardDetail()]");
        return sqlSession.selectOne(namespace + "getBoardDetail", post_id);
    }

    // 조회수 증가
    @Override
    public void increaseViewCount(int post_id) {
        System.out.println("[CommunityDAOImpl - increaseViewCount()]");
        sqlSession.update(namespace + "increaseViewCount", post_id);
    }

    // 게시글 등록
    @Override
    public void insertBoard(CommunityDTO dto) {
        System.out.println("[CommunityDAOImpl - insertBoard()]");
        sqlSession.insert(namespace + "insertBoard", dto);
    }

    // 게시글 삭제
    @Override
    public void deleteBoard(int post_id) {
        System.out.println("[CommunityDAOImpl - deleteBoard()]");
        sqlSession.update(namespace + "deleteBoard", post_id);
    }
}