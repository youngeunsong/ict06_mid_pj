<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-08
 * 최종수정일: 2026-03-10
 
  AJAX 화면: 정렬/페이지 포함 상세 검색 결과
 - type = REST / ACC / FEST
 - ALL 은 초기 화면(viewAllPage) 복귀 전제
 
 검색바 > 검색 페이지 > 상단 탭(전체 숙소 맛집 축제) 클릭 화면
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<c:choose>

    <c:when test="${type eq 'REST'}">
        <c:if test="${empty restList}">
            <div class="row g-3 mt-3">
                <div class="col-12 text-center text-muted py-5">검색 결과가 없습니다.</div>
            </div>
        </c:if>

        <c:if test="${not empty restList}">
            <div class="row g-3 mt-3">
                <c:forEach var="restDTO" items="${restList}">
                    <div class="col-6 col-md-4 col-lg-3 searchRestCard">
                        <c:set var="rest" value="${restDTO}" />
                        <c:set var="mode" value="search" />
                        <c:set var="cardWrapClass" value="search-card-wrap" />
                        <%@ include file="/WEB-INF/views/common/card/restCard.jsp" %>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </c:when>

    <c:when test="${type eq 'ACC'}">
        <c:if test="${empty accList}">
            <div class="row g-3 mt-3">
                <div class="col-12 text-center text-muted py-5">검색 결과가 없습니다.</div>
            </div>
        </c:if>

        <c:if test="${not empty accList}">
            <div class="row g-3 mt-3">
                <c:forEach var="accDTO" items="${accList}">
                    <div class="col-6 col-md-4 col-lg-3 searchAccCard">
                        <c:set var="acc" value="${accDTO}" />
                        <c:set var="mode" value="search" />
                        <c:set var="cardWrapClass" value="search-card-wrap" />
                        <%@ include file="/WEB-INF/views/common/card/accCard.jsp" %>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </c:when>

    <c:when test="${type eq 'FEST'}">
        <c:if test="${empty festList}">
            <div class="row g-3 mt-3">
                <div class="col-12 text-center text-muted py-5">검색 결과가 없습니다.</div>
            </div>
        </c:if>

        <c:if test="${not empty festList}">
            <div class="row g-3 mt-3">
                <c:forEach var="festDTO" items="${festList}">
                    <div class="col-6 col-md-4 col-lg-3 searchFestCard">
                        <c:set var="fest" value="${festDTO}" />
                        <c:set var="mode" value="search" />
                        <c:set var="cardWrapClass" value="search-card-wrap" />
                        <%@ include file="/WEB-INF/views/common/card/festivalCard.jsp" %>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </c:when>

    <c:otherwise>
        <div class="row g-3 mt-3">
            <div class="col-12 text-center text-muted py-5">검색 결과가 없습니다.</div>
        </div>
    </c:otherwise>

</c:choose>

<c:if test="${totalPages > 1}">
    <div class="d-flex justify-content-center gap-2 mt-4 mb-5">
        <c:set var="groupStart" value="${((currentPage - 1) div 10) * 10 + 1}" />
        <c:set var="tempEnd" value="${groupStart + 9}" />

        <c:choose>
            <c:when test="${tempEnd > totalPages}">
                <c:set var="groupEnd" value="${totalPages}" />
            </c:when>
            <c:otherwise>
                <c:set var="groupEnd" value="${tempEnd}" />
            </c:otherwise>
        </c:choose>

        <button class="btn btn-sm btn-outline-secondary"
                onclick="goPage(${currentPage - 1})"
                <c:if test="${currentPage == 1}">disabled</c:if>>
            &lsaquo;
        </button>

        <c:forEach var="i" begin="${groupStart}" end="${groupEnd}">
            <button class="btn btn-sm ${i == currentPage ? 'btn-success' : 'btn-outline-secondary'}"
                    onclick="goPage(${i})">
                ${i}
            </button>
        </c:forEach>

        <button class="btn btn-sm btn-outline-secondary"
                onclick="goPage(${currentPage + 1})"
                <c:if test="${currentPage == totalPages}">disabled</c:if>>
            &rsaquo;
        </button>
    </div>
</c:if>
