<!-- 
 * @author 김다솜
 * 최초작성일: 2026-03-25
 * 최종수정일: 2026-03-25
 * 참고 코드: none
 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!-- CSS -->
<link rel="stylesheet" href="${path}/resources/css/user/mypage/survey.css">

<!-- begin::설문 진행률 표시 -->
<div class="progress mt-2">
	<div id="surveyProgressBar" class="progress-bar" style="width:0%"></div>
</div>
<div id="progressText" class="text-end small mt-1"></div>
<!-- end::설문 진행률 표시 -->

<!-- begin::설문 안내 카드 -->
<div class="container mt-3">
	<div id="surveyGuide" class="alert alert-info d-none d-flex justify-content-between align-items-center">
		<div>
			😊 최근 이용하신 '<span id="surveyGuideText"></span>'에 대한 설문이 있습니다!
		</div>
		<div>
			<button class="btn btn-success btn-sm" id="openSurveyBtn">작성하기</button>
			<button class="btn btn-outline-secondary btn-sm" id="laterBtn">나중에</button>
		</div>
	</div>
	
	<!-- '나중에' 버튼 클릭 시 -->
	<div id="surveyLater" class="alert alert-warning d-none d-flex justify-content-between align-items-center">
		<div>
			⏳ 설문이 대기 중입니다. 언제든지 다시 작성할 수 있습니다.
		</div>
		<div>
			<button class="btn btn-success btn-sm" id="retryBtn">지금 작성하기</button>
		</div>
	</div>
</div>
<!-- end::설문 안내 카드 -->

<!-- begin::설문 Modal -->
<div class="modal fade" id="surveyModal" tabindex="-1">
	<div class="modal-dialog">
		<div class="modal-content p-4">
			<h4 class="fw-bold mb-3">이용 완료 설문</h4>
			<p><strong><span id="survey_place_name"></span></strong> 이용은 어떠셨나요?</p>
			
			<input type="hidden" id="survey_reservation_id">
			
			<!-- 1. 만족도 -->
			<div class="score-group" data-type="satisfaction">
				<label>1. 만족도(10점 만점)</label>
				<div class="score-desc">
					<span>😡 매우 불만</span>
					<span>😍 매우 만족</span>
				</div>
				
				<div class="score-wrap">
					<c:forEach begin="1" end="10" var="i">
						<button type="button" class="score-item" data-value="${i}">${i}</button>
					</c:forEach>
				</div>
				<input type="hidden" id="satisfaction_score">
			</div>
			
			<!-- 2. 불편사항 -->
			<div class="score-group">
				<label>2. 불편사항</label>
				<textarea id="inconvenience" class="form-control"></textarea>
			</div>
			
			<!-- 3. 신뢰도 -->
			<div class="score-group" data-type="reliability">
				<label>3. 정보 신뢰도(10점 만점)</label>
				<div class="score-desc">
					<span>😡 매우 불만</span>
					<span>😍 매우 만족</span>
				</div>
				
				<div class="score-wrap">
					<c:forEach begin="1" end="10" var="i">
						<button type="button" class="score-item" data-value="${i}">${i}</button>
					</c:forEach>
				</div>
				<input type="hidden" id="info_reliability_score">
			</div>

			<!-- 4. 개선사항 -->
			<div class="score-group">
				<label>4. 개선사항</label>
				<textarea id="improvements" class="form-control"></textarea>
			</div>
			
			<!-- 5. NPS -->
			<div class="score-group" data-type="nps">
				<label>5. 추천 의향(10점 만점)</label>
				<div class="score-desc">
					<span>😡 매우 불만</span>
					<span>😍 매우 만족</span>
				</div>
				
				<div class="score-wrap">
					<c:forEach begin="1" end="10" var="i">
						<button type="button" class="score-item" data-value="${i}">${i}</button>
					</c:forEach>
				</div>
				<input type="hidden" id="nps_score">
			</div>			
			
			<button class="btn btn-success w-100" onclick="submitSurvey()">제출</button>
			
		</div>
	</div>
</div>
<!-- end::설문 Modal -->

<!-- begin::리뷰 Modal -->
<div class="modal fade" id="reviewModal" tabindex="-1">
	<div class="modal-dialog">
		<div class="modal-content p-4">
			<h4 class="fw-bold mb-1">리뷰 작성</h4>
			<p class="text-muted mb-3"><span id="review_place_name"></span>에 대한 리뷰를 남겨주세요.</p>
			
			<input type="hidden" id="review_place_id">
			
			<!-- 별점 -->
			<div class="mb-3">
				<label class="fw-bold mb-2 d-block">별점</label>
				<div id="starWrap" class="d-flex gap-2">
					<c:forEach begin="1" end="5" var="i">
						<button type="button" class="star-item" data-value="${i}">★</button>
					</c:forEach>
				</div>
				<input type="hidden" id="review_rating">
			</div>
			
			<!-- 리뷰 내용 -->
			<div class="mb-4">
				<label class="fw-bold mb-2 d-block">리뷰 내용</label>
				<textarea id="review_content" class="form-control" rows="4"
							placeholder="이용 후기를 자유롭게 작성해주세요."></textarea>
			</div>
			
			<button class="btn btn-success w-100" onclick="submitReview()">리뷰 등록</button>
			<button class="btn btn-outline-secondary w-100 mt-2" onclick="$('#reviewModal').modal('hide')">건너뛰기</button>
		</div>
	</div>
</div>
<!-- end::리뷰 Modal -->

<!-- begin::알림 toast -->
<div id="toast" class="toast-box"></div>
<!-- end::알림 toast -->