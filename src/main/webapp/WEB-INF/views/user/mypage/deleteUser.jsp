<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/login.css"> <script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>

<link rel="stylesheet" href="${path}/resources/css/common/header.css">
<link rel="stylesheet" href="${path}/resources/css/common/footer.css">
<style>
    .delete_info {
        background-color: #f8f8f8;
        padding: 20px;
        border-radius: 8px;
        text-align: left;
        margin-bottom: 25px;
        font-size: 14px;
        color: #666;
        line-height: 1.6;
    }
    .delete_info strong { color: #f91a32; }
    .btn_delete {
        width: 100%;
        padding: 15px;
        background-color: #999; /* 처음엔 무채색 */
        color: white;
        border: none;
        border-radius: 4px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
    }
    .btn_delete:hover { background-color: #f91a32; } /* 하버 시 빨간색 */
</style>
</head>
<body>
   <div class="wrap">
      <%@ include file="../../common/header.jsp" %>
      
      <div id="container">
         <div id="contents">
            <div class="login_form_area">
               <h2>회원 탈퇴</h2>
               <p>계정을 삭제하시기 전 안내사항을 확인해주세요.</p>

               <div class="delete_info">
                  * 탈퇴 후에는 <strong>로그인이 불가능</strong>합니다. [cite: 2026-02-24] <br>
                  * 작성하신 <strong>게시글과 댓글은 그대로 유지</strong>됩니다.<br>
                  * 현재 보유하신 포인트는 모두 소멸됩니다. [cite: 2026-02-24]
               </div>

               <form name="deleteform" action="${path}/deleteUserAction.do" method="post">
                  <div class="input_box">
                     <div class="input_group">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" name="password" id="password" placeholder="본인 확인을 위해 비밀번호를 입력하세요" required>
                     </div>
                  </div>

                  <div class="btn_area">
                     <input type="submit" value="탈퇴하기" class="btn_delete">
                  </div>
                  
                  <div class="login_bottom_links">
                     <a href="${path}/main.do">탈퇴 취소하고 돌아가기</a>
                  </div>
               </form>
            </div>
         </div>
      </div>
      
      <!-- 관련 SQL -->
    SQL 쿼리 : 회원 탈퇴 
   		<pre>
			<code>
			<c:out escapeXml="true" value="
		        UPDATE MEMBER 
        SET status = 'OUT' 
        WHERE user_id = #${'{'}user_id}
			" />
			</code> 
		</pre>
     <!-- 관련 SQL -->
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>