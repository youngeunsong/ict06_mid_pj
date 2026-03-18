package spring.ict06team1.midpj.dao;

import java.util.List;


import spring.ict06team1.midpj.dto.CommunityCommentDTO;

public interface CommunityCommentDAO {

    // 댓글 목록
	public List<CommunityCommentDTO> getCommentList(int post_id);
	
    // 댓글 등록
    public void insertComment(CommunityCommentDTO dto);
    
    // 작성자 검증
    public CommunityCommentDTO getCommentDetail(int comment_id);
    
    // 댓글 삭제
    public void deleteComment(int comment_id);
    
	
}