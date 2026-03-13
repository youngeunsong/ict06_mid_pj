<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<div class="row g-3 mt-3">
    <c:if test="${empty list}">
        <div class="col-12 text-center text-muted py-5">검색 결과가 없습니다.</div>
    </c:if>

    <c:forEach var="dto" items="${list}">
        <div class="col-6 col-md-4 col-lg-3">
            <div class="search-card-wrap">
            	<!-- place_type에 맞춰 카드 클릭 시 url 변경하기 -->
                <c:choose>
				    <c:when test="${dto.place_type eq 'REST'}">
				        <c:set var="detailUrl" value="${path}/restaurantDetail.rs?place_id=${dto.place_id}" />
				    </c:when>
				    <c:when test="${dto.place_type eq 'ACC'}">
				        <c:set var="detailUrl" value="${path}/accommodationDetail.ac?place_id=${dto.place_id}" />
				    </c:when>
				    <c:when test="${dto.place_type eq 'FEST'}">
				        <c:set var="detailUrl" value="${path}/festivalDetail.fe?place_id=${dto.place_id}" />
				    </c:when>
				    <c:otherwise>
				        <c:set var="detailUrl" value="${path}/place/detail?id=${dto.place_id}" />
				    </c:otherwise>
				</c:choose>
				
				<a href="${detailUrl}" class="place-card text-decoration-none text-dark">

                    <div class="place-card__thumb-wrap position-relative">
                        <img src="${dto.image_url}"
                             class="thumb-img"
                             alt="${dto.name}">

                        <button type="button"
                                class="bookmark-btn"
                                data-place-id="${dto.place_id}"
                                onclick="toggleBookmark(event, this)">
                            <i class="${favoritePlaceIds.contains(dto.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
                        </button>
                    </div>

                    <div class="place-card__body">
                        <div class="place-card__title">${dto.name}</div>

                        <div class="place-card__address">
                            <i class="bi bi-geo-alt-fill text-danger"></i>
                            ${dto.address}
                        </div>

                        <div class="place-card__meta">
                            <span><i class="fa-regular fa-eye"></i> ${dto.view_count}</span>
                            <span><i class="fa-regular fa-heart"></i> <c:out value="${avgRatingMap[dto.place_id]}" default="0"/></span>
                            <span><i class="fa-regular fa-comment"></i> <c:out value="${reviewCountMap[dto.place_id]}" default="0"/></span>
                        </div>
                    </div>

                </a>
            </div>
        </div>
    </c:forEach>
</div>

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