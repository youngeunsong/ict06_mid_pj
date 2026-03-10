<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>고객지원(관리자)</title>

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
		<div class="content-wrapper">
			<div align="center">
				<a href="${path}/inquiryFaqList.adsp">1:1 문의 & FAQ 목록</a>	
				<img src="${path}/resources/images/user/faq/faq.png" width="100%"
					alt="main">
			</div>
		</div>
		<!-- 컨텐츠 끝 -->

		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
	</div>

	<!-- 관련 SQL -->
	<div align="center">
		SQL 쿼리 : 1:1 문의 목록, FAQ 문의 목록 조회
		<pre>
			<code>
			<c:out value="
			" />
			</code>
		</pre>
	</div>

	<!-- ================= JS ================= -->
</body>
</html>