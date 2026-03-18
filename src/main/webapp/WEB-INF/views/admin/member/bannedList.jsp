<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<fmt:setTimeZone value="Asia/Seoul" />
<!-- ad_reservation.css -->
<link rel="stylesheet"
	href="${path}/resources/css/admin/ad_reservation.css" />

<meta charset="UTF-8">
<title>제재 회원 관리</title>
</head>
<!--begin::Body-->
<body class="hold-transition sidebar-mini layout-fixed">
	<div class="wrapper">
		<!-- Preloader -->
		<div
			class="preloader flex-column justify-content-center align-items-center">
			<img src="${path}/resources/admin/dist/img/AdminLTELogo.png"
				height="60" width="60">
		</div>

		<!-- ================= HEADER ================= -->
		<%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>

		<!-- ================= SIDEBAR ================= -->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

		<!-- ================= CONTENT ================= -->
		<div class="content-wrapper">
			<!-- 컨텐츠 시작 -->
			<section class="content-header">
				<div class="container-fluid">
					<h1>제재 회원 관리</h1>
				</div>
			</section>
			
			<section class="content">
				<div class="container-fluid">
				
					<!-- 검색/필터 -->
					<div class="card mb-3">
						<div class="card-body">
							<form action="${path}/bannedList.adme" method="get">
								<div class="filter-box">
									<!-- 검색 -->
									<div class="filter-left">
										<select name="searchType" class="form-control form-control-sm" style="width:100px;">
											<option value="id" ${sf.searchType eq 'id' ? 'selected' : ''}>ID</option>
											<option value="name" ${sf.searchType eq 'name' ? 'selected' : ''}>이름</option>
										</select>
										<input type="text" name="keyword" value="${sf.keyword}"
												class="form-control form-control-sm" style="width:200px;" placeholder="검색어 입력">
									</div>
									
									<!-- 필터 -->
									<div class="filter-right">
										<div class="filter-title">필터</div>
										<div class="filter-row">
											<span class="filter-row-label">권한</span>
											<span class="tag tag-secondary ${empty sf.role ? 'active' : ''}"
													onclick="setFilter('role', '')">전체</span>
											<span class="tag tag-success ${sf.role eq 'USER' ? 'active' : ''}"
													onclick="setFilter('role', 'USER')">일반</span>
											<span class="tag tag-danger ${sf.role eq 'ADMIN' ? 'active' : ''}"
													onclick="setFilter('role', 'ADMIN')">관리자</span>
										</div>
										<div class="filter-row">
											<input type="hidden" id="roleInput" name="role" value="${sf.role}">
											<a href="${path}/bannedList.adme" class="tag tag-secondary active btn-filter-search">초기화</a>
										</div>
									</div>
								</div>
							</form>
						</div>
					</div>
					
					<!-- 목록 -->
					<div class="card">
						<div class="card-header">
							<span>총 ${totalCount}명</span>
							<div class="float-right">
								<button type="button" class="tag tag-success active" onclick="bulkUnban()">선택 제재해제</button>
							</div>
						</div>
						<div class="card-body table-responsive p-0">
							<table class="table table-hover text-nowrap text-center">
								<thead>
									<tr>
										<th><input type="checkbox" id="checkAll"></th>
										<th>ID</th>
										<th>이름</th>
										<th>이메일</th>
										<th>전화번호</th>
										<th>권한</th>
										<th>가입일</th>
										<th>관리</th>
									</tr>
								</thead>
								<tbody>
									<c:choose>
										<c:when test="${empty bannedList}">
											<tr>
												<td colspan="9">제재된 회원이 없습니다.</td>
											</tr>
										</c:when>
										<c:otherwise>
											<c:forEach var="member" items="${bannedList}">
												<tr>
													<td><input type="checkbox" class="member-check" value="${member.user_id}"></td>
													<td>${member.user_id}</td>
													<td>${member.name}</td>
													<td>${member.email}</td>
													<td>${member.phone}</td>
													<td>
														<c:choose>
															<c:when test="${member.role eq 'ADMIN'}">
																<span class="badge badge-info">관리자</span>
															</c:when>
															<c:otherwise>
																<span class="badge badge-secondary">일반</span>
															</c:otherwise>
														</c:choose>
													</td>
													<td><fmt:formatDate value="${member.joinDate}" pattern="yyyy.MM.dd" /></td>
													<td>
														<button type="button" class="tag tag-success" onclick="unbanUser('${member.user_id}')">제재해제</button>
													</td>
												</tr>
											</c:forEach>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>
						
						<!-- 페이징 -->
						<div class="card-footer clearfix">
							<ul class="pagination pagination-sm m-0 float-right">
								<c:if test="${paging.prev > 0}">
									<li class="page-item">
										<a class="page-link" href="${path}/bannedList.adme?pageNum=${paging.prev}&
											searchType=${sf.searchType}&keyword=${sf.keyword}&status=${sf.status}&role=${sf.role}">«</a>
									</li>
								</c:if>
								<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
									<li class="page-item ${paging.currentPage == i ? 'active' : ''}">
										<a class="page-link" href="${path}/bannedList.adme?pageNum=${i}&
											searchType=${sf.searchType}&keyword=${sf.keyword}&status=${sf.status}&role=${sf.role}">${i}</a>
									</li>
								</c:forEach>
								<c:if test="${paging.next > 0}">
									<li class="page-item">
										<a class="page-link" href="${path}/bannedList.adme?pageNum=${paging.next}&
											searchType=${sf.searchType}&keyword=${sf.keyword}&status=${sf.status}&role=${sf.role}">»</a>
									</li>
								</c:if>
							</ul>
						</div>
					</div>
					
				</div>
			</section>
		</div>
		<!-- 컨텐츠 끝 -->

		<!-- ================= FOOTER ================= -->
		<!--begin::Footer-->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
		<!--end::Footer-->
	
	</div>
	<!--end::div Wrapper-->

<script>const path = "${path}";</script>
<script src="${path}/resources/js/admin/member.js"></script>

</body>
<!--end::Body-->
</html>