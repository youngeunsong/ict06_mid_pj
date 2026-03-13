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
										style="width:160px;" onchange="filterData()">
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
									<span class="tag tag-secondary" data-value="ENDED" onclick="toggleTag(this)">종료</span> <!-- TODO: 함수 작동 테스트 -->
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
					
					<%-- ===== 리스트 카드 ===== --%>	
					<div class="card shadow-sm border-0">
						<div class="card-body p-0">
							<%-- ===== 리스트 보기 ===== --%>
							<div id="reservationListView">
								<table class="table table-hover align-middle m-0">
									<thead class="thead-light">
										<tr>
											<th style="width:80px;">축제번호</th>
											<th style="width:140px;">축제명</th>
											<th style="width:140px;">주소</th>
											<th style="width:80px;">조회수</th>
											<th style="width:80px;">위도</th>
											<th style="width:80px;">경도</th>
											<th style="width:130px;">대표 이미지</th>
											<th style="width:80px;">축제 시작일</th>
											<th style="width:80px;">축제 종료일</th>
											<th style="width:80px;">축제 상태</th>
											<th style="width:80px;">등록일</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="dto" items="${list}">
											<tr onclick="location.href='${path}/showFestivalDetail.adfe?festival_id=${dto.festival_id}';" style="cursor:pointer;"> <!-- TODO: 나중에 수정하기 -->
												<td>${dto.festival_id}</td>
												<td>${dto.placeDTO.name}</td>
												<td>${dto.placeDTO.address}</td>
												<td>${dto.placeDTO.view_count}</td>
												<td>${dto.placeDTO.latitude}</td>
												<td>${dto.placeDTO.longitude}</td>
												<td><img src='${dto.placeDTO.image_url}' style="width: 80%; height: auto;"></td>
												<td><fmt:formatDate value="${dto.start_date}" pattern="yyyy-MM-dd" /></td>
												<td><fmt:formatDate value="${dto.end_date}" pattern="yyyy-MM-dd" /></td>
												<td> <%-- ${dto.status} 에 따라 다른 스타일링. 필터와 동일한 컬러 및 이름 적용 --%>
													<c:choose>
														<c:when test="${dto.status == 'UPCOMING'}">
															<span class="badge badge-success">시작 전</span>
														</c:when>
														<c:when test="${dto.status == 'ONGOING'}">
															<span class="badge badge-warning">진행 중</span>
														</c:when>
														<c:when test="${dto.status == 'ENDED'}">
															<span class="badge badge-secondary">종료</span>
														</c:when>
													</c:choose>	
												</td>	
												<td><fmt:formatDate value="${dto.placeDTO.placeRegDate}" pattern="yyyy-MM-dd" /></td>
												<%-- TODO: 수정버튼 클릭 시 행클릭 이벤트 차단 --%>
											</tr>
										</c:forEach>
										<!-- 리스트가 빈 경우 -->
										<c:if test="${empty list}">
											<tr>
												<td colspan="11" class="text-center py-4 text-muted">
													조회된 예약 내역이 없습니다.
												</td>
											</tr>
										</c:if>
									</tbody>
								</table>
								
								<%-- 페이징 --%>
								<!-- TODO: 페이징 부분이 컨텐츠 영역의 정중앙에 오게 수정 -->
								<div class="py-3 border-top">
									<%@ include file="/WEB-INF/views/common/pagination.jsp"%>
								</div>
								
								<div align="left">
									<button type="button" class="btn btn-block btn-success" style="width:10%;" onclick="location.href='${path}/createFestival.adfe'">새 축제 추가</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</section>
			
			<!-- 샘플 이미지: 실제 사이트에선 누락 -->
			<%-- <img src="${path}/resources/images/admin/placeList.png" width="100%"
				alt="main"> --%>
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
				<c:out value="
					SELECT *
					FROM (
					    SELECT ROWNUM AS rnum, A.*
					    FROM (
					        SELECT 
					            F.festival_id,
					            F.description,
					            F.start_date,
					            F.end_date,
					            F.status,
					            P.name,
					            P.address,
					            P.view_count,
					            P.latitude,
					            P.longitude,
					            P.image_url,
					            P.created_at
					        FROM FESTIVAL F
					        LEFT JOIN PLACE P
					            ON F.festival_id = P.place_id
					        WHERE
					            (
					                :keyword IS NULL
					                OR P.name LIKE '%' || :keyword || '%'
					                OR P.address LIKE '%' || :keyword || '%'
					                OR F.description LIKE '%' || :keyword || '%'
					            )
					        AND (
					                :status IS NULL
					                OR F.status IN (:status)
					            )
					        -- sortType에 따라 다르게 정렬: P.created_at ASC, F.start_date DESC, F.start_date DESC, F.end_date ASC, F.end_date DESC     
					        ORDER BY P.created_at DESC
					    ) A
					)
					WHERE rnum BETWEEN :startRow AND :endRow;
				"/>
			</code></pre>
		</div>
		<!-- 관련 SQL 끝 -->
	</div>
	<!--end::div Wrapper-->

	<!-- ================= JS ================= -->
	<script>const path = "${path}";</script>
	<script src="${path}/resources/js/admin/festival.js"></script>
	
</body>
<!--end::Body-->
</html>