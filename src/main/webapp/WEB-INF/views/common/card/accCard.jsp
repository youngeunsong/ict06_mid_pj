<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!-- ==============================================
[공통 카드 구조]
숙소 전용 카드
- mode = top10
=============================================== -->

<div class="
    ${mode eq 'top10' ? 'top10-card-wrap' : ''}
    ${mode eq 'best' ? 'best-card-wrap' : ''}
    ${mode eq 'bestMain' ? 'best-main-card-wrap' : ''}
">
    <a href="${path}/accommodationDetail.ac?place_id=${place.placeDTO.place_id}" class="place-card text-decoration-none text-dark">
        
        <div class="place-card__thumb-wrap position-relative">
            <img src="${place.placeDTO.image_url}" 
                 alt="${place.placeDTO.name}" 
                 loading="lazy" 
                 class="thumb-img" />

            <!-- main.js TOP10 슬라이더용 -->
            <c:if test="${mode eq 'top10'}">
                <span class="rank-badge ${rankCls}">${rank}위</span>
            </c:if>
            
            <!-- main.js BEST 추천 빅카드용  -->
			<c:if test="${mode eq 'bestMain'}">
			    <span class="rank-badge top1">
			        1위 평균 <c:out value="${avgRatingMap[place.placeDTO.place_id]}" default="0"/>점
			    </span>
			</c:if>

            <!-- [유지] bookmark.js 대응 -->
            <button type="button"
                    class="bookmark-btn"
                    data-place-id="${place.placeDTO.place_id}"
                    onclick="toggleBookmark(event, this)">
                <i class="${not empty favoritePlaceIds and favoritePlaceIds.contains(place.placeDTO.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
            </button>
        </div>

        <div class="place-card__body">
            <div class="place-card__title">${place.placeDTO.name}</div>

            <div class="place-card__address">
                <i class="bi bi-geo-alt-fill text-danger"></i>
                ${place.placeDTO.address}
            </div>

            <!-- [수정] 공통 meta 구조 -->
            <div class="place-card__meta">
                <span><i class="fa-regular fa-eye"></i> ${place.placeDTO.view_count}</span>
                <span><i class="fa-regular fa-heart"></i> <c:out value="${avgRatingMap[place.placeDTO.place_id]}" default="0"/></span>
                <span><i class="fa-regular fa-comment"></i> <c:out value="${reviewCountMap[place.placeDTO.place_id]}" default="0"/></span>
            </div>

            <div class="place-card__price">
                <fmt:formatNumber value="${place.price}" type="number" />원
            </div>
        </div>
    </a>
</div>