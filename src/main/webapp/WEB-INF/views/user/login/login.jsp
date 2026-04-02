<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>로그인</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<link rel="stylesheet" href="${path}/resources/css/common/header.css">
<link rel="stylesheet" href="${path}/resources/css/common/footer.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>
<script src="${path}/resources/js/user/login.js" defer></script>
</head>
<body>
   <div class="wrap">
      <%@ include file="../../common/header.jsp" %>
      
      <div id="container">
         <div id="contents">
           <div class="login_form_area">
			    <h2>로그인</h2>
			    <p>고객님의 소중한 하루를 책임지는 맛침내입니다.
			    환영합니다!</p>
			
			    <form name="loginform" action="${path}/loginAction.do" method="post" onsubmit="return loginCheck()">
					
					<!-- 비로그인 상태로 북마크 클릭 시 원래 있던 페이지로 돌아오기 위한 코드 추가 -->
					<input type="hidden" name="next" value="${param.next}">
					
			        <div class="login_input_container"> <div class="login_group">
			                <i class="fa-regular fa-user"></i>
			                <input type="text" name="user_id" id="user_id" placeholder="아이디" required>
			            </div>
			
			            <div class="login_group">
			                <i class="fa-solid fa-lock"></i>

			                <input type="password" name="password" id="password" placeholder="비밀번호" required>
			                <i class="fa-solid fa-eye-slash" id="togglePassword"></i>
			            </div>
			        </div>
			
			        <input type="submit" value="로그인" class="btn_login_submit">
			        
			        <div class="login_bottom_links">
					    <a href="${path}/join.do">회원가입</a> 
					    <span class="mx-2">|</span> 
					    <a href="${path}/findId.do">아이디 찾기</a> 
					    <span class="mx-2">|</span> 
					    <a href="${path}/findPassword.do">비밀번호 찾기</a>
					</div>
			    </form>
			</div>
         </div>
      </div>
      
      <script src="${path}/resources/js/user/login.js" defer></script>
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>