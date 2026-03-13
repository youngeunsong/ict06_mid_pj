package spring.ict06team1.midpj.SearchCriteria;

public class SearchFilter {
	
	private String category;
	private String status;
	private String importance;
	private String keyword;
	
	private String startDate;
	private String endDate;
	private String sortType;
	
	public SearchFilter() {
		super();
		// TODO Auto-generated constructor stub
	}

	public SearchFilter(String category, String status, String importance, String keyword, String startDate,
			String endDate, String sortType) {
		super();
		this.category = category;
		this.status = status;
		this.importance = importance;
		this.keyword = keyword;
		this.startDate = startDate;
		this.endDate = endDate;
		this.sortType = sortType;
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

	public String getImportance() {
		return importance;
	}

	public void setImportance(String importance) {
		this.importance = importance;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getSortType() {
		return sortType;
	}

	public void setSortType(String sortType) {
		this.sortType = sortType;
	}

	@Override
	public String toString() {
		return "SearchFilter [category=" + category + ", status=" + status + ", importance=" + importance + ", keyword="
				+ keyword + ", startDate=" + startDate + ", endDate=" + endDate + ", sortType=" + sortType + "]";
	}
	
}
