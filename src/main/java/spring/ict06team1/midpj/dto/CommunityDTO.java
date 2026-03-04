package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class CommunityDTO {

	private int post_id;
	private String user_id;
	private String title;
	private String content;
	private String category;
	private int view_count;
	private int like_count;
	private String status;
	private Timestamp postDate;
	private Timestamp updateDate;
	
	public CommunityDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public CommunityDTO(int post_id, String user_id, String title, String content, String category, int view_count,
			int like_count, String status, Timestamp postDate, Timestamp updateDate) {
		super();
		this.post_id = post_id;
		this.user_id = user_id;
		this.title = title;
		this.content = content;
		this.category = category;
		this.view_count = view_count;
		this.like_count = like_count;
		this.status = status;
		this.postDate = postDate;
		this.updateDate = updateDate;
	}
	
	public int getPost_id() {
		return post_id;
	}
	public void setPost_id(int post_id) {
		this.post_id = post_id;
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
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public int getView_count() {
		return view_count;
	}
	public void setView_count(int view_count) {
		this.view_count = view_count;
	}
	public int getLike_count() {
		return like_count;
	}
	public void setLike_count(int like_count) {
		this.like_count = like_count;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Timestamp getPostDate() {
		return postDate;
	}
	public void setPostDate(Timestamp postDate) {
		this.postDate = postDate;
	}
	public Timestamp getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(Timestamp updateDate) {
		this.updateDate = updateDate;
	}
	
	@Override
	public String toString() {
		return "CommunityDTO [post_id=" + post_id + ", user_id=" + user_id + ", title=" + title + ", content=" + content
				+ ", category=" + category + ", view_count=" + view_count + ", like_count=" + like_count + ", status="
				+ status + ", postDate=" + postDate + ", updateDate=" + updateDate + "]";
	}
	
}
