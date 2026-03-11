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
              	<form>
	              	<!-- card-body 시작  -->
	                <div class="card-body">
	                	<!-- 정보 입력 테이블 영역 시작 -->
	                	<table class="table">
	                		<!-- 축제 이름 시작-->
	                		<tr>
	                			<th><label for="inputName">축제 이름</label></th>
	                			<td><input type="text" id="inputName" class=".form-control-border" placeholder="축제 이름을 입력해주세요"></td>
	                		</tr>
	                		<!-- 축제 이름 끝-->
		                	<!-- 축제 주소 시작-->
		                	<tr>
	                			<th><label for="inputAddress">축제 주소</label></th>
	                			<td><input type="text" id="inputAddress" class=".form-control-border" placeholder="축제 주소를 입력해주세요"></td>
	                		</tr>
		                	<!-- 축제 주소 끝-->
		                	<!-- 축제 위도 시작-->
		                	<tr>
	                			<th><label for="inputLatitude">축제 위도</label></th>
	                			<td><input type="text" id="inputLatitude" class=".form-control-border" placeholder="축제 위도를 입력해주세요"></td>
	                		</tr>
		                	<!-- 축제 위도 끝-->
		                	<!-- 축제 경도 시작-->
		                	<tr>
	                			<th><label for="inputLongitude">축제 경도</label></th>
	                			<td><input type="text" id="inputLongitude" class=".form-control-border" placeholder="축제 경도를 입력해주세요"></td>
	                		</tr>
		                	<!-- 축제 경도 끝-->
		                	<!-- 축제 이미지 URL 시작 -->
		                	<tr>
	                			<th><label for="inputImgAddress">축제 이미지 웹주소</label></th>
	                			<td><input type="text" id="inputImgAddress" class=".form-control-border" placeholder="축제 이미지 웹주소를 입력해주세요"></td>
	                		</tr>
		                	<!-- 축제 이미지 URL 끝 -->
		                	<!-- 축제 설명 시작 -->
		                	<tr>
	                			<th><label for="inputDescription">축제 설명</label></th>
	                			<td><textarea id="inputDescription" cols="30" rows="10" placeholder="축제에 대한 설명문을 입력해주세요."></textarea></td>
	                		</tr>
		                	<!-- 축제 설명 끝 -->
		                	
	                	</table>
	                	<!-- 정보 입력 테이블 영역 끝 -->
	                	
	                	
	                  <!-- <div class="form-group">
	                    <label for="exampleInputEmail1">Email address</label>
	                    <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Enter email">
	                  </div>
	                  <div class="form-group">
	                    <label for="exampleInputPassword1">Password</label>
	                    <input type="password" class="form-control" id="exampleInputPassword1" placeholder="Password">
	                  </div>
	                  <div class="form-group">
	                    <label for="exampleInputFile">File input</label>
	                    <div class="input-group">
	                      <div class="custom-file">
	                        <input type="file" class="custom-file-input" id="exampleInputFile">
	                        <label class="custom-file-label" for="exampleInputFile">Choose file</label>
	                      </div>
	                      <div class="input-group-append">
	                        <span class="input-group-text">Upload</span>
	                      </div>
	                    </div>
	                  </div>
	                  <div class="form-check">
	                    <input type="checkbox" class="form-check-input" id="exampleCheck1">
	                    <label class="form-check-label" for="exampleCheck1">Check me out</label>
	                  </div> -->
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
				
			</code></pre>
		</div>
		<!-- 관련 SQL 끝 -->
		
	</div>
	<!--end::div wrapper-->

	<!-- ================= JS ================= -->
	<script>const path = "${path}";</script>
</body>
</html>