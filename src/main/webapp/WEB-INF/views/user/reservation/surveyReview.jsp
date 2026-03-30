<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>설문 · 리뷰 작성</title>

<!-- 공통 CSS / JS -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>

<!-- 페이지 전용 CSS -->
<link rel="stylesheet" href="${path}/resources/css/user/surveyReview.css">
</head>

<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<section class="survey-review-section">

			<!-- =========================
			     페이지 헤더
			     ========================= -->
			<div class="page-header">
				<h2>
					<i class="bi bi-chat-square-heart"></i> 설문 · 리뷰 작성
				</h2>
			</div>

			<!-- =========================
			     예약 / 장소 안내 영역
			     dto가 있으면 dto 우선 사용
			     없으면 param 값으로 최소 표시
			     ========================= -->
			<div class="info-card">
				<div class="place-name">
					<c:choose>
						<c:when test="${not empty dto.placeDTO.name}">
							${dto.placeDTO.name}
						</c:when>
						<c:otherwise>
							이용하신 장소
						</c:otherwise>
					</c:choose>
				</div>

				<p class="info-text">
					예약번호 :
					<strong>
						<c:choose>
							<c:when test="${not empty dto.reservation_id}">
								${dto.reservation_id}
							</c:when>
							<c:otherwise>
								${param.reservation_id}
							</c:otherwise>
						</c:choose>
					</strong>
					<br>
					소중한 이용 후기를 남겨주시면 서비스 개선에 큰 도움이 됩니다.
					설문과 리뷰를 작성해주시면 포인트 지급 대상이 될 수 있습니다.
				</p>
			</div>

			<!-- =========================
			     설문 + 리뷰 작성 폼
			     ========================= -->
			<form id="surveyForm" action="${path}/surveyReviewAction.rv" method="post">

				<!-- 예약번호 / 장소번호 hidden 값 세팅 -->
				<c:choose>
					<c:when test="${not empty dto.reservation_id}">
						<c:set var="hiddenReservationId" value="${dto.reservation_id}" />
					</c:when>
					<c:otherwise>
						<c:set var="hiddenReservationId" value="${param.reservation_id}" />
					</c:otherwise>
				</c:choose>

				<c:choose>
					<c:when test="${not empty dto.placeDTO.place_id}">
						<c:set var="hiddenPlaceId" value="${dto.placeDTO.place_id}" />
					</c:when>
					<c:otherwise>
						<c:set var="hiddenPlaceId" value="${param.place_id}" />
					</c:otherwise>
				</c:choose>

				<input type="hidden" name="reservation_id" value="${hiddenReservationId}">
				<input type="hidden" name="place_id" value="${hiddenPlaceId}">

				<!-- =========================
				     페이지 전용 hidden
				     ※ name도 page_... 로 통일
				     ※ 서비스에서 request.getParameter("page_...") 로 받기
				     ========================= -->
				<input type="hidden" name="page_satisfaction_score" id="page_satisfaction_score">
				<input type="hidden" name="page_info_reliability_score" id="page_info_reliability_score">
				<input type="hidden" name="page_nps_score" id="page_nps_score">
				<input type="hidden" name="page_rating" id="page_rating">

				<!-- =========================
				     설문 카드
				     ========================= -->
				<div class="form-card">
					<h3>
						<i class="bi bi-ui-checks-grid"></i> 이용 설문
					</h3>

					<!-- 1. 만족도 -->
					<div class="form-group">
						<label class="form-label">1. 전반적인 만족도를 선택해주세요. (10점 만점)</label>
						<div class="score-wrap" data-target="page_satisfaction_score">
							<c:forEach begin="1" end="10" var="i">
								<button type="button" class="score-item" data-value="${i}">${i}</button>
							</c:forEach>
						</div>
						<div class="form-hint">1점은 매우 불만족, 10점은 매우 만족입니다.</div>
					</div>

					<!-- 2. 불편사항 -->
					<div class="form-group">
						<label for="inconvenience" class="form-label">2. 이용 중 불편했던 점이 있었다면 적어주세요.</label>
						<textarea id="inconvenience" name="inconvenience" class="form-control-custom"
							placeholder="예) 대기 시간이 길었어요 / 시설 안내가 조금 아쉬웠어요"></textarea>
					</div>

					<!-- 3. 정보 신뢰도 -->
					<div class="form-group">
						<label class="form-label">3. 제공된 정보의 신뢰도는 어땠나요? (10점 만점)</label>
						<div class="score-wrap" data-target="page_info_reliability_score">
							<c:forEach begin="1" end="10" var="i">
								<button type="button" class="score-item" data-value="${i}">${i}</button>
							</c:forEach>
						</div>
						<div class="form-hint">장소 정보, 이용 정보, 안내 정보 기준으로 생각하면 됩니다.</div>
					</div>

					<!-- 4. 개선사항 -->
					<div class="form-group">
						<label for="improvements" class="form-label">4. 개선되었으면 하는 점이 있다면 적어주세요.</label>
						<textarea id="improvements" name="improvements" class="form-control-custom"
							placeholder="예) 예약 확인 안내가 더 명확했으면 좋겠어요"></textarea>
					</div>

					<!-- 5. 추천 의향 -->
					<div class="form-group survey-last-group">
						<label class="form-label">5. 다른 사람에게 추천할 의향이 있나요? (10점 만점)</label>
						<div class="score-wrap" data-target="page_nps_score">
							<c:forEach begin="1" end="10" var="i">
								<button type="button" class="score-item" data-value="${i}">${i}</button>
							</c:forEach>
						</div>
						<div class="form-hint">재방문 의사와 추천 의향을 기준으로 생각하면 됩니다.</div>
					</div>
				</div>

				<!-- =========================
				     리뷰 카드
				     ========================= -->
				<div class="form-card">
					<h3>
						<i class="bi bi-star"></i> 리뷰 작성
					</h3>

					<!-- 별점 -->
					<div class="form-group">
						<label class="form-label">별점을 선택해주세요. (5점 만점)</label>
						<div class="score-wrap" data-target="page_rating">
							<c:forEach begin="1" end="5" var="i">
								<button type="button" class="star-item" data-value="${i}">★${i}</button>
							</c:forEach>
						</div>
						<div class="star-guide">별점은 리뷰 평균 점수에 반영될 수 있습니다.</div>
					</div>

					<!-- 리뷰 내용 -->
					<div class="form-group review-last-group">
						<label for="content" class="form-label">리뷰 내용을 작성해주세요.</label>
						<textarea id="content" name="content" class="form-control-custom"
							placeholder="이용 경험을 자유롭게 남겨주세요. 다른 사용자에게도 큰 도움이 됩니다."></textarea>
					</div>
				</div>

				<!-- =========================
				     하단 버튼
				     ========================= -->
				<div class="button-area">
					<button type="button" class="btn-line"
						onclick="location.href='${path}/viewReservations.do'">
						목록으로
					</button>

					<button type="submit" class="btn-point">
						제출하기
					</button>
				</div>
			</form>
		</section>

		<%@ include file="../../common/footer.jsp"%>
	</div>

	<script>
	document.addEventListener("DOMContentLoaded", function() {

		/* =========================
		   점수 / 별점 버튼 공통 처리
		   data-target 값과 hidden id를 1:1로 맞춤
		   ========================= */
		const wraps = document.querySelectorAll(".score-wrap");

		wraps.forEach(function(wrap) {
			const targetId = wrap.getAttribute("data-target");
			const hiddenInput = document.getElementById(targetId);
			const buttons = wrap.querySelectorAll("button");

			buttons.forEach(function(btn) {
				btn.addEventListener("click", function() {
					// 같은 그룹 버튼 active 초기화
					buttons.forEach(function(item) {
						item.classList.remove("active");
					});

					// 현재 버튼 active
					btn.classList.add("active");

					// hidden 값 세팅
					if (hiddenInput) {
						hiddenInput.value = btn.getAttribute("data-value");
						console.log(targetId + " =", hiddenInput.value);
					} else {
						console.log("hidden input 못 찾음:", targetId);
					}
				});
			});
		});

		/* =========================
		   제출 전 검증
		   page_... hidden 기준으로 검사
		   ========================= */
		const form = document.getElementById("surveyForm");

		if (form) {
			form.addEventListener("submit", function(e) {
				const satisfaction = document.getElementById("page_satisfaction_score").value;
				const reliability = document.getElementById("page_info_reliability_score").value;
				const nps = document.getElementById("page_nps_score").value;
				const rating = document.getElementById("page_rating").value;
				const content = document.getElementById("content").value.trim();

				console.log("FINAL satisfaction =", satisfaction);
				console.log("FINAL reliability =", reliability);
				console.log("FINAL nps =", nps);
				console.log("FINAL rating =", rating);

				if (!satisfaction) {
					alert("만족도를 선택해주세요.");
					e.preventDefault();
					return;
				}

				if (!reliability) {
					alert("정보 신뢰도를 선택해주세요.");
					e.preventDefault();
					return;
				}

				if (!nps) {
					alert("추천 의향을 선택해주세요.");
					e.preventDefault();
					return;
				}

				if (!rating) {
					alert("리뷰 별점을 선택해주세요.");
					e.preventDefault();
					return;
				}

				if (content === "") {
					alert("리뷰 내용을 작성해주세요.");
					document.getElementById("content").focus();
					e.preventDefault();
				}
			});
		}
	});
	</script>
</body>
</html>