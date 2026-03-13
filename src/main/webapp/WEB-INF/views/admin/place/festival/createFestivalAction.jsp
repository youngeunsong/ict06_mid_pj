<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->       
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>축제 등록 성공</title>
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
		<%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>

		<!-- ================= SIDEBAR ================= -->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

		<!-- ================= CONTENT ================= -->
		<c:if test="${insertCnt == 1}">
			<script type="text/javascript">
				alert("신규 축제 등록 성공!!"); 
				window.location="${path}/festivalList.adfe"; 
			</script>
		</c:if>		
		
		<c:if test="${insertCnt != 1}">
			<script type="text/javascript">
				alert("신규 축제 등록 실패!!"); 
				window.location="${path}/createFestivalAction.adfe"
			</script>
		</c:if>

		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
		
	</div>
	<!--end::div wrapper-->

	<!-- ================= JS ================= -->
</body>
</html>