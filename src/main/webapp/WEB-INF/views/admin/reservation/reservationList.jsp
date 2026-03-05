<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   	

<!DOCTYPE html>
<html>
<head>
<fmt:setTimeZone value="Asia/Seoul"/>

<style>
body {
	background-color: #F6F6F6 !important;
}

.card {
	border: none;
	box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
}

.card-header {
	background-color: #ffffff;
	border-bottom: 1px solid #eeeeee;
}

.table td, .table th {
	padding: 1rem 0.5rem;
}

.table thead th {
	background-color: #ffffff;
	color: #333;
	font-weight: 600;
	border-bottom: 2px solid #dee2e6;
}

.table tbody td {
	font-size: 0.9rem;
	vertical-align: middle;
}

.table-hover tbody tr:hover {
	background-color: #fcfcfc !important;
}

/* 버튼설정 시작 */
.btn-detail-custom {
	background-color: #495057 !important;
	color: #ffffff !important;
	border: none;
	transition: 0.3s;
}

.btn-detail-custom:hover {
	background-color: #01D281;
}
/* 버튼설정 끝 */
.form-select, .form-control {
	border-radius: 8px !important;
}

.form-switch .form-check-input {
	width: 2.5em;
	height: 1.25em;
	cursor: pointer;
}

.form-switch .form-check-input:checked {
	background-color: #01D281 !important;
	border-color: #01D281 !important;
}

.input-group-sm .form-control {
	border-radius: 20px 0 0 20px;
	padding-left: 15px;
}

.input-group-sm .btn {
	border-radius: 0 20px 20px 0;
	padding-right: 15px;
}

/* 액션icon 시작 */
.action-icon {
	color: #adb5bd;
	transition: 0.2s;
	font-size: 1.1rem;
	cursor: pointer;
	text-decoration: none !important;
}

.action-icon:hover {
	color: #01D281;
	transform: scale(1.15);
}
/* 액션icon 끝 */

/* 배지 커스텀 시작 */
.badge {
	padding: 5px 10px;
	font-weight: 600;
	border-radius: 4px;
}

.bg-res-success {
	background-color: #01D281 !important;
	color: white;
}

.bg-res-pending {
	background-color: #FEFBDA !important;
	color: #856404 !important;
}

.bg-res-cancel {
	background-color: #FF6B6B !important;
	color: white !important;
}

.bg-res-secondary {
	background-color: #E9ECEF !important;
	color: #495057 !important;
}
/* 배지 커스텀 끝 */

