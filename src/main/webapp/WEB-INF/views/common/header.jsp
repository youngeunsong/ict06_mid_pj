<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<header>
	<!-- header 시작 -->
	<!-- 요청 : url, 버튼, 링크 연결 -->
	<nav class="navbar navbar-expand-lg bg-white border-bottom">
	  <div class="container-fluid px-4">
	
	    <!-- 로고 -->
	    <a class="navbar-brand fw-bold me-3" href="${path}/main.do">
	      맛침내
	    </a>
	
	    <!-- 모바일 토글 -->
	    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#topNav">
	      <span class="navbar-toggler-icon"></span>
	    </button>
	    
		<!-- 웹 헤더바 s -->
	    <div class="collapse navbar-collapse" id="topNav">
	      <!-- 검색바 (중앙) -->
	      <form class="d-flex flex-grow-1 mx-lg-3 my-2 my-lg-0" role="search" action="/search.do" method="get">
	        <div class="input-group">
	          <span class="input-group-text bg-white border-end-0">🔍</span>
	          <input class="form-control border-start-0" type="search" name="keyword"
	                 placeholder="맛집 · 숙소 · 축제 검색" aria-label="Search">
	        </div>
	      </form>
	
	      <!-- 메뉴 -->
	      <ul class="navbar-nav me-auto mb-2 mb-lg-0 gap-lg-2">
	        <li class="nav-item"><a class="nav-link fw-semibold" href="${path}/restaurant.rs">맛집</a></li>
	        <li class="nav-item"><a class="nav-link fw-semibold" href="${path}/accommodation.ac">숙소</a></li>
	        <li class="nav-item"><a class="nav-link fw-semibold" href="${path}/festival.fe">축제</a></li>
	        <li class="nav-item"><a class="nav-link fw-semibold" href="${path}/community.co">커뮤니티</a></li>
			
	        <!-- 더보기 드롭다운 -->
	        <li class="nav-item dropdown">
	          <a class="nav-link dropdown-toggle fw-semibold" href="#" role="button" data-bs-toggle="dropdown">
	            고객지원
	          </a>
	          <ul class="dropdown-menu">
	            <li><a class="dropdown-item" href="${path}/FAQ.do">FAQ</a></li>
	            <li><a class="dropdown-item" href="${path}/inquiry.do">1:1 문의</a></li>
	            <%-- <li><a class="dropdown-item" href="${path}/notice.do">공지</a></li> --%> <!-- 커뮤니티 게시판의 공지만 쓰기로 했던 것으로 기억하여 주석처리 -->
	          </ul>
	        </li>
	      </ul>
	
		  <!-- 우측 버튼 -->
	      <div class="d-flex align-items-center gap-2">
	      	<c:choose>
	      		
		  		<c:when test="${empty sessionScope.sessionID}">
			        <a class="btn btn-outline-secondary btn-sm" href="${path}/join.do">회원가입</a>
			        <a class="btn btn-primary btn-sm px-3" href="${path}/login.do">로그인</a>
			    </c:when>
		        
		  		<c:when test="${fn:startsWith(sessionScope.sessionID, 'admin')}">
			        <a class="btn btn-outline-secondary btn-sm" href="${path}/logout.do">로그아웃</a>
			        <a class="btn btn-primary btn-sm px-3" href="${path}/adminHome.ad">관리자Home</a>
			    </c:when>
		        
			    <c:otherwise>
			        <a class="btn btn-outline-secondary btn-sm" href="${path}/logout.do">로그아웃</a>
			        <a class="btn btn-primary btn-sm px-3" href="${path}/myPageHome.do">마이 페이지</a>
			    </c:otherwise>
			</c:choose>
	      </div>
	      <!-- 우측 버튼: 로그아웃/관리자페이지 -->
	    </div>
	    <!-- 웹 헤더바 s -->
	  </div>
	</nav>
</header>
<!-- header 끝 -->

