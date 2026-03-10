<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

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

<title>회원정보 수정 처리</title>
</head>
<body>

    <c:choose>
        <c:when test="${updateCnt > 0}">
            <script type="text/javascript">
                alert("회원 정보가 성공적으로 수정되었습니다.");
                // 수정 후에는 메인 화면이나 마이페이지 메인으로
                location.href = "${path}/main.do"; 
            </script>
        </c:when>

        <c:otherwise>
            <script type="text/javascript">
                alert("정보 수정에 실패했습니다. 다시 시도해주세요.");
                // 이전 상세 페이지(modifyDetailPage.do)로
                history.back(); 
            </script>
        </c:otherwise>
    </c:choose>

</body>
</html>