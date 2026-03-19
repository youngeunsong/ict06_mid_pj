<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>1:1문의 상세(관리자)</title>
</head>
<!--end::Head-->
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
		<!-- 컨텐츠 시작 -->
		<div align="center">
		
		</div>
		<!-- 컨텐츠 끝 -->

		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
		
		<!-- 관련 SQL 시작 -->
		<div align="center">SQL 쿼리 : 1:1 문의 상세 조회</div>
		
		<!-- 작성 요령 : 몇몇 특수문자를 화면에 제대로 출력하기 위해 아래와 같이 사용 필요-->
		<!-- #${'{'} : #과 { 표시 -->
		<!-- &lt; : < 표시 -->
		<!-- &gt; : > 표시 -->
		<div>
			<pre><code>
			
			</code></pre>
		</div>
		<!-- 관련 SQL 끝 -->
	</div>
</body>
<!--end::Body-->
</html>