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
      
      <button type="button" class="btn_area" onclick="location.href='${path}/restaurantDetail.rs'">
	        음식점 이름
	  </button>
      
      <div align="center">
			<img src="${path}/resources/images/user/restaurant/restaurant.jpg" width="100%" alt="main">
	  </div>
	  
	  <!-- 관련 SQL -->
		SQL 쿼리 : 내 주변 맛집 탐색
		<pre>
			<code>
			<c:out value="
			SELECT *
			    FROM (
			        SELECT
			            p.place_id,
			            p.name,
			            p.address,
			            p.latitude,
			            p.longitude,
			
			            (
			                6371 * ACOS(
			                    COS(RADIANS(#${'{'}userLat})) *
			                    COS(RADIANS(p.latitude)) *
			                    COS(RADIANS(p.longitude) - RADIANS(#${'{'}userLng})) +
			                    SIN(RADIANS(#${'{'}userLat})) *
			                    SIN(RADIANS(p.latitude))
			                )
			            ) AS distance_km
			
			        FROM PLACE p
			        WHERE p.place_type = 'REST'
			          AND p.latitude BETWEEN #${'{'}minLat} AND #${'{'}maxLat}
			          AND p.longitude BETWEEN #${'{'}minLng} AND #${'{'}maxLng}
			    )
			    WHERE distance_km <= #${'{'}radius}
			    ORDER BY distance_km ASC
			" />
			</code>
		</pre>
  	
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>