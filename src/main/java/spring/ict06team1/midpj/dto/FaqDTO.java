package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class FaqDTO {

	private int faq_id;
	private String admin_id;
	private String question;
	private String answer;
	private String category;
	private int order_no;
	private String visible;
	private Timestamp faqRegDate;
	private Timestamp faqUpdateDate;
	
	public FaqDTO() {
		super();
	}

	public FaqDTO(int faq_id, String admin_id, String question, String answer, String category, int order_no,
			String visible, Timestamp faqRegDate, Timestamp faqUpdateDate) {
		super();
		this.faq_id = faq_id;
		this.admin_id = admin_id;
		this.question = question;
		this.answer = answer;
		this.category = category;
		this.order_no = order_no;
		this.visible = visible;
		this.faqRegDate = faqRegDate;
		this.faqUpdateDate = faqUpdateDate;
	}

	public int getFaq_id() {
		return faq_id;
	}

	public void setFaq_id(int faq_id) {
		this.faq_id = faq_id;
	}

	public String getAdmin_id() {
		return admin_id;
	}

	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public int getOrder_no() {
		return order_no;
	}

	public void setOrder_no(int order_no) {
		this.order_no = order_no;
	}

	public String getVisible() {
		return visible;
	}

	public void setVisible(String visible) {
		this.visible = visible;
	}

	public Timestamp getFaqRegDate() {
		return faqRegDate;
	}

	public void setFaqRegDate(Timestamp faqRegDate) {
		this.faqRegDate = faqRegDate;
	}

	public Timestamp getFaqUpdateDate() {
		return faqUpdateDate;
	}

	public void setFaqUpdateDate(Timestamp faqUpdateDate) {
		this.faqUpdateDate = faqUpdateDate;
	}

	@Override
	public String toString() {
		return "FaqDTO [faq_id=" + faq_id + ", admin_id=" + admin_id + ", question=" + question + ", answer=" + answer
				+ ", category=" + category + ", order_no=" + order_no + ", visible=" + visible + ", faqRegDate="
				+ faqRegDate + ", faqUpdateDate=" + faqUpdateDate + "]";
	}

}
