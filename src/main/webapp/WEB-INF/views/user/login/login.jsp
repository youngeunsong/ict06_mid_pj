<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>로그인</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script> <!-- 아이콘 -->
<script src="${path}/resources/js/user/login.js" defer></script>

</head>
<body>
   <div class="wrap">
      <%@ include file="../../common/header.jsp" %>
      
      <div id="container">
         <div id="contents">
           <div class="login_form_area">
			    <h2>로그인</h2>
			    <p>오신 것을 환영합니다!</p>
			
			    <form name="loginform" action="${path}/loginAction.do" method="post" onsubmit="return loginCheck()">
			        <div class="login_input_container">
			        	<div class="login_group">
			                <i class="fa-regular fa-user"></i>
			                <input type="text" name="user_id" id="user_id" placeholder="아이디" required>
			            </div>
			
			            <div class="login_group">
			                <i class="fa-solid fa-lock"></i>
			                <input type="password" name="user_password" id="user_password" placeholder="비밀번호" required>
			                <i class="fa-solid fa-eye-slash" id="togglePassword"></i>
			            </div>
			        </div>
			
			        <input type="submit" value="로그인" class="btn_login_submit">
			        
			        <div class="login_bottom_links">
			            <a href="${path}/join.do">회원가입</a> | <a href="#">ID/PW 찾기</a>
			        </div>
			    </form>
			</div>
         </div>
      </div>
      
      <!-- 관련 SQL -->
      SQL 쿼리 : 로그인  
  	<pre><code>
  	SELECT count(*) FROM MEMBER
     WHERE user_id = #${'{'}user_id}
	   AND password = #${'{'}password}
	</code></pre>
      
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>