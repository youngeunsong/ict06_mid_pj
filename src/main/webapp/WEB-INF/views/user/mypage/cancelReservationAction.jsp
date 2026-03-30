<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 취소 처리</title>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<c:choose>
			<c:when test="${result == 1}">
				<script type="text/javascript">
					alert("${msg}");
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