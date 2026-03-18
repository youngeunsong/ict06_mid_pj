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
<title>댓글 관리</title>
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
					<h1>댓글 관리</h1>
				</div>
			</section>
			
			<section class="content">
				<div class="container-fluid">
				
					<!-- 게시글 정보 카드 -->
					<div class="card">
						<div class="card-header">
							<button type="button" class="tag tag-warning active" onclick="bulkCommentAction('hide')">선택 숨김</button>
							<button type="button" class="tag tag-success active" onclick="bulkCommentAction('show')">선택 숨김해제</button>
							<button type="button" class="tag tag-danger active" onclick="bulkCommentAction('delete')">선택 삭제</button>
						</div>
						<div class="card-body table-responsive p-0">
							<table class="table table-hover text-nowrap text-center">
								<thead>
									<tr>
										<th><input type="checkbox" id="checkAll"></th>
										<th>번호</th>
										<th>제목</th>
										<th>작성자</th>
										<th>댓글 내용</th>
										<th>상태</th>
										<th>작성일</th>
										<th>관리</th>
									</tr>
								</thead>
								<tbody>
									<c:choose>
										<c:when test="${empty commentList}">
											<tr>
												<td colspan="8">댓글이 없습니다.</td>
											</tr>
										</c:when>
										<c:otherwise>
											<c:forEach var="comment" items="${commentList}">
												<tr>
													<td><input type="checkbox" class="comment-check" value="${comment.comment_id}"></td>
													<td>${comment.comment_id}</td>
													<td>
														<a href="${path}/communityDetail.adco?post_id=${comment.post_id}">
															${comment.communityDTO.title}
														</a>
													</td>
													<td>${comment.user_id}</td>
													<td>${comment.content}</td>
													<td>
														<c:choose>
															<c:when test="${comment.status eq 'DISPLAY'}">
																<span class="badge badge-success">정상</span>
															</c:when>
															<c:when test="${comment.status eq 'HIDDEN'}">
																<span class="badge badge-warning">숨김</span>
															</c:when>
															<c:when test="${comment.status eq 'DELETED'}">
																<span class="badge badge-danger">삭제</span>
															</c:when>
														</c:choose>
													</td>
													<td><fmt:formatDate value="${comment.commentDate}" pattern="yyyy.MM.dd HH:mm" /></td>
													<td>
														<c:choose>
															<c:when test="${comment.status eq 'DISPLAY'}">
																<button type="button" class="tag tag-warning" onclick="hideComment(${comment.comment_id})">숨김</button>
															</c:when>
															<c:when test="${comment.status eq 'HIDDEN'}">
																<button type="button" class="tag tag-success" onclick="showComment(${comment.comment_id})">숨김해제</button>
															</c:when>
														</c:choose>
														<c:if test="${comment.status ne 'DELETED'}">
															<button type="button" class="tag tag-danger" onclick="deleteComment(${comment.comment_id})">삭제</button>
														</c:if>
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
<script src="${path}/resources/js/admin/comment.js"></script>

</body>
<!--end::Body-->
</html>