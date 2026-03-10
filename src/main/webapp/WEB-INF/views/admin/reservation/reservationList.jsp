<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<fmt:setTimeZone value="Asia/Seoul"/>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">

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
		<!--begin::content 헤더-->
		<div class="content-wrapper">
			<div class="app-content-header py-3">
				<div class="container-fluid">
					<h3 class="mb-0 font-weight-bold">예약 관리</h3>
				</div>
			</div>
			
			<section class="app-content">
				<div class="container-fluid">
				
					<%--필터 영역--%>
					<div class="filter-box mb-3 p-3 bg-white shadow-sm rounded">
					<%--좌측: 보기방식+키워드 검색+정렬--%>
						<div class="d-flex align-items-center justify-content-between flex-wrap" style="gap:15px;">
							<div class="d-flex align-items-center" style="gap:15px;">
								<%--보기방식 선택 영역--%>
								<div class="btn-group btn-group-sm" role="group">
									<button type="button" class="btn btn-success" id="viewCalBtn">
										<i class="bi bi-calendar3 mr-1"></i>캘린더
									</button>
									<button type="button" class="btn btn-outline-success" id="viewListBtn">
										<i class="bi bi-list-ul mr-1"></i>리스트
									</button>
								</div>
								
								<%--키워드 검색 영역--%>
								<div class="input-group input-group-sm" style="width:220px;">
									<input type="text" id="keyword" name="keyword" class="form-control"
										placeholder="ID / 예약번호 입력" value="${param.keyword}" style="font-size:0.78rem;">
									<div class="input-group-append">
										<button class="btn btn-outline-secondary" type="button" onclick="keywordSearch()" style="font-size:0.78rem;">
											<i class="bi bi-search"></i>
										</button>
									</div>
								</div>
							</div>
						</div>
										
						<%--우측: 필터 태그 및 검색 영역--%>
						<div class="filter-right">
							<%--정렬 드롭다운 영역--%>
							<div class="filter-row">
								<span class="filter-row-label">정렬</span>
								<select id="sortType" name="sortType" class="form-control form-control-sm"
										style="width:130px;" onchange="filterData()">
									<option value="created_at_desc" ${sortType=='created_at_desc' ? 'selected' : ''}>예약일 최신순</option>
									<option value="check_in_asc" ${sortType=='check_in_asc' ? 'selected' : ''}>방문일 오름차순</option>
									<option value="check_in_desc" ${sortType=='check_in_desc' ? 'selected' : ''}>방문일 내림차순</option>
									<option value="status" ${sortType=='status' ? 'selected' : ''}>예약상태순</option>
								</select>
							</div>
								<%--필터(예약 상태)--%>
							<div class="filter-row">
								<span class="filter-row-label">예약 상태</span>
								<div style="display:flex; gap:4px;">
									<span class="tag tag-success" data-value="RESERVED" onclick="toggleTag(this)">확정</span>
									<span class="tag tag-warning" data-value="PENDING" onclick="toggleTag(this)">결제대기</span>
									<span class="tag tag-danger" data-value="CANCELLED" onclick="toggleTag(this)">취소</span>
									<span class="tag tag-secondary" data-value="COMPLETED" onclick="toggleTag(this)">이용완료</span>
								</div>
							</div>
							
							<%--필터(장소분류)--%>
							<div class="filter-row">
								<span class="filter-row-label">장소 분류</span>
									<div style="display:flex; gap:4px;">
										<span class="tag tag-primary" data-value="REST" onclick="toggleTag(this)">맛집</span>
										<span class="tag tag-primary" data-value="ACC" onclick="toggleTag(this)">숙소</span>
										<span class="tag tag-primary" data-value="FEST" onclick="toggleTag(this)">축제</span>
									</div>
							</div>
	
							<%-- ===== 필터 검색버튼 ===== --%>
							<div class="filter-row">
								<span class="filter-row-label"></span>
								<button type="button" class="btn btn-dark btn-filter-search" onclick="filterData()">
									<i class="bi bi-search mr-1"></i>검색
								</button>
							</div>
						</div>
					</div>
								
					<%-- ===== 테이블/캘린더 카드 ===== --%>		
					<div class="card shadow-sm border-0">
						<div class="card-body p-0">
							<%-- ===== 리스트 보기 ===== --%>
							<div id="reservationListView">
								<table class="table table-hover align-middle m-0">
									<thead class="thead-light">
										<tr>
											<th style="width:80px;">예약번호</th>
											<th style="width:140px;">사용자</th>
											<th style="width:80px;">분류</th>
											<th style="width:130px;">예약일</th>
											<th style="width:130px;">방문일</th>
											<th style="width:110px;">예약상태</th>
											<th style="width:130px;">관리</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="dto" items="${list}">
											<tr style="cursor:pointer;" onclick="viewDetail('${dto.reservation_id}')">
												<td>${dto.reservation_id}</td>
												<td>${dto.user_id}</td>
												<td>
													<c:choose>
														<c:when test="${dto.placeDTO.place_type == 'REST'}">맛집</c:when>
														<c:when test="${dto.placeDTO.place_type == 'ACC'}">숙소</c:when>
														<c:when test="${dto.placeDTO.place_type == 'FEST'}">축제</c:when>
													</c:choose>
												</td>
												<td><fmt:formatDate value="${dto.check_in}" pattern="yyyy-MM-dd" /></td>
												<td><fmt:formatDate value="${dto.resDate}" pattern="yyyy-MM-dd" /></td>
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
												<td>
													<%-- 수정버튼 클릭 시 행클릭 이벤트 차단 --%>
													<button class="btn btn-sm btn-edit" onclick="event.stopPropagation(); editReservation('${dto.reservation_id}')">
														<i class="bi bi-pencil-fill"></i>
													</button>
												</td>
											</tr>
										</c:forEach>
										<c:if test="${empty list}">
											<tr>
												<td colspan="7" class="text-center py-4 text-muted">
												조회된 예약 내역이 없습니다.
												</td>
											</tr>
										</c:if>
									</tbody>
								</table>

								<%-- 페이징 --%>
								<div class="py-3 border-top">
									<%@ include file="/WEB-INF/views/common/pagination.jsp"%>
								</div>
							</div>
							
							<%-- ===== 캘린더 보기 ===== --%>
							<div id="reservationCalendarView" style="display:none; padding:20px;">
								<div id="calendar" class="bg-white p-3 rounded shadow-sm border"></div>
							</div>
							
						</div>
					</div>
					
				</div>
			</section>
		</div>
		
		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
	</div>

	<%-- ===== 예약 상세보기 Modal ===== --%>
	<div class="modal fade" id="resDetailModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header modal-header-success text-white">
					<h5 class="modal-title">
						<i class="bi bi-info-circle mr-2"></i>예약 상세 정보
					</h5>
					<button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<table class="table table-bordered">
						<tbody>
							<tr>
								<th class="table-light" style="width:20%;">예약번호</th>
								<td id="modal_res_id" style="width:30%;"></td>
								<th class="table-light" style="width:20%;">예약상태</th>
								<td id="modal_status" style="width:30%;"></td>
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
					<button type="button" class="btn btn-edit" onclick="$('#resDetailModal').modal('hide'); editReservation($('#modal_res_id').text());">
						수정하기
					</button>
					<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

	<%-- ===== 예약 수정 Modal ===== --%>
	<div class="modal fade" id="resUpdateModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header modal-header-success text-white">
					<h5 class="modal-title font-weight-bold">
						<i class="bi bi-pencil-square mr-2"></i>예약 정보 수정
					</h5>
					<button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
						<span>&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<table class="table table-bordered">
						<tbody>
							<tr>
								<th class="table-light" style="width:25%;">예약번호</th>
								<td style="width:25%;">
									<span id="update_res_id" class="form-control-plaintext pl-2"></span>
								</td>
								<!--수정 가능 정보-->
								<th class="table-light" style="width:25%;">예약상태</th>
								<td style="width:25%;">
									<select id="update_status" class="form-control border-primary">
										<option value="RESERVED">확정</option>
										<option value="PENDING">결제대기</option>
										<option value="CANCELLED">취소</option>
										<option value="COMPLETED">이용완료</option>
									</select>
								</td>
							</tr>
							<tr>
								<th class="table-light">장소명</th>
								<td><span id="update_name" class="pl-2"></span></td>
								<th class="table-light">예약자ID</th>
								<td><span id="update_user_id" class="fpl-2"></span></td>
							</tr>
							<tr>
								<th class="table-light">방문일</th>
								<td>
									<input type="date" id="update_check_in" class="form-control form-control-sm">
								</td>
								<th class="table-light">퇴실일</th>
								<td>
									<input type="date" id="update_check_out" class="form-control form-control-sm">
								</td>
							</tr>
							<tr>
								<th class="table-light">방문시간</th>
								<td>
									<input type="time" id="update_visit_time" class="form-control form-control-sm">
								</td>
								<th class="table-light">인원수</th>
								<td>
									<input type="number" id="update_guest_count" class="form-control form-control-sm" min="1">
								</td>
							</tr>
							<tr>
								<th class="table-light">요청사항</th>
								<td colspan="3">
									<textarea id="update_request_note" class="form-control form-control-sm" rows="2" placeholder="요청사항 입력"></textarea>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" onclick="updateReservation()">변경사항 저장</button>
					<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>

