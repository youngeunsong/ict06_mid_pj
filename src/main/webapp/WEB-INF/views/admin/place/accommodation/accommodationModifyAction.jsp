<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp"%>
<!-- 관리자용 setting 별도로 함. 주의! -->
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>숙소 수정 성공</title>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
	<!--begin::div wrapper-->
	<div class="wrapper">
		<!-- Preloader -->
		<div
			class="preloader flex-column justify-content-center align-items-center">
			<img src="${path}/resources/admin/dist/img/AdminLTELogo.png"
				height="60" width="60">
		</div>

		<!-- ================= HEADER ================= -->
		<%@ include file="/WEB-INF/views/common/adminHeader.jsp"%>

		<!-- ================= SIDEBAR ================= -->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp"%>

		<!-- ================= CONTENT ================= -->
		<c:if test="${updateCnt == 1}">
			<script type="text/javascript">
				setTimeout(
						function() {
							alert("숙소 수정 성공!!");
			<%-- 키워드가 있을 때는 accommodationSearch.acc로, 없을 때는 accommodation.acc로 분기 --%>
				<c:choose>
							<c:when test="${not empty keyword}">
							window.location = "${path}/accommodationSearch.adac?pageNum=${hiddenPageNum}&areaCode=${areaCode1}&category=${category1}&keyword=${keyword}";
							</c:when>
							<c:otherwise>
							window.location = "${path}/accommodation.adac?pageNum=${hiddenPageNum}&areaCode=${areaCode1}&category=${category1}";
							</c:otherwise>
							</c:choose>
						}, 1000);
			</script>
		</c:if>

		<c:if test="${updateCnt != 1}">
			<script type="text/javascript">
				setTimeout(
						function() {
							alert("숙소 수정 실패!!");
			<%-- 실패 시 다시 수정 폼으로 돌아갈 때도 파라미터 유지 --%>
				window.location = "${path}/accommodation.adac?place_id=${pDto.place_id}&pageNum=${hiddenPageNum}&areaCode=${areaCode1}&category=${category1}&keyword=${keyword}";
						}, 1000);
			</script>
		</c:if>

		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>

	</div>
	<!--end::div wrapper-->

	<!-- ================= JS ================= -->
</body>
</html>