/* 페이징 시작 */
.page-link {
	border-radius: 6px !important;
	margin: 0 3px;
	color: #666;
}
/* 페이징 끝 */
</style>
<meta charset="UTF-8">
<title>예약 내역 관리</title>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
	<div class="wrapper">
		<!-- ================= HEADER ================= -->
		<%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>

		<!-- ================= SIDEBAR ================= -->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>
		
		<!-- ================= CONTENT ================= -->
		<div class="content-wrapper"> 
			<main class="app-main">
				<div class="app-content-header py-3">
					<div class="container-fluid">
						<div class="row">
							<div class="col-sm-12">
								<h3 class="mb-0 fw-bold">예약 관리</h3>
							</div>
						</div>
					</div>
				</div>
	
				<!--begin::App Content-->
				<div class="app-content">
					<div class="container-fluid">
						<div class="card shadow-sm border-0">
							<div class="card-header bg-white py-3">
								<div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
									<div class="d-flex align-items-center gap-3">
										<h3 class="card-title">전체 예약 목록</h3>
										
										<!--begin::보기방식 선택영역-->
										<div class="btn-group btn-group sm" role="group" style="margin-left: 20px;">
											<button type="button" class="btn btn-success"
												id="viewCalBtn">
												<i class="bi bi-calendar3 me-1"></i>캘린더
											</button>
											<button type="button" class="btn btn-outline-success"
												id="viewListBtn">
												<i class="bi bi-list-ul me-1"></i>리스트
											</button>
										</div>
										<!--end::보기방식 선택영역-->
										
										<!--begin::필터 선택영역-->					
										<div id="listFilters" class="d-flex gap-2">
											<!--예약상태 필터-->
											<select id="statusFilter"
												class="form-select form-select-sm border-light bg-light shadow-none"
												onchange="statusFilterChange(this.value)" style="width: 130px;">
												<option value="">예약 상태</option>
												<option value="RESERVED"
													${param.status == 'RESERVED' ? 'selected':''}>확정</option>
												<option value="PENDING"
													${param.status == 'PENDING' ? 'selected':''}>결제대기</option>
												<option value="CANCELLED"
													${param.status == 'CANCELLED' ? 'selected':''}>취소</option>
												<option value="COMPLETED"
													${param.status == 'COMPLETED' ? 'selected':''}>이용완료</option>
											</select>
											<!--장소분류 필터-->
											<select id="placeTypeFilter" class="form-select form-select-sm border-light bg-light shadow-none"
													onchange="placeTypeFilterChange(this.value)" style="width:130px;">
													<option value="">장소 분류</option>
													<option value="REST" ${param.placeType == 'REST' ? 'selected' : ''}>맛집</option>
													<option value="ACC" ${param.placeType == 'ACC' ? 'selected' : ''}>숙소</option>
													<option value="FEST" ${param.placeType == 'FEST' ? 'selected' : ''}>축제</option>
											</select>
										</div>
										<!--end::필터 선택영역-->	
									</div>
									
									<!--begin::검색창-->
									<div id="searchTool">
										<form action="${path}/getReservationList.ad" method="get"
											class="input-group input-group-sm" style="width: 250px;">
											<input type="text" name="keyword"
												class="form-control border-0 bg-light" value="${param.keyword}"
												placeholder="ID 또는 예약번호">
											<button type="submit" class="btn text-white" style="background-color:#01D281;">
												<i class="bi bi-search"></i>
											</button>
										</form>
									</div>
									<!--end::검색창-->
								</div>
							</div>
	
						<!--begin::리스트로 보기-->
						<div class="card-body p-0">
							<div id="reservationListView">
								<div class="table-responsive">
									<table class="table table-hover align-middle m-0" data-bs-toggle="false" style="width:100%;">
										<thead class="table-light">
											<tr>
												<th class="text-center" style="width: 80px;">No.</th>
												<th class="ps-4">사용자 ID</th>
												<th class="text-center">분류</th>
												<th class="text-center">인원</th>
												<th class="text-center">예약일</th>
												<th class="text-center">상태</th>
												<th class="text-center" style="width: 120px;">관리</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="dto" items="${list}">
												<tr>
													<td class="text-center text-muted">${dto.reservation_id}</td>
													<td class="ps-4 fw-bold">${dto.user_id}</td>
													<td class="text-center">
														<c:choose>
															<c:when test="${dto.placeDTO.place_type == 'REST'}">맛집</c:when>
															<c:when test="${dto.placeDTO.place_type == 'ACC'}">숙소</c:when>
															<c:when test="${dto.placeDTO.place_type == 'FEST'}">축제</c:when>
														</c:choose>
													</td>
													<td class="text-center">${dto.guest_count}명</td>
													<td class="text-center"><fmt:formatDate
															value="${dto.resDate}" pattern="yyyy-MM-dd" /></td>
													<td class="text-center">
														<c:choose>
															<c:when test="${dto.status == 'RESERVED'}">
																<span class="badge bg-res-success">확정</span>
															</c:when>
															<c:when test="${dto.status == 'PENDING'}">
																<span class="badge bg-res-pending">결제대기</span>
															</c:when>
															<c:when test="${dto.status == 'CANCELLED'}">
																<span class="badge bg-res-cancel">취소</span>
															</c:when>
															<c:when test="${dto.status == 'COMPLETED'}">
																<span class="badge bg-res-secondary">이용완료</span>
															</c:when>
															<c:otherwise>
																<span class="badge bg-res-secondary">${dto.status}</span>
															</c:otherwise>
														</c:choose>
													</td>
													<td class="text-center">
														<div class="d-flex justify-content-center gap-3">
															<a href="javascript:void(0)"
																onclick="viewDetail('${dto.reservation_id}')"
																class="action-icon" title="상세보기">
																<i class="bi bi-eye"></i>
															</a>
															<a href="javascript:void(0)"
																onclick="editReservation('${dto.reservation_id}')"
																class="action-icon" title="수정">
																<i class="bi bi-pencil-square"></i>
															</a>
														</div>
													</td>
												</tr>
											</c:forEach>
		
											<c:if test="${empty list}">
												<tr>
													<td colspan="6">조회된 예약 내역이 없습니다.</td>
												</tr>
											</c:if>
										</tbody>
									</table>
								</div>
								<!--end::리스트로 보기-->
								
								<!--begin::pagination-->
								<div class="py-3 border-top">
									<%@ include file="/WEB-INF/views/common/pagination.jsp"%>
								</div>
								<!--end::pagination-->
							</div>
							<!--end::리스트로 보기-->
	
							<!--begin::캘린더로 보기-->
							<div id="reservationCalendarView"
								style="display: none; padding: 20px;">
								<div id="calendar" class="bg-white p-3 rounded shadow-sm border" style="height:650px;"></div>
							</div>
							<!--end::캘린더로 보기-->
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>	
	<!-- ================= FOOTER ================= -->
	<footer class="main-footer">
		<strong>Copyright &copy; 2026</strong>
	</footer>
	
	</div>
	<!--end::Div-wrapper-->