<!-- FullCalendar -->
<script>
const reservationData = [
	<c:forEach var="res" items="${list}" varStatus="status">
	<c:choose>
		<c:when test="${res.placeDTO != null}">
			<c:choose>
				<c:when test="${res.placeDTO.place_type == 'REST'}"><c:set var="placeType" value="맛집"/></c:when>
				<c:when test="${res.placeDTO.place_type == 'ACC'}"><c:set var="placeType" value="숙소"/></c:when>
				<c:when test="${res.placeDTO.place_type == 'FEST'}"><c:set var="placeType" value="축제"/></c:when>
			</c:choose>
			<c:set var="resTitle" value="${res.user_id} | ${res.placeDTO.name}"/>
		</c:when>
		<c:otherwise>
			<c:set var="resTitle" value="${res.user_id}"/>
		</c:otherwise>
	</c:choose>
	<c:choose>
		<c:when test="${res.status == 'RESERVED'}"><c:set var="bgColor" value="#01D281"/></c:when>
		<c:when test="${res.status == 'PENDING'}"><c:set var="bgColor" value="#ffc107"/></c:when>
		<c:when test="${res.status == 'COMPLETED'}"><c:set var="bgColor" value="#6c757d"/></c:when>
		<c:otherwise><c:set var="bgColor" value="#dc3545"/></c:otherwise>
	</c:choose>
	{
		id: '${res.reservation_id}',
		title: '${resTitle}',
		start: '<fmt:formatDate value="${res.check_in}" pattern="yyyy-MM-dd"/>',
		end: '<fmt:formatDate value="${res.check_out}" pattern="yyyy-MM-dd"/>',
		backgroundColor: '${bgColor}'
	}${!status.last ? ',' : ''}
	</c:forEach>
];
</script>

<script>const path = "${path}";</script>
<script src="${path}/resources/js/admin/reservation.js"></script>


</body>
</html>