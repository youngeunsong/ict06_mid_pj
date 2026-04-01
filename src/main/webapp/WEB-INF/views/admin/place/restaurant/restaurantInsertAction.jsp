<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 관리자용 setting 별도로 함. 주의! -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>숙소 수정 성공</title>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp"%>
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
		<c:choose>
			<c:when test="${insertCnt == 1}">
				<script type="text/javascript">
					setTimeout(
							function() {
								alert("맛집 등록 성공!!");
				<%-- 키워드 유무에 따라 서블릿 주소 결정 --%>
					<c:if test="${not empty keyword}">
								window.location = "${path}/restaurantSearch.adre?pageNum=${pageNum}&areaCode=${areaCode}&category=${category}&keyword=${keyword}";
								</c:if>
								<c:if test="${empty keyword}">
								window.location = "${path}/restaurantList.adre?pageNum=${pageNum}&areaCode=${areaCode}&category=${category}";
								</c:if>
							}, 1000);
				</script>
			</c:when>

			<c:otherwise>
				<script type="text/javascript">
					setTimeout(
							function() {
								alert("맛집 등록 실패!!");
				<%-- 실패 시 다시 등록 폼으로 돌아갈 때도 검색어 유지 --%>
					window.location = "${path}/restaurantInsert.adre?pageNum=${pageNum}&areaCode=${areaCode}&category=${category}&keyword=${keyword}";
							}, 1000);
				</script>
			</c:otherwise>
		</c:choose>

		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
	</div>
	<!--end::div wrapper-->

	<!-- ================= JS ================= -->
</body>
</html>