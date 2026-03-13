package spring.ict06team1.midpj.dto;

public class RestaurantDTO {

	private int restaurant_id;
	private String description;
	private String phone;
	private String category;
	private String status;
	private String restdate;
	private String areaCode;

	public RestaurantDTO() {
		super();
	}

	public RestaurantDTO(int restaurant_id, String description, String phone, String category, String status,
			String restdate, String areaCode) {
		super();
		this.restaurant_id = restaurant_id;
		this.description = description;
		this.phone = phone;
		this.category = category;
		this.status = status;
		this.restdate = restdate;
		this.areaCode = areaCode;
	}

	public int getRestaurant_id() {
		return restaurant_id;
	}

	public void setRestaurant_id(int restaurant_id) {
		this.restaurant_id = restaurant_id;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRestdate() {
		return restdate;
	}

	public void setRestdate(String restdate) {
		this.restdate = restdate;
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	@Override
	public String toString() {
		return "RestaurantDTO [restaurant_id=" + restaurant_id + ", description=" + description + ", phone=" + phone
				+ ", category=" + category + ", status=" + status + ", restdate=" + restdate + ", areaCode=" + areaCode
				+ "]";
	}
	
}
