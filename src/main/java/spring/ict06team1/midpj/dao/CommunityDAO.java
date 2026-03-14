package spring.ict06team1.midpj.dao;

import java.util.List;

import spring.ict06team1.midpj.dto.CommunityDTO;

public interface CommunityDAO {

    // 자유게시판 목록(카테고리 필터)
    List<CommunityDTO> getFreeBoardList(String category);

    // 인기글 TOP3
    List<CommunityDTO> getPopularBoardList();

    // 게시글 상세
    CommunityDTO getBoardDetail(int post_id);

    // 조회수 증가
    void increaseViewCount(int post_id);

    // 게시글 등록
    void insertBoard(CommunityDTO dto);

    // 게시글 삭제
    void deleteBoard(int post_id);
    
    
}