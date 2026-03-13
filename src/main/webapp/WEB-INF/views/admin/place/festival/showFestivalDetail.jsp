<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<!DOCTYPE html>
<html lang="en">
<head>
<fmt:setTimeZone value="Asia/Seoul"/>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>축제 상세 조회(관리자)</title>

</head>
<!--end::Head-->
<!--begin::Body-->
<body class="hold-transition sidebar-mini layout-fixed">
	<!--begin::div wrapper-->
	<div class="wrapper">
		<!-- Preloader -->
		<div
			class="preloader flex-column justify-content-center align-items-center">
			<img src="${path}/resources/admin/dist/img/AdminLTELogo.png"
				height="60" width="60">
		</div>

		<!-- ================= HEADER ================= -->
		<%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>

		<!-- ================= SIDEBAR ================= -->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

		<!-- ================= CONTENT ================= -->
		<div class="content-wrapper">
			<div class="app-content-header py-3">
				<div class="container-fluid">
					<h3 class="mb-0 font-weight-bold">축제 상세 정보</h3>
				</div>
			</div>
			
			<!-- 축제 상세 정보 영역 시작 -->
			<!-- hidden input : festival_id 시작 : dto 조회에 필요-->
            <input name="festival_id" value="${festival_id}" type="hidden"> 
            <!-- hidden input : festival_id 끝-->
            <div class="card card-primary">
              	<!-- card-body 시작  -->
                <div class="card-body">
                	<!-- 정보 테이블 영역 시작 -->
                	<table class="table">
                		
                		<!-- 축제 이름 시작-->
                		<tr>
                			<th><label for="inputName">* 축제 이름</label></th>
                			<td>${festivalDTO.placeDTO.name}</td>
                		</tr>
                		<!-- 축제 이름 끝-->
	                	<!-- 축제 주소 시작-->
	                	<tr>
                			<th><label for="inputAddress">축제 주소</label></th>
                			<td>${festivalDTO.placeDTO.address}</td>
                		</tr>
	                	<!-- 축제 주소 끝-->
	                	<!-- 축제 위도 시작-->
	                	<tr>
                			<th><label for="inputLatitude">축제 위도</label></th>
                			<td>${festivalDTO.placeDTO.latitude}</td>
                		</tr>
	                	<!-- 축제 위도 끝-->
	                	<!-- 축제 경도 시작-->
	                	<tr>
                			<th><label for="inputLongitude">축제 경도</label></th>
                			<td>${festivalDTO.placeDTO.longitude}</td>
                		</tr>
	                	<!-- 축제 경도 끝-->
	                	<!-- 축제 이미지 URL 시작 -->
	                	<tr>
                			<th><label for="inputImgAddress">축제 이미지 웹주소</label></th>
                			<td>
                				<%-- ${festivalDTO.placeDTO.image_url}<br> --%>
                				<img src="${festivalDTO.placeDTO.image_url}" style="width: 25%; height: auto;">
                			</td>
                		</tr>
	                	<!-- 축제 이미지 URL 끝 -->
	                	<!-- 축제 설명 시작 -->
	                	<tr>
                			<th><label for="inputDescription">축제 설명</label></th>
                			<td><div style="white-space: pre-wrap;">${festivalDTO.description}</div></td>
                		</tr>
	                	<!-- 축제 설명 끝 -->
	                	<!-- 축제 시작일 시작 -->
	                	<tr>
                			<th><label for="inputStartDate">축제 시작일</label></th>
                			<td>${festivalDTO.start_date}</td>
                		</tr>
	                	<!-- 축제 시작일 끝 -->
	                	<!-- 축제 종료일 시작 -->
	                	<tr>
                			<th><label for="inputEndDate">축제 종료일</label></th>
                			<td>${festivalDTO.end_date}</td>
                		</tr>
	                	<!-- 축제 종료일 끝 -->
	                	<!-- 티켓 정보 시작 -->
	                	<tr>
	                		<th>티켓 정보</th>
	                		<td> 
	                			<!-- 티켓 표 시작 -->
		                		<table class="table">
		                			<!-- 헤더 시작: 티켓 종류, 가격, 재고, 설명 -->
		                			<tr>
		                				<th>티켓 종류</th>
		                				<th>가격</th>
		                				<th>재고</th>
		                				<th>설명</th>
		                			</tr>
		                			<!-- 헤더 끝 -->
		                			<!-- 무료 티켓 시작 -->
		                			<tr>
		                				<td>무료</td>
		                				<td>${freeTicket.price}원</td>
		                				<td>${freeTicket.stock}</td>
		                				<td>${freeTicket.description}</td>
		                			</tr>
		                			<!-- 무료 티켓 끝 -->
		                			<!-- 1일권 시작 -->
		                			<tr>
		                				<td>1일권</td>
		                				<td>${oneDayTicket.price}원</td>
		                				<td>${oneDayTicket.stock}</td>
		                				<td>${oneDayTicket.description}</td>
	                				</tr>
		                			<!-- 1일권 끝 -->
		                			<!-- 2일권 시작 -->
		                			<tr>
		                				<td>2일권</td>
		                				<td>${twoDayTicket.price}원</td>
		                				<td>${twoDayTicket.stock}</td>
		                				<td>${twoDayTicket.description}</td>
	                				</tr>
		                			<!-- 2일권 끝 -->
		                			<!-- 전일권 시작 -->
		                			<tr>
		                				<td>전일권</td>
		                				<td>${allDayTicket.price}원</td>
		                				<td>${allDayTicket.stock}</td>
		                				<td>${allDayTicket.description}</td>
	                				</tr>
		                			<!-- 전일권 끝 -->
			                	</table>
			                	<!-- 티켓 표 끝 -->
		                	</td>
	                	</tr>
	                	<!-- 티켓 정보 끝 -->
                	</table>
                	<!-- 정보 테이블 영역 끝 -->
                </div>
                <!-- card-body 끝 -->
            </div>
            <!-- 축제 상세 정보 영역 끝 -->
		</div>

		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
		
		<!-- 관련 SQL 시작 -->
		<div align="center">SQL 쿼리 : 축제 상세 조회 </div>
		
		<!-- 작성 요령 : 몇몇 특수문자를 화면에 제대로 출력하기 위해 아래와 같이 사용 필요-->
		<!-- #${'{'} : #과 { 표시 -->
		<!-- &lt; : < 표시 -->
		<!-- &gt; : > 표시 -->
		<div>
			<pre><code>
					SELECT
							F.festival_id,
							F.description,
							F.start_date,
							F.end_date,
							F.status,
							P.place_id,
							P.place_type,
							P.name,
							P.address,
							P.view_count,
							P.latitude,
							P.longitude,
							P.image_url,
							P.created_at
					FROM 	FESTIVAL F
					LEFT JOIN PLACE P
					ON F.festival_id = P.place_id
					WHERE F.festival_id = #${'{'}festival_id}
					
					
					SELECT
						    ticket_id,
						    festival_id,
						    ticket_type,
						    price,
						    stock,
						    description
					  FROM  FESTIVAL_TICKET
					 WHERE  festival_id = #${'{'}festival_id}
			</code></pre>
		</div>
		<!-- 관련 SQL 끝 -->
		
	</div>
	<!--end::div wrapper-->

	<!-- ================= JS ================= -->
	<script>const path = "${path}";</script>
</body>
</html>