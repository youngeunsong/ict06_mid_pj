<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ==============================================
[공통 카드 구조]
맛집 전용 카드
- mode = top10     / 슬라이더
- mode = bestMain  / BEST 추천 빅카드용
- mode = best      / BEST 추천 우측 카드용
- mode = search    / 검색 화면 카드용
=============================================== -->

<c:set var="placeId" value="${rest.placeDTO.place_id}" />
<c:choose>
    <c:when test="${mode eq 'search'}">
        <c:set var="displayAvgRating" value="${avgRatingMap[placeId]}" />
        <c:set var="displayReviewCount" value="${reviewCountMap[placeId]}" />
    </c:when>
    <c:otherwise>
        <c:set var="displayAvgRating" value="${rest.placeDTO.avg_rating}" />
        <c:set var="displayReviewCount" value="${rest.placeDTO.review_count}" />
    </c:otherwise>
</c:choose>

<div class="${cardWrapClass}">
    <div class="place-card-wrap position-relative">

        <button type="button"
        class="bookmark-btn"
        data-place-id="${rest.placeDTO.place_id}">
		    <i class="${not empty favoritePlaceIds and favoritePlaceIds.contains(rest.placeDTO.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
		</button>

        <a href="${path}/restaurantDetail.rs?place_id=${placeId}"
           class="place-card text-decoration-none text-dark d-block">

            <div class="place-card__thumb-wrap position-relative">
                <img src="${rest.placeDTO.image_url}"
                     alt="${rest.placeDTO.name}"
                     loading="lazy"
                     class="thumb-img"
                     onerror="this.src='${path}/resources/images/common/no-image.png';" />

                <c:if test="${mode eq 'top10'}">
                    <span class="rank-badge ${rankCls}">${rank}위</span>
                </c:if>

	             <c:if test="${mode eq 'bestMain'}">
				    <span class="rank-badge top1">
				        1위 평균 <c:out value="${rest.placeDTO.avg_rating}" default="0"/>점
				    </span>
				</c:if>
            </div>

            <div class="place-card__body">
                <div class="place-card__title">${rest.placeDTO.name}</div>

                <div class="place-card__address">
                    <i class="bi bi-geo-alt-fill text-danger"></i>
                    ${rest.placeDTO.address}
                </div>

                <div class="place-card__meta">
                    <span>
                        <i class="fa-regular fa-eye"></i>
                        ${rest.placeDTO.view_count}
                    </span>
                    <span>
                        <i class="fa-regular fa-heart"></i>
                        <c:out value="${displayAvgRating}" default="0"/>
                    </span>
                    <span>
                        <i class="fa-regular fa-comment"></i>
                        <c:out value="${displayReviewCount}" default="0"/>
                    </span>
                </div>
            </div>
        </a>
    </div>
</div>
