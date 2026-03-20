package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.CommunityDTO;
import spring.ict06team1.midpj.dto.ImageStoreDTO;

public interface CommunityDAO {
	
	// 자유게시판 목록 총 갯수
	public int freeBoardCount(String category);
	
	// 자유게시판 목록 페이징
    public List<CommunityDTO> freeBoardPage(Map<String, Object> map);
	
    // 인기글 TOP3
	public List<CommunityDTO> popularList();

    // 게시글 상세
	public CommunityDTO boardDetail(int post_id);

    // 조회수 증가
	public void increaseViewCount(int post_id);
	
    // 게시글 작성
	public void insertBoard(CommunityDTO dto);
	
	// 게시글 이미지 등록
	public void insertCommunityImage(ImageStoreDTO dto);

    // 게시글 삭제
	public void deleteBoard(int post_id);
    
    // 게시글 수정
	public void updateBoard(CommunityDTO dto);
	
	// 게시글 이미지 수정
	public void deleteCommunityImagesByPostId(int post_id);
	
	// 검색 게시글 갯수
	public int searchFreeBoardCount(Map<String, Object> map);
	
	// 검색 게시글 리스트
	public List<CommunityDTO> searchFreeBoardPage(Map<String, Object> map);
	
	// 게시글 좋아요 여부 체크
	public int checkCommunityLike(Map<String, Object> map);

	// 게시글 좋아요 추가
	public int insertCommunityLike(Map<String, Object> map);

	// 게시글 좋아요 삭제
	public int deleteCommunityLike(Map<String, Object> map);

	// 게시글 좋아요 증가
	public int increaseLikeCount(int post_id);

	// 게시글 좋아요 감소
	public int decreaseLikeCount(int post_id);
    
    
}