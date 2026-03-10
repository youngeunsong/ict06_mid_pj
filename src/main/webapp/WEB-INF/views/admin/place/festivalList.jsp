<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<fmt:setTimeZone value="Asia/Seoul"/>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">

<title>축제 관리</title>
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
		<!-- 컨텐츠 시작 -->
		<div class="content-wrapper">
		
			<div class="app-content-header py-3">
				<div class="container-fluid">
					<h3 class="mb-0 font-weight-bold">축제 관리</h3>
				</div>
			</div>
			
			<section class="app-content">
				<div class="container-fluid">
				
					<%--필터 영역--%>
					<div class="filter-box mb-3 p-3 bg-white shadow-sm rounded">
					
						<%--좌측: 보기방식+키워드 검색+정렬--%>
						<div class="d-flex align-items-center justify-content-between flex-wrap" style="gap:15px;">
							<div class="d-flex align-items-center" style="gap:15px;">
								<%--키워드 검색 영역--%>
								<div class="input-group input-group-sm" style="width:220px;">
									<input type="text" id="keyword" name="keyword" class="form-control"
										placeholder="축제 키워드 입력" value="${param.keyword}" style="font-size:0.78rem;"> <!-- TODO: 이 변수 체크 -->
									<div class="input-group-append">
										<button class="btn btn-outline-secondary" type="button" onclick="keywordSearch()" style="font-size:0.78rem;">
											<i class="bi bi-search"></i>
										</button>
									</div>
								</div>
							</div>
						</div>
						
						<%--우측: 필터 태그 및 검색 영역--%>
						<div class="filter-right">
							<%--정렬 드롭다운 영역--%>
							<div class="filter-row">
								<span class="filter-row-label">정렬</span>
								<select id="sortType" name="sortType" class="form-control form-control-sm"
										style="width:130px;" onchange="filterData()">
									<option value="created_at_desc" ${sortType=='created_at_desc' ? 'selected' : ''}>축제 등록일 최신순</option>
									<option value="start_date_asc" ${sortType=='start_date_asc' ? 'selected' : ''}>축제 시작일 오름차순</option> <!-- TODO: 상황 따라 변수 수정 필요  -->
									<option value="start_date_desc" ${sortType=='start_date_desc' ? 'selected' : ''}>축제 시작일 내림차순</option> <!-- TODO: 상황 따라 변수 수정 필요  -->
									<option value="end_date_asc" ${sortType=='end_date_asc' ? 'selected' : ''}>축제 종료일 오름차순</option> <!-- TODO: 상황 따라 변수 수정 필요  -->
									<option value="end_date_desc" ${sortType=='end_date_desc' ? 'selected' : ''}>축제 종료일 내림차순</option> <!-- TODO: 상황 따라 변수 수정 필요  -->
									<option value="status" ${sortType=='status' ? 'selected' : ''}>축제 상태순</option>
								</select>
							</div>
							
							<%--필터(축제 상태)--%>
							<div class="filter-row">
								<span class="filter-row-label">축제 상태</span>
								<div style="display:flex; gap:4px;"> 
									<span class="tag tag-success" data-value="UPCOMING" onclick="toggleTag(this)">시작 전</span> <!-- TODO: 함수 작동 테스트  -->
									<span class="tag tag-warning" data-value="ONGOING" onclick="toggleTag(this)">진행 중</span> <!-- TODO: 함수 작동 테스트 -->
s									<span class="tag tag-secondary" data-value="ENDED" onclick="toggleTag(this)">종료</span> <!-- TODO: 함수 작동 테스트 -->
								</div>
							</div>
							
							<%-- ===== 필터 검색버튼 ===== --%>
							<div class="filter-row">
								<span class="filter-row-label"></span>
								<button type="button" class="btn btn-dark btn-filter-search" onclick="filterData()"> <!-- TODO: 함수 작동 테스트 -->
									<i class="bi bi-search mr-1"></i>검색
								</button>
							</div>
						</div>
					</div>
				</div>
			</section>
			
			<img src="${path}/resources/images/admin/placeList.png" width="100%"
				alt="main">
		</div>
		<!-- 컨텐츠 끝 -->

		<!-- ================= FOOTER ================= -->
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
		
		<!-- 관련 SQL 시작 -->
		<div align="center">SQL 쿼리 : 등록 맛집 목록 조회</div>
		
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
	<!--end::div Wrapper-->

	<!-- ================= JS ================= -->
</body>
<!--end::Body-->
</html>