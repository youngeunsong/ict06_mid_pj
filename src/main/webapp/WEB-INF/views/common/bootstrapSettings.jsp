<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- =========================================================
[bootstrapSettings.jsp 역할]
- 공통 화면 리소스 로딩 파일
- Bootstrap / Icons / AdminLTE / 공통 CSS·JS를 담당

[주의]
- setting.jsp에서 ${path}가 먼저 선언된 상태를 전제로 사용한다.
- 공통 라이브러리(CSS/JS)는 이 파일에서만 관리한다.
- 개별 JSP에서 동일한 라이브러리를 중복 선언하지 않는다.
- 라이브러리 추가/버전 변경 시 이 파일만 수정한다.
========================================================= -->
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!--Bootstrap Icons 1-->
<link
	rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css"
	crossorigin="anonymous" />
	
<!--Bootstrap Icons 2-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

<!-- AdminLTE CSS -->
<link rel="stylesheet" href="${path}/resources/css/adminlte.css">

<!-- Common CSS -->
<link rel="stylesheet" href="${path}/resources/css/common/header.css">
<link rel="stylesheet" href="${path}/resources/css/common/footer.css">
<link rel="stylesheet" href="${path}/resources/css/common/card.css">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap bundle (Popper 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" defer></script>
<!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> -->

<!-- AdminLTE JS -->
<script src="${path}/resources/js/adminlte.js" defer></script>
