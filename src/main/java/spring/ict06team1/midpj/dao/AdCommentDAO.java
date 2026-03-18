package spring.ict06team1.midpj.dao;

import java.util.List;

import spring.ict06team1.midpj.dto.CommunityCommentDTO;

public interface AdCommentDAO {

	//1. 전체 댓글 목록(숨김 포함)
	public List<CommunityCommentDTO> getAdCommentList();
	
	//2. 댓글 숨김
	public int hideComment(int comment_id);
	
	//3. 댓글 숨김 해제
	public int showComment(int comment_id);
	
	//4. 댓글 삭제
	public int deleteComment(int comment_id);
}
