<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->    
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>1:1문의 답변 처리 결과(관리자)</title>
<%-- [스크립트 영역] DB 처리 결과에 따른 알림 및 페이지 이동 제어 --%>
    <script type="text/javascript">
        window.onload = function() {
            // 서비스 단에서 넘어온 updateCnt(성공한 행의 개수) 확인
            <c:choose>
                <c:when test="${updateCnt > 0}">
                    alert("답변 등록 및 알림 메일 발송이 성공적으로 완료되었습니다.");
                    location.href = "${path}/adInquiryList.adsp"; // 성공 시 목록으로 이동
                </c:when>
                <c:otherwise>
                    alert("답변 등록에 실패했습니다. 다시 시도해 주세요.");
                    history.back(); // 실패 시 이전 작성 폼으로 이동
                </c:otherwise>
            </c:choose>
        };
    </script>
</head>
<!--end::Head-->
<!--begin::Body-->
<body class="hold-transition sidebar-mini layout-fixed">

	<div class="wrapper">
        <!-- Preloader -->
        <div class="preloader flex-column justify-content-center align-items-center">
            <img src="${path}/resources/admin/dist/img/AdminLTELogo.png" height="60" width="60">
        </div>

		<!-- ================= HEADER ================= -->
        <%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>
		<!-- ================= SIDEBAR ================= -->
        <%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>
		<!-- ================= CONTENT ================= -->
		<!-- 컨텐츠 시작 -->
        <div class="content-wrapper">
            <div align="center" style="margin-top: 100px;">
                <h3 style="font-weight: bold;">1:1 문의 답변 처리 중</h3>
                <p>데이터를 저장하고 알림 메일을 발송하고 있습니다.</p>
                <p>잠시만 기다려 주세요...</p>
            </div>
        </div>
        <!-- 컨텐츠 끝 -->

		<!-- ================= FOOTER ================= -->
        <footer class="main-footer">
            <strong>Copyright &copy; 2026</strong>
        </footer>
	</div>
</body>
<!--end::Body-->
</html>
