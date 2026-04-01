<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet"
	href="${path}/resources/css/admin/ad_reservation.css">

<title>공지/이벤트 상세보기</title>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
	<!--begin::div wrapper-->
	<div class="wrapper">
		<!-- Preloader -->
		<div
			class="preloader flex-column justify-content-center align-items-center">
			<img src="${path}/resources/admin/dist/img/AdminLTELogo.png"
				height="60" width="60">
		</div>

		<!-- ================= HEADER ================= -->
		<%@ include file="/WEB-INF/views/common/adminHeader.jsp"%>

		<!-- ================= SIDEBAR ================= -->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp"%>

		<!-- ================= CONTENT ================= -->
		<!--begin::content 헤더-->
		<div class="content-wrapper">
			<div class="app content-header">
				<div class="container-fluid">
					<h3 class="mb-0 font-weight-bold">공지/이벤트 상세보기</h3>
				</div>
			</div>

			<div class="app-content">
				<div class="container-fluid">

					<div class="card shadow-sm">
						<div class="card-body">
							<table class="table">
								<tbody>
									<%--분류 + 상단고정 + 조회수--%>
									<tr>
										<th class="detail-th" style="width: 15%;">분류</th>
										<td><c:choose>
												<c:when test="${dto.category == 'NOTICE'}">
													<span class="badge badge-primary">공지사항</span>
												</c:when>
												<c:otherwise>
													<span class="badge badge-success">이벤트</span>
												</c:otherwise>
											</c:choose></td>
										<th class="detail-th" style="width: 15%;">상단고정</th>
										<td><c:choose>
												<c:when test="${dto.is_top == 'Y'}">
													<span class="badge badge-warning">고정</span>
												</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose></td>
										<th class="detail-th" style="width: 15%;">조회수</th>
										<td>${dto.view_count}</td>
									</tr>
									<%--제목--%>
									<tr>
										<th class="detail-th">제목</th>
										<td colspan="5">${dto.title}</td>
									</tr>
									<%--작성자 + 등록일--%>
									<tr>
										<th class="detail-th">작성자</th>
										<td>${dto.admin_id}</td>
										<th class="detail-th">등록일</th>
										<td colspan="3"><fmt:formatDate
												value="${dto.noticeRegDate}" pattern="yyyy-MM-dd HH:mm" /></td>
									</tr>
									<%--이미지--%>
									<c:if test="${not empty dto.image_url}">
										<tr>
											<th class="detail-th">이미지</th>
											<td colspan="5"><c:forEach var="img"
													items="${fn:split(dto.image_url, ',')}">
													<img src="${img}" class="img-fluid"
														style="max-height: 300px; margin-right: 8px;">
												</c:forEach></td>
										</tr>
									</c:if>
									<%--내용--%>
									<tr>
										<th class="detail-th">내용</th>
										<td colspan="5"
											style="white-space: pre-wrap; min-height: 200px; text-align: left;">${dto.content}</td>
									</tr>
								</tbody>
							</table>

							<%--버튼--%>
							<div class="d-flex justify-content-between mt-3">
								<a href="${path}/noticeList.adnt" class="btn btn-secondary">목록</a>
								<div>
									<a href="${path}/noticeModify.adnt?noticeId=${dto.notice_id}"
										class="btn btn-primary">수정</a>
									<button class="btn btn-danger"
										onclick="deleteNotice('${dto.notice_id}')">삭제</button>
								</div>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
		<%--end::content-wrapper--%>
	
		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
	</div>
	<%--end::wrapper--%>

	<script>
		const path = "${path}";
	</script>
	<script src="${path}/resources/js/admin/notice.js"></script>

</body>
</html>