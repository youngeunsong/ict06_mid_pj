<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!-- ==============================================

[사용 시 참고 사항]
맛집 전용 사용
=============================================== -->

<div class="${mode eq 'top10' ? 'top10-card-wrap' : ''}">
    <a href="${path}/place/detail?id=${place.place_id}" class="place-card text-decoration-none text-dark">
        <div class="place-card__thumb-wrap position-relative">
            <img src="${place.image_url}" alt="${place.name}" loading="lazy" class="thumb-img" />
				
			<!-- MAIN > TOP10 전용 랭킹 표기 -->	
            <c:if test="${mode eq 'top10'}">
                <span class="rank-badge ${rankCls}">${rank}위</span>
            </c:if>

			<!-- 즐겨찾기 -->
            <button type="button"
                    class="bookmark-btn"
                    data-place-id="${place.place_id}"
                    onclick="toggleBookmark(event, this)">
                <i class="${favoritePlaceIds.contains(place.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
            </button>
        </div>

        <div class="place-card__body">
            <div class="place-card__title">${place.name}</div>

            <div class="place-card__address">
                <i class="bi bi-geo-alt-fill text-danger"></i>
                ${place.address}
            </div>

            <div class="d-flex gap-3 text-muted small mt-2">
                <span><i class="fa-regular fa-eye"></i> ${place.view_count}</span>
                <span><i class="fa-regular fa-heart"></i> ${avgRatingMap[place.place_id]}</span>
                <span><i class="fa-regular fa-comment"></i> ${reviewCountMap[place.place_id]}</span>
            </div>
        </div>
    </a>
</div>