package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class FavoriteDTO {

	private int favorite_id;
	private String user_id;
	private int place_id;
	private Timestamp favRegDate;

	public FavoriteDTO() {
		super();
	}

	public FavoriteDTO(int favorite_id, String user_id, int place_id, Timestamp favRegDate) {
		super();
		this.favorite_id = favorite_id;
		this.user_id = user_id;
		this.place_id = place_id;
		this.favRegDate = favRegDate;
	}

	public int getFavorite_id() {
		return favorite_id;
	}
	public void setFavorite_id(int favorite_id) {
		this.favorite_id = favorite_id;
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
	public Timestamp getFavRegDate() {
		return favRegDate;
	}
	public void setFavRegDate(Timestamp favRegDate) {
		this.favRegDate = favRegDate;
	}

	@Override
	public String toString() {
		return "FavoriteDTO [favorite_id=" + favorite_id + ", user_id=" + user_id + ", place_id=" + place_id
				+ ", favRegDate=" + favRegDate + "]";
	}
	
}
