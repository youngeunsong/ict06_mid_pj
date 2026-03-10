package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class CommunityCommentDTO {

	private int comment_id;
	private int post_id;
	private String user_id;
	private String content;
	private String status;
	private Timestamp commentDate;
	private Timestamp commentUpdateDate;
	
	public CommunityCommentDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public CommunityCommentDTO(int comment_id, int post_id, String user_id, String content, String status,
			Timestamp commentDate, Timestamp commentUpdateDate) {
		super();
		this.comment_id = comment_id;
		this.post_id = post_id;
		this.user_id = user_id;
		this.content = content;
		this.status = status;
		this.commentDate = commentDate;
		this.commentUpdateDate = commentUpdateDate;
	}

	public int getComment_id() {
		return comment_id;
	}

	public void setComment_id(int comment_id) {
		this.comment_id = comment_id;
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

	public Timestamp getCommentDate() {
		return commentDate;
	}

	public void setCommentDate(Timestamp commentDate) {
		this.commentDate = commentDate;
	}

	public Timestamp getCommentUpdateDate() {
		return commentUpdateDate;
	}

	public void setCommentUpdateDate(Timestamp commentUpdateDate) {
		this.commentUpdateDate = commentUpdateDate;
	}

	@Override
	public String toString() {
		return "CommunityCommentDTO [comment_id=" + comment_id + ", post_id=" + post_id + ", user_id=" + user_id
				+ ", content=" + content + ", status=" + status + ", commentDate=" + commentDate
				+ ", commentUpdateDate=" + commentUpdateDate + "]";
	}
	
}
