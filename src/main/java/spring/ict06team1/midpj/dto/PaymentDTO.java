package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class PaymentDTO {

	private String payment_id;
	private String user_id;
	private String reservation_id;
	private int amount;
	private String payment_method;
	private String payment_status;
	private Timestamp payDate;

	public PaymentDTO() {
		super();
	}

	public PaymentDTO(String payment_id, String user_id, String reservation_id, int amount, String payment_method,
			String payment_status, Timestamp payDate) {
		super();
		this.payment_id = payment_id;
		this.user_id = user_id;
		this.reservation_id = reservation_id;
		this.amount = amount;
		this.payment_method = payment_method;
		this.payment_status = payment_status;
		this.payDate = payDate;
	}
	
	public String getPayment_id() {
		return payment_id;
	}
	public void setPayment_id(String payment_id) {
		this.payment_id = payment_id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getReservation_id() {
		return reservation_id;
	}
	public void setReservation_id(String reservation_id) {
		this.reservation_id = reservation_id;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	public String getPayment_method() {
		return payment_method;
	}
	public void setPayment_method(String payment_method) {
		this.payment_method = payment_method;
	}
	public String getPayment_status() {
		return payment_status;
	}
	public void setPayment_status(String payment_status) {
		this.payment_status = payment_status;
	}
	public Timestamp getPayDate() {
		return payDate;
	}
	public void setPayDate(Timestamp payDate) {
		this.payDate = payDate;
	}

	@Override
	public String toString() {
		return "PaymentDTO [payment_id=" + payment_id + ", user_id=" + user_id + ", reservation_id=" + reservation_id
				+ ", amount=" + amount + ", payment_method=" + payment_method + ", payment_status=" + payment_status
				+ ", payDate=" + payDate + "]";
	}
	
}
