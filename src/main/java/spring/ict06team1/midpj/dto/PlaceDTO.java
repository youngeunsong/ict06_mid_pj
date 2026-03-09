package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

public class PlaceDTO {

	private int place_id;      // -- 장소 고유 번호 (PK, 부모)
	private String place_type; // -- 구분 (REST: 맛집, ACC: 숙소, FEST: 축제)
	private String name;		// -- 장소/업체 이름
	private String address;    // -- 지번/도로명 주소
	private int view_count;    //-- 조회수 (인기순 정렬용)
	private double latitude;
	private double longitude;
	private String image_url;  //-- 대표 이미지 경로
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy.MM.dd")
	private Timestamp placeRegDate;
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy.MM.dd")
	private Timestamp placeUpdateDate;

	public PlaceDTO() {
		super();
	}

	public PlaceDTO(int place_id, String place_type, String name, String address, int view_count, double latitude,
			double longitude, String image_url, Timestamp placeRegDate, Timestamp placeUpdateDate) {
		super();
		this.place_id = place_id;
		this.place_type = place_type;
		this.name = name;
		this.address = address;
		this.view_count = view_count;
		this.latitude = latitude;
		this.longitude = longitude;
		this.image_url = image_url;
		this.placeRegDate = placeRegDate;
		this.placeUpdateDate = placeUpdateDate;
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

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public String getImage_url() {
		return image_url;
	}

	public void setImage_url(String image_url) {
		this.image_url = image_url;
	}

	public Timestamp getPlaceRegDate() {
		return placeRegDate;
	}

	public void setPlaceRegDate(Timestamp placeRegDate) {
		this.placeRegDate = placeRegDate;
	}

	public Timestamp getPlaceUpdateDate() {
		return placeUpdateDate;
	}

	public void setPlaceUpdateDate(Timestamp placeUpdateDate) {
		this.placeUpdateDate = placeUpdateDate;
	}

	@Override
	public String toString() {
		return "PlaceDTO [place_id=" + place_id + ", place_type=" + place_type + ", name=" + name + ", address="
				+ address + ", view_count=" + view_count + ", latitude=" + latitude + ", longitude=" + longitude
				+ ", image_url=" + image_url + ", placeRegDate=" + placeRegDate + ", placeUpdateDate=" + placeUpdateDate
				+ "]";
	}

}
