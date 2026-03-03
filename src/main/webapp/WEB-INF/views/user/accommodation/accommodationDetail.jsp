<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>숙소 페이지</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

</head>
<body>
   <div class="wrap">
      <%@ include file="../../common/header.jsp" %>
      
      <button type="button" class="btn_area" onclick="location.href='${path}/accommodationMap.ac'">
	        지도 보기
	  </button>	
	  
	  <button type="button" class="btn_area" onclick="location.href='${path}/reservation.rv'">
	        예약하기
	  </button>	
      
      <div align="center">
			<img src="${path}/resources/images/user/accommodation/accommodationDetail.jpg" width="100%" alt="main">
	  </div>
      
		<!-- 관련 SQL -->
		SQL 쿼리 : 숙소 상세 조회 쿼리
		<pre style="background-color:#f8f9fa; border:1px solid #dee2e6; border-left:4px solid #01D281;">
			<code>
			<c:out value="
			" />
			</code>
		</pre>
      
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>