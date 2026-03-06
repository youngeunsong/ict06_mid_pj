<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 반응형 웹 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>main</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/common/main.css">

</head>
<body>
	<div class="wrap">
		<!-- header 시작 -->
		<%@ include file="header.jsp" %>
		<!-- header 끝 -->
		
		<!-- 컨텐츠 시작 -->
		<div align="center">
			<img src="${path}/resources/images/main/main.jpg" width="100%" alt="main">
		</div>
		<!-- 컨텐츠 끝 -->
		
		<!-- 관련 SQL -->
		SQL 쿼리 : 장소 통합 검색
		<pre style="background-color:#f8f9fa; border:1px solid #dee2e6; border-left:4px solid #01D281;">
			<code>
			<c:out value="
			SELECT * FROM PLACE ORDER BY PLACE_ID;
			SELECT * FROM RESTAURANT ORDER BY RESTAURANT_ID;
			SELECT * FROM ACCOMMODATION ORDER BY ACCOMMODATION_ID;
			SELECT * FROM FESTIVAL ORDER BY FESTIVAL_ID;
			
			CREATE OR REPLACE VIEW PLACE_ALL_DETAIL AS
			SELECT
			    -- [1] PLACE 공통 정보
			    P.PLACE_ID,
			    P.PLACE_TYPE,
			    P.NAME,
			    P.ADDRESS,
			    P.VIEW_COUNT,
			    P.LATITUDE,
			    P.LONGITUDE,
			    P.IMAGE_URL,
			    P.CREATED_AT,
			
			    -- [2] 타입별 장소설명 통합 (하나의 DESCRIPTION으로 보여주기)
			    CASE
			        WHEN P.PLACE_TYPE = 'REST' THEN R.DESCRIPTION
			        WHEN P.PLACE_TYPE = 'ACC'  THEN A.DESCRIPTION
			        WHEN P.PLACE_TYPE = 'FEST' THEN F.DESCRIPTION
			    END AS DESCRIPTION,
			
			    -- [3] 타입별 연락처 통합
			    CASE
			        WHEN P.PLACE_TYPE = 'REST' THEN R.PHONE
			        WHEN P.PLACE_TYPE = 'ACC'  THEN A.PHONE
			        ELSE NULL -- 축제는 연락처가 없을 경우 대비
			    END AS PHONE,
			
			    -- [4] 타입별 상태 통합
			    CASE
			        WHEN P.PLACE_TYPE = 'REST' THEN R.STATUS
			        WHEN P.PLACE_TYPE = 'ACC'  THEN A.STATUS
			        WHEN P.PLACE_TYPE = 'FEST' THEN F.STATUS
			    END AS PLACE_STATUS,
			
			    -- [5] 타입별 고유 정보 (합칠 수 없는 정보들)
			    R.CATEGORY AS REST_CATEGORY,
			    A.PRICE    AS ACC_PRICE,
			    F.START_DATE AS FEST_START_DATE,
			    F.END_DATE   AS FEST_END_DATE
			
			FROM PLACE P
			LEFT JOIN RESTAURANT R ON P.PLACE_ID = R.RESTAURANT_ID
			LEFT JOIN ACCOMMODATION A ON P.PLACE_ID = A.ACCOMMODATION_ID
			LEFT JOIN FESTIVAL F ON P.PLACE_ID = F.FESTIVAL_ID;
			
			SELECT * FROM PLACE_ALL_DETAIL
			ORDER BY PLACE_ID;
			" />
			</code>
		</pre>
		
		<!-- footer 시작 -->
		<%@ include file="footer.jsp" %>
		<!-- footer 끝 -->
		
	</div>
</body>
</html>