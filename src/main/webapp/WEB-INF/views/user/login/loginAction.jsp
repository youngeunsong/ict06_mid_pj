<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 처리</title>
</head>
<body>

    <c:choose>
        <%-- 1. 로그인 성공 시 --%>
        <c:when test="${selectCnt == 1}">
            <script type="text/javascript">
                // 세션에 저장된 ID를 가져와 환영 메시지 출력
                alert("${sessionScope.sessionID}님, 환영합니다!");
               
                //--------------------------------------------------------------------
                // 추가 포인트 지급부분
             	// 신규 회원가입 포인트 지급 메시지 (한 번만)
                <c:if test="${not empty sessionScope.joinPointGiven}">
                    alert("🎉 신규 회원 가입으로 2,000 포인트가 적립되었습니다!");
                    <c:remove var="joinPointGiven" scope="session"/>
                </c:if>;
                //---------------------------------------------------------------------
                
                // 메인 페이지로 이동
                location.href = "${path}/main.do";
            </script>
        </c:when>

        <%-- 2. 로그인 실패 시 --%>
        <c:otherwise>
            <script type="text/javascript">

                alert("아이디 또는 비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
                
                // 이전 로그인 폼 페이지로 이동 (입력했던 정보 유지)
                history.back();
            </script>
        </c:otherwise>
    </c:choose>

</body>
</html>