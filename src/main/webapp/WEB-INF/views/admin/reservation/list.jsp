<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<style>
	body {
		background-color: #F6F6F6 !important;
	}
	.card {
		border: none;
		box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
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
		color: #856404;
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
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
	<div class="app-wrapper">
		<!--begin::Sidebar-->
		<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
		<!--end::Sidebar-->
		
		<main class="app-main">
			<div class="app-content-header">
				<div class="container-fluid">
					<div class="row">
						<div class="col-sm-6">
							<nav aria-label="breadcrumb">
								<ol class="breadcrumb m-0">
									<li class="breadcrumb-item"><a href="${path}/admin/home" class="text-decoration-none text-muted">Home</a></li>
									<li class="breadcrumb-item active" aria-current="page">예약 목록</li>
								</ol>
							</nav>
						</div>
					</div>
				</div>
			</div>
	
		<div class="app-content">
			<div class="container-fluid">
				<div class="card shadow-sm border-0 mb-4">
					<div class="card-header bg-white py-3">
						<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
					
						<div class="d-flex justify-content-between align-items-center">
							<div class="d-flex align-items-center gap-3">
								<h3 class="card-title fw-bold m-0" style="color:#333; min-width:150px;">
									<span style="border-left:5px solid #01D281; padding-left:10px;">전체 예약 목록</span>
								</h3>
								<select id="statusFilter" class="form-select form-select-sm border-light bg-light shadow-none" onchange="handleFilterChange(this.value)" style="width:130px;">
									<option value="">예약 상태</option>
									<option value="RESERVED" ${param.status == 'RESERVED' ? 'selected':''}>확정</option>
									<option value="PENDING" ${param.status == 'PENDING' ? 'selected':''}>결제대기</option>
									<option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected':''}>취소</option>
									<option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected':''}>이용완료</option>
								</select>
							</div>
							
							<div class="card-tools">
								<form action="${path}/admin/reservation/list" method="get" class="input-group input-group-sm" style="width: 250px;">
									<input type="text" name="keyword" class="form-control border-0 bg-light shadow-none"
										style="border-radius: 8px 0 0 8px;"
										value="${param.keyword}" placeholder="ID 또는 예약번호">
									<button type="submit" class="btn text-white" style="background-color:#01D281; border-radius:0 8px 8px 0;">
										<i class="fas fa-search"></i>
									</button>
								</form>
							</div>
						</div>
					</div>
						
					<div class="card-body p-0">
						<table class="table table-hover align-middle m-0">
							<thead class="table-light">
								<tr>
									<th class="text-center" style="width:80px;">No.</th>
									<th class="ps-4">사용자 ID</th>
									<th class="text-center">인원</th>
									<th class="text-center">예약일시</th>
									<th class="text-center">상태</th>
									<th class="text-center" style="width: 120px;">관리</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="dto" items="${list}">
									<tr>
										<td class="text-center text-muted">${dto.reservation_id}</td>
										<td class="ps-4 fw-bold">${dto.user_id}</td>
										<td class="text-center">${dto.guest_count}명</td>
										<td class="text-center">
											<fmt:formatDate value="${dto.resDate}" pattern="yyyy-MM-dd HH:mm"/>
										</td>
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
												<a href="javascript:void(0)" onclick="viewDetail('${dto.reservation_id}')" class="action-icon" title="상세보기">
													<i class="fas fa-eye"></i>
												</a>
												<a href="javascript:void(0)" onclick="editReservation('${dto.reservation_id}')" class="action-icon" title="수정">
													<i class="fas fa-edit"></i>
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
				</div>
			</div>
		</div>
	</main>
</div>

<!-- 예약 상세보기 modal 시작 -->
<div class="modal fade" id="resDetailModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
				<h5 class="modal-title" id="resDetailModalLabel fw-bold"><i class="fas fa-info-circle me-2"></i>예약 상세 정보</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<table class="table table-bordered">
				
					<tbody>
						<tr>
			            <th class="table-light" style="width:20%;">예약번호</th>
			            <td id="modal_res_id" style="width:30%;"></td>
			            <th class="table-light" style="width:20%;">예약상태</th>
			            <td id="modal_status" style="width:30%;">
			            	<select class="form-select form-select-sm"></select>
			            </td>
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
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
		</div>
	</div>
</div>
</div>
<!-- 예약 상세보기 modal 끝 -->

<!-- 예약 수정 modal 시작 -->
<div class="modal fade" id="resUpdateModal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header bg-primary text-white">
				<h5 class="modal-title fw-bold">
					<i class="fas fa-edit me-2">예약 정보 수정</i>
				</h5>
				<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<table class="table table-bordered">
					<tbody>
						<tr>
			            <th class="table-light" style="width:20%;">예약번호</th>
			            <td style="width:30%;">
			            	<input type="text" id="update_res_id" class="form-control-plaintext ps-2 fw-bold" readonly>
			            </td>
			            <th class="table-light" style="width:20%;">예약상태</th>
			            <td style="width:30%;">
			            	<select id="update_status" class="form-select border-primary">
			            		<option value="RESERVED">확정</option>
			            		<option value="PENDING">결제대기</option>
			            		<option value="CANCELLED">취소</option>
			            		<option value="COMPLETED">이용완료</option>
			            	</select>
			            </td>
					</tr>
					<tr>
			            <th class="table-light">장소명</th>
			            <td>
			            	<input type="text" id="update_name" class="form-control-plaintext ps-2" readonly>
			            </td>
						<th class="table-light">예약자ID</th>
						<td>
							<input type="text" id="update_user_id" class="form-control-plaintext ps-2" readonly>
						</td>
					</tr>
					<tr>
						<th class="table-light">방문일</th>
						<td>
							<input type="text" id="update_check_in" class="form-control-plaintext ps-2" readonly>
						</td>
						<th class="table-light">퇴실일</th>
						<td>
							<input type="text" id="update_check_out" class="form-control-plaintext ps-2" readonly>
						</td>
					</tr>
					<tr>
						<th class="table-light">인원수</th>
						<td colspan="3">
							<input type="text" id="update_guest_count" class="form-control-plaintext ps-2" readonly>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" onclick="updateReservationStatus()">변경사항 저장</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>
<!-- 예약 수정 modal 끝 -->

<%@ include file="/WEB-INF/views/common/footer_script.jsp" %>
<script src="${path}/resources/js/admin/reservation.js"></script>
</body>
</html>