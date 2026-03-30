<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정 처리</title>
</head>
<body>

<c:choose>
	<c:when test="${updateCnt == 1}">
		<script type="text/javascript">
			alert("회원정보가 수정되었습니다.");
			window.location="${path}/myPageHome.do";
		</script>
	</c:when>

	<c:when test="${updateCnt == -1}">
		<script type="text/javascript">
			alert("비밀번호는 영문, 숫자, 특수문자를 포함한 8~20자여야 합니다.");
			window.history.back();
		</script>
	</c:when>

	<c:otherwise>
		<script type="text/javascript">
			alert("회원정보 수정에 실패했습니다.");
			window.history.back();
		</script>
	</c:otherwise>
</c:choose>

</body>
</html>