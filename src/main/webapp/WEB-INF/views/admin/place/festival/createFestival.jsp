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
<title>신규 축제 작성 폼</title>

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
					<h3 class="mb-0 font-weight-bold">신규 축제 추가</h3>
				</div>
			</div>
			
			<!-- 신규 축제 정보 입력 폼 영역 시작 -->
            <div class="card card-primary">
              	<!-- form start -->
              	<form name="festivalForm" action="${path}/createFestivalAction.adfe" method="post"> <!-- onsubmit 필요한 지 확인 -->
	              	<!-- card-body 시작  -->
	                <div class="card-body">
	                	<!-- 정보 입력 테이블 영역 시작 -->
	                	<table class="table">
	                		<!-- 축제 이름 시작-->
	                		<tr>
	                			<th><label for="inputName">* 축제 이름</label></th>
	                			<td><input type="text" id="inputName" name="name" placeholder="축제 이름을 입력해주세요" required></td>
	                		</tr>
	                		<!-- 축제 이름 끝-->
		                	<!-- 축제 주소 시작-->
		                	<tr>
	                			<th><label for="inputAddress">축제 주소</label></th>
	                			<td><input type="text" id="inputAddress" name="address" placeholder="축제 주소를 입력해주세요"></td>
	                		</tr>
		                	<!-- 축제 주소 끝-->
		                	<!-- 축제 위도 시작-->
		                	<tr>
	                			<th><label for="inputLatitude">축제 위도</label></th>
	                			<td><input type="number" step="0.00000001" id="inputLatitude" name="latitude" placeholder="축제 위도를 입력해주세요"></td>
	                		</tr>
		                	<!-- 축제 위도 끝-->
		                	<!-- 축제 경도 시작-->
		                	<tr>
	                			<th><label for="inputLongitude">축제 경도</label></th>
	                			<td><input type="number" step="0.00000001" name="longitude" id="inputLongitude" placeholder="축제 경도를 입력해주세요"></td>
	                		</tr>
		                	<!-- 축제 경도 끝-->
		                	<!-- 축제 이미지 URL 시작 -->
		                	<tr>
	                			<th><label for="inputImgAddress">축제 이미지 웹주소</label></th>
	                			<td><input type="text" id="inputImgAddress" name="image_url" placeholder="축제 이미지 웹주소를 입력해주세요"></td>
	                		</tr>
		                	<!-- 축제 이미지 URL 끝 -->
		                	<!-- 축제 설명 시작 -->
		                	<tr>
	                			<th><label for="inputDescription">축제 설명</label></th>
	                			<td><textarea id="inputDescription" name="description" cols="50" rows="10" placeholder="축제에 대한 설명문을 입력해주세요."></textarea></td>
	                		</tr>
		                	<!-- 축제 설명 끝 -->
		                	<!-- 축제 시작일 시작 -->
		                	<tr>
	                			<th><label for="inputStartDate">축제 시작일</label></th>
	                			<td><input type="date" id="inputStartDate" name="start_date"></td>
	                		</tr>
		                	<!-- 축제 시작일 끝 -->
		                	<!-- 축제 종료일 시작 -->
		                	<tr>
	                			<th><label for="inputEndDate">축제 종료일</label></th>
	                			<td><input type="date" id="inputEndDate" name="end_date"></td>
	                		</tr>
		                	<!-- 축제 종료일 끝 -->
		                	<!-- 티켓 정보 입력 시작 -->
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
			                				<td><input type="number" name="priceFree" placeholder="가격" ></td>
			                				<td><input type="number" name="stockFree" placeholder="재고" ></td>
			                				<td><textarea name="ticketDescFreeDay" cols="24" rows="5" placeholder="티켓 설명문을 입력해주세요."></textarea></td>
			                			</tr>
			                			<!-- 무료 티켓 끝 -->
			                			<!-- 1일권 시작 -->
			                			<tr>
			                				<td>1일권</td>
			                				<td><input type="number" name="priceOneDay" placeholder="가격" ></td>
			                				<td><input type="number" name="stockOneDay" placeholder="재고" ></td>
			                				<td><textarea name="ticketDescOneDay" cols="24" rows="5" placeholder="티켓 설명문을 입력해주세요."></textarea></td>
			                			</tr>
			                			<!-- 1일권 끝 -->
			                			<!-- 2일권 시작 -->
			                			<tr>
			                				<td>2일권</td>
			                				<td><input type="number" name="priceTwoDay" placeholder="가격" ></td>
			                				<td><input type="number" name="stockTwoDay" placeholder="재고" ></td>
			                				<td><textarea name="ticketDescTwoDay" cols="24" rows="5" placeholder="티켓 설명문을 입력해주세요."></textarea></td>
			                			</tr>
			                			<!-- 2일권 끝 -->
			                			<!-- 전일권 시작 -->
			                			<tr>
			                				<td>전일권</td>
			                				<td><input type="number" name="priceAllDay" placeholder="가격" ></td>
			                				<td><input type="number" name="stockAllDay" placeholder="재고" ></td>
			                				<td><textarea name="ticketDescAllDay" cols="24" rows="5" placeholder="티켓 설명문을 입력해주세요."></textarea></td>
			                			</tr>
			                			<!-- 전일권 끝 -->
				                	</table>
				                	<!-- 티켓 표 끝 -->
			                	</td>
		                	</tr>
		                	<!-- 티켓 정보 입력 끝 -->
	                	</table>
	                	<!-- 정보 입력 테이블 영역 끝 -->
	                </div>
	                <!-- card-body 끝 -->

	                <div class="card-footer">
	                  	<button type="submit" class="btn btn-primary">제출</button>
	             	</div>
              	</form>
            </div>
            <!-- 신규 축제 정보 입력 폼 영역 끝 -->
		</div>

		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
		
		<!-- 관련 SQL 시작 -->
		<div align="center">SQL 쿼리 : 신규 축제 insert </div>
		
		<!-- 작성 요령 : 몇몇 특수문자를 화면에 제대로 출력하기 위해 아래와 같이 사용 필요-->
		<!-- #${'{'} : #과 { 표시 -->
		<!-- &lt; : < 표시 -->
		<!-- &gt; : > 표시 -->
		<div>
			<pre><code>
				-- 1. PLACE 테이블에 축제 장소 추가
				INSERT INTO PLACE (
				    place_id,
				    place_type,
				    name,
				    address,
				    latitude,
				    longitude,
				    image_url
				) VALUES (
				    SEQ_PLACE.NEXTVAL,
				    'FEST',
				    '서울 벚꽃 축제',
				    '서울특별시 영등포구 여의서로',
				    37.528316,
				    126.932676,
				    'https://example.com/images/cherry_festival.jpg'
				);
				
				-- 2. FESTIVAL 테이블에 축제 상세 정보 추가
				INSERT INTO FESTIVAL (
				    festival_id,
				    description,
				    start_date,
				    end_date,
				    status
				) VALUES (
				    SEQ_PLACE.CURRVAL,
				    '여의도에서 열리는 대표적인 봄 벚꽃 축제로 다양한 공연과 먹거리 부스가 운영됩니다.',
				    DATE '2026-04-05',
				    DATE '2026-04-12',
				    'UPCOMING'
				);
			</code></pre>
		</div>
		<!-- 관련 SQL 끝 -->
		
	</div>
	<!--end::div wrapper-->

	<!-- ================= JS ================= -->
	<script>const path = "${path}";</script>
</body>
</html>