package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class SearchHistoryDTO {

	private int history_id;       // -- 검색 기록 번호 (PK, 시퀀스)
	private String user_id;       // -- 사용자 ID(FK)  
	private String keyword;       // -- 검색한 키워드
	private Timestamp searchDate; // CREATED_AT -- 검색 일시 (DTO: searchDate)

	public SearchHistoryDTO() {
		super();
	}

	public SearchHistoryDTO(int history_id, String user_id, String keyword, Timestamp searchDate) {
		super();
		this.history_id = history_id;
		this.user_id = user_id;
		this.keyword = keyword;
		this.searchDate = searchDate;
	}

	public int getHistory_id() {
		return history_id;
	}
	public void setHistory_id(int history_id) {
		this.history_id = history_id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public Timestamp getSearchDate() {
		return searchDate;
	}
	public void setSearchDate(Timestamp searchDate) {
		this.searchDate = searchDate;
	}

	@Override
	public String toString() {
		return "SearchHistoryDTO [history_id=" + history_id + ", user_id=" + user_id + ", keyword=" + keyword
				+ ", searchDate=" + searchDate + "]";
	}
	
}
