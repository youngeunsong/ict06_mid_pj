package spring.ict06team1.midpj.dto;

import java.sql.Date;
import java.sql.Timestamp;

public class UserDTO {

	//TEST용 DTO => 현 미사용
	
	private String user_id;
	private String password;
	private String email;
	private String name;
	private Date birth_date;
	private String gender;
	private String phone;
	private String address;
	private int point_balance;
	private String role;
	private String status;
	private Timestamp joinDate;
	
	
	public UserDTO() {
		super();
		
	}

	public UserDTO(String user_id, String password, String email, String name, Date birth_date, String gender,
			String phone, String address, int point_balance, String role, String status, Timestamp joinDate) {
		super();
		this.user_id = user_id;
		this.password = password;
		this.email = email;
		this.name = name;
		this.birth_date = birth_date;
		this.gender = gender;
		this.phone = phone;
		this.address = address;
		this.point_balance = point_balance;
		this.role = role;
		this.status = status;
		this.joinDate = joinDate;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getBirth_date() {
		return birth_date;
	}

	public void setBirth_date(Date birth_date) {
		this.birth_date = birth_date;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getPoint_balance() {
		return point_balance;
	}

	public void setPoint_balance(int point_balance) {
		this.point_balance = point_balance;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Timestamp getJoinDate() {
		return joinDate;
	}

	public void setJoinDate(Timestamp joinDate) {
		this.joinDate = joinDate;
	}

	@Override
	public String toString() {
		return "UserDTO [user_id=" + user_id + ", password=" + password + ", email=" + email + ", name=" + name
				+ ", birth_date=" + birth_date + ", gender=" + gender + ", phone=" + phone + ", address=" + address
				+ ", point_balance=" + point_balance + ", role=" + role + ", status=" + status + ", joinDate="
				+ joinDate + "]";
	}
	
}	