package spring.ict06team1.midpj.dto;

public class FestivalTicketDTO {

	private int ticket_id;
	private int festival_id;
	private String ticket_type;
	private int price;
	private int stock;
	private String description;
    
	public FestivalTicketDTO() {
		super();
	}

	public FestivalTicketDTO(int ticket_id, int festival_id, String ticket_type, int price, int stock,
			String description) {
		super();
		this.ticket_id = ticket_id;
		this.festival_id = festival_id;
		this.ticket_type = ticket_type;
		this.price = price;
		this.stock = stock;
		this.description = description;
	}

	public int getTicket_id() {
		return ticket_id;
	}

	public void setTicket_id(int ticket_id) {
		this.ticket_id = ticket_id;
	}

	public int getFestival_id() {
		return festival_id;
	}

	public void setFestival_id(int festival_id) {
		this.festival_id = festival_id;
	}

	public String getTicket_type() {
		return ticket_type;
	}

	public void setTicket_type(String ticket_type) {
		this.ticket_type = ticket_type;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Override
	public String toString() {
		return "FestivalTicketDTO [ticket_id=" + ticket_id + ", festival_id=" + festival_id + ", ticket_type="
				+ ticket_type + ", price=" + price + ", stock=" + stock + ", description=" + description + "]";
	}
}
