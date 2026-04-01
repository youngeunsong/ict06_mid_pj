<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>설문/리뷰 처리</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<c:choose>
			<c:when test="${result == 1}">
				<script type="text/javascript">
					alert("${msg}");
					alert("🎉 설문조사와 리뷰참여로 500 포인트가 적립되었습니다!");
					location.href = "${path}/viewReservations.do";
				</script>
			</c:when>

			<c:otherwise>
				<script type="text/javascript">
					alert("${msg}");
					history.back();
				</script>
			</c:otherwise>
		</c:choose>

		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>