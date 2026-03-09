<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 페이지</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

</head>
<body>
   <div class="wrap">
      <%@ include file="../../common/header.jsp" %>
      <h3>게시글 수정 </h3>
	  <button type="button" class="btn_area" onclick="location.href='${path}/modifyBoardAction.co'">
	        게시글 수정
	  </button>
      
      <div align="center">
			<img src="${path}/resources/images/user/inquiry/inquiryForm.png" width="100%" alt="main">
	  </div>
      
      <!-- 관련 SQL -->
		SQL 쿼리 : 커뮤니티 게시글 수정 사항 update 
		<pre>
			<code>
				UPDATE BOARD
				SET 
				    title = #'{'title},
				    content = #'{'content},
				    created_at = SYSDATE
				WHERE 
				    board_id = #'{'board_id}
				    AND user_id = #'{'sessionID}
			</code>
		</pre>
      
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>