<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!-- ==============================================

[사용 시 참고 사항]
- 숙소 전용 사용
- 사용 시 꼭 상단에 bookmark.css 선언
- 
=============================================== -->

<div class="${mode eq 'top10' ? 'top10-card-wrap' : ''}">
    <a href="${path}/place/detail?id=${acc.placeDTO.place_id}" class="place-card text-decoration-none text-dark">
        <div class="place-card__thumb-wrap position-relative">
            <img src="${place.placeDTO.image_url}" alt="${place.placeDTO.name}" loading="lazy" class="thumb-img" />

			<!-- MAIN > TOP10 전용 랭킹 표기 -->
            <c:if test="${mode eq 'top10'}">
                <span class="rank-badge ${rankCls}">${rank}위</span>
            </c:if>

			<!-- 즐겨찾기 -->
            <button type="button"
                    class="bookmark-btn"
                    data-place-id="${place.placeDTO.place_id}"
                    onclick="toggleBookmark(event, this)">
                <i class="${not empty favoritePlaceIds and favoritePlaceIds.contains(acc.placeDTO.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
            </button>
        </div>

        <div class="place-card__body">
            <div class="place-card__title">${place.placeDTO.name}</div>

            <div class="place-card__address">
                <i class="bi bi-geo-alt-fill text-danger"></i>
                ${place.placeDTO.address}
            </div>

            <div class="d-flex gap-3 text-muted small mt-2">
                <span><i class="fa-regular fa-eye"></i> ${place.placeDTO.view_count}</span>
                <span><i class="fa-regular fa-heart"></i> <c:out value="${avgRatingMap[place.placeDTO.place_id]}" default="0"/></span>
                <span><i class="fa-regular fa-comment"></i> <c:out value="${reviewCountMap[place.placeDTO.place_id]}" default="0"/></span>
            </div>

            <div class="place-card__price mt-2">
                <fmt:formatNumber value="${place.price}" type="number" />원
            </div>
        </div>
    </a>
</div>