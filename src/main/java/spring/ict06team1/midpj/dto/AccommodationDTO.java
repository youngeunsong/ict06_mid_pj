package spring.ict06team1.midpj.dto;

public class AccommodationDTO {

	private int accommodation_id;
	private String description;
	private String phone;
	private int price;
	private String status;

	public AccommodationDTO() {
		super();
	}

	public AccommodationDTO(int accommodation_id, String description, String phone, int price, String status) {
		super();
		this.accommodation_id = accommodation_id;
		this.description = description;
		this.phone = phone;
		this.price = price;
		this.status = status;
	}
	
	public int getAccommodation_id() {
		return accommodation_id;
	}
	public void setAccommodation_id(int accommodation_id) {
		this.accommodation_id = accommodation_id;
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
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "AccommodationDTO [accommodation_id=" + accommodation_id + ", description=" + description + ", phone="
				+ phone + ", price=" + price + ", status=" + status + "]";
	}
	
}
