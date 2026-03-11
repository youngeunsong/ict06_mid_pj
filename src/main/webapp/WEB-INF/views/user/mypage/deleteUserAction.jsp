<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>탈퇴 처리 결과 | 맛침내!</title>
</head>
<body>
    <c:choose>
        <%-- 1. 비밀번호 인증 성공 & 탈퇴 처리(Update status='0') 성공 --%>
        <c:when test="${selectCnt == 1 && deleteCnt == 1}">
            <script>
                alert("회원 탈퇴가 정상적으로 완료되었습니다.\n그동안 '맛침내!'를 이용해주셔서 감사합니다.");
                location.href = "${path}/main.do";
            </script>
        </c:when>

        <%-- 2. 비밀번호 인증 실패 (비번이 틀린 경우) --%>
        <c:when test="${selectCnt == 0}">
            <script>
                alert("비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
                history.back();
            </script>
        </c:when>

        <%-- 3. 기타 에러 (DB 오류 등) --%>
        <c:otherwise>
            <script>
                alert("처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
                history.back();
            </script>
        </c:otherwise>
    </c:choose>
</body>
</html>