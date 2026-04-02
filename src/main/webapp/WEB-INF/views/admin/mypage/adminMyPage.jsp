<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>관리자 프로필</title>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
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
					<h3 class="mb-0 font-weight-bold">프로필/비밀번호 변경</h3>
				</div>
			</div>
			
			<div class="app-content">
				<div class="container-fluid">
				
					<div class="row justify-content-center">
						<div class="col-md-6">
							<div class="card shadow-sm">
								<div class="card-header bg-success text-white">
									<h5 class="mb-0"><i class="bi bi-person-gear mr-2"></i></h5>
								</div>
								<div class="card-body">
									<form action="${path}/adminMyPageAction.ad" method="post">
										<%--ID(읽기 전용)--%>
										<div class="form-group">
											<label>ID</label>
											<input type="text" class="form-control bg-light"
													value="${sessionScope.sessionID}" readonly>
										</div>
									
										<%--이름--%>
										<div class="form-group">
											<label>이름<span class="text-danger">*</span></label>
											<input type="text" name="name" class="form-control"
													value="${dto.name}" required>
										</div>
									
										<%--이메일--%>
										<div class="form-group">
											<label>이름<span class="text-danger">*</span></label>
											<input type="email" name="email" class="form-control"
													value="${dto.email}" required>
										</div>
									
										<%--연락처--%>
										<div class="form-group">
											<label>연락처</label>
											<input type="text" name="phone" class="form-control"
													value="${dto.phone}" placeholder="010-0000-0000">
										</div>
										
										<hr>
										<p class="text-muted small">비밀번호를 입력하지 않으면 변경되지 않습니다.</p>
										
										<%--현재 비밀번호--%>
										<div class="form-group">
											<label>현재 비밀번호<span class="text-danger">*</span></label>
											<input type="password" name="currentPassword" class="form-control"
													placeholder="현재 비밀번호 입력" required>
										</div>
										
										<%--새 비밀번호--%>
										<div class="form-group">
											<label>새 비밀번호</label>
											<input type="password" name="newPassword" class="form-control"
													placeholder="변경할 비밀번호 입력(선택)">
										</div>

										<%--새 비밀번호 확인--%>
										<div class="form-group">
											<label>새 비밀번호 확인</label>
											<input type="password" name="newPasswordConfirm" class="form-control"
													placeholder="변경할 비밀번호 재입력(선택)">
										</div>
										
										<div class="d-flex justify-content-between mt-4">
											<a href="${path}/adminHome.ad" class="btn btn-secondary">취소</a>
											<button type="submit" class="btn btn-success">저장</button>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
								
		
		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
	</div>
</body>
</html>