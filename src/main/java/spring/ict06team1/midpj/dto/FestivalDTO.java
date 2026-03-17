package spring.ict06team1.midpj.dto;

import java.sql.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

public class FestivalDTO {

	private int festival_id;
	private String description;
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private Date start_date;
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private Date end_date;
	private String status;
	private PlaceDTO placeDTO;
	private List<FestivalTicketDTO> ticketList; // 추가: 해당 축제의 티켓을 관리하기 위해 추가했습니다. 
	
	// 출력용 날짜 데이터 : sql.Date 타입 변수가 타임존의 영향을 받아 실제보다 하루 빠르게 화면에 표시되는 현상 발생. 
	// 이를 방지하기 위한 추가 변수  
	private String start_date_str;
	private String end_date_str;
	
	public FestivalDTO() {
		super();
	}

	public String getStart_date_str() {
		return start_date_str;
	}

	public void setStart_date_str(String start_date_str) {
		this.start_date_str = start_date_str;
	}

	public String getEnd_date_str() {
		return end_date_str;
	}

	public void setEnd_date_str(String end_date_str) {
		this.end_date_str = end_date_str;
	}

	public FestivalDTO(int festival_id, String description, Date start_date, Date end_date, String status,
			PlaceDTO placeDTO, List<FestivalTicketDTO> ticketList) {
		super();
		this.festival_id = festival_id;
		this.description = description;
		this.start_date = start_date;
		this.end_date = end_date;
		this.status = status;
		this.placeDTO = placeDTO;
		this.ticketList = ticketList;
	}

	public int getFestival_id() {
		return festival_id;
	}

	public void setFestival_id(int festival_id) {
		this.festival_id = festival_id;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Date getStart_date() {
		return start_date;
	}

	public void setStart_date(Date start_date) {
		this.start_date = start_date;
	}

	public Date getEnd_date() {
		return end_date;
	}

	public void setEnd_date(Date end_date) {
		this.end_date = end_date;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public PlaceDTO getPlaceDTO() {
		return placeDTO;
	}

	public void setPlaceDTO(PlaceDTO placeDTO) {
		this.placeDTO = placeDTO;
	}

	public List<FestivalTicketDTO> getTicketList() {
		return ticketList;
	}

	public void setTicketList(List<FestivalTicketDTO> ticketList) {
		this.ticketList = ticketList;
	}

	@Override
	public String toString() {
		return "FestivalDTO [festival_id=" + festival_id + ", description=" + description + ", start_date=" + start_date
				+ ", end_date=" + end_date + ", status=" + status + ", placeDTO=" + placeDTO + ", ticketList="
				+ ticketList + ", start_date_str=" + start_date_str + ", end_date_str=" + end_date_str + "]";
	}
}
