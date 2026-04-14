package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import spring.ict06team1.midpj.dto.InquiryDTO;
import spring.ict06team1.midpj.dto.MemberDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.PointDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;

@Repository
public class UserDAOImpl implements UserDAO {

	@Autowired
	private SqlSession sqlSession;
	
	 // 1. 아이디 중복 체크
	@Override
	public int idCheck(String user_id) {
		System.out.println("UserDAOImpl - idCheck()");
		
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
    // 회원정보 인증(수정, 탈퇴시)
	@Override
	public int loginCheck(Map<String, Object> map) {
		System.out.println("UserDAOImpl - loginCheck()");
		
		int selectCnt = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.loginCheck", map);
		
		return selectCnt;
	}
	
	// 아이디 찾기 (이름과 이메일로 마스킹된 아이디 조회)
	@Override
	public String findUserId(Map<String, Object> map) {
		System.out.println("UserDAOImpl - findUserId()");
		
		// 네임스페이스와 ID를 직접 연결 (가장 안전함)
	    return sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.findUserId", map);
	}
	
	// 비밀번호 찾기 본인확인
	@Override
	public int findPasswordCheck(Map<String, Object> map) {
		System.out.println("UserDAOImpl - findPasswordCheck()");

		return sqlSession.getMapper(UserDAO.class).findPasswordCheck(map);
	}
	
	// 임시 비밀번호 발급
	@Override
	public int updatePassword(Map<String, Object> map) {
		System.out.println("UserDAOImpl - loginCheck()");
		
		return sqlSession.getMapper(UserDAO.class).updatePassword(map);
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
		System.out.println("UserDAOImpl - updateUser()");
		
		int updateCnt = sqlSession.update("spring.ict06team1.midpj.dao.UserDAO.updateUser", dto);
		
		return updateCnt;
	}

	// 7. 나의 북마크 목록 조회
	@Override
	public List<PlaceDTO> getFavoriteList(Map<String, Object> map) {
		System.out.println("UserDAOImpl - getFavoriteList()");
		
		List<PlaceDTO> list = sqlSession.selectList("spring.ict06team1.midpj.dao.UserDAO.getFavoriteList", map);
		
		return list;
	}
	// 북마크 목록 카운트
	@Override
	public int getFavoriteListCount(Map<String, Object> map) {
		System.out.println("UserDAOImpl - getFavoriteListCount()");
		
	    int count = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.getFavoriteListCount", map);
	    
	    return count;
	}
	
	// 마이페이지 홈 북마크 카테고리별 탑3
	@Override
	public List<PlaceDTO> getFavoriteTop3ByCategory(Map<String, Object> map) {
		System.out.println("UserDAOImpl - getFavoriteTop3ByCategory()");
		
		List<PlaceDTO> list = sqlSession.selectList("spring.ict06team1.midpj.dao.UserDAO.getFavoriteTop3ByCategory", map);
		
		return list;
	}
	
	// 마이페이지 홈 캘린더 예약 목록 조회
	@Override
	public List<Map<String, Object>> getMyCalendarReservations(String user_id) {
		System.out.println("UserDAOImpl - getMyCalendarReservations()");
		
		List<Map<String, Object>> list = sqlSession.selectList("spring.ict06team1.midpj.dao.UserDAO.getMyCalendarReservations",user_id);
		
		return list;
	}

	// 나의 문의 목록 조회
	@Override
	public List<InquiryDTO> selectMyInquiryList(Map<String, Object> map) {
		System.out.println("UserDAOImpl - selectMyInquiryList()");
		
		List<InquiryDTO> list = sqlSession.selectList("spring.ict06team1.midpj.dao.UserDAO.selectMyInquiryList", map);
		
		return list;
	}

	// 나의 문의 총 개수 조회
	@Override
	public int selectMyInquiryCount(Map<String, Object> map) {
		System.out.println("UserDAOImpl - selectMyInquiryCount()");
		
		int selectCnt = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.selectMyInquiryCount", map);
		
		return selectCnt;
	}

	// 나의 문의 상세
	@Override
	public InquiryDTO selectMyInquiryDetail(Map<String, Object> map) {
		System.out.println("UserDAOImpl - selectMyInquiryDetail()");
		
		InquiryDTO dto = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.selectMyInquiryDetail", map);
		
		return dto;
	}
	
	// 나의 예약 취소
	@Override
	public int cancelReservation(String reservation_id) {
	    System.out.println("UserDAOImpl - cancelReservation()");

	    int updateCnt = sqlSession.update("spring.ict06team1.midpj.dao.UserDAO.cancelReservation", reservation_id);

	    return updateCnt;
	}
	
	// 마이페이지 홈 활동현황 카운트
	@Override
	public int getFavoriteCount(String user_id) {
		System.out.println("UserDAOImpl - getFavoriteCount()");
		
		int selectCnt = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.getFavoriteCount", user_id);
		
		return selectCnt;
	}
	@Override
	public int getInquiryCount(String user_id) {
		System.out.println("UserDAOImpl - getInquiryCount()");
		
		int selectCnt = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.getInquiryCount", user_id);
		
		return selectCnt;
	}
	@Override
	public int getReservationCount(String user_id) {
		System.out.println("UserDAOImpl - getReservationCount()");
		
		int selectCnt = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.getReservationCount", user_id);
		
		return selectCnt;
	}
	
	// 나의 예약 목록
	@Override
	public List<ReservationDTO> selectMyReservationList(Map<String, Object> map) {
	    System.out.println("UserDAOImpl - selectMyReservationList()");
	    
	    List<ReservationDTO> list = sqlSession.selectList("spring.ict06team1.midpj.dao.UserDAO.selectMyReservationList", map);

	    return list;
	}
	// 나의 예약 목록 카운트
	@Override
	public int selectMyReservationCount(Map<String, Object> map) {
	    System.out.println("UserDAOImpl - selectMyReservationCount()");
	    
	    int count = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.selectMyReservationCount", map);

	    return count;
	}

	// 나의 예약 상세
	@Override
	public ReservationDTO selectMyReservationDetail(Map<String, Object> map) {
	    System.out.println("UserDAOImpl - selectMyReservationDetail()");
	    
	    ReservationDTO dto = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.selectMyReservationDetail", map);

	    return dto;
	}
	
	// 북마크(버튼) 존재 여부 확인
	@Override
	public int checkmyFavorite(Map<String, Object> map) {
	    System.out.println("UserDAOImpl - checkmyFavorite()");
	    
	    int checkCnt = sqlSession.selectOne("spring.ict06team1.midpj.dao.UserDAO.checkmyFavorite", map);
	    
	    return checkCnt;
	}

	// 북마크(버튼) 추가
	@Override
	public int insertmyFavorite(Map<String, Object> map) {
	    System.out.println("UserDAOImpl - insertmyFavorite()");
	    
	    int insertCnt = sqlSession.insert("spring.ict06team1.midpj.dao.UserDAO.insertmyFavorite", map);
	    
	    return insertCnt;
	}

	// 북마크(버튼) 삭제
	@Override
	public int deletemyFavorite(Map<String, Object> map) {
	    System.out.println("UserDAOImpl - deletemyFavorite()");
	    
	    int deleteCnt = sqlSession.delete("spring.ict06team1.midpj.dao.UserDAO.deletemyFavorite", map);
	    
	    return deleteCnt;
	}
	
	//관리자 정보 수정
	@Override
	public int updateAdmin(MemberDTO dto) {
		System.out.println("UserDAOImpl - updateAdminInfo()");

		return sqlSession.getMapper(UserDAO.class).updateAdmin(dto);
	}
	// ===============================
	// 추가: 김재원 2026-03-27
	// 포인트 DB에 입력
	@Override
	public int insertPoint(Map<String, Object> map) {
		System.out.println("UserDAOImpl - insertPoint()");
		return sqlSession.insert("PointMapper.insertPoint", map);
	}
	
	// 마이페이지 포인트 가져오기
	@Override
    public List<PointDTO> getPointHistory(String userId) {
		System.out.println("UserDAOImpl - getPointHistory()");
        return sqlSession.selectList("PointMapper.getPointHistory", userId);
    }
}