package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class SurveyDTO {

	private int survey_id;
	private String user_id;
	private int nps_score;
	private int satisfaction_score;
	private String inconvenience;
	private int info_reliability_score;
	private String improvements;
	private Timestamp surveyDate;

	public SurveyDTO() {
		super();
	}

	public SurveyDTO(int survey_id, String user_id, int nps_score, int satisfaction_score, String inconvenience,
			int info_reliability_score, String improvements, Timestamp surveyDate) {
		super();
		this.survey_id = survey_id;
		this.user_id = user_id;
		this.nps_score = nps_score;
		this.satisfaction_score = satisfaction_score;
		this.inconvenience = inconvenience;
		this.info_reliability_score = info_reliability_score;
		this.improvements = improvements;
		this.surveyDate = surveyDate;
	}

	public int getSurvey_id() {
		return survey_id;
	}

	public void setSurvey_id(int survey_id) {
		this.survey_id = survey_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public int getNps_score() {
		return nps_score;
	}

	public void setNps_score(int nps_score) {
		this.nps_score = nps_score;
	}

	public int getSatisfaction_score() {
		return satisfaction_score;
	}

	public void setSatisfaction_score(int satisfaction_score) {
		this.satisfaction_score = satisfaction_score;
	}

	public String getInconvenience() {
		return inconvenience;
	}

	public void setInconvenience(String inconvenience) {
		this.inconvenience = inconvenience;
	}

	public int getInfo_reliability_score() {
		return info_reliability_score;
	}

	public void setInfo_reliability_score(int info_reliability_score) {
		this.info_reliability_score = info_reliability_score;
	}

	public String getImprovements() {
		return improvements;
	}

	public void setImprovements(String improvements) {
		this.improvements = improvements;
	}

	public Timestamp getSurveyDate() {
		return surveyDate;
	}

	public void setSurveyDate(Timestamp surveyDate) {
		this.surveyDate = surveyDate;
	}

	@Override
	public String toString() {
		return "SurveyDTO [survey_id=" + survey_id + ", user_id=" + user_id + ", nps_score=" + nps_score
				+ ", satisfaction_score=" + satisfaction_score + ", inconvenience=" + inconvenience
				+ ", info_reliability_score=" + info_reliability_score + ", improvements=" + improvements
				+ ", surveyDate=" + surveyDate + "]";
	}

}
