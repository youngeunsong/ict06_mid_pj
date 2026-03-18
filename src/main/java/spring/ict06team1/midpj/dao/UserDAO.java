package spring.ict06team1.midpj.dao;

import java.util.Map;


import spring.ict06team1.midpj.dto.MemberDTO;

public interface UserDAO {

    // 1. 아이디 중복 체크
    public int idCheck(String user_id);
	
	// 2. 회원 정보 삽입 (회원가입)
    public int insertUser(MemberDTO dto);

    // 3. 로그인 처리 (아이디와 비밀번호 대조)
    // 회원정보 인증(수정, 탈퇴시)
    public int loginCheck(Map<String, Object> map);
    
    //비밀번호 찾기 본인확인, 임시비밀번호 발급
    public int findPasswordCheck(Map<String, Object> map);
    public int updatePassword(Map<String, Object> map);

    // 4. 회원정보 인증 및 회원 삭제 (탈퇴)
    public int deleteUser(String user_id);
    
    // 5. 회원정보 인증 및 회원 상세 정보 가져오기
    public MemberDTO getUserDetail(String user_id);

    // 6. 회원 정보 수정
    public int updateUser(MemberDTO dto);
    
    //------------------------------
    //관리자 정보 수정
    public int updateAdmin(MemberDTO dto);

}    
