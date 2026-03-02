package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class NoticeDTO {

	private int notice_id;
	private String admin_id;
	private String title;
	private String content;
	private int view_count;
	private String is_top;
	private Timestamp created_at;

	public NoticeDTO() {
		super();
	}

	public NoticeDTO(int notice_id, String admin_id, String title, String content, int view_count, String is_top,
			Timestamp created_at) {
		super();
		this.notice_id = notice_id;
		this.admin_id = admin_id;
		this.title = title;
		this.content = content;
		this.view_count = view_count;
		this.is_top = is_top;
		this.created_at = created_at;
	}
	
	public int getNotice_id() {
		return notice_id;
	}
	public void setNotice_id(int notice_id) {
		this.notice_id = notice_id;
	}
	public String getAdmin_id() {
		return admin_id;
	}
	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
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
	public Timestamp getCreated_at() {
		return created_at;
	}
	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}

	@Override
	public String toString() {
		return "NoticeDTO [notice_id=" + notice_id + ", admin_id=" + admin_id + ", title=" + title + ", content="
				+ content + ", view_count=" + view_count + ", is_top=" + is_top + ", created_at=" + created_at + "]";
	}
	
}
