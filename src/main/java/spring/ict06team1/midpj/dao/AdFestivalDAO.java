package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.FestivalDTO;
import spring.ict06team1.midpj.dto.FestivalTicketDTO;
import spring.ict06team1.midpj.dto.PlaceDTO;

public interface AdFestivalDAO {

	// 축제 조회 ------------------------------
	// 축제 목록 조회
	public List<FestivalDTO> getFestivalList(Map<String,Object> map);
	
	// 축제 상세 정보 조회
	public FestivalDTO getFestivalDetail(int festival_id); 
	
	// 전체 축제 건수 조회(페이징용)
	public int getFestivalCount(Map<String,Object> map);
	
	// 축제 정보 수정
	public int modifyFestival(FestivalDTO dto);
	
	// (1) 신규 장소 등록 
	public int insertPlace(PlaceDTO dto); 
	
	// (2) 신규 축제 등록
	public int insertFestival(FestivalDTO dto); 
	
	// (3) 신규 티켓 정보 등록
	public int insertTicket(FestivalTicketDTO dto); 
	
	// 축제 정보 삭제
	public int deleteFestival(int festival_id);
}
