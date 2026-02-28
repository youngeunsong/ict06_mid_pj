package spring.ict06team1.midpj.dto;

public class PointPolicyDTO {

	private String policy_key;
	private int amount;
	private String description;
	
	public PointPolicyDTO() {
		super();
	}
	
	public PointPolicyDTO(String policy_key, int amount, String description) {
		super();
		this.policy_key = policy_key;
		this.amount = amount;
		this.description = description;
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Override
	public String toString() {
		return "PointPolicyDTO [policy_key=" + policy_key + ", amount=" + amount + ", description=" + description + "]";
	}
	
}
