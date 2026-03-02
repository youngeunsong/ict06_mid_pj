package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

public class PlaceDTO {

	private int place_id;
	private String place_type;
	private String name;
	private String address;
	private int view_count;
	private int latitude;
	private int longitude;
	private String image_url;
	
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy.MM.dd HH:mm")
	private Timestamp placeRegDate;

	public PlaceDTO() {
		super();
	}
	
	public PlaceDTO(int place_id, String place_type, String name, String address, int view_count, int latitude,
			int longitude, String image_url, Timestamp placeRegDate) {
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
				+ ", image_url=" + image_url + ", placeRegDate=" + placeRegDate + "]";
	}
	
}
