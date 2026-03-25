package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.CommunityDTO;
import spring.ict06team1.midpj.dto.ImageStoreDTO;

public interface CommunityDAO {

	// 자유게시판 목록 갯수
	public int freeBoardCount(String category);
	
	// 자유게시판 목록(카테고리 필터 + 페이징)
    public List<CommunityDTO> freeBoardPage(Map<String, Object> map);
	
    // 인기글 TOP3
	public List<CommunityDTO> popularList();

    // 게시글 1건 조회
	public CommunityDTO boardDetail(int post_id);

    // 조회수 증가
	public void increaseViewCount(int post_id);
	
    // 게시글 작성(본문)
	public void insertBoard(CommunityDTO dto);
	
	// 게시글 대표 이미지 등록
	public void insertCommunityImage(ImageStoreDTO dto);

    // 게시글 삭제
	public void deleteBoard(int post_id);
    
    // 게시글 수정(본문)
	public void updateBoard(CommunityDTO dto);
	
	// 게시글 수정(기존 대표 이미지 삭제)
	public void deleteCommunityImagesByPostId(int post_id);
	
	// 자유게시판 검색 목록 갯수
	public int searchFreeBoardCount(Map<String, Object> map);
	
	// 자유게시판 검색 목록(카테고리 필터 + 페이징)
	public List<CommunityDTO> searchFreeBoardPage(Map<String, Object> map);
	
	// 좋아요 여부 체크 (0 좋아요 클릭 상태/ 1 좋아요 미클릭 상태)
	public int checkCommunityLike(Map<String, Object> map);

	// COMMUNITY_LIKE 테이블 +1
	public int insertCommunityLike(Map<String, Object> map);

	// COMMUNITY_LIKE 테이블 -1
	public int deleteCommunityLike(Map<String, Object> map);

	// 좋아요 +1
	public int increaseLikeCount(int post_id);

	// 좋아요 -1
	public int decreaseLikeCount(int post_id);
    
    
}