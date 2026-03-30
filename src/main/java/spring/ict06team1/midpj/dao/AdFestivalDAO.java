package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;
/**
 * @author 송영은
 * 최초작성일: 26.03.10
 * 최종수정일: 26.03.30
 * 한 메서드 안에서 여러 개의 sql 쿼리가 반드시 순차적으로 일어나야 할 경우 @Transaction 추가 
 * 
 * 코드 변경사항
 * v260318: 
 *    	오픈 API로 받아온 정보를 DB에 추가하는 기능 구현 완료. 
 * 		기존 신규 축제 등록 방법 변경. 축제 이름, 주소, 시작일이 일치 시 중복 등록 안 되게 설정.  
 * v260330: 
 * 		다양한 티켓 유형 대응할 수 있게 수정. 
 * 		축제 수정 시 기존 티켓 유형 삭제 및 추가 가능하게 수정
 */
public interface AdFestivalDAO {

	// 축제 조회 ------------------------------
	// 축제 목록 조회
	public List<FestivalDTO> getFestivalList(Map<String,Object> map);
	
	// 축제 상세 정보 조회
	public FestivalDTO getFestivalDetail(int festival_id); 
	
	// 티켓 상세 정보 조회
	public List<FestivalTicketDTO> getFestivalTickets(int festival_id); 
	
	// 전체 축제 건수 조회(페이징용)
	public int getFestivalCount(Map<String,Object> map);
	
	// 축제 정보 수정 : 3단계
	// (1) 장소 수정
	public int updatePlace(PlaceDTO dto);
	// (2) 축제 수정
	public int modifyFestival(FestivalDTO dto);
	// (3) 티켓 수정 
	public int updateTicket(FestivalTicketDTO dto);
	
	// 신규 축제 등록 : 3단계 
	
	// 신규 축제 등록 : 4단계
	// (0) 기존 테이블에 있는 데이터인지 확인
	public Integer checkDuplication(FestivalDTO dto);
	
	// (1) 신규 장소 등록 
	public int insertPlace(PlaceDTO dto); 
	
	// (2) 신규 축제 등록
	public int insertFestival(FestivalDTO dto); 
	
	// (3) 신규 티켓 정보 등록
	public int insertTicket(FestivalTicketDTO dto); 
	
	// 기존 티켓 조회
	List<FestivalTicketDTO> getTicketsByFestivalId(int festival_id);
	
	// 축제 정보 삭제 - 2단계 
	// (1) 축제 티켓 정보 삭제
	public int deleteFestivalTickets(int festival_id);
		
	// (2) 축제 정보 삭제
	public int deleteFestival(int festival_id);
	
	// 단일 티켓 삭제
	int deleteTicket(int ticket_id);
	
	// 공공축제 데이터 넣기
	public int insertFestivalBatch(List<FestivalDTO> list); 
	
}
