package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

public class PlaceDTO {

	private int place_id;      // -- 장소 고유 번호 (PK, 부모)
	private String place_type; // -- 구분 (REST: 맛집, ACC: 숙소, FEST: 축제)
	private String name;       // -- 장소/업체 이름
	private String address;    // -- 지번/도로명 주소
	private int view_count;    //-- 조회수 (인기순 정렬용)
	private int latitude;
	private int longitude;
	private String image_url;  //-- 대표 이미지 경로
	private int review_count;  //-- 장소 별 리뷰 카운트
	
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy.MM.dd")
	private Timestamp placeRegDate;

	public PlaceDTO() {
		super();
	}
	
	public PlaceDTO(int place_id, String place_type, String name, String address, int view_count, int latitude,
			int longitude, String image_url, int review_count, Timestamp placeRegDate) {
		super();
		this.place_id = place_id;
		this.place_type = place_type;
		this.name = name;
		this.address = address;
		this.view_count = view_count;
		this.latitude = latitude;
		this.longitude = longitude;
		this.image_url = image_url;
		this.review_count = review_count;
		this.placeRegDate = placeRegDate;
	}

	public int getPlace_id() {
		return place_id;
	}
	public void setPlace_id(int place_id) {
		this.place_id = place_id;
	}
	public String getPlace_type() {
		return place_type;
	}
	public void setPlace_type(String place_type) {
		this.place_type = place_type;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public int getView_count() {
		return view_count;
	}
	public void setView_count(int view_count) {
		this.view_count = view_count;
	}
	public int getLatitude() {
		return latitude;
	}
	public void setLatitude(int latitude) {
		this.latitude = latitude;
	}
	public int getLongitude() {
		return longitude;
	}
	public void setLongitude(int longitude) {
		this.longitude = longitude;
	}
	public String getImage_url() {
		return image_url;
	}
	public void setImage_url(String image_url) {
		this.image_url = image_url;
	}
	
	public int getReview_count() {
		return review_count;
	}

	public void setReview_count(int review_count) {
		this.review_count = review_count;
	}

	public Timestamp getPlaceRegDate() {
		return placeRegDate;
	}
	public void setPlaceRegDate(Timestamp placeRegDate) {
		this.placeRegDate = placeRegDate;
	}

	@Override
	public String toString() {
		return "PlaceDTO [place_id=" + place_id + ", place_type=" + place_type + ", name=" + name + ", address="
				+ address + ", view_count=" + view_count + ", latitude=" + latitude + ", longitude=" + longitude
				+ ", image_url=" + image_url + ", review_count=" + review_count + ", placeRegDate=" + placeRegDate
				+ "]";
	}
	
}
