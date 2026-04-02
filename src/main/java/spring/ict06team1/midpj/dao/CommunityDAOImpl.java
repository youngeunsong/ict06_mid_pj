package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.CommunityDTO;
import spring.ict06team1.midpj.dto.ImageStoreDTO;

@Repository
public class CommunityDAOImpl implements CommunityDAO {

    @Autowired
    private SqlSession sqlSession;

    // 자유게시판 목록 갯수
    @Override
    public int freeBoardCount(String category) {
        System.out.println("[CommunityDAOImpl - freeBoardCount()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        int freeBoardCount = dao.freeBoardCount(category);
        
        return freeBoardCount;
    }
    
    // 자유게시판 목록(카테고리 필터 + 페이징)
    @Override
    public List<CommunityDTO> freeBoardPage(Map<String, Object> map) {
        System.out.println("[CommunityDAOImpl - freeBoardPage()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        List<CommunityDTO> freeBoardPage = dao.freeBoardPage(map);
        
        return freeBoardPage;
    }
    
    // 인기글 TOP3
    @Override
    public List<CommunityDTO> popularList() {
        System.out.println("[CommunityDAOImpl - getPopularBoardList()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        List<CommunityDTO> popularList = dao.popularList();
        
        return popularList;
    }

    // 게시글 1건 조회
    @Override
    public CommunityDTO boardDetail(int post_id) {
        System.out.println("[CommunityDAOImpl - getBoardDetail()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        CommunityDTO dto = dao.boardDetail(post_id);
        
        return dto;
    }

    // 게시글 내 다중 이미지 조회
    @Override
    public List<ImageStoreDTO> getCommunityImages(int post_id) {
        System.out.println("[CommunityDAOImpl - getCommunityImages()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        return dao.getCommunityImages(post_id);
    }

    // 조회수 증가
    @Override
    public void increaseViewCount(int post_id) {
        System.out.println("[CommunityDAOImpl - increaseViewCount()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        dao.increaseViewCount(post_id);
    }

    // 게시글 작성(본문)
    @Override
    public void insertBoard(CommunityDTO dto) {
        System.out.println("[CommunityDAOImpl - insertBoard()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        dao.insertBoard(dto);
    }
    
    // 게시글 대표 이미지 등록
    @Override
    public void insertCommunityImage(ImageStoreDTO dto) {
        System.out.println("[CommunityDAOImpl - insertCommunityImage()]");

        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        dao.insertCommunityImage(dto);
    }

    // 게시글 삭제
    @Override
    public void deleteBoard(int post_id) {
        System.out.println("[CommunityDAOImpl - deleteBoard()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        dao.deleteBoard(post_id);
    }

    // 게시글 수정(본문)
	@Override
	public void updateBoard(CommunityDTO dto) {
		System.out.println("[CommunityDAOImpl - updateBoard()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        dao.updateBoard(dto);
	}
	
	// 게시글 수정(기존 대표 이미지 삭제)
	@Override
	public void deleteCommunityImagesByPostId(int post_id) {
	    System.out.println("[CommunityDAOImpl - deleteCommunityImagesByPostId()]");

	    CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
	    dao.deleteCommunityImagesByPostId(post_id);
	}
	
	// 자유게시판 검색 목록 갯수
	@Override
	public int searchFreeBoardCount(Map<String, Object> map) {
		System.out.println("[CommunityDAOImpl - searchFreeBoardCount()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        int searchCount = dao.searchFreeBoardCount(map);
        
        return searchCount;
	}
	
	// 자유게시판 검색 목록(카테고리 필터 + 페이징)
	@Override
	public List<CommunityDTO> searchFreeBoardPage(Map<String, Object> map) {
		System.out.println("[CommunityDAOImpl - searchFreeBoardPage()]");
        
        CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
        List<CommunityDTO> searchPageList = dao.searchFreeBoardPage(map);
        
        return searchPageList;
	}
	
	// 게시글 좋아요 여부 체크
	public int checkCommunityLike(Map<String, Object> map) {
		System.out.println("[CommunityDAOImpl - checkCommunityLike()]");
		
		CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
		int checkCommunityLike = dao.checkCommunityLike(map);
		
		return checkCommunityLike;
	}

	// 게시글 좋아요 추가
	public int insertCommunityLike(Map<String, Object> map) {
		System.out.println("[CommunityDAOImpl - insertCommunityLike()]");
		
		CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
		int insertCommunityLike = dao.insertCommunityLike(map);
		
		return insertCommunityLike;
	}

	// 게시글 좋아요 삭제
	public int deleteCommunityLike(Map<String, Object> map) {
		System.out.println("[CommunityDAOImpl - deleteCommunityLike()]");
		
		CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
		int deleteCommunityLike = dao.deleteCommunityLike(map);
		
		return deleteCommunityLike;
	}

	// 게시글 좋아요 증가
	public int increaseLikeCount(int post_id) {
		System.out.println("[CommunityDAOImpl - increaseLikeCount()]");
		
		CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
		int increaseLikeCount = dao.increaseLikeCount(post_id);
		
		return increaseLikeCount;
	}
	
	// 게시글 좋아요 감소
	public int decreaseLikeCount(int post_id) {
		System.out.println("[CommunityDAOImpl - decreaseLikeCount()]");
		
		CommunityDAO dao = sqlSession.getMapper(CommunityDAO.class);
		int decreaseLikeCount = dao.decreaseLikeCount(post_id);
		
		return decreaseLikeCount;
	}

	
}