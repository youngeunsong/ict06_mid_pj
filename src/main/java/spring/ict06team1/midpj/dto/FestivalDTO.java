package spring.ict06team1.midpj.dto;

import java.sql.Date;

public class FestivalDTO {

	private int festival_id;
	private String description;
	private Date start_date;
	private Date end_date;
	private String status;
	
	public FestivalDTO() {
		super();
	}

	public FestivalDTO(int festival_id, String description, Date start_date, Date end_date, String status) {
		super();
		this.festival_id = festival_id;
		this.description = description;
		this.start_date = start_date;
		this.end_date = end_date;
		this.status = status;
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

	@Override
	public String toString() {
		return "FestivalDTO [festival_id=" + festival_id + ", description=" + description + ", start_date=" + start_date
				+ ", end_date=" + end_date + ", status=" + status + "]";
	}
	
}
