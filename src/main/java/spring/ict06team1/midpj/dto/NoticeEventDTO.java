package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class NoticeEventDTO {

	private int notice_event_id;
	private String admin_id;
	private String category;
	private String title;
	private String content;
	private String image_url;
	private int view_count;
	private String is_top;
	private Timestamp regDate;

	public NoticeEventDTO() {
		super();
	}

	public NoticeEventDTO(int notice_event_id, String admin_id, String category, String title, String content,
			String image_url, int view_count, String is_top, Timestamp regDate) {
		super();
		this.notice_event_id = notice_event_id;
		this.admin_id = admin_id;
		this.category = category;
		this.title = title;
		this.content = content;
		this.image_url = image_url;
		this.view_count = view_count;
		this.is_top = is_top;
		this.regDate = regDate;
	}

	public int getNotice_event_id() {
		return notice_event_id;
	}

	public void setNotice_event_id(int notice_event_id) {
		this.notice_event_id = notice_event_id;
	}

	public String getAdmin_id() {
		return admin_id;
	}

	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
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

	public String getImage_url() {
		return image_url;
	}

	public void setImage_url(String image_url) {
		this.image_url = image_url;
	}

	public int getView_count() {
		return view_count;
	}

	public void setView_count(int view_count) {
		this.view_count = view_count;
	}

	public String getIs_top() {
		return is_top;
	}

	public void setIs_top(String is_top) {
		this.is_top = is_top;
	}

	public Timestamp getRegDate() {
		return regDate;
	}

	public void setRegDate(Timestamp regDate) {
		this.regDate = regDate;
	}

	@Override
	public String toString() {
		return "NoticeEventDTO [notice_event_id=" + notice_event_id + ", admin_id=" + admin_id + ", category="
				+ category + ", title=" + title + ", content=" + content + ", image_url=" + image_url + ", view_count="
				+ view_count + ", is_top=" + is_top + ", regDate=" + regDate + "]";
	}
	
}
