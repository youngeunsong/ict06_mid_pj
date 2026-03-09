<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->


<!--  카드 목록 -->
<div class="row g-3 mt-3">
    <c:if test="${empty list}">
        <div class="col-12 text-center text-muted py-5">검색 결과가 없습니다.</div>
    </c:if>

    <c:forEach var="dto" items="${list}">
        <div class="col-6 col-md-4 col-lg-3">
            <a href="#" style="text-decoration:none; color:inherit;">
                <div class="card border-0 shadow-sm h-100">
                    <img src="${dto.image_url}"
                         class="card-img-top"
                         style="aspect-ratio:16/9; object-fit:cover;"
                         onerror="this.src='https://via.placeholder.com/300x169'">

                    <div class="card-body">
                        <div class="fw-semibold">${dto.name}</div>
                        <div class="text-muted small mb-2">${dto.address}</div>
                        <div class="d-flex gap-3 text-muted small">
                            <span><i class="fa-regular fa-eye"></i> ${dto.view_count}</span>
                            <span><i class="fa-regular fa-comment"></i> ${dto.review_count}</span>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    </c:forEach>
</div>

<!-- ✅ 페이징 -->
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

        <!-- 이전 -->
        <button class="btn btn-sm btn-outline-secondary"
                onclick="goPage(${currentPage - 1})"
                <c:if test="${currentPage == 1}">disabled</c:if>>
            &lsaquo;
        </button>

        <!-- 번호 -->
        <c:forEach var="i" begin="${groupStart}" end="${groupEnd}">
            <button class="btn btn-sm ${i == currentPage ? 'btn-success' : 'btn-outline-secondary'}"
                    onclick="goPage(${i})">
                ${i}
            </button>
        </c:forEach>

        <!-- 다음 -->
        <button class="btn btn-sm btn-outline-secondary"
                onclick="goPage(${currentPage + 1})"
                <c:if test="${currentPage == totalPages}">disabled</c:if>>
            &rsaquo;
        </button>
    </div>
</c:if>