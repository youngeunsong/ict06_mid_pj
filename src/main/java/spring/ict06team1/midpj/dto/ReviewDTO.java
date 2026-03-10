package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class ReviewDTO {

	private int review_id;
	private String user_id;
	private int place_id;
	private int rating;
	private String content;
	private String status;
	private Timestamp reviewDate;
	private Timestamp reviewUpdateDate;
	
	public ReviewDTO() {
		super();
	}

	public ReviewDTO(int review_id, String user_id, int place_id, int rating, String content, String status,
			Timestamp reviewDate, Timestamp reviewUpdateDate) {
		super();
		this.review_id = review_id;
		this.user_id = user_id;
		this.place_id = place_id;
		this.rating = rating;
		this.content = content;
		this.status = status;
		this.reviewDate = reviewDate;
		this.reviewUpdateDate = reviewUpdateDate;
	}

	public int getReview_id() {
		return review_id;
	}

	public void setReview_id(int review_id) {
		this.review_id = review_id;
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

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
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

	public Timestamp getReviewDate() {
		return reviewDate;
	}

	public void setReviewDate(Timestamp reviewDate) {
		this.reviewDate = reviewDate;
	}

	public Timestamp getReviewUpdateDate() {
		return reviewUpdateDate;
	}

	public void setReviewUpdateDate(Timestamp reviewUpdateDate) {
		this.reviewUpdateDate = reviewUpdateDate;
	}

	@Override
	public String toString() {
		return "ReviewDTO [review_id=" + review_id + ", user_id=" + user_id + ", place_id=" + place_id + ", rating="
				+ rating + ", content=" + content + ", status=" + status + ", reviewDate=" + reviewDate
				+ ", reviewUpdateDate=" + reviewUpdateDate + "]";
	}

}
