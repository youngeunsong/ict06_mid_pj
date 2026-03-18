package spring.ict06team1.midpj.SearchCriteria;

public class MemberSearchFilter {

	private String searchType;		//ID, NAME
	private String keyword;
	private String status;			//ACTIVE, BANNED
	private String role;			//USER, ADMIN
	
	public MemberSearchFilter() {
		super();
		// TODO Auto-generated constructor stub
	}

	public MemberSearchFilter(String searchType, String keyword, String status, String role) {
		super();
		this.searchType = searchType;
		this.keyword = keyword;
		this.status = status;
		this.role = role;
	}
	
	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	@Override
	public String toString() {
		return "MemberSearchFilter [searchType=" + searchType + ", keyword=" + keyword + ", status=" + status
				+ ", role=" + role + "]";
	}
	
}
