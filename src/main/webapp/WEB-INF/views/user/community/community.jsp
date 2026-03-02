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
      
      <button type="button" class="btn_area" onclick="location.href='${path}/createBoard.co'">
	        게시글 작성
	  </button>
	  
	  <button type="button" class="btn_area" onclick="location.href='${path}/boardDetail.co'">
	        게시글 상세 조회
	  </button>
      
      <div align="center">
			<img src="${path}/resources/images/user/community/community.png" width="100%" alt="main">
	  </div>
      
      <!-- 관련 SQL -->
		SQL 쿼리 : 커뮤니티 게시글 목록 로드 쿼리 (공지, 이벤트, 회원 게시글)
		<pre>
			<code>
			<c:out value="
			" />
			</code>
		</pre>
      
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>