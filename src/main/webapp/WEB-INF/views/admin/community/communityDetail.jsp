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
<title>게시글 상세</title>
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
					<h1>게시글 상세</h1>
				</div>
			</section>
			
			<section class="content">
				<div class="container-fluid">
				
					<!-- 게시글 정보 카드 -->
					<div class="card">
						<div class="card-header">
							<h3 class="card-title">게시글 정보</h3>
						</div>
						<div class="card-body">
							<table class="table">
								<tr>
									<th class="detail-th">번호</th>
									<td>${dto.post_id}</td>
									<th class="detail-th">상태</th>
									<td>
										<c:choose>
											<c:when test="${dto.status eq 'DISPLAY'}">
												<span class="badge badge-success">정상</span>
											</c:when>
											<c:when test="${dto.status eq 'HIDDEN'}">
												<span class="badge badge-danger">삭제</span>
											</c:when>
											<c:when test="${dto.status eq 'BANNED'}">
												<span class="badge badge-warning">숨김/제재</span>
											</c:when>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th class="detail-th">카테고리</th>
									<td>${dto.category}</td>
									<th class="detail-th">작성일</th>
									<td><fmt:formatDate value="${dto.postDate}" pattern="yyyy.MM.dd HH:mm" /></td>
								</tr>
								<tr>
									<th class="detail-th">작성자</th>
									<td>${dto.user_id}</td>
									<th class="detail-th">조회/추천</th>
									<td>${dto.view_count} / ${dto.like_count}</td>
								</tr>
								<tr>
									<th class="detail-th">제목</th>
									<td colspan="3">${dto.title}</td>
								</tr>
								<tr>
									<th class="detail-th">내용</th>
									<td colspan="3" style="white-space:pre-wrap;">${dto.content}</td>
								</tr>
							</table>
						</div>
						<div class="card-footer">
							<c:choose>
								<c:when test="${dto.status eq 'DISPLAY'}">
									<button type="button" class="btn btn-warning" onclick="hidePost(${dto.post_id})">숨김</button>
								</c:when>
								<c:when test="${dto.status eq 'BANNED'}">
									<button type="button" class="btn btn-success" onclick="showPost(${dto.post_id})">숨김해제</button>
								</c:when>
							</c:choose>
							<c:if test="${dto.status ne 'HIDDEN'}">
								<button type="button" class="btn btn-danger" onclick="deletePost(${dto.post_id})">삭제</button>
							</c:if>
							<button type="button" class="btn btn-secondary float-right" 
									onclick="location.href='${path}/communityHome.adco'">목록</button>
						</div>
					</div>
					
					<!-- 작성자 제재 카드 -->
					<div class="card">
						<div class="card-header">
							<h3 class="card-title">작성자 제재 관리</h3>
						</div>
						<div class="card-body">
							<table class="table">
								<tr>
									<th class="detail-th">작성자 ID</th>
									<td>${member.user_id}</td>
									<th class="detail-th">현재 상태</th>
									<td>
										<c:choose>
											<c:when test="${member.status eq 'ACTIVE'}">
												<span class="badge badge-success">정상</span>
											</c:when>
											<c:when test="${member.status eq 'BANNED'}">
												<span class="badge badge-danger">제재중</span>
											</c:when>
										</c:choose>
									</td>
								</tr>
							</table>
						</div>
						<div class="card-footer">
							<c:choose>
								<c:when test="${member.status eq 'ACTIVE'}">
									<button type="button" class="btn btn-danger" onclick="banUser('${member.user_id}')">제재 처리</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn btn-success" onclick="unbanUser('${member.user_id}')">제재 해제</button>
								</c:otherwise>
							</c:choose>
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
<script src="${path}/resources/js/admin/community.js"></script>
<script src="${path}/resources/js/admin/member.js"></script>

</body>
<!--end::Body-->
</html>