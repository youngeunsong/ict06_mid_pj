package spring.ict06team1.midpj.dto;

import java.sql.Date;
import java.sql.Timestamp;

public class ReservationDTO {

	private String reservation_id;
	private String user_id;
	private int place_id;
	private Date check_in;
	private Date check_out;
	private String visit_time;
	private String ticket_type;
	private int guest_count;
	private String request_note;
	private String status;
	private String payment_id;
	private Timestamp resDate;

	public ReservationDTO() {
		super();
	}

	public ReservationDTO(String reservation_id, String user_id, int place_id, Date check_in, Date check_out,
			String visit_time, String ticket_type, int guest_count, String request_note, String status,
			String payment_id, Timestamp resDate) {
		super();
		this.reservation_id = reservation_id;
		this.user_id = user_id;
		this.place_id = place_id;
		this.check_in = check_in;
		this.check_out = check_out;
		this.visit_time = visit_time;
		this.ticket_type = ticket_type;
		this.guest_count = guest_count;
		this.request_note = request_note;
		this.status = status;
		this.payment_id = payment_id;
		this.resDate = resDate;
	}
	
	public String getReservation_id() {
		return reservation_id;
	}
	public void setReservation_id(String reservation_id) {
		this.reservation_id = reservation_id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public int getPlace_id() {
		return place_id;
	}
	public void setPlace_id(int place_id) {
		this.place_id = place_id;
	}
	public Date getCheck_in() {
		return check_in;
	}
	public void setCheck_in(Date check_in) {
		this.check_in = check_in;
	}
	public Date getCheck_out() {
		return check_out;
	}
	public void setCheck_out(Date check_out) {
		this.check_out = check_out;
	}
	public String getVisit_time() {
		return visit_time;
	}
	public void setVisit_time(String visit_time) {
		this.visit_time = visit_time;
	}
	public String getTicket_type() {
		return ticket_type;
	}
	public void setTicket_type(String ticket_type) {
		this.ticket_type = ticket_type;
	}
	public int getGuest_count() {
		return guest_count;
	}
	public void setGuest_count(int guest_count) {
		this.guest_count = guest_count;
	}
	public String getRequest_note() {
		return request_note;
	}
	public void setRequest_note(String request_note) {
		this.request_note = request_note;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getPayment_id() {
		return payment_id;
	}
	public void setPayment_id(String payment_id) {
		this.payment_id = payment_id;
	}
	public Timestamp getResDate() {
		return resDate;
	}
	public void setResDate(Timestamp resDate) {
		this.resDate = resDate;
	}

	@Override
	public String toString() {
		return "ReservationDTO [reservation_id=" + reservation_id + ", user_id=" + user_id + ", place_id=" + place_id
				+ ", check_in=" + check_in + ", check_out=" + check_out + ", visit_time=" + visit_time
				+ ", ticket_type=" + ticket_type + ", guest_count=" + guest_count + ", request_note=" + request_note
				+ ", status=" + status + ", payment_id=" + payment_id + ", resDate=" + resDate + "]";
	}
	
}
