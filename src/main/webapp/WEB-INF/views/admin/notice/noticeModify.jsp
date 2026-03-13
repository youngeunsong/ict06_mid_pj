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

<title>공지/이벤트 수정</title>
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
				<h3 class="mb-0 font-weight-bold">공지/이벤트 수정</h3>
			</div>
		</div>
		
		<div class="app-content">
			<div class="container-fluid">
			
				<div class="card shadow-sm">
					<div class="card-body">
						<form id="noticeModifyForm" method="post" action="${path}/noticeUpdate.adnt"
								enctype="multipart/form-data">
						
							<%--notice_id hidden--%>
							<input type="hidden" name="noticeId" value="${dto.notice_id}">
							
							<%--분류--%>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label font-weight-bold">분류
									<span class="text-danger">*</span>
								</label>
								<div class="col-sm-4">
									<select name="category" class="form-control" required>
										<option value="">선택</option>
										<option value="NOTICE" ${dto.category == 'NOTICE' ? 'selected' : ''}>공지사항</option>
										<option value="EVENT" ${dto.category == 'EVENT' ? 'selected' : ''}>이벤트</option>
									</select>
								</div>
							</div>
							
							<%--제목--%>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label font-weight-bold">제목
									<span class="text-danger">*</span>
								</label>
								<div class="col-sm-10">
									<input type="text" name="title" class="form-control"
											value="${dto.title}" maxlength="200" required>
								</div>
							</div>
							
							<%--내용--%>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label font-weight-bold">내용
									<span class="text-danger">*</span>
								</label>
								<div class="col-sm-10">
									<textarea id="content" name="content" class="form-control" rows="15"
											placeholder="내용 입력" required>${dto.content}</textarea>
								</div>
							</div>
							
							<%--이미지 URL--%>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label font-weight-bold">이미지 파일</label>
								<div class="col-sm-10">
									<input type="file" name="uploadFile" class="form-control" accept="image/*">
								</div>
							</div>
							
							<%--상단 고정--%>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label font-weight-bold">상단 고정</label>
								<div class="col-sm-10 d-flex align-items-center">
									<div class="icheck-primary">
										<input type="checkbox" id="isTop" name="isTop" value="Y"
												${dto.is_top == 'Y' ? 'checked' : ''}>
										<label for="isTop">상단 고정</label>
									</div>
								</div>
							</div>
							
							<%--버튼--%>
							<div class="form-group row">
								<div class="col-sm-12 text-right">
									<a href="${path}/noticeList.adnt" class="btn btn-secondary mr-2">취소</a>
									<button type="button" class="btn btn-danger mr-2"
											onclick="deleteNotice('${dto.notice_id}')">삭제</button>
									<button type="submit" class="btn btn-primary">수정</button>
								</div>
							</div>
							
						</form>
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