package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.CommunityDTO;

public interface AdCommunityDAO {

	//1. 전체 게시글 목록(숨김 포함), 게시글 수
	public List<CommunityDTO> getAdPostList(Map<String, Object> map);
	public int getAdPostCount(Map<String, Object> map);
	
	//2. 게시글 상세보기
	public CommunityDTO getAdPostDetail(int post_id);
	
	//3. 게시글 숨김/제재(status='BANNED')
	public int hidePost(int post_id);
	
	//4. 게시글 숨김 해제(status='DISPLAY')
	public int showPost(int post_id);
	
	//5. 게시글 삭제(status='HIDDEN')
	public int deletePost(int post_id);
	
}
