package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class CommunityLikeDTO {
	
	private int like_id;
	private String user_id;
	private int post_id;
	private Timestamp resDate;
	
	public CommunityLikeDTO() {
		super();
	}

	public CommunityLikeDTO(int like_id, String user_id, int post_id, Timestamp resDate) {
		super();
		this.like_id = like_id;
		this.user_id = user_id;
		this.post_id = post_id;
		this.resDate = resDate;
	}

	public int getLike_id() {
		return like_id;
	}

	public void setLike_id(int like_id) {
		this.like_id = like_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public int getPost_id() {
		return post_id;
	}

	public void setPost_id(int post_id) {
		this.post_id = post_id;
	}

	public Timestamp getResDate() {
		return resDate;
	}

	public void setResDate(Timestamp resDate) {
		this.resDate = resDate;
	}

	@Override
	public String toString() {
		return "CommunityLikeDTO [like_id=" + like_id + ", user_id=" + user_id + ", post_id=" + post_id + ", resDate="
				+ resDate + "]";
	}

}
