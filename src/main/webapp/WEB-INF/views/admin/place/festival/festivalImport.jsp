<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>축제 목록 임포트</title>

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
		<div class="content-wrapper">
			<div class="content-header">
				<div class="container-fluid">
					<h1 class="m-0">축제 목록 임포트</h1>
				</div>
			</div>
			
			<!-- 임포트 폼 시작 -->
			<form action="${path}/festivalImportAction.adfe" method="get">
			    페이지 번호 :
			    <input type="number" name="pageNo" value="1" min="1">
			    
			    <!-- 축제 시작일: 무조건 오늘 이후로 설정 -->
			    축제 시작일 : 
			    <input type="date" id="fstvlStartDate" name="fstvlStartDate">
				
				<script>
				    const today = new Date().toISOString().split('T')[0];
				
				    const start = document.getElementById("fstvlStartDate");
				
				    start.min = today;
				    start.value = today;
				</script>
			
			    가져올 개수 :
			    <select name="numOfRows">
			        <option value="10">10개</option>
			        <option value="50">50개</option>
			        <option value="100">100개</option>
			    </select>
			
			    <button type="submit">API 데이터 가져오기</button>
			</form>
			<!-- 임포트 폼 끝 -->
		</div>

		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
		
	</div>
	<!--end::div wrapper-->

	<!-- ================= JS ================= -->
</body>
</html>