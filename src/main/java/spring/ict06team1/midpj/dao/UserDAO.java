package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.InquiryDTO;
import spring.ict06team1.midpj.dto.MemberDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.ReservationDTO;

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
    
    // 7. 즐겨찾기 목록 조회
    public List<PlaceDTO> getFavoriteList(Map<String, Object> map);
    // 즐겨찾기 목록 카운트
    public int getFavoriteListCount(Map<String, Object> map);
    
    // 마이페이지 홈 즐겨찾기 카테고리별 탑3
    public List<PlaceDTO> getFavoriteTop3ByCategory(Map<String, Object> map);
    
    // 마에피이지 홈 캘린더 예약 목록
    public List<Map<String, Object>> getMyCalendarReservations(String user_id);
    
    // 나의 문의 목록 조회
    public List<InquiryDTO> selectMyInquiryList(Map<String, Object> map);
    
    // 나의 문의 총 개수 조회
    public int selectMyInquiryCount(Map<String, Object> map);
    
    // 나의 문의 상세
    public InquiryDTO selectMyInquiryDetail(Map<String, Object> map);
    
    // 마이페이지 홈 활동현황 카운트
    public int getFavoriteCount(String user_id);
    public int getInquiryCount(String user_id);
    public int getReservationCount(String user_id);
    
    // 나의 예약 목록
    public int selectMyReservationCount(Map<String, Object> map);
    public List<ReservationDTO> selectMyReservationList(Map<String, Object> map);
    
    // 나의 예약 상세
    public ReservationDTO selectMyReservationDetail(Map<String, Object> map);
    
    // 나의 예약 취소 처리
    public int cancelReservation(String reservation_id);
    
    //------------------------------
    //관리자 정보 수정
    public int updateAdmin(MemberDTO dto);

}    
