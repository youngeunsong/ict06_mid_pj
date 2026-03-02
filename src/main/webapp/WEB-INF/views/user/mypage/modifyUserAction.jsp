<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 반응형 웹 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>update</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/customer/join.css">


<!-- (3-4).  각 페이지마다 main.js를 추가해서 연결  -->
<!-- defer : html을 다 읽은 후에 자바스크립트를 실행한다. 페이지가 모두 로드된 후에 해당 외부 스크립트가 실행된다. -->
<script src="${path}/resources/js/common/main.js" defer></script>

<script src="${path}/resources/js/customer/modify.js" defer></script>

</head>
<body>
	<div class="wrap">
		
			
		<c:if test="${updateCnt == 1}">
			<script type="text/javascript">
				alert("정보 수정 성공!!");
				window.location= "${path}/main.do";
			</script>
		</c:if>
		
		<c:if test="${updateCnt != 1}">
			<script type="text/javascript">
				alert("정보 수정 실패!!");
				window.location= "${path}/modifyDetailAction.do";
			</script>
		</c:if>
	
	</div>
</body>
</html>