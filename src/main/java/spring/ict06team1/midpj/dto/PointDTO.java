package spring.ict06team1.midpj.dto;

public class PointDTO {

	private int point_id;
	private String user_id;
	private String policy_key;
	private int amount;
	private String type;
	private String description;
	private String pointLogDate;

	public PointDTO() {
		super();
	}
	
	public PointDTO(int point_id, String user_id, String policy_key, int amount, String type, String description,
			String pointLogDate) {
		super();
		this.point_id = point_id;
		this.user_id = user_id;
		this.policy_key = policy_key;
		this.amount = amount;
		this.type = type;
		this.description = description;
		this.pointLogDate = pointLogDate;
	}
	
	public int getPoint_id() {
		return point_id;
	}

	public void setPoint_id(int point_id) {
		this.point_id = point_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getPolicy_key() {
		return policy_key;
	}

	public void setPolicy_key(String policy_key) {
		this.policy_key = policy_key;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getPointLogDate() {
		return pointLogDate;
	}

	public void setPointLogDate(String pointLogDate) {
		this.pointLogDate = pointLogDate;
	}

	@Override
	public String toString() {
		return "PointDTO [point_id=" + point_id + ", user_id=" + user_id + ", policy_key=" + policy_key + ", amount="
				+ amount + ", type=" + type + ", description=" + description + ", pointLogDate=" + pointLogDate + "]";
	}
	
}
