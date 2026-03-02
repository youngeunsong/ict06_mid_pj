package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.MemberDTO;

@Repository
public class UserDAOImpl implements UserDAO {

	@Autowired
	private SqlSession sqlSession;
	
	 // 1. 아이디 중복 체크
	@Override
	public int idCheck(String user_id) {
		System.out.println("UserDAOImpl - idCheck()");
		
		//int selectCnt = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.idCheck", user_id);
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		int selectCnt = dao.idCheck(user_id);
		
		return selectCnt;
	}

	// 2. 회원 정보 삽입 (회원가입)
	@Override
	public int insertUser(MemberDTO dto) {
		System.out.println("UserDAOImpl - insertUser()");
		
		return sqlSession.insert("spring.ict06team1.midpj.dao.UserDAO.insertUser", dto);
	}

	// 3. 로그인 체크 / 회원정보 인증(수정, 탈퇴)
	@Override
	public int loginCheck(Map<String, Object> map) {
		System.out.println("UserDAOImpl - loginCheck()");
		
		int selectCnt = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.loginCheck", map);
		
		return selectCnt;
	}

	 // 4. 회원정보 인증 및 회원 삭제 (탈퇴)
	@Override
	public int deleteUser(String user_id) {
		System.out.println("UserDAOImpl - deleteUser()");
		
		int deleteCnt = sqlSession.delete("spring.ict06team1.midpj.dao.UserDAO.deleteUser", user_id);
		
		return deleteCnt;
	}

	// 5. 회원정보 인증 및 회원 상세 정보 가져오기
	@Override
	public MemberDTO getUserDetail(String user_id) {
		System.out.println("UserDAOImpl - getUserDetail()");
		
		MemberDTO dto = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.getUserDetail", user_id);
		
		return dto;
	}

	// 6. 회원 정보 수정
	@Override
	public int updateUser(MemberDTO dto) {
		return 0;
	}

	// 7. 전체 회원 리스트 조회
	@Override
	public List<MemberDTO> getUserList() {
		// TODO Auto-generated method stub
		return null;
	}

	

}
