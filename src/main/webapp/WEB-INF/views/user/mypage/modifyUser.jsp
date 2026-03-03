<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정 인증</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>

<style>
    .modify_auth_box {
        width: 450px;
        margin: 80px auto;
        padding: 40px;
        border: 1px solid #eee;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        text-align: center;
    }
    .auth_desc {
        color: #666;
        font-size: 14px;
        margin-bottom: 30px;
        line-height: 1.5;
    }
    .btn_auth {
        width: 100%;
        padding: 15px;
        background-color: #333;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
    }
    .btn_auth:hover { background-color: #f91a32; }
</style>

</head>
<body>
   <div class="wrap">
      <%@ include file="../../common/header.jsp" %>
      
      <div id="container">
         <div id="contents">
            <div class="modify_auth_box">
               <h2>회원정보 수정</h2>
               <div class="auth_desc">
                  고객님의 개인정보를 안전하게 보호하기 위해<br>
                  <strong>비밀번호를 다시 한번 입력</strong>해주세요.
               </div>

               <form name="modifyAuthForm" action="${path}/modifyDetailPage.do" method="post">
                  <div class="input_box">
                     <div class="input_group" style="background-color: #f9f9f9;">
                        <i class="fa-regular fa-user"></i>
                        <input type="text" value="${sessionScope.sessionID}" readonly style="background: transparent;">
                     </div>

                     <div class="input_group">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" name="password" id="password" placeholder="비밀번호 입력" required autofocus>
                     </div>
                  </div>

                  <div class="btn_area">
                     <input type="submit" value="확인" class="btn_auth">
                  </div>
               </form>
            </div>
         </div>
      </div>
      
      <!-- 관련 SQL -->
      SQL 쿼리 : 회원 비밀번호 재확인
  	<pre><code>
	SELECT password
	FROM MEMBER
	WHERE user_id = #${'{'}userId}
	</code></pre>
	
	SQL 쿼리 : 회원정보 인증 및 회원 상세 정보 가져오기
  		<pre>
			<code>
			<c:out escapeXml="true" value="
		        SELECT * FROM MEMBER WHERE user_id = #${'{'}user_id}
			" />
			</code> 
		</pre>
      
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>