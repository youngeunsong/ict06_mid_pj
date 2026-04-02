<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>축제 수정 처리</title>

</head>
<!--end::Head-->
<!--begin::Body-->
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
		<c:if test="${updateCnt == 1}">
			<script type="text/javascript">
				alert("축제 수정 성공!!"); 
				window.location="${path}/festivalList.adfe"; 
			</script>
		</c:if>		
		
		<c:if test="${updateCnt != 1}">
			<script type="text/javascript">
				alert("축제 수정 실패!!"); 
				editFestival(festival_id); 
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