<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>축제 페이지</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

</head>
<body>
   <div class="wrap">
      <%@ include file="../../common/header.jsp" %>
      
      <hr>
      축제
      
      	  <!-- 관련 SQL -->
		SQL 쿼리 : 내 주변 축제 탐색
		<pre style="background-color:#f8f9fa; border:1px solid #dee2e6; border-left:4px solid #01D281;">
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
			        WHERE p.place_type = 'FEST'
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