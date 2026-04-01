<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- 공통 설정 파일(경로, 태그라이브러리 등) 포함 --%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 | 맛침내!</title>
<%-- 부트스트랩 및 폰트어썸 등 외부 라이브러리 설정 포함 --%>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet"
	href="${path}/resources/css/user/mypage/myPageHome.css">
<!-- 풀캘린더 css -->
<link
	href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/main.min.css"
	rel="stylesheet" />
<!-- 풀캘린더 js -->
<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js"></script>
<script src="${path}/resources/js/user/survey.js"></script>

</head>
<body>

	<c:if test="${empty sessionScope.sessionID}">
		<script>
			alert("로그인이 필요합니다.");
			window.location = "${path}/login.do";
		</script>
	</c:if>

	<!-- 
	<부트스트랩>
	m : Margin(바깥쪽 여백), p : Padding(안쪽 여백)
	t (top): 위 / b (bottom): 아래 / s (start): 왼쪽 / e (end): 오른쪽
	x: 좌우 / y: 위아래 / (없음): 상하좌우 전체
	g : Gutter -> 부트스트랩의 row 안에서 자식 요소(col)들 사이의 간격
	 -->

	<div class="wrap">
		<%-- 공통 헤더 포함 --%>
		<%@ include file="../../common/header.jsp"%>

		<%-- 메인 컨테이너: 상하 여백(my-5) --%>
		<div class="container my-5">
			<%-- 그리드 시스템 시작: 간격(g-4) --%>
			<div class="row g-4">

				<aside class="col-lg-3">
					<%-- 프로필 정보 표시 섹션 --%>
					<div class="profile_card p-4 text-center mb-4">
						<div class="profile_img mb-3">
							<img src="${path}/resources/images/common/myLocation.png"
								class="mypage-character">
						</div>
						<p class="mb-1 small">반가워요!</p>
						<h3 class="fw-bold h4 mb-3">${sessionScope.sessionID}님</h3>
						<p class="mb-3 point_text">
							<i class="bi bi-cash-coin"></i> 보유 포인트 <strong>${dto.point_balance != null ? dto.point_balance : 0}
								P</strong>
						</p>

						<!--  ===============================
						 추가: 김재원 2026-03-26
						 마이페이지 포인트 내역 보여주기 -->
						<!-- 포인트 내역 카드 -->
						<div class="point-card card mb-4 shadow-sm">
							<div class="card-body p-3">
								<!-- 펼치기 버튼 -->
								<button id="toggleHistory" class="toggle-btn mb-2">
									<span class="arrow">▼</span> 포인트 내역
								</button>

								<!-- 포인트 내역 -->
								<div class="point-history"
									style="display: none; max-height: 250px; overflow-y: auto;">
									<c:forEach var="p" items="${pointList}">
										<div
											class="point-row d-flex align-items-center py-1 border-bottom">
											<div class="date text-muted"
												style="width: 45px; flex-shrink: 0;">
												${fn:substring(p.pointLogDate.toString(),2,10)}</div>
											<div class="content text-truncate"
												style="flex-grow: 1; margin: 0 7px;">
												<c:choose>
													<c:when test="${p.policy_key == 'EARN_JOIN'}">회원가입</c:when>
													
													<c:when test="${p.policy_key == 'EARN_SURVEY&REVIEW'}">설문조사&리뷰 참여</c:when>
													<c:when test="${p.policy_key == 'USE_BOOKING'}">예약사용</c:when>
													<c:otherwise>${p.policy_key}</c:otherwise>
												</c:choose>
											</div>

											<div class="amount text-end fw-bold"
												style="width:60px; flex-shrink:0; color:${p.type == 'EARN' ? 'green' : 'red'};">
												${p.amount} P</div>
										</div>
									</c:forEach>
								</div>
							</div>
						</div>

						<!-- =================================  -->

						<a href="${path}/modifyUser.do"
							class="btn btn-light btn-sm rounded-pill fw-bold px-3 text-success">정보
							수정/탈퇴</a>
					</div>

					<%-- 캘린더 요약 섹션 --%>
					<div class="card border-0 shadow-sm p-4 rounded-4">
						<div
							class="d-flex justify-content-between align-items-center mb-3">
							<h5 class="fw-bold mb-0">나의 예약 캘린더</h5>

							<!-- 큰 캘린더 모달 열기 버튼 -->
							<button type="button" id="openCalendarModal"
								class="calendar_icon_btn" title="큰 캘린더 보기">
								<i class="bi bi-calendar3"></i>
							</button>
						</div>

						<%-- FullCalendar가 들어갈 영역 --%>
						<div id="miniCalendar"></div>
					</div>
				</aside>

				<main class="col-lg-9">

					<h4 class="fw-bold mb-4 d-flex align-items-center">
						<img src="${path}/resources/images/common/locationMarker.png"
							class="title-marker">나의 활동현황
					</h4>
					<div class="row g-3 mb-5 text-center">
						<div class="col-md-4">
							<div class="card activity_item p-4"
								onclick="location.href='${path}/viewBookmarks.do'">
								<div class="icon_box mb-3">
									<i class="bi bi-heart text-success fs-4"></i> <span
										class="badge rounded-pill bg-primary count_badge">${bookmarkCount}</span>
								</div>
								<span class="fw-bold">즐겨찾기</span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="card activity_item p-4"
								onclick="location.href='${path}/viewReservations.do'">
								<div class="icon_box mb-3">
									<i class="bi bi-calendar-check text-success fs-4"></i> <span
										class="badge rounded-pill bg-primary count_badge">${reservationCount}</span>
								</div>
								<span class="fw-bold">예약 목록</span>
							</div>
						</div>
						<div class="col-md-4">
							<div class="card activity_item p-4"
								onclick="location.href='${path}/viewInquiries.do'">
								<div class="icon_box mb-3">
									<i class="bi bi-envelope text-success fs-4"></i> <span
										class="badge rounded-pill bg-primary count_badge">${inquiryCount}</span>
								</div>
								<span class="fw-bold">1:1 문의</span>
							</div>
						</div>
					</div>

					<h4 class="fw-bold mb-4 d-flex align-items-center">
						<img src="${path}/resources/images/common/locationMarker.png"
							class="title-marker"> 내 즐겨찾기 맛집 TOP3
					</h4>
					<div class="row g-3 mb-5">
						<c:choose>
							<c:when test="${not empty topRestList}">
								<c:forEach var="item" items="${topRestList}" varStatus="status">
									<div class="col-md-4">
										<div class="card custom_card position-relative"
											onclick="location.href='${path}/restaurantDetail.rs?place_id=${item.place_id}'">

											<div class="card_img"
												style="background-image: url('${empty item.image_url ? path.concat('/resources/images/noimage.jpg') : item.image_url}');">

												<button type="button" class="bookmark-btn"
													onclick="toggleBookmark(event, this)"
													data-place-id="${item.place_id}">
													<i class="bi bi-bookmark-fill"></i>
												</button>

												<span class="rank_badge"> ${status.index + 1}위</span>
											</div>

											<div class="card-body p-3">
												<p class="fw-bold mb-0 text-truncate"
													style="font-size: 1.05rem;">${item.name}</p>
												<small class="text-muted d-block mt-1">${item.address}</small>
											</div>
										</div>
									</div>
								</c:forEach>
							</c:when>

							<c:otherwise>
								<div class="col-12">
									<div
										class="card border-0 shadow-sm p-4 rounded-4 text-center text-muted">
										즐겨찾기한 맛집이 없습니다.</div>
								</div>
							</c:otherwise>
						</c:choose>
					</div>

					<h4 class="fw-bold mb-4 d-flex align-items-center">
						<img src="${path}/resources/images/common/locationMarker.png"
							class="title-marker">내 즐겨찾기 숙소 TOP3
					</h4>
					<div class="row g-3 mb-5">
						<c:choose>
							<c:when test="${not empty topAccList}">
								<c:forEach var="item" items="${topAccList}" varStatus="status">
									<div class="col-md-4">
										<div class="card custom_card position-relative"
											onclick="location.href='${path}/accommodationDetail.ac?place_id=${item.place_id}'">

											<div class="card_img"
												style="background-image: url('${empty item.image_url ? path.concat('/resources/images/noimage.jpg') : item.image_url}');">

												<button type="button" class="bookmark-btn"
													onclick="toggleBookmark(event, this)"
													data-place-id="${item.place_id}">
													<i class="bi bi-bookmark-fill"></i>
												</button>

												<span class="rank_badge"> ${status.index + 1}위</span>
											</div>

											<div class="card-body p-3">
												<p class="fw-bold mb-0 text-truncate"
													style="font-size: 1.05rem;">${item.name}</p>
												<small class="text-muted d-block mt-1">${item.address}</small>
											</div>
										</div>
									</div>
								</c:forEach>
							</c:when>

							<c:otherwise>
								<div class="col-12">
									<div
										class="card border-0 shadow-sm p-4 rounded-4 text-center text-muted">
										즐겨찾기한 숙소가 없습니다.</div>
								</div>
							</c:otherwise>
						</c:choose>
					</div>

					<h4 class="fw-bold mb-4 d-flex align-items-center">
						<img src="${path}/resources/images/common/locationMarker.png"
							class="title-marker">내 즐겨찾기 축제 TOP3
					</h4>
					<div class="row g-3">
						<c:choose>
							<c:when test="${not empty topFestList}">
								<c:forEach var="item" items="${topFestList}" varStatus="status">
									<div class="col-md-4">
										<div class="card custom_card position-relative"
											onclick="location.href='${path}/festivalDetail.fe?place_id=${item.place_id}'">

											<div class="card_img"
												style="background-image: url('${empty item.image_url ? path.concat('/resources/images/noimage.jpg') : item.image_url}');">

												<button type="button" class="bookmark-btn"
													onclick="toggleBookmark(event, this)"
													data-place-id="${item.place_id}">
													<i class="bi bi-bookmark-fill"></i>
												</button>

												<span class="rank_badge"> ${status.index + 1}위</span>
											</div>

											<div class="card-body p-3">
												<p class="fw-bold mb-0 text-truncate"
													style="font-size: 1.05rem;">${item.name}</p>
												<small class="text-muted d-block mt-1">${item.address}</small>
											</div>
										</div>
									</div>
								</c:forEach>
							</c:when>

							<c:otherwise>
								<div class="col-12">
									<div
										class="card border-0 shadow-sm p-4 rounded-4 text-center text-muted">
										즐겨찾기한 축제가 없습니다.</div>
								</div>
							</c:otherwise>
						</c:choose>
					</div>

				</main>
			</div>
		</div>

		<%-- 공통 푸터 포함 --%>
		<%@ include file="../../common/footer.jsp"%>
	</div>

	<script>
		const contextPath = '${path}';
		
	    /* 미니 캘린더 타입/상태 2줄 표시용 */
	    var miniEvents = [
	        <c:forEach var="item" items="${calendarList}" varStatus="st">
	        {
	        	/* 예약 고유번호(클릭 상세이동) */
	            id: '${item.RESERVATIONID}',
	            /* 예약 날짜 */
	            start: '${item.STARTDATE}',
	            /* 종일 일정처리 */
	            allDay: true,

	            /* 미니 캘린더 표시용 텍스트 */
	            extendedProps: {
	                placeTypeText:
	                    <c:choose>
	                        <c:when test="${item.PLACETYPE eq 'REST'}">'맛집'</c:when>
	                        <c:when test="${item.PLACETYPE eq 'ACC'}">'숙소'</c:when>
	                        <c:when test="${item.PLACETYPE eq 'FEST'}">'축제'</c:when>
	                        <c:otherwise>'기타'</c:otherwise>
	                    </c:choose>,
	                statusText:
	                    <c:choose>
	                        <c:when test="${item.STATUS eq 'COMPLETED'}">'완료'</c:when>
	                        <c:when test="${item.STATUS eq 'PENDING'}">'대기'</c:when>
	                        <c:when test="${item.STATUS eq 'RESERVED'}">'확정'</c:when>
	                        <c:when test="${item.STATUS eq 'CANCELLED'}">'취소'</c:when>
	                        <c:when test="${item.STATUS eq 'NOSHOW'}">'미방'</c:when>
	                        <c:otherwise>'기타'</c:otherwise>
	                    </c:choose>
	            },
				/* 타입/상태 색상 구분 */
	            classNames: [
	                <c:choose>
	                    <c:when test="${item.PLACETYPE eq 'REST'}">'fc-type-rest'</c:when>
	                    <c:when test="${item.PLACETYPE eq 'ACC'}">'fc-type-acc'</c:when>
	                    <c:when test="${item.PLACETYPE eq 'FEST'}">'fc-type-fest'</c:when>
	                    <c:otherwise>'fc-type-etc'</c:otherwise>
	                </c:choose>,
	                <c:choose>
	                    <c:when test="${item.STATUS eq 'COMPLETED'}">'fc-status-completed'</c:when>
	                    <c:when test="${item.STATUS eq 'PENDING'}">'fc-status-pending'</c:when>
	                    <c:when test="${item.STATUS eq 'RESERVED'}">'fc-status-reserved'</c:when>
	                    <c:when test="${item.STATUS eq 'CANCELLED'}">'fc-status-cancelled'</c:when>
	                    <c:when test="${item.STATUS eq 'NOSHOW'}">'fc-status-noshow'</c:when>
	                    <c:otherwise>'fc-status-etc'</c:otherwise>
	                </c:choose>
	            ]
	        }<c:if test="${!st.last}">,</c:if>
	        </c:forEach>
	    ];

	    /* 모달 캘린더용 이벤트 */
	    var modalEvents = [
	        <c:forEach var="item" items="${calendarList}" varStatus="st">
	        {
	        	/* 예약 고유번호 */
	            id: '${item.RESERVATIONID}',
	            /* 모달 캘린더 장소명 */
	            title: '${item.PLACENAME}',
	            /* 예약 날자 */
	            start: '${item.STARTDATE}',
	            /* 종일 일정 */
	            allDay: true,
	            /* 타입/상태 색상 구분 클래스 */
	            classNames: [
	                <c:choose>
	                    <c:when test="${item.PLACETYPE eq 'REST'}">'fc-type-rest'</c:when>
	                    <c:when test="${item.PLACETYPE eq 'ACC'}">'fc-type-acc'</c:when>
	                    <c:when test="${item.PLACETYPE eq 'FEST'}">'fc-type-fest'</c:when>
	                    <c:otherwise>'fc-type-etc'</c:otherwise>
	                </c:choose>,
	                <c:choose>
	                    <c:when test="${item.STATUS eq 'COMPLETED'}">'fc-status-completed'</c:when>
	                    <c:when test="${item.STATUS eq 'PENDING'}">'fc-status-pending'</c:when>
	                    <c:when test="${item.STATUS eq 'RESERVED'}">'fc-status-reserved'</c:when>
	                    <c:when test="${item.STATUS eq 'CANCELLED'}">'fc-status-cancelled'</c:when>
	                    <c:when test="${item.STATUS eq 'NOSHOW'}">'fc-status-noshow'</c:when>
	                    <c:otherwise>'fc-status-etc'</c:otherwise>
	                </c:choose>
	            ]
	        }<c:if test="${!st.last}">,</c:if>
	        </c:forEach>
	    ];
	
	</script>

	<!-- 큰 캘린더 모달 -->
	<div id="calendarModal" class="calendar_modal">
		<div class="calendar_modal_overlay"></div>

		<div class="calendar_modal_content">
			<div class="calendar_modal_header">
				<h4 class="fw-bold mb-0">예약 캘린더 전체보기</h4>
				<button type="button" id="closeCalendarModal"
					class="calendar_modal_close">×</button>
			</div>

			<div class="calendar_modal_body">
				<!-- 큰 FullCalendar가 렌더링될 영역 -->
				<div id="bigCalendar"></div>
			</div>
		</div>
	</div>
	<script src="${path}/resources/js/user/mypage/myPageHome.js"></script>
</body>
<!-- 포인트 부분 펼치고 접는 기능 js  -->

</html>