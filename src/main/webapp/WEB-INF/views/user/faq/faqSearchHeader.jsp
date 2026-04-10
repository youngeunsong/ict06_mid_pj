<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* [1] 헤더 전체 컨테이너 고정 */
    .sticky-search-wrap {
        position: sticky;
        top: 0; 
        z-index: 1020;
        background-color: rgba(255, 255, 255, 0.98);
        backdrop-filter: blur(8px);
        border-bottom: 1px solid #eee;
        padding: 35px 0 !important; /* 여백을 모든 페이지 동일하게 강제 */
        transition: all 0.3s ease;
	    font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif !important;
        
    }

    /* [2] ⭐ 제목 폰트 완전 통일 (중앙 정렬 및 굵기) */
	.sticky-search-wrap h2#header-title-area {
	    font-weight: 800 !important;
	    color: #2c3e50 !important;
	    letter-spacing: -1.5px !important;
	    margin-bottom: 1.5rem !important;
	    display: flex !important;
	    align-items: center !important;
	    justify-content: center !important;
	    
	    /* 기본 크기 (PC용) */
	    font-size: 2.2rem !important; 
	}
	
	/* 모바일/태블릿 대응 (화면 너비 768px 이하일 때) */
	@media (max-width: 768px) {
	    .sticky-search-wrap h2#header-title-area {
	        font-size: 1.6rem !important; /* 글자 크기를 줄여서 한 줄에 나오게 함 */
	        letter-spacing: -1px !important;
	    }
	    
	    .sticky-search-wrap h2#header-title-area img {
	        width: 35px !important; /* 로고 아이콘 크기도 같이 조절 */
	    }
	
	    .sticky-search-wrap {
	        padding: 20px 0 !important; /* 모바일에서는 위아래 여백도 줄여서 공간 확보 */
	    }
	}

    /* [3] 검색바 디자인 고정 */
    .sticky-search-wrap .input-group {
        max-width: 600px !important;
        margin: 0 auto !important;
        display: flex !important;
        flex-wrap: nowrap !important;
    }
	/* [3-1] 검색창(Input) 디자인 */
    .sticky-search-wrap .input-group #keyword {
        font-size: 1rem !important;
        padding: 12px 20px !important;
        border-radius: 50px 0 0 50px !important;
        border: 2px solid #ddd !important;
        border-right: none !important; /* 버튼과 연결 부위 */
        height: 50px !important;
    }
	/* 검색창 클릭(Focus) 시 효과 */
    .sticky-search-wrap .input-group #keyword:focus {
        border-color: #3CB371 !important;
        box-shadow: 0 0 0 0.2rem rgba(60, 179, 113, 0.2) !important;
        outline: none !important;
    }
	/* [3-2] 검색 버튼 디자인 */
    .sticky-search-wrap .input-group .btn-primary {
	    font-size: 1rem !important;
	    font-weight: 600 !important;
	    background-color: #3CB371 !important;
	    border: 2px solid #3CB371 !important;
	    border-radius: 0 50px 50px 0 !important;
	    padding: 0 30px !important;
	    height: 50px !important;
	    color: #fff !important;
	    white-space: nowrap !important;
		
	    display: flex !important;
	    align-items: center !important;     /* 세로 중앙 정렬 */
	    justify-content: center !important;  /* 가로 중앙 정렬 */
	    gap: 8px !important;                /* 아이콘(돋보기)과 '검색' 글자 사이 간격 */
	}
	
	/* 검색 버튼 마우스 호버 효과 */
	.sticky-search-wrap .input-group .btn-primary:hover {
	    background-color: #2E8B57 !important; /* 조금 더 진한 그린 */
	    border-color: #2E8B57 !important;
	    transform: translateY(-1px); /* 살짝 위로 떠오르는 효과 */
	    box-shadow: 0 4px 8px rgba(0,0,0,0.1) !important;
	}
</style>

<div id="stickySearch" class="sticky-search-wrap shadow-sm">
    <div class="container">
        <div class="text-center">
            <h2 id="header-title-area" class="fw-bold">
			    <a href="${pageContext.request.contextPath}/faqMain.sp" 
			       onclick="return confirmExit();" style="text-decoration: none;">
			        <img src="${pageContext.request.contextPath}/resources/images/user/faq/logo_icon.png" 
			             alt="맛침내 로고" class="me-2" style="width: 45px; height: auto;"> 
			    </a>
			    
			    <a href="${pageContext.request.contextPath}/faqMain.sp" id="dynamic-title" 
			       onclick="return confirmExit();" style="text-decoration: none; color: inherit;">
			        <c:choose>
			            <c:when test="${isMainPage == true}">무엇을 도와드릴까요?</c:when>
			            <c:otherwise>맛침내 고객센터</c:otherwise>
			        </c:choose>
			    </a>
			</h2>

            <div class="input-group">
                <input type="text" id="keyword" class="form-control shadow-none" 
                       placeholder="검색어를 입력하세요 (예: 비밀번호, 결제)" 
                       onkeyup="checkEnter(event)"
                       value="${param.keyword}"> 
                <button class="btn btn-primary" type="button" onclick="searchFaq()">
                    <i class="fa-solid fa-magnifying-glass"></i> 검색
                </button>
            </div>
        </div>
    </div>
</div>