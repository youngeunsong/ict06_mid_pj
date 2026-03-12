<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<title>맛집 관리 목록</title>

<script src="${path}/resources/js/admin/request.js"></script>

<style>
    /* 1. 본문 영역: 배경색은 유지하되, 푸터 높이를 고려하여 최소 높이 조절 */
    .content-wrapper { 
        background-color: #F6F6F6 !important; 
        /* 푸터가 바닥에 고정되면서도 본문과 겹치지 않게 하단 패딩 부여 */
        padding-bottom: 40px !important; 
        min-height: calc(100vh - 60px) !important;
    }

    /* 사이드바 여백 유지 */
    body:not(.sidebar-collapse) .content-wrapper {
        margin-left: 250px; 
    }

    /* 2. 카드 설정: 아래쪽 마진을 제거하여 푸터와 밀착 */
    .card { 
        border: none; 
        box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); 
        margin-bottom: 0 !important; 
    }

    /* 3. 테이블 및 버튼 스타일 */
    .table tbody td { font-size: 0.9rem; vertical-align: middle; }
    
    .btn-res-primary, .input-group .btn { 
        background-color: #01D281 !important; 
        color: white !important; 
        border: none;
        border-radius: 8px;
    }
    .btn-res-primary:hover { background-color: #01b06c; color: white; }

    /* 4. 푸터 간격 강제 조정: 본문 바로 아래에 붙도록 설정 */
   .main-footer {
        margin-top: 0 !important;
        /* 위아래 패딩을 30px로 늘려 푸터의 폭을 크게 확보합니다 */
        padding: 30px 0 !important; 
        border-top: 1px solid #dee2e6 !important;
        background-color: #fff !important;
        display: block !important;
        text-align: center !important;
        /* 폰트 크기를 키워 존재감을 줍니다 */
        font-size: 1rem; 
        color: #333; /* 글자색을 조금 더 진하게 조정 */
        letter-spacing: 1px; /* 글자 간격을 넓혀 고급스럽게 설정 */
    }
    
    /* 사이드바 보정 (이 부분이 있어야 수평 중앙이 맞습니다) */
    body:not(.sidebar-collapse) .main-footer {
        margin-left: 250px !important;
    }

    /* 페이징 중앙 정렬 유지 */
    .card-footer { 
        display: flex !important; 
        justify-content: center !important; 
        background-color: #fff !important; 
        align-items: center !important;
    }
    .pagination { margin: 0 !important; }
</style>
	
	<script type="text/javascript">
	    // 페이지가 로드된 후 실행
	    window.onload = function() {
	        var areaCode = "${areaCode}";
	        if (areaCode) {
	            // 페이징 영역(card-footer) 내의 모든 <a> 태그를 찾습니다.
	            var pageLinks = document.querySelectorAll(".card-footer .page-link");
	            
	            pageLinks.forEach(function(link) {
	                var currentHref = link.getAttribute("href");
	                
	                // 이미 areaCode가 붙어있지 않은 경우에만 붙여줍니다.
	                if (currentHref && currentHref.indexOf("areaCode") === -1) {
	                    // 주소에 ?가 있으면 &로, 없으면 ?로 연결
	                    var separator = currentHref.indexOf("?") !== -1 ? "&" : "?";
	                    link.setAttribute("href", currentHref + separator + "areaCode=" + areaCode);
	                }
	            });
	        }
	    };
	
	    // 기존 필터 변경 함수는 유지
	    function handleFilterChange(areaCode) {
	        location.href = "${path}/restaurant.ad?areaCode=" + areaCode + "&pageNum=1";
	    }
	</script>

</head>
<body class="hold-transition sidebar-mini layout-fixed">
	<div class="wrapper">
		<!--begin::header-->
		<%@ include file="/WEB-INF/views/common/adminHeader.jsp"%>
		<!--end::header-->

		<!--begin::Sidebar-->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp"%>
		<!--end::Sidebar-->

		<div class="content-wrapper">
			<section class="app-content-header">
				<div class="container-fluid">
					<div class="row mb-2">
						<div class="col-sm-6">
							<h1 class="m-0 fw-bold">맛집 관리</h1>
						</div>
						<div class="col-sm-6">
							<ol class="breadcrumb float-sm-right">
								<li class="breadcrumb-item">
									<a href="${path}/admin/home">Home</a>
								</li>
								<li class="breadcrumb-item active">맛집 목록</li>
							</ol>
						</div>
					</div>
				</div>
			</section>
			
			<!-- 상단 필터/검색 영역 -->
			<section class="app-content">
				<div class="container-fluid">
					<div class="card">
						<div class="card-header border-0 pt-4 px-4">
							<div class="d-flex justify-content-between align-items-center">
								<div class="d-flex align-items-center gap-2">
									<button type="button" class="btn btn-res-primary px-3 py-2"
											onclick="location.href='${path}/restaurantInsert.ad?areaCode=${areaCode}&pageNum=${paging.pageNum}'">
										<i class="fas fa-plus-circle me-1"></i> 등록하기
									</button>
	
									<select id="statusFilter" class="form-select shadow-none"
							        	onchange="handleFilterChange(this.value)" style="width: 140px;">
									    <option value="" ${areaCode == '' ? 'selected' : ''}>전체 지역</option>
									    <option value="1" ${areaCode == '1' ? 'selected' : ''}>서울</option>
									    <option value="2" ${areaCode == '2' ? 'selected' : ''}>인천</option>
									    <option value="31" ${areaCode == '31' ? 'selected' : ''}>경기</option>
									    <option value="32" ${areaCode == '32' ? 'selected' : ''}>강원</option>
									    <option value="3" ${areaCode == '3' ? 'selected' : ''}>대전</option>
									    <option value="4" ${areaCode == '4' ? 'selected' : ''}>대구</option>
									    <option value="5" ${areaCode == '5' ? 'selected' : ''}>광주</option>
									    <option value="6" ${areaCode == '6' ? 'selected' : ''}>부산</option>
									</select>
									</div>
								
								<form action="${path}/restaurantArea.ad" method="get" class="input-group" style="width:250px;">
									<input type="text" name="keyword"
										class="form-control" placeholder="맛집 이름"
										style="border-radius: 8px 0 0 8px;" value="${param.keyword}">
									<button type="submit" class="btn text-white" style="border-radius: 0 8px 8px 0;">
										<i class="bi bi-bar-chart"></i>
									</button>
								</form>
							</div>
						</div>
						
						<div class="card-body p-0">
							<table class="table table-hover align-middle m-0">
								<thead class="table-light">
									<tr class="text-center">
										<th style="width: 130px;">장소 번호</th>
										<th>장소 유형</th>
										<th>이름</th>
										<th>주소</th>
										<th>조회수</th>
										<th>이미지</th>
										<th>등록일</th>
										<th>수정</th>
										<th>삭제</th>
									</tr>
								</thead>
								<tbody id="restaurant_list_body">
									<c:forEach var="dto" items="${list}">
										<tr class="text-center">
											<td class="text-muted">${dto.place_id}</td>
											<td>
											    <c:choose>
											        <c:when test="${dto.category == 'A05020100'}"><span class="badge bg-success">한식</span></c:when>
											        <c:when test="${dto.category == 'A05020400'}"><span class="badge bg-warning text-dark">중식</span></c:when>
											        <c:when test="${dto.category == 'A05020300'}"><span class="badge bg-danger">일식</span></c:when>
											        <c:when test="${dto.category == 'A05020200'}"><span class="badge bg-info text-dark">양식</span></c:when>
											        <c:when test="${dto.category == 'A05020600'}"><span class="badge bg-secondary">카페</span></c:when>
											        <c:otherwise><span class="badge bg-light text-dark">맛집</span></c:otherwise>
											    </c:choose>
											</td>
											<td class="fw-bold">${dto.name}</td>
											<td class="text-start text-truncate" style="max-width:250px;">${dto.address}</td>
											<td>${dto.view_count}</td>
											<td><img src="${dto.image_url}" style="width:100px; height:60px; object-fit:cover; border-radius:4px;"></td>
											<td>${dto.placeRegDate}</td>
											<td>
												<button class="btn btn-sm btn-outline-secondary me-1" onclick="location.href='${path}/restaurantModify.ad?place_id=${dto.place_id}&pageNum=${paging.pageNum}&areaCode=${areaCode}'">수정</button>
											</td>
											<td>
												<button class="btn btn-sm btn-outline-danger" onclick="if(confirm('삭제하시겠습니까?')) { location.href='${path}/restaurantDeleteAction.ad?place_id=${dto.place_id}&pageNum=${paging.pageNum}&areaCode=${areaCode}';}">삭제</button>
											</td>
										</tr>
									</c:forEach>
		
									<c:if test="${empty list}">
										<tr>
											<td colspan="9">조회된 맛집 정보가 없습니다.</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>
						<!-- 페이징 -->
						<div class="card-footer py-3">
							<%@ include file="/WEB-INF/views/common/pagination.jsp"%>
						</div>
					</div>
				</div>
			</section>
		</div>
		<footer class="main-footer">
			<strong>Copyright &copy; 2026</strong>
		</footer>
	</div>
</body>
</html>