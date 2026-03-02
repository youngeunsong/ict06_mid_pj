<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>예약</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>

</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<script type="text/javascript">
			alert("성공적으로 예약됐습니다!");
			// 메인 페이지로 이동
			location.href = "${path}/surveyReview.rv";
		</script>

		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>