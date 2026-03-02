<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="setting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 반응형 웹 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>main</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/common/main.css">

</head>
<body>
	<div class="wrap">
		<!-- header 시작 -->
		<%@ include file="header.jsp" %>
		<!-- header 끝 -->
		
		<!-- 컨텐츠 시작 -->
		<div align="center">
			<img src="${path}/resources/images/main/main.jpg" width="100%" alt="main">
		</div>

		<!-- 컨텐츠 끝 -->
		
		<!-- footer 시작 -->
		<%@ include file="footer.jsp" %>
		<!-- footer 끝 -->
		
	</div>
</body>
</html>