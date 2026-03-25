<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!--jstl -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>사용자 만족도 테이블</title>

</head>
<!--end::Head-->
<!--begin::Body-->
<body>
	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>예약번호</th>
				<th>NPS 점수</th>
				<th>만족도</th>
				<th>정보신뢰도</th>
				<th>제출일</th>
			</tr>
		</thead>
		
		<tbody>
			<c:forEach var="dto" items="${list}">
				<tr>
					<td>${dto.survey_id}</td>
					<td>${dto.reservation_id}</td>
					<td>${dto.nps_score}</td>
					<td>${dto.satisfaction_score}</td>
					<td>${dto.info_reliability_score}</td>
					<td>${dto.created_at}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
<!-- end::Body -->
</html>
