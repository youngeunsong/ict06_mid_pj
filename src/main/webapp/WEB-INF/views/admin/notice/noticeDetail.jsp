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

<title>공지/이벤트 상세보기</title>
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
		<div class="app content-header">
			<div class="container-fluid">
				<h3 class="mb-0 font-weight-bold">공지/이벤트 상세보기</h3>
			</div>
		</div>
		
		<div class="app-content">
			<div class="container-fluid">
			
				<div class="card shadow-sm">
					<div class="card-body">
							
						<%--분류--%>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label font-weight-bold">분류</label>
							<div class="col-sm-10 d-flex align-items-center">
								<c:choose>
									<c:when test="${dto.category == 'NOTICE'}">
										<span class="badge badge-primary">공지사항</span>
									</c:when>
								<c:otherwise>
									<span class="badge badge-primary">이벤트</span>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
					
					<%--제목--%>
					<div class="form-group row">
						<label class="col-sm-2 col-form-label font-weight-bold">제목</label>
						<div class="col-sm-10 d-flex align-items-center">
							${dto.title}
						</div>
					</div>
						
						<%--작성자+등록일+조회수--%>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label font-weight-bold">작성자</label>
							<div class="col-sm-4 d-flex align-items-center">${dto.admin_id}</div>
							<label class="col-sm-2 col-form-label font-weight-bold">등록일</label>
							<div class="col-sm-4 d-flex align-items-center">
								<fmt:formatDate value="${dto.noticeRegDate}" pattern="yyyy-MM-dd HH:mm" />
							</div>
						</div>
							
						<%--조회수+상단고정--%>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label font-weight-bold">조회수</label>
							<div class="col-sm-4 d-flex align-items-center">${dto.view_count}</div>
							<label class="col-sm-2 col-form-label font-weight-bold">상단고정</label>
							<div class="col-sm-4 d-flex align-items-center">
								<c:choose>
									<c:when test="${dto.is_top == 'Y'}">
										<span class="badge badge-warning">고정</span>
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</div>
						</div>
						
						<%--이미지--%>
						<c:if test="${not empty dto.image_url}">
							<div class="form-group row">
								<label class="col-sm-2 col-form-label font-weight-bold">이미지</label>
								<div class="col-sm-10">
									<img src="${dto.image_url}" class="img-fluid" style="max-height:300px;">
								</div>
							</div>
						</c:if>
						
						<%--내용--%>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label font-weight-bold">내용</label>
							<div class="col-sm-10">
								<div class="border rounded p-3 bg-light" style="min-height:200px; white-space:pre-wrap;">
								${dto.content}
								</div>
							</div>
						</div>

						<%--버튼--%>
						<div class="form-group row">
							<div class="col-sm-12 text-right">
								<a href="${path}/noticeList.adnt" class="btn btn-secondary mr-2">목록</a>
								<a href="${path}/noticeModify.adnt?noticeId=${dto.notice_id}" class="btn btn-primary">수정</a>
								<button class="btn btn-danger" onclick="deleteNotice('${dto.notice_id}')">삭제</button>
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

<script src="${path}/resources/js/admin/notice.js"></script>

</body>
</html>