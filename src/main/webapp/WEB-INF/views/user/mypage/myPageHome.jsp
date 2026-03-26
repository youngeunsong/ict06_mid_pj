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
<link
	href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/main.min.css"
	rel="stylesheet" />
<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js"></script>
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
							<i class="bi bi-person-fill fs-1"></i>
						</div>
						<p class="mb-1 small">반가워요!</p>
						<h3 class="fw-bold h4 mb-3">${sessionScope.sessionID}님</h3>
						<p class="mb-3 point_text">
							<i class="bi bi-cash-coin"></i> 보유 포인트 <strong>${dto.point_balance != null ? dto.point_balance : 0}
								P</strong>
						</p>
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

					<h4 class="fw-bold mb-4">나의 활동현황</h4>
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

					<h4 class="fw-bold mb-4">내 즐겨찾기 맛집 TOP3</h4>
					<div class="row g-3 mb-5">
						<c:choose>
							<c:when test="${not empty topRestList}">
								<c:forEach var="item" items="${topRestList}" varStatus="status">
									<div class="col-md-4">
										<div class="card custom_card"
											onclick="location.href='${path}/restaurantDetail.rs?place_id=${item.place_id}'">

											<div class="card_img"
												style="background-image: url('${empty item.image_url ? path.concat('/resources/images/noimage.jpg') : item.image_url}');">
												<span class="rank_badge">BEST ${status.index + 1}</span>
											</div>

											<div class="card-body p-3">
												<p class="fw-bold mb-0 text-truncate"
													style="font-size: 1.05rem;">${item.name}</p>
												<small class="text-muted d-block mt-1">
													${item.address} </small>
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

					<h4 class="fw-bold mb-4">내 즐겨찾기 숙소 TOP3</h4>
					<div class="row g-3 mb-5">
						<c:choose>
							<c:when test="${not empty topAccList}">
								<c:forEach var="item" items="${topAccList}" varStatus="status">
									<div class="col-md-4">
										<div class="card custom_card"
											onclick="location.href='${path}/accommodationDetail.ac?place_id=${item.place_id}'">

											<div class="card_img"
												style="background-image: url('${empty item.image_url ? path.concat('/resources/images/noimage.jpg') : item.image_url}');">
												<span class="rank_badge">BEST ${status.index + 1}</span>
											</div>

											<div class="card-body p-3">
												<p class="fw-bold mb-0 text-truncate"
													style="font-size: 1.05rem;">${item.name}</p>
												<small class="text-muted d-block mt-1">
													${item.address} </small>
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

					<h4 class="fw-bold mb-4">내 즐겨찾기 축제 TOP3</h4>
					<div class="row g-3">
						<c:choose>
							<c:when test="${not empty topFestList}">
								<c:forEach var="item" items="${topFestList}" varStatus="status">
									<div class="col-md-4">
										<div class="card custom_card"
											onclick="location.href='${path}/festivalDetail.fe?place_id=${item.place_id}'">

											<div class="card_img"
												style="background-image: url('${empty item.image_url ? path.concat('/resources/images/noimage.jpg') : item.image_url}');">
												<span class="rank_badge">BEST ${status.index + 1}</span>
											</div>

											<div class="card-body p-3">
												<p class="fw-bold mb-0 text-truncate"
													style="font-size: 1.05rem;">${item.name}</p>
												<small class="text-muted d-block mt-1">
													${item.address} </small>
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
	document.addEventListener('DOMContentLoaded', function() {
	
	    // calendarList를 FullCalendar 이벤트 배열로 변환
	    var events = [
	        <c:forEach var="item" items="${calendarList}" varStatus="st">
	        {
	            // 예약 고유번호 (클릭 시 예약상세 이동에 사용)
	            id: '${item.RESERVATIONID}',
	
	            // 캘린더에 표시할 제목
	            title: '${item.PLACENAME}',
	
	            // 예약 날짜
	            start: '${item.STARTDATE}',
	
	            // 종일 이벤트로 처리
	            allDay: true,
	
	            // 장소 타입별 클래스 지정 (맛집/숙소/축제 색상 구분용)
	            classNames: [
	                <c:choose>
	                    <c:when test="${item.PLACETYPE eq 'REST'}">'fc-type-rest'</c:when>
	                    <c:when test="${item.PLACETYPE eq 'ACC'}">'fc-type-acc'</c:when>
	                    <c:when test="${item.PLACETYPE eq 'FEST'}">'fc-type-fest'</c:when>
	                    <c:otherwise>'fc-type-etc'</c:otherwise>
	                </c:choose>
	            ]
	        }<c:if test="${!st.last}">,</c:if>
	        </c:forEach>
	    ];
	
	    /* 미니 캘린더 생성 */
	    var miniCalendar = new FullCalendar.Calendar(document.getElementById('miniCalendar'), {
	
	        // 월간 달력 뷰
	        initialView: 'dayGridMonth',
	
	        // 캘린더 높이
	        height: 470,
	
	        // 상단 헤더 구성
	        headerToolbar: {
	            left: 'prev',
	            center: 'title',
	            right: 'next'
	        },
	
	        // 하루에 이벤트 1개만 보이고 나머지는 +more 처리
	        dayMaxEvents: 1,
	
	        // 현재 달이 아닌 날짜는 숨김
	        showNonCurrentDates: false,
	
	        // 이벤트 데이터 연결
	        events: events,
	
	        // 예약 클릭 시 예약상세 페이지로 이동
	        eventClick: function(info) {
	            location.href = '${path}/reservationDetail.do?reservation_id=' + info.event.id;
	        }
	    });
	
	    miniCalendar.render();
	
	    /* 큰 캘린더 모달 관련 */
	    var calendarModal = document.getElementById('calendarModal');
	    var openCalendarModalBtn = document.getElementById('openCalendarModal');
	    var closeCalendarModalBtn = document.getElementById('closeCalendarModal');
	    var modalOverlay = document.querySelector('.calendar_modal_overlay');
	
	    // 큰 캘린더는 모달이 처음 열릴 때 1번만 생성
	    var bigCalendar = null;
	
	    // 모달 열기
	    function openCalendarModal() {
	        calendarModal.classList.add('show');
	        document.body.style.overflow = 'hidden';
	
	        // 큰 캘린더가 아직 없으면 생성
	        if (!bigCalendar) {
	            bigCalendar = new FullCalendar.Calendar(document.getElementById('bigCalendar'), {
	                initialView: 'dayGridMonth',
	                height: 650,
	
	                headerToolbar: {
	                    left: 'prev,next today',
	                    center: 'title',
	                    right: 'dayGridMonth,listMonth'
	                },
	
	                buttonText: {
	                    today: '오늘',
	                    dayGridMonth: '월',
	                    listMonth: '목록'
	                },
	
	                dayMaxEvents: true,
	                events: events,
	
	                // 큰 캘린더에서도 예약 클릭 시 상세 이동
	                eventClick: function(info) {
	                    location.href = '${path}/reservationDetail.do?reservation_id=' + info.event.id;
	                }
	            });
	
	            bigCalendar.render();
	        } else {
	            // 이미 생성된 경우 크기 다시 계산
	            bigCalendar.updateSize();
	        }
	    }
	
	    // 모달 닫기
	    function closeCalendarModal() {
	        calendarModal.classList.remove('show');
	        document.body.style.overflow = '';
	    }
	
	    // 열기 버튼 클릭
	    openCalendarModalBtn.addEventListener('click', openCalendarModal);
	
	    // 닫기 버튼 클릭
	    closeCalendarModalBtn.addEventListener('click', closeCalendarModal);
	
	    // 오버레이 클릭 시 닫기
	    modalOverlay.addEventListener('click', closeCalendarModal);
	
	    // ESC 키로 닫기
	    document.addEventListener('keydown', function(e) {
	        if (e.key === 'Escape') {
	            closeCalendarModal();
	        }
	    });
	
	});
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
</body>
</html>