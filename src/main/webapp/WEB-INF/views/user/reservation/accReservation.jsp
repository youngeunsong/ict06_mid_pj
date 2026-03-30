<!-- 
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-30
 * 참고 코드: festReservation.jsp
 * 변경 사항
 * ----------------------------------------
 * v260330
 * 예약날짜 선택 flatpickr 캘린더 적용, 예약시간 30분 단위 생성으로 수정
 * ----------------------------------------	
-->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>

<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>숙소 예약 정보 입력</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
	
<!-- Flatpickr Calendar -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>

<style>
:root {
	--r-text: #111827;
	--r-muted: #6b7280;
	--r-line: #e5e7eb;
	--r-brand: #10b981;
	--r-brand2: #059669;
	--r-pill: #f3f4f6;
}

/* 공통 */
.r-muted {
	color: var(--r-muted);
}

.r-pill {
	font-size: 12px;
	color: var(--r-muted);
	background: var(--r-pill);
	padding: 6px 10px;
	border-radius: 999px;
	border: 1px solid var(--r-line);
	display: inline-flex;
	align-items: center;
	gap: 6px;
}

/* 상단 타이틀 */
.r-placeName {
	font-size: 34px;
	line-height: 1.15;
	font-weight: 800;
	letter-spacing: -.02em;
	margin: 0;
}

.r-stars i {
	color: #22c55e;
}

.r-score {
	font-weight: 800;
	color: var(--r-text);
}

/* 갤러리 */
.r-hero {
	border-radius: 18px;
	overflow: hidden;
	border: 1px solid var(--r-line);
	background: #f9fafb;
	position: relative;
	min-height: 420px;
}

.r-hero img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
}

.r-heroCount {
	position: absolute;
	bottom: 14px;
	right: 14px;
	background: rgba(17, 24, 39, .75);
	color: #fff;
	padding: 8px 10px;
	border-radius: 12px;
	font-size: 13px;
	display: flex;
	align-items: center;
	gap: 8px;
}

.r-thumb {
	border: 1px solid var(--r-line);
	border-radius: 16px;
	overflow: hidden;
	background: #f9fafb;
	height: 124px;
	display: grid;
	grid-template-columns: 110px 1fr;
	cursor: pointer;
	transition: .15s;
}

.r-thumb:hover {
	transform: translateY(-1px);
}

.r-thumb img {
	width: 110px;
	height: 100%;
	object-fit: cover;
	display: block;
}

.r-thumbInfo {
	padding: 12px;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}

.r-thumbTitle {
	font-weight: 800;
	font-size: 14px;
	letter-spacing: -.01em;
}

.r-thumbSub {
	color: var(--r-muted);
	font-size: 12px;
	display: flex;
	gap: 8px;
	align-items: center;
}

/* 섹션 */
.r-section {
	padding: 18px 0;
	border-bottom: 1px solid var(--r-line);
}

.r-section:last-child {
	border-bottom: none;
}

.r-sectionTitle {
	font-size: 22px;
	font-weight: 900;
	letter-spacing: -.02em;
	margin: 0 0 10px;
}

.r-lead {
	color: var(--r-muted);
	font-size: 14px;
	line-height: 1.7;
	margin: 0;
}

.r-chip {
	border: 1px solid var(--r-line);
	background: #fff;
	border-radius: 999px;
	padding: 8px 12px;
	font-size: 13px;
	color: var(--r-muted);
	display: inline-flex;
	gap: 8px;
	align-items: center;
	margin-right: 8px;
	margin-bottom: 8px;
}

.r-chip i {
	color: var(--r-brand);
}

/* 지도 */
.r-mapBox {
	border: 1px solid var(--r-line);
	border-radius: 18px;
	overflow: hidden;
	height: 240px;
	background: #f9fafb;
}

/* 메뉴 */
.r-menuItem {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 12px;
	padding: 12px 0;
	border-bottom: 1px dashed var(--r-line);
}

.r-menuItem:last-child {
	border-bottom: none;
}

.r-menuName {
	font-weight: 900;
	letter-spacing: -.01em;
}

