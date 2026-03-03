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
			<img src="${path}/resources/images/user/restaurant/bestRestaurants_realTime.png" width="100%" alt="main">
	  </div>
	  
	  <!-- 관련 SQL -->
		SQL 쿼리 : 베스트 맛집 랭킹 쿼리
		<pre>
			<code>
			<c:out value="
			SELECT * FROM (
			    SELECT 
			        p.place_id, p.name, p.address, p.view_count, p.image_url,
			        r.category, r.status
			    FROM PLACE p
			    JOIN RESTAURANT r ON p.place_id = r.restaurant_id
			    WHERE p.place_type = 'REST' AND r.status = 'OPEN'
			    ORDER BY p.view_count DESC, p.created_at DESC
			) WHERE ROWNUM <= 10
			" />
			</code>
		</pre>
		SQL 쿼리 : 실시간 베스트 맛집 랭킹 쿼리
		<pre>
			<code>
			<c:out value="
				SELECT * FROM (
				    SELECT 
				        p.place_id, p.name, p.address, p.image_url,
				        COUNT(v.log_id) AS weekly_views  -- 최근 7일간의 카운트
				    FROM PLACE p
				    JOIN PLACE_VIEW_LOG v ON p.place_id = v.place_id
				    WHERE v.view_date >= SYSDATE - 7  -- 최근 7일 데이터만 필터링
				      AND p.place_type = 'REST'
				    GROUP BY p.place_id, p.name, p.address, p.image_url
				    ORDER BY weekly_views DESC
				) WHERE ROWNUM <= 10;
			" />
			</code>
		</pre>
  	
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>