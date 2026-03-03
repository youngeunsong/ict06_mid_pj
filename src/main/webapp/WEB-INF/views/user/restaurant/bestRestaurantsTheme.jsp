<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>맛집 페이지</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

</head>
<body>
   <div class="wrap">
      <%@ include file="../../common/header.jsp" %>
      
      <%@ include file="./restaurantMenus.jsp" %>
      <%@ include file="./restaurantRankMenus.jsp" %>
      
      <div align="center">
			<img src="${path}/resources/images/user/restaurant/bestRestaurants_theme.png" width="100%" alt="main">
	  </div>
	  
	  <!-- 관련 SQL -->
		SQL 쿼리 : 테마별 맛집 랭킹 쿼리
		<pre>
			<code>
			<c:out value="
				SELECT p.name, r.category, p.view_count
				FROM PLACE p
				JOIN RESTAURANT r ON p.place_id = r.restaurant_id
				WHERE r.category = '#${'{'}category}'
				ORDER BY p.view_count DESC;
			" />
			</code>
		</pre>
  	
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>