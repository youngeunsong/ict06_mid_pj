<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- TODO : 이 페이지의 작동 제대로 하는 지 체크 필요 -->
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<!DOCTYPE html>
<html>
<head>
<fmt:setTimeZone value="Asia/Seoul" />
<!-- ad_reservation.css -->
<link rel="stylesheet"
	href="${path}/resources/css/admin/ad_reservation.css" />
<!-- apexcharts -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/apexcharts@3.37.1/dist/apexcharts.css"
	integrity="sha256-4MX+61mt9NVvvuPjUWdUdyfZfxSB1/Rf9WtqRHgG5S0="
	crossorigin="anonymous" />

<meta charset="UTF-8">
<title>Reservation DASHBOARD</title>
</head>
<!--begin::Body-->
<body class="hold-transition sidebar-mini layout-fixed">
	<!--begin::div wrapper-->
	<div class="wrapper">

		<!-- ================= HEADER ================= -->
		<%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>

		<!-- ================= SIDEBAR ================= -->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>	
		
		<!-- ================= CONTENT ================= -->
		<div class="content-wrapper">	
			<!--begin::App Content Header-->
			<div class="app-content-header py-4 bg-white border-bottom mb-4">
				<div class="container-fluid">
					<h3 class="font-weight-bold text-dark"><i class="bi bi-bar-chart-fill me-2"></i>Reservation Dashboard</h3>
				</div>
			</div>
			<!--end::App Content Header-->
			
			<!--begin::App Content-->
			<div class="app-content">
				<!--begin::Container-->
				<div class="container-fluid">
					<div class="app-content-header py-3">
						<h3 class="mb-0 font-weight-bold">예약 통계 대시보드</h3>
					</div>
				</div>
				
				<section class="app-content">
					<div class="container-fluid">
						<%--=====KPI 카드=====--%>
						<div class="row mb-4">
							<div class="col-6 col-md-3 mb-3">
								<div class="card text-center shadow-sm">
									<div class="card-body">
										<p class="text-muted mb-1" style="font-size:0.85rem;">전체 예약</p>
										<h3 class="font-weight-bold" style="color:#01D281;">${kpi.TOTAL}</h3>
										<small class="text-muted">건</small>
									</div>
								</div>
							</div>
							<div class="col-6 col-md-3 mb-3">
								<div class="card text-center shadow-sm">
									<div class="card-body">
										<p class="text-muted mb-1" style="font-size:0.85rem;">오늘 예약</p>
										<h3 class="font-weight-bold" style="color:#01D281;">${kpi.TODAY}</h3>
										<small class="text-muted">건</small>
									</div>
								</div>
							</div>
							<div class="col-6 col-md-3 mb-3">
								<div class="card text-center shadow-sm">
									<div class="card-body">
										<p class="text-muted mb-1" style="font-size:0.85rem;">이번달 예약</p>
										<h3 class="font-weight-bold" style="color:#01D281;">${kpi.MONTHLY}</h3>
										<small class="text-muted">건</small>
									</div>
								</div>
							</div>
							<div class="col-6 col-md-3 mb-3">
								<div class="card text-center shadow-sm">
									<div class="card-body">
										<p class="text-muted mb-1" style="font-size:0.85rem;">취소율</p>
										<h3 class="font-weight-bold" style="color:#01D281;">${kpi.CANCEL_RATE}</h3>
										<small class="text-muted">%</small>
									</div>
								</div>
							</div>
						</div>
						
						<%--=====통계 차트=====--%>
						<div class="row mb-4">
							<%--=====left::월별 추이+도넛 차트=====--%>
							<div class="col-12 col-md-6 mb-3">
								<%--월별 예약 추이--%>
								<div class="card shadow-sm mb-3">
									<div class="card-header">
										<h5 class="card-title font-weight-bold mb-0">월별 예약 추이</h5>
									</div>
									<div class="card-body" style="position:relative; height:250px">
										<canvas id="monthlyChart"></canvas>
									</div>
								</div>
								<%--예약상태별 비율(도넛차트)--%>
								<div class="card shadow-sm mb-3">
									<div class="card-header">
										<h5 class="card-title font-weight-bold mb-0">예약 상태별 비율</h5>
									</div>
									<div class="card-body d-flex justify-content-center">
										<canvas id="statusChart" height="120"></canvas>
									</div>
								</div>
								<%--장소분류별 비율(도넛차트)--%>
								<div class="card shadow-sm">
									<div class="card-header">
										<h5 class="card-title font-weight-bold mb-0">장소 분류별 비율</h5>
									</div>
									<div class="card-body d-flex justify-content-center">
										<canvas id="placeTypeChart" height="120"></canvas>
									</div>
								</div>
							</div>
							
							<%--=====right::요일별 분포+예약 처리 현황=====--%>
							<div class="col-12 col-md-6 mb-3">
								<%--=====요일별 분포=====--%>
								<div class="card shadow-sm mb-3">
									<div class="card-header">
										<h5 class="card-title font-weight-bold mb-0">요일별 예약 분포</h5>
									</div>
									<div class="card-body" style="position:relative; height:250px;">
										<canvas id="dayOfWeekChart"></canvas>
									</div>
								</div>
								<%--=====예약 처리 현황 요약=====--%>
								<div class="card shadow-sm">
									<div class="card-header">
										<h5 class="card-title font-weight-bold mb-0">예약 처리 현황</h5>
									</div>
									<div class="card-body">
										<div class="list-group list-group-flush">
											<div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
												<span>대기 중인 예약</span>
												<span class="badge badge-warning badge-pill">${pendingList.size()}건</span>
											</div>
											<div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
												<span>금일 신규 예약</span>
												<span class="badge badge-success badge-pill">${kpi.TODAY}건</span>
											</div>
											<div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
												<span>취소된 예약 비율</span>
												<span class="badge badge-danger badge-pill">${kpi.CANCEL_RATE}%</span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					
						<%--=====미처리 목록+최근 예약=====--%>
						<div class="row">
							<%--=====미처리 목록(PENDING)=====--%>
							<div class="col-12 col-md-6 mb-3">
								<div class="card shadow-sm">
									<div class="card-header">
										<h5 class="card-title font-weight-bold mb-0 text-danger">
											<i class="bi bi-exclamation-circle mr-1"></i>미처리 예약
											<span class="badge badge-danger ml-1">${pendingList.size()}</span>
										</h5>
									</div>
									<div class="card-body p-0">
										<table class="table table-hover m-0">
											<thead class="thead-light">
												<tr>
													<th>예약번호</th>
													<th>사용자</th>
													<th>장소</th>
													<th>방문일</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="dto" items="${pendingList}">
													<tr style="cursor:pointer;" onclick="location.href='${path}/getReservationList.ad?status=PENDING'">
														<td>${dto.reservation_id}</td>
														<td>${dto.user_id}</td>
														<td>${dto.placeDTO.name}</td>
														<td><fmt:formatDate value="${dto.check_in}" pattern="MM-dd" /></td>
													</tr>
												</c:forEach>
												<c:if test="${empty pendingList}">
													<tr>
														<td colspan="4" class="text-center py-3 text-muted">미처리</td>
													</tr>
												</c:if>
											</tbody>
										</table>
									</div>
									<div class="card-footer bg-white">
										<div class="mt-3 p-3 bg-light rounded" style="font-size:0.9rem; color:#666">
											<i class="bi bi-info-circle me-1"></i>미처리 예약은 목록 클릭 시 상세 관리 페이지로 이동합니다.
										</div>
									</div>
								</div>
							</div>
							
							<%--최근 예약 5건--%>
							<div class="col-12 col-md-6 mb-3">
								<div class="card shadow-sm">
									<div class="card-header">
										<h5 class="card-title font-weight-bold mb-0">
											<i class="bi bi-clock-history mr-1"></i>최근 예약
										</h5>
									</div>
									<div class="card-body p-0">
										<table class="table table-hover m-0">
											<thead class="thead-light">
												<tr>
													<th>예약번호</th>
													<th>사용자</th>
													<th>장소</th>
													<th>분류</th>
													<th>상태</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="dto" items="${recentList}">
													<tr>
														<td>${dto.reservation_id}</td>
														<td>${dto.user_id}</td>
														<td>${dto.placeDTO.name}</td>
														<td>
															<c:choose>
																<c:when test="${dto.placeDTO.place_type == 'REST'}">맛집</c:when>
																<c:when test="${dto.placeDTO.place_type == 'ACC'}">숙소</c:when>
																<c:when test="${dto.placeDTO.place_type == 'FEST'}">축제</c:when>
															</c:choose>
														</td>
														<td>
															<c:choose>
																<c:when test="${dto.status == 'RESERVED'}">
																	<span class="badge badge-success">확정</span>
																</c:when>
																<c:when test="${dto.status == 'PENDING'}">
																	<span class="badge badge-warning">결제대기</span>
																</c:when>
																<c:when test="${dto.status == 'CANCELLED'}">
																	<span class="badge badge-danger">취소</span>
																</c:when>
																<c:when test="${dto.status == 'COMPLETED'}">
																	<span class="badge badge-secondary">이용완료</span>
																</c:when>
															</c:choose>
														</td>
													</tr>
												</c:forEach>
												<c:if test="${empty recentList}">
													<tr>
														<td colspan="5" class="text-center py-3 text-muted">예약 내역이 없습니다.</td>
													</tr>
												</c:if>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					
					</div>					
				</section>
			</div>
		
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
	</div>
		
	<!-- JS -->
	<script>
		const dashBoardData = {
			monthly: {
				labels: [
					<c:forEach var="item" items="${monthlyTrend}" varStatus="s">
						'${item.MONTH}'${!s.last ? ',' : ''}
					</c:forEach>
				],
				data: [
					<c:forEach var="item" items="${monthlyTrend}" varStatus="s">
						${item.CNT}${!s.last ? ',' : ''}
					</c:forEach>
				]
			},
			status: {
				labels: [
					<c:forEach var="item" items="${statusRatio}" varStatus="s">
						'${item.STATUS}'${!s.last ? ',' : ''}
					</c:forEach>
				],
				data: [
					<c:forEach var="item" items="${statusRatio}" varStatus="s">
						${item.CNT}${!s.last ? ',' : ''}
					</c:forEach>
				]
			},
			placeType: {
				labels: [
					<c:forEach var="item" items="${placeTypeRatio}" varStatus="s">
						'${item.PLACE_TYPE}'${!s.last ? ',' : ''}
					</c:forEach>
				],
				data: [
					<c:forEach var="item" items="${placeTypeRatio}" varStatus="s">
						${item.CNT}${!s.last ? ',' : ''}
					</c:forEach>
				]
			},
			dayOfWeek: {
				labels: [
					<c:forEach var="item" items="${dayOfWeekStats}" varStatus="s">
						'${item.DAY_NAME}'${!s.last ? ',' : ''}
					</c:forEach>
				],
				data: [
					<c:forEach var="item" items="${dayOfWeekStats}" varStatus="s">
						${item.CNT}${!s.last ? ',' : ''}
					</c:forEach>
				]
			}
		};
	</script>
	<script src="${path}/resources/js/admin/dashboard.js"></script>
</body>
<!--end::Body-->
</html>