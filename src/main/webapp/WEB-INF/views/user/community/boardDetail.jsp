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
      
	  <button type="button" class="btn_area" onclick="location.href='${path}/modifyBoard.co'">
	        게시글 수정
	  </button>
      
      <div align="center">
			<img src="${path}/resources/images/user/inquiry/inquiryForm.png" width="100%" alt="main">
	  </div>
      
      <!-- 관련 SQL -->
		SQL 쿼리 : 커뮤니티 게시글 상세 조회 select 쿼리
		<pre>
			<code>
			<c:out value="
			SELECT 
			    b.user_id,
			    b.title,
			    b.content,
			    b.name AS user_name,
			    b.view_count,
			    TO_CHAR(b.created_at, 'YYYY-MM-DD HH24:MI') AS reg_date
			FROM BOARD b
			JOIN MEMBER m ON b.user_id = m.user_id
			WHERE b.board_id = #'{'board_id'}' AND b.status = 'display'
			" />
			</code>
		</pre>
      
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>