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
			<img src="${path}/resources/images/user/restaurant/bestRestaurants_region.png" width="100%" alt="main">
	  </div>
	  
	  <!-- 관련 SQL -->
		SQL 쿼리 : 지역별 베스트 맛집 랭킹 쿼리
		<pre>
			<code>
			<c:out value="
			SELECT * FROM (
			    SELECT 
			        p.name, p.address, 
			        ROUND(AVG(rv.rating), 1) as avg_rating,
			        COUNT(rv.review_id) as review_cnt
			    FROM PLACE p
			    JOIN REVIEW rv ON p.place_id = rv.place_id
			    WHERE p.address LIKE '%마포구%' -- 특정 지역
			      AND p.place_type = 'REST'
			    GROUP BY p.place_id, p.name, p.address
			    HAVING COUNT(rv.review_id) >= 5 -- 리뷰 최소 5개 이상인 곳만
			    ORDER BY avg_rating DESC, review_cnt DESC
			) WHERE ROWNUM <= 10;
			" />
			</code>
		</pre>
  	
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>