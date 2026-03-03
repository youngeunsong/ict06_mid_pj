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
		SQL 쿼리 : 베스트 맛집 랭킹 쿼리 (테마별 TOP 6)
		<pre>
			<code>
			<c:out escapeXml="true" value="
				SELECT *
				FROM (
				    SELECT
				        p.place_id,
				        p.name,
				        p.address,
				        p.image_url,
				        NVL(AVG(r.rating), 0)  AS avg_rating,
				        COUNT(r.review_id)     AS review_count
				    FROM place p
				    JOIN restaurant rt
				        ON rt.restaurant_id = p.place_id   
				    LEFT JOIN review r
				        ON r.place_id = p.place_id
				       AND r.status = 'ACTIVE'            
				    WHERE rt.category = :category          
				    GROUP BY p.place_id, p.name, p.address, p.image_url
				    ORDER BY NVL(AVG(r.rating), 0) DESC, COUNT(r.review_id) DESC
				)
				WHERE ROWNUM <= 6;
			" />
			</code> 
		</pre>
  	
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>