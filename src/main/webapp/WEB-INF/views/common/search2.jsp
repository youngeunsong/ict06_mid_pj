<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 반응형 웹 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>검색바 화면 페이지</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/common/search.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script> <!-- 아이콘 -->

<script src="${path}/resources/js/search/search.js" defer></script>

</head>
<body>
	<div class="wrap">
		<!-- header 시작 -->
		<%@ include file="header.jsp" %>
		<!-- header 끝 -->
		
		<!-- 컨텐츠 시작 -->
		<div class="container py-4" style="max-width:1000px;">
		
			<!-- 전체용  -->
			<section id="viewFilterPage" class="d-none">
			
		    <!-- 검색 결과 타이틀 -->
		    <div class="d-flex align-items-center gap-2 mb-3">
		        <h4 id="resultTitle" class="mb-0 fw-semibold"></h4>
		
		        <div class="dropdown">
		            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" id="sortLabel" data-bs-toggle="dropdown">
		                인기순
		            </button>
		
		            <ul class="dropdown-menu">
		                <li><button class="dropdown-item" onclick="changeSort('popular')">인기순</button></li>
		                <li><button class="dropdown-item" onclick="changeSort('latest')">최신순</button></li>
		            </ul>
		        </div>
		    </div>
		
		    <!-- 카테고리 필터 -->
		    <div class="chip-tabs d-flex flex-wrap gap-2 justify-content-center mb-3">
		        <button class="btn btn-outline-success active" odata-type="ALL">전체</button>
		        <button class="btn btn-outline-success" data-type="REST">맛집</button>
		        <button class="btn btn-outline-success" data-type="ACC">숙소</button>
		        <button class="btn btn-outline-success" data-type="FEST">축제</button>
		    </div>
		    
		    <hr>
		    
		    <!-- 카드 결과 영역 : AJAX 결과 영역 -->
		    <div id="searchResultArea" class="row g-3 mt-3">
		    	<div class="col-12 text-center py-5">
		            <div class="spinner-border text-success" role="status"></div>
		        </div>
		    </div>
		    
	        <!-- 페이징 -->
		    <div id="pagination"
		         class="d-flex justify-content-center gap-2 mt-4 mb-5">
		    </div>
		
		    <!-- keyword hidden -->
		    <input type="hidden" id="searchKeyword" value="${keyword}">
		    
		    </section>
		</div>
		<!-- 컨텐츠 끝 -->
			
		    

		<!-- footer 시작 -->
		<%@ include file="footer.jsp" %>
		<!-- footer 끝 -->
	</div>
</body>
</html>