<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!--Third Party Plugin(Bootstrap Icons)-->
<link
	rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css"
	crossorigin="anonymous" />

<!-- adminlte template -->
<link rel="stylesheet" href="${path}/resources/css/adminlte.css">
	
<!-- 부트스트랩 외 css 수정사항 반영 시 -->
<link rel="stylesheet" href="${path}/resources/css/common/header.css">
<link rel="stylesheet" href="${path}/resources/css/common/footer.css">
<link rel="stylesheet" href="${path}/resources/css/common/card.css">

<!-- 부트스트랩 bundle(popper.js 포함) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" defer></script>
<!-- Bootstrap 버전 충돌 문제로 adminSetting.jsp의 버전4만 남김 -->

<script src="${path}/resources/js/adminlte.js" defer></script>