.r-menuDesc {
	margin-top: 4px;
	color: var(--r-muted);
	font-size: 12px;
	line-height: 1.5;
}

.r-menuPrice {
	font-weight: 900;
	white-space: nowrap;
}

/* 오른쪽 예약 버튼 */
.r-reserveBtn {
	width: 220px;
	height: 44px;
	border-radius: 999px;
	font-weight: 900;
}

/* sticky 사이드 */
@media ( min-width : 992px) {
	.r-sticky {
		position: sticky;
		top: 14px;
	}
}

#btnFavorite.is-on, #btnFavoriteSide.is-on {
	border-color: #ef4444;
	color: #ef4444;
}

#btnFavorite.is-on i, #btnFavoriteSide.is-on i {
	color: #ef4444;
}
</style>
</head>

<body>
	<%@ include file="../../common/header.jsp"%>

	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-lg-6">

				<!-- ===== 상단 헤더 ===== -->
				<div class="d-flex align-items-center gap-3 mb-4 p-3 bg-light rounded-3">
					<img src="${accommodation.placeDTO.image_url}"
						style="width:80px; height:80px;	object-fit:cover; border-radius:12px;">
					<div>
						<h4 class="mb-1 fw-bold">${accommodation.placeDTO.name}</h4>
						<p class="text-muted mb-0 small">
							<i class="fa-solid fa-location-dot me-1"></i>
							${accommodation.placeDTO.address}
						</p>
					</div>
				</div>
				
				<h3 class="fw-bold mb-4">예약 정보 입력</h3>
				
				<div class="card shadow-sm border-0 p-4" style="border-radius: 20px;">
					<!-- 체크인/체크아웃 -->
					<div class="mb-4">
						<label class="form-label fw-bold">체크인 · 체크아웃</label>
						<div id="selected_date_display" class="text-center mb-2 fw-bold text-success"></div>
						<div id="flatpickr-container" style="display:flex; justify-content:center;"></div>
						<input type="hidden" id="check_in">
						<input type="hidden" id="check_out">
					</div>
					
					<!-- 인원수 -->
					<div class="mb-4">
						<label class="form-label fw-bold">인원 수</label>
						<div class="input-group input-group-lg">
							<input type="number" id="guest_count" class="form-control" value="1" min="1">
							<span class="input-group-text">명</span>
						</div>
					</div>
					
					<!-- 요청사항 -->
					<div class="mb-4">
						<label class="form-label fw-bold">요청사항</label>
						<textarea id="request_note" class="form-control" rows="3" placeholder="전달할 메시지를 적어주세요."></textarea>
					</div>
					
					<hr class="my-4">
					
					<!-- 1박 요금 안내 -->
					<div class="d-flex justify-content-between mb-2 text-muted">
						<span>1박 요금</span>
						<span><fmt:formatNumber value="${accommodation.price}" type="currency" /></span>
					</div>
					<div class="d-flex justify-content-between mb-2 text-muted">
						<span>숙박기간</span>
						<span id="nights_label">-박</span>
					</div>
					
					<!-- 최종 금액 -->
					<div class="d-flex justify-content-between align-items-center mb-4">
						<span class="fs-5 fw-bold">최종 결제 금액</span>
						<span id="total_price" class="fs-3 fw-bold text-success"></span>
					</div>
					
					<!-- 결제/예약 버튼 -->
					<button type="button" id="btnSubmitReservation" class="btn btn-success btn-lg w-100 fw-bold py-3"
							onclick="submitReservation()" style="border-radius:15px;" disabled>
						결제 및 예약하기
					</button>
				</div>
			</div>
		</div>
	</div>

<script>
	const CTX = '${path}';
	const PLACE_ID = '${accommodation.placeDTO.place_id}';
	const PLACE_TYPE = 'ACC';
	const PRICE_PER_NIGHT = ${accommodation.price};
</script>

<script src="${pageContext.request.contextPath}/resources/js/user/accReservation.js"></script>

<%@ include file="../../common/footer.jsp"%>
</body>
</html>