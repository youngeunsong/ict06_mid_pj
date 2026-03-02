<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<html>
<body>
	<!-- 1주차 시연을 위해 임시로 주석처리. 추후 구현 시 필요한 부분 주석 해제하여 사용하시면 됩니다. -->

    <%-- <c:choose> --%>
        <%-- 1. 비밀번호 인증 성공 & 탈퇴 처리 성공 --%>
        <%-- <c:when test="${selectCnt == 1 && deleteCnt == 1}"> --%>
            <script>
                alert("회원 탈퇴가 완료되었습니다. 그동안 이용해주셔서 감사합니다.");
                location.href = "${path}/main.do";
            </script>
       <%--  </c:when> --%>
        
        <%-- 2. 비밀번호 인증 실패 --%>
       <%--  <c:when test="${selectCnt == 0}">
            <script>
                alert("비밀번호가 일치하지 않습니다.");
                history.back();
            </script>
        </c:when> --%>
        
        <%-- 3. 기타 에러 --%>
        <%-- <c:otherwise>
            <script>
                alert("탈퇴 처리 중 오류가 발생했습니다. 다시 시도해주세요.");
                history.back();
            </script>
        </c:otherwise>
    </c:choose> --%>
</body>
</html>