<!-- 예약 상세보기 modal 시작 -->
<div class="modal fade" id="resDetailModal" tabindex="-1" role="dialog"
	aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="resDetailModalLabel">
					<i class="bi bi-info-circle me-2"></i>예약 상세 정보
				</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<table class="table table-bordered">

					<tbody>
						<tr>
							<th class="table-light" style="width: 20%;">예약번호</th>
							<td id="modal_res_id" style="width: 30%;"></td>
							<th class="table-light" style="width: 20%;">예약상태</th>
							<td id="modal_status" style="width: 30%;"></td>
						</tr>
						<tr>
							<th class="table-light">장소명</th>
							<td id="modal_name"></td>
							<th class="table-light">예약자ID</th>
							<td id="modal_user_id"></td>
						</tr>
						<tr>
							<th class="table-light">방문일</th>
							<td id="modal_check_in"></td>
							<th class="table-light">퇴실일</th>
							<td id="modal_check_out"></td>
						</tr>
						<tr>
							<th class="table-light">인원수</th>
							<td id="modal_guest_count" colspan="3"></td>
						</tr>
					</tbody>
				</table>
				<pre>
			<code>
				SELECT R.*,
					P.NAME,
					P.ADDRESS
				FROM RESERVATION R
				JOIN PLACE P ON R.PLACE_ID = P.PLACE_ID
				WHERE R.RESERVATION_ID = #${'{'}reservation_id}	
			</code>
		</pre>
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-secondary"
					data-bs-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>
<!-- 예약 상세보기 modal 끝 -->

