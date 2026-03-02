<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약목록</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<script src="https://kit.fontawesome.com/648e5e962b.js"
	crossorigin="anonymous"></script>

<style>
.delete_info {
	background-color: #f8f8f8;
	padding: 20px;
	border-radius: 8px;
	text-align: left;
	margin-bottom: 25px;
	font-size: 14px;
	color: #666;
	line-height: 1.6;
}

.delete_info strong {
	color: #f91a32;
}

.btn_delete {
	width: 100%;
	padding: 15px;
	background-color: #999; /* 처음엔 무채색 */
	color: white;
	border: none;
	border-radius: 4px;
	font-weight: bold;
	cursor: pointer;
	transition: 0.3s;
}

.btn_delete:hover {
	background-color: #f91a32;
} /* 하버 시 빨간색 */
</style>

</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<!-- 컨텐츠 시작 -->
		<button type="button" class="btn_area"
			onclick="location.href='${path}/reservationDetail.do'">
			예약상세</button>
		<div align="center">
			<img src="${path}/resources/images/user/mypage/viewReservations.png"
				width="100%" alt="main">
		</div>

		<!-- 관련 SQL -->
		SQL 쿼리 : 모든 예약 목록 조회
		<pre>
			<code>
	   	SELECT
		        r.reservation_id,
		        r.user_id,
		        r.place_id,
		        
		        p.name AS place_name,
		        p.place_type,
	        
	        CASE
	            WHEN p.place_type = 'FEST' THEN '축제'
	            WHEN p.place_type = 'ACC'  THEN '숙소'
	            WHEN p.place_type = 'REST' THEN '음식점'
	        END AS place_type_name,
	        
		        r.check_in,
		        r.check_out,
		        r.visit_time,
		        r.ticket_type,
		        r.guest_count,
		        r.status,
		        r.created_at
		        
		    FROM RESERVATION r
		    JOIN PLACE p
		        ON r.place_id = p.place_id
		    WHERE r.user_id = #${'{'}userId}
		    ORDER BY r.created_at DESC
			</code>
		</pre>

		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>