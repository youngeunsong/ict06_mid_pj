package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.MemberDTO;

public interface AdMemberDAO {

	//1. 전체 회원 목록
	public List<MemberDTO> getMemberList(Map<String, Object> map);
	public int getMemberCount(Map<String, Object> map);
	
	//2. 제재 회원 목록
	public List<MemberDTO> getBannedList(Map<String, Object> map);
	public int getBannedCount(Map<String, Object> map);
	
	//3. 작성자 제재(status='BANNED')
	public int banUser(String user_id);
	
	//4. 작성자 제재 해제(status='ACTIVE')
	public int unbanUser(String user_id);
	
	//5. 작성자 상태 조회
	public MemberDTO getUserStatus(String user_id);
}
