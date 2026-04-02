<!-- 
 * @author 송혜진
 * 최초작성일: 2026-02-26
 * 최종수정일: 2026-03-23
 
 참고) 
 Google tag는 관리자> 메인대시보드에서 유저가 이용하는 값들을 파악하고 집계하기 위해 유저 HEADER에 넣었음
 
-->



<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="${path}/resources/js/common/header.js" defer></script>
<header class="site-header position-sticky top-0">


	<!-- header 시작 -->
	<!-- 요청 : url, 버튼, 링크 연결 -->
	<nav class="navbar navbar-expand-lg bg-white border-bottom">
	  <div class="container px-lg-0">
	
	    <!-- 로고 -->
		<a class="navbar-brand brand-logo me-3" href="${path}/main.do">
		   <img src="${path}/resources/images/common/myLocation.png" alt="맛침내 심볼" class="brand-symbol">
		   <img src="${path}/resources/images/common/matchimnae.png" alt="맛침내" class="brand-text-image">
		</a>
	
	    <!-- 모바일 토글 -->
	    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#topNav">
	      <span class="navbar-toggler-icon"></span>
	    </button>
	    
		<!-- 웹 헤더바 s -->
	    <div class="collapse navbar-collapse" id="topNav">
	      

	
	      <!-- 메뉴: 중앙 검색폼이 있을 땐 우측으로 밀고, 메인에서는 브라우저 화면 정중앙(gnb-nav-main)에 고정 -->
	      <ul class="navbar-nav gnb-nav-center mb-2 mb-lg-0 gap-lg-3">
	        <li class="nav-item"><a class="nav-link fw-bold gnb-main-link" href="${path}/restaurant.rs">맛집</a></li>
	        <li class="nav-item"><a class="nav-link fw-bold gnb-main-link" href="${path}/accommodation.ac">숙소</a></li>
	        <li class="nav-item"><a class="nav-link fw-bold gnb-main-link" href="${path}/festival.fe">축제</a></li>
	        <li class="nav-item"><a class="nav-link fw-bold gnb-main-link" href="${path}/community_free.co">커뮤니티</a></li>
			<li class="nav-item"><a class="nav-link fw-bold gnb-main-link" href="${path}/faqMain.sp">고객지원</a></li>
	      </ul>
	        
		  <!-- 우측 버튼 (ms-auto 속성 부여로 남는 공간을 밀어내어 자연스러운 우측 끝 고정) -->
	      <div class="d-flex align-items-center gap-2 ms-auto">
	        
            <!-- 헤더 검색 토글 스위치 (메인 화면 로딩 직후에는 일단 가상 숨김 처리) -->
            <button id="headerSearchToggleBtn" class="btn btn-link text-success p-0 me-3 fs-5 ${not empty isMain ? 'd-none' : ''}">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>
			
	      	<c:choose>
	      		
		  		<c:when test="${empty sessionScope.sessionID}">
			        <a class="header-user-link" href="${path}/join.do">회원가입</a>
			        <a class="header-user-link" href="${path}/login.do">로그인</a>
			    </c:when>
		        
		  		<c:when test="${fn:startsWith(sessionScope.sessionID, 'admin')}">
			        <a class="header-user-link" href="${path}/logout.do">로그아웃</a>
			        <a class="header-user-link" href="${path}/adminHome.ad">관리자Home</a>
			    </c:when>
		        
			    <c:otherwise>
			        <a class="header-user-link" href="${path}/logout.do">로그아웃</a>
			        <a class="header-user-link" href="${path}/myPageHome.do">마이 페이지</a>
			    </c:otherwise>
			</c:choose>
	      </div>
	      <!-- 우측 버튼: 로그아웃/관리자페이지 -->
	    </div>
	    <!-- 웹 헤더바 s -->
	  </div>
	</nav>
	
	<!-- 헤더 전용 글로벌 검색 드롭다운 패널 (공통) -->
	<div id="headerSearchPanel" class="header-search-panel position-absolute w-100 bg-white shadow-sm" style="top: 100%; z-index: 1050; border-top: 1px solid #eee;">
	    <div class="container py-3">
	        <form class="search-module mx-auto position-relative" style="max-width: 650px;" action="${path}/search.do" method="get">
	            <div class="input-group input-group-lg shadow-sm rounded-pill overflow-hidden border">
	                <span class="input-group-text bg-white border-0 ps-4"></span>
	                <input class="form-control border-0 bg-white search-keyword-input" type="search" name="keyword" autocomplete="off" placeholder="어떤 여행을 기대하시나요?" style="padding: 1rem;">
	                <button class="btn btn-success fw-bold px-4" type="submit">검색</button> 
	            </div>
	            
	            <!-- 공통 제안 박스 (서브모듈 래핑 구조) -->
	            <div class="search-suggest-box d-none position-absolute w-100 mt-2 bg-white rounded-3 shadow" style="top: 100%; z-index: 1060; border: 1px solid #ddd;">
					<div class="suggest-section search-recent-area d-none p-3 pb-0">
						<div class="suggest-title fs-6 fw-bold text-muted mb-2">최근 검색어</div>
						<ul class="suggest-list search-recent-list list-unstyled mb-0"></ul>
					</div>
					<div class="suggest-section search-auto-area d-none p-3 pb-0">
						<div class="suggest-title fs-6 fw-bold text-muted mb-2">추천 검색어</div>
						<ul class="suggest-list search-auto-list list-unstyled mb-0"></ul>
					</div>
	            </div>
	        </form>
	    </div>
	</div>
</header>
<!-- header 끝 -->

<%@ include file="/WEB-INF/views/user/mypage/surveyModal.jsp" %>