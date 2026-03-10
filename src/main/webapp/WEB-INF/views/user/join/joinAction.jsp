<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입 결과</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/common/header.css">
<link rel="stylesheet" href="${path}/resources/css/common/footer.css">
<link rel="stylesheet" href="${path}/resources/css/user/join.css">

<style>
    .result_container { padding: 80px 0; text-align: center; }
    .result_icon { font-size: 50px; color: #f91a32; margin-bottom: 20px; }
    .result_title { font-size: 24px; font-weight: bold; margin-bottom: 15px; }
    .result_msg { color: #666; margin-bottom: 40px; line-height: 1.6; }
    .btn_login { 
        background-color: #f91a32; color: white; border: none; 
        padding: 15px 40px; font-size: 16px; cursor: pointer; border-radius: 4px;
    }
    .btn_home { 
        background-color: #fff; color: #333; border: 1px solid #ccc; 
        padding: 15px 40px; font-size: 16px; cursor: pointer; border-radius: 4px; margin-left: 10px;
    }
</style>
</head>
<body>
    <div class="wrap">
        <%@ include file="../../common/header.jsp" %>
        
        <div id="container">
            <div class="result_container">
                
                <c:if test="${insertCnt == 1}">
                    <div class="result_icon"><i class="fa-regular fa-circle-check"></i></div>
                    <div class="result_title">환영합니다! 가입이 완료되었습니다.</div>
                    <div class="result_msg">
                        지금 바로 다양한 혜택을 만나보세요.<br>
                        설문에 참여한 고객님을 위한 포인트가 준비되어 있습니다.
                    </div>
                    <div class="result_btns">
                        <button class="btn_login" onclick="window.location='${path}/login.do'">로그인 하기</button>
                        <button class="btn_home" onclick="window.location='${path}/main.do'">홈으로 가기</button>
                    </div>
                </c:if>

                <c:if test="${insertCnt != 1}">
                    <div class="result_icon" style="color: #666;"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    <div class="result_title">회원가입에 실패하였습니다.</div>
                    <div class="result_msg">
                        일시적인 오류가 발생했거나 데이터 형식이 맞지 않습니다.<br>
                        잠시 후 다시 시도해 주세요.
                    </div>
                    <div class="result_btns">
                        <button class="btn_login" onclick="history.back()">다시 시도하기</button>
                        <button class="btn_home" onclick="window.location='${path}/main.do'">홈으로 가기</button>
                    </div>
                </c:if>
                
            </div>
        </div>
        <%@ include file="../../common/footer.jsp" %>
    </div>
</body>
</html>