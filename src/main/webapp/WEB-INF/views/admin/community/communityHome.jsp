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
<title>커뮤니티 관리</title>
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
					<h1>커뮤니티 게시글 관리</h1>
				</div>
			</section>
			
			<section class="content">
				<div class="container-fluid">
					<div class="card">
						<div class="card-header">
							<!-- 일괄처리 버튼 -->
							<button type="button" class="tag tag-warning active" onclick="bulkAction('hide')">숨김</button>
							<button type="button" class="tag tag-success active" onclick="bulkAction('show')">숨김해제</button>
							<button type="button" class="tag tag-danger active" onclick="bulkAction('delete')">삭제</button>
						</div>
						
						<div class="card-body table-responsive p-0">
							<table class="table table-hover text-nowrap text-center">
								<thead>
									<tr>
										<th><input type="checkbox" id="checkAll"></th>
										<th>번호</th>
										<th>카테고리</th>
										<th>제목</th>
										<th>작성자</th>
										<th>조회</th>
										<th>추천</th>
										<th>상태</th>
										<th>작성일</th>
										<th>관리</th>
									</tr>
								</thead>
								<tbody>
									<c:choose>
										<c:when test="${empty postList}">
											<tr>
												<td colspan="10">게시글이 없습니다.</td>
											</tr>
										</c:when>
										<c:otherwise>
											<c:forEach var="post" items="${postList}">
												<tr>
													<td><input type="checkbox" class="post-check" value="${post.post_id}"></td>
													<td>${post.post_id}</td>
													<td>${post.category}</td>
													<td>
														<a href="${path}/communityDetail.adco?post_id=${post.post_id}">
															${post.title}
														</a>
													</td>
													<td>${post.user_id}</td>
													<td>${post.view_count}</td>
													<td>${post.like_count}</td>
													<td>
														<c:choose>
															<c:when test="${post.status eq 'DISPLAY'}">
																<span class="badge badge-success">정상</span>
															</c:when>
															<c:when test="${post.status eq 'HIDDEN'}">
																<span class="badge badge-warning">숨김</span>
															</c:when>
															<c:when test="${post.status eq 'DELETED'}">
																<span class="badge badge-danger">삭제</span>
															</c:when>
														</c:choose>
													</td>
													<td><fmt:formatDate value="${post.postDate}" pattern="yyyy.MM.dd" /></td>
													<td>
														<c:choose>
															<c:when test="${post.status eq 'DISPLAY'}">
																<button type="button" class="tag tag-warning" onclick="hidePost(${post.post_id})">숨김</button>
															</c:when>
															<c:when test="${post.status eq 'HIDDEN'}">
																<button type="button" class="tag tag-success" onclick="showPost(${post.post_id})">숨김해제</button>
															</c:when>
														</c:choose>
														<c:if test="${post.status ne 'DELETED'}">
															<button type="button" class="tag tag-danger" onclick="deletePost(${post.post_id})">삭제</button>
														</c:if>
														<button type="button" class="tag tag-info" onclick="location.href='${path}/communityDetail.adco?post_id=${post.post_id}'">상세보기</button>
													</td>
												</tr>
											</c:forEach>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
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

</body>
<!--end::Body-->
</html>