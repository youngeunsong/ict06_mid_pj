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
      <button type="button" class="btn_area" onclick="location.href='${path}/accommodation.ac'">
	        내 주변 숙소
	  </button>	
	  <button type="button" class="btn_area" onclick="location.href='${path}/bestAccommodations.ac'">
	        베스트 숙소
	  </button>	
   </div>
</body>
</html>