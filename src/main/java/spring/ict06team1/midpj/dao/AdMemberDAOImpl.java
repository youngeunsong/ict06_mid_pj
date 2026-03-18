package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.MemberDTO;

@Repository
public class AdMemberDAOImpl implements AdMemberDAO {

	@Autowired
	private SqlSession sqlSession;

	//1. 전체 회원 목록
	@Override
	public List<MemberDTO> getMemberList(Map<String, Object> map) {
		System.out.println("[AdMemberDAOImpl - getMemberList()]");
		return sqlSession.getMapper(AdMemberDAO.class).getMemberList(map);
	}

	//1-1. 전체 회원 수
	@Override
	public int getMemberCount(Map<String, Object> map) {
		System.out.println("[AdMemberDAOImpl - getMemberCount()]");
		return sqlSession.getMapper(AdMemberDAO.class).getMemberCount(map);
	}

	//2. 제재 회원 목록
	@Override
	public List<MemberDTO> getBannedList(Map<String, Object> map) {
		System.out.println("[AdMemberDAOImpl - getBannedList()]");
		return sqlSession.getMapper(AdMemberDAO.class).getBannedList(map);
	}

	//2-1. 제재 회원 수
	@Override
	public int getBannedCount(Map<String, Object> map) {
		System.out.println("[AdMemberDAOImpl - getBannedCount()]");
		return sqlSession.getMapper(AdMemberDAO.class).getBannedCount(map);
	}

	//3. 작성자 제재(status='BANNED')
	@Override
	public int banUser(String user_id) {
		System.out.println("[AdMemberDAOImpl - banUser()]");
		return sqlSession.getMapper(AdMemberDAO.class).banUser(user_id);
	}

	//4. 작성자 제재 해제(status='ACTIVE')
	@Override
	public int unbanUser(String user_id) {
		System.out.println("[AdMemberDAOImpl - unbanUser()]");
		return sqlSession.getMapper(AdMemberDAO.class).unbanUser(user_id);
	}

	//5. 작성자 상태 조회
	@Override
	public MemberDTO getUserStatus(String user_id) {
		System.out.println("[AdMemberDAOImpl - getUserStatus()]");
		return sqlSession.getMapper(AdMemberDAO.class).getUserStatus(user_id);
	}

}
