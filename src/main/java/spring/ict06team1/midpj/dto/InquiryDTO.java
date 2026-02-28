package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class InquiryDTO {

	private int inquiry_id;
	private String user_id;
	private String title;
	private String content;
	private String status;
	private String admin_reply;
	private Timestamp inquiryDate;
	private Timestamp answerDate;

	public InquiryDTO() {
		super();
	}

	public InquiryDTO(int inquiry_id, String user_id, String title, String content, String status, String admin_reply,
			Timestamp inquiryDate, Timestamp answerDate) {
		super();
		this.inquiry_id = inquiry_id;
		this.user_id = user_id;
		this.title = title;
		this.content = content;
		this.status = status;
		this.admin_reply = admin_reply;
		this.inquiryDate = inquiryDate;
		this.answerDate = answerDate;
	}
	
	public int getInquiry_id() {
		return inquiry_id;
	}
	public void setInquiry_id(int inquiry_id) {
		this.inquiry_id = inquiry_id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getAdmin_reply() {
		return admin_reply;
	}
	public void setAdmin_reply(String admin_reply) {
		this.admin_reply = admin_reply;
	}
	public Timestamp getInquiryDate() {
		return inquiryDate;
	}
	public void setInquiryDate(Timestamp inquiryDate) {
		this.inquiryDate = inquiryDate;
	}
	public Timestamp getAnswerDate() {
		return answerDate;
	}
	public void setAnswerDate(Timestamp answerDate) {
		this.answerDate = answerDate;
	}

	@Override
	public String toString() {
		return "InquiryDTO [inquiry_id=" + inquiry_id + ", user_id=" + user_id + ", title=" + title + ", content="
				+ content + ", status=" + status + ", admin_reply=" + admin_reply + ", inquiryDate=" + inquiryDate
				+ ", answerDate=" + answerDate + "]";
	}

}
