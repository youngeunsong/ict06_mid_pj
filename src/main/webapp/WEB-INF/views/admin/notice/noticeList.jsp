<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">

<title>공지/이벤트 관리</title>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<!--begin::div wrapper-->
<div class="wrapper">
	<!-- Preloader -->
	<div class="preloader flex-column justify-content-center align-items-center">
		<img src="${path}/resources/admin/dist/img/AdminLTELogo.png" height="60" width="60">
	</div>
	
	<!-- ================= HEADER ================= -->
	<%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>

	<!-- ================= SIDEBAR ================= -->
	<%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

	<!-- ================= CONTENT ================= -->
	<!--begin::content 헤더-->
	<div class="content-wrapper">
		<div class="content-header">
			<div class="container-fluid">
				<h3 class="mb-0 font-weight-bold">공지사항/이벤트 관리</h3>
			</div>
		</div>
		
		<div class="app-content">
			<div class="container-fluid">
			
				<%--필터+검색+등록 버튼--%>
				<div class="card shadow-sm mb-3">
					<div class="card-body">
						<div class="row align-items-center">
							<%--카테고리 탭--%>
							<div class="col-auto">
								<div class="btn-group" role="group">
									<a href="${path}/noticeList.adnt?category=&keyword=${sc.keyword}"
										class="btn btn-sm ${empty sc.category ? 'btn-dark' : 'btn-outline-dark'}">전체</a>
									<a href="${path}/noticeList.adnt?category=NOTICE&keyword=${sc.keyword}"
										class="btn btn-sm ${'NOTICE' == sc.category ? 'btn-primary' : 'btn-outline-primary'}">공지사항</a>
									<a href="${path}/noticeList.adnt?category=EVENT&keyword=${sc.keyword}"
										class="btn btn-sm ${'EVENT' == sc.category ? 'btn-success' : 'btn-outline-success'}">이벤트</a>
								</div>
							</div>
							<%--검색--%>
							<div class="col-3">
								<form method="get" action="${path}/noticeList.adnt" class="d-flex mb-0">
									<input type="hidden" name="category" value="${sc.category}">
									<input type="text" name="keyword" class="form-control form-control-sm mr-2"
											placeholder="제목 검색" value="${sc.keyword}">
									<button type="submit" class="btn btn-sm btn-secondary flex-shrink-0">검색</button>
								</form>
							</div>
							<%--등록 버튼--%>
							<div class="col-auto">
								<a href="${path}/noticeWrite.adnt" class="btn btn-sm btn-primary">
									<i class="fas fa-plus"></i>등록
								</a>
							</div>
						</div>
					</div>
				</div>
				
				<%--목록 테이블--%>
				<div class="card shadow-sm">
					<div class="card-body p-0">
						<table class="table table-hover align-middle m-0">
							<thead class="table-light text-center">
								<tr>
									<th style="width:60px;">번호</th>
									<th style="width:80px;">분류</th>
									<th>제목</th>
									<th style="width:80px;">상단고정</th>
									<th style="width:80px;">조회수</th>
									<th style="width:120px;">등록일</th>
									<th style="width:100px;">관리</th>
								</tr>
							</thead>
							<tbody class="text-center">
								<c:choose>
									<c:when test="${empty list}">
										<tr>
											<td colspan="7" class="py-5 text-muted">
											등록된 공지/이벤트가 없습니다.
											</td>
										</tr>
									</c:when>
									<c:otherwise>
										<c:forEach var="dto" items="${list}">
											<tr style="cursor:pointer;" onclick="location.href='${path}/noticeDetail.adnt?noticeId=${dto.notice_id}'">
												<td>${dto.notice_id}</td>
												<td>
													<c:choose>
														<c:when test="${dto.category == 'NOTICE'}">
															<span class="badge badge-primary">공지</span>
														</c:when>
														<c:otherwise>
															<span class="badge badge-success">이벤트</span>
														</c:otherwise>
													</c:choose>
												</td>
												<td class="text-left">
														${dto.title}
												</td>
												<td>
													<c:choose>
														<c:when test="${dto.is_top == 'Y'}">
															<span class="badge badge-warning">고정</span>
														</c:when>
														<c:otherwise>-</c:otherwise>
													</c:choose>
												</td>
												<td>${dto.view_count}</td>
												<td>
													<fmt:formatDate value="${dto.noticeRegDate}" pattern="yyyy-MM-dd" />
												</td>
												<td onclick="event.stopPropagation()">
													<a href="${path}/noticeModify.adnt?noticeId=${dto.notice_id}"
														class="btn btn-xs btn-outline-secondary"
														onclick="event.stopPropagation()">수정</a>
													<button class="btn btn-xs btn-outline-danger"
															onclick="event.stopPropagation(); deleteNotice('${dto.notice_id}')">삭제</button>
												</td>
											</tr>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>
					<%--페이징--%>
					<div class="card-footer text-center">
						<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
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

<script src="${path}/resources/js/admin/notice.js"></script>

</body>
</html>