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
    }

    /* [2] ⭐ 제목 폰트 완전 통일 (가장 중요) */
    .sticky-search-wrap h2#header-title-area {
        font-size: 2.2rem !important;      /* 크기 고정 */
        font-weight: 800 !important;      /* 굵기 고정 */
        color: #2c3e50 !important;        /* 색상 고정 */
        letter-spacing: -1.5px !important; /* 자간 고정 */
        margin-bottom: 1.5rem !important; /* 아래 여백 고정 */
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
    }

    /* [3] 검색바 디자인 고정 */
    .sticky-search-wrap .input-group {
        max-width: 600px !important;
        margin: 0 auto !important;
        display: flex !important;
        flex-wrap: nowrap !important;
    }

    .sticky-search-wrap .input-group #keyword {
        font-size: 1rem !important;
        padding: 12px 20px !important;
        border-radius: 50px 0 0 50px !important;
        border: 2px solid #ddd !important;
        border-right: none !important; /* 버튼과 연결 부위 */
        height: 50px !important;
    }

    .sticky-search-wrap .input-group #keyword:focus {
        border-color: #3CB371 !important;
        box-shadow: 0 0 0 0.2rem rgba(60, 179, 113, 0.2) !important;
        outline: none !important;
    }

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
    }
</style>

<div id="stickySearch" class="sticky-search-wrap shadow-sm">
    <div class="container">
        <div class="text-center">
            <h2 id="header-title-area" class="fw-bold">
                <img src="${pageContext.request.contextPath}/resources/images/user/faq/logo_icon.png" 
                     alt="맛침내 로고" 
                     class="me-2" 
                     style="width: 45px; height: auto;"> 
                
                <span id="dynamic-title">
                    <c:choose>
                        <c:when test="${isMainPage == true}">
                            무엇을 도와드릴까요?
                        </c:when>
                        <c:otherwise>
                            맛침내 고객센터
                        </c:otherwise>
                    </c:choose>
                </span>
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