<!-- 예약 수정 modal 시작 -->
<div class="modal fade" id="resUpdateModal" tabindex="-1" role="dialog"
	aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header bg-primary text-white">
				<h5 class="modal-title fw-bold">
					<i class="bi bi-pencil-square me-2"></i>예약 정보 수정
				</h5>
				<button type="button" class="btn-close btn-close-white"
					data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<table class="table table-bordered">
					<tbody>
						<tr>
							<th class="table-light" style="width: 20%;">예약번호</th>
							<td style="width: 30%;"><input type="text"
								id="update_res_id" class="form-control-plaintext ps-2 fw-bold"
								readonly></td>
							<th class="table-light" style="width: 20%;">예약상태</th>
							<td style="width: 30%;"><select id="update_status"
								class="form-select border-primary">
									<option value="RESERVED">확정</option>
									<option value="PENDING">결제대기</option>
									<option value="CANCELLED">취소</option>
									<option value="COMPLETED">이용완료</option>
							</select></td>
						</tr>
						<tr>
							<th class="table-light">장소명</th>
							<td><input type="text" id="update_name"
								class="form-control-plaintext ps-2" readonly></td>
							<th class="table-light">예약자ID</th>
							<td><input type="text" id="update_user_id"
								class="form-control-plaintext ps-2" readonly></td>
						</tr>
						<tr>
							<th class="table-light">방문일</th>
							<td><input type="text" id="update_check_in"
								class="form-control-plaintext ps-2" readonly></td>
							<th class="table-light">퇴실일</th>
							<td><input type="text" id="update_check_out"
								class="form-control-plaintext ps-2" readonly></td>
						</tr>
						<tr>
							<th class="table-light">인원수</th>
							<td colspan="3"><input type="text" id="update_guest_count"
								class="form-control-plaintext ps-2" readonly></td>
						</tr>
					</tbody>
				</table>
				<pre>
			<code>
			SELECT R.*,
				P.NAME,
				P.ADDRESS
			FROM RESERVATION R
			JOIN PLACE P ON R.PLACE_ID = P.PLACE_ID
			WHERE R.RESERVATION_ID = #${'{'}reservation_id}	
			</code>
		</pre>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary"
					onclick="updateReservationStatus()">변경사항 저장</button>
				<button type="button" class="btn btn-secondary"
					data-bs-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>
<!-- 예약 수정 modal 끝 -->

<!-- 관련 SQL -->
SQL 쿼리 : 예약목록 전체 조회
<pre>
	<code>
		SELECT * FROM RESERVATION
		<where>
			<if test="keyword != null and keyword != ''">
				(user_id LIKE '%'||#${'{'}keyword}||'%' OR reservation_id LIKE '%'||#${'{'}keyword}||'%')
			</if>
			<if test="status != null and status != ''">
				AND status = #${'{'}status}
			</if>
		</where>
		ORDER BY created_at DESC
	</code>
</pre>

<!--begin::리스트/캘린더형 보기 클릭 시 전환-->
<!-- FullCalendar 라이브러리 -->
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>

<script>
	//서버데이터를 js 전역변수로 선언
	const reservationData = [
		<c:forEach var="res" items="${list}" varStatus="status">
		<c:choose>
			<c:when test="${res.placeDTO != null}">
				<c:choose>
					<c:when test="${res.placeDTO.place_type == 'REST'}"><c:set var="placeType" value="맛집" /></c:when>
					<c:when test="${res.placeDTO.place_type == 'ACC'}"><c:set var="placeType" value="숙소" /></c:when>
					<c:when test="${res.placeDTO.place_type == 'FEST'}"><c:set var="placeType" value="축제" /></c:when>
				</c:choose>
				<c:set var="resTitle" value="${res.user_id} | ${res.placeDTO.name}" />
			</c:when>
			<c:otherwise>
				<c:set var="resTitle" value="${res.user_id}" />
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${res.status == 'RESERVED'}"><c:set var="bgColor" value="#01D281" /></c:when>	
			<c:when test="${res.status == 'PENDING'}"><c:set var="bgColor" value="#ffc107" /></c:when>	
			<c:when test="${res.status == 'COMPLETED'}"><c:set var="bgColor" value="#6c757d" /></c:when>
			<c:otherwise><c:set var="bgColor" value="#dc3545" /></c:otherwise>
		</c:choose>
		{
			id: '${res.reservation_id}',	
			title: '${resTitle}',	
			start: '<fmt:formatDate value="${res.check_in}" pattern="yyyy-MM-dd" />',
			end: '<fmt:formatDate value="${res.check_out}" pattern="yyyy-MM-dd" />',
			backgroundColor: '${bgColor}'
		}
		${!status.last ? ',' : ''}
		</c:forEach>
	];
</script>

<!-- ================= JS ================= -->
<!-- path 별도로 선언해야 아래 js에서 활용 가능 -->
<script>
    const path = "${path}";
</script>
<script src="${path}/resources/js/admin/reservation.js"></script>
<!--end::리스트/캘린더형 보기 클릭 시 전환-->

</body>
</html>