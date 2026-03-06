<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!--jstl -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 컨텍스트패스(=플젝명=ict06_mid_pj)를 path 변수에 설정 -->
<c:set var="path" value="${pageContext.request.contextPath}" />	<!-- value="ict06_mid_pj" -->

<!-- css 시작-->
<!-- Font Awesome -->
<link rel="stylesheet"
	href="${path}/resources/admin/plugins/fontawesome-free/css/all.min.css">
	
<!-- Tempusdominus -->
<link rel="stylesheet"
	href="${path}/resources/admin/plugins/tempusdominus-bootstrap-4/css/tempusdominus-bootstrap-4.min.css">

<!-- iCheck -->
<link rel="stylesheet"
	href="${path}/resources/admin/plugins/icheck-bootstrap/icheck-bootstrap.min.css">

<!-- JQVMap -->
<link rel="stylesheet"
	href="${path}/resources/admin/plugins/jqvmap/jqvmap.min.css">

<!-- OverlayScrollbars -->
<link rel="stylesheet"
	href="${path}/resources/admin/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">

<!-- Daterangepicker -->
<link rel="stylesheet"
	href="${path}/resources/admin/plugins/daterangepicker/daterangepicker.css">

<!-- Summernote -->
<link rel="stylesheet"
	href="${path}/resources/admin/plugins/summernote/summernote-bs4.min.css">

<!-- AdminLTE -->
<link rel="stylesheet"
	href="${path}/resources/admin/dist/css/adminlte.min.css">
	
<!-- css 끝-->	

<!-- js 시작 -->
<!-- jQuery -->
<script src="${path}/resources/admin/plugins/jquery/jquery.min.js"></script>

<!-- jQuery UI 1.11.4 -->
<script src="${path}/resources/admin/plugins/jquery-ui/jquery-ui.min.js"></script>

<!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
<script>$.widget.bridge('uibutton', $.ui.button)</script>

<!-- Bootstrap 4 -->
<script src="${path}/resources/admin/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- ChartJS -->
<script src="${path}/resources/admin/plugins/chart.js/Chart.min.js"></script>

<!-- Sparkline -->
<script src="${path}/resources/admin/plugins/sparklines/sparkline.js"></script>

<!-- JQVMap -->
<script src="${path}/resources/admin/plugins/jqvmap/jquery.vmap.min.js"></script>
<script src="${path}/resources/admin/plugins/jqvmap/maps/jquery.vmap.usa.js"></script>

<!-- jQuery Knob Chart -->
<script src="${path}/resources/admin/plugins/jquery-knob/jquery.knob.min.js"></script>

<!-- daterangepicker -->
<script src="${path}/resources/admin/plugins/moment/moment.min.js"></script>
<script src="${path}/resources/admin/plugins/daterangepicker/daterangepicker.js"></script>

<!-- Tempusdominus Bootstrap 4 -->
<script src="${path}/resources/admin/plugins/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min.js"></script>

<!-- Summernote -->
<script src="${path}/resources/admin/plugins/summernote/summernote-bs4.min.js"></script>

<!-- overlayScrollbars -->
<script src="${path}/resources/admin/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>

<!-- AdminLTE App -->
<script src="${path}/resources/admin/dist/js/adminlte.js"></script>

<script src="https://kit.fontawesome.com/b93c336804.js" crossorigin="anonymous"></script> <!-- FontAwsome 아이콘 넣기  -->
<!-- js 끝 -->
