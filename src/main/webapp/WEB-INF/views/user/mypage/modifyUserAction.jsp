<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정 처리</title>
</head>
<body>

<c:if test="${updateCnt == 1}">
	<script>
		alert("정보 수정 성공!!");
		location.href = "${path}/main.do";
	</script>
</c:if>

<c:if test="${updateCnt != 1}">
	<script>
		alert("정보 수정 실패!!");
		location.href = "${path}/modifyUser.do";
	</script>
</c:if>

</body>
</html>