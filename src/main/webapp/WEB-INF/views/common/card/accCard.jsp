<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-03
 * 최종수정일: 2026-03-10
 * 참고 코드: restCard.jsp
 카드 내 가격 추가
 
[공통 카드 구조]
숙소 전용 카드
- mode = top10     / 슬라이더
- mode = bestMain  / BEST 추천 빅카드용
- mode = best      / BEST 추천 우측 카드용
- mode = search    / 검색 화면 카드용

-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="placeId" value="${acc.placeDTO.place_id}" />
<c:choose>
    <c:when test="${mode eq 'search'}">
        <c:set var="displayAvgRating" value="${avgRatingMap[placeId]}" />
        <c:set var="displayReviewCount" value="${reviewCountMap[placeId]}" />
    </c:when>
    <c:otherwise>
        <c:set var="displayAvgRating" value="${acc.placeDTO.avg_rating}" />
        <c:set var="displayReviewCount" value="${acc.placeDTO.review_count}" />
    </c:otherwise>
</c:choose>

<div class="${cardWrapClass}">
    <div class="place-card-wrap position-relative">
    
		<!-- 북마크 -->
		<button type="button"
		        class="bookmark-btn"
		        data-place-id="${acc.placeDTO.place_id}">
		    <i class="${not empty favoritePlaceIds and favoritePlaceIds.contains(acc.placeDTO.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
		</button>

        <a href="${path}/accommodationDetail.ac?place_id=${placeId}"
           class="place-card text-decoration-none text-dark d-block">

            <div class="place-card__thumb-wrap position-relative">
                <img src="${acc.placeDTO.image_url}"
                     alt="${acc.placeDTO.name}"
                     loading="lazy"
                     class="thumb-img"
                     onerror="this.src='${path}/resources/images/common/no-image.png';" />

                <c:if test="${mode eq 'top10'}">
                    <span class="rank-badge ${rankCls}">${rank}위</span>
                </c:if>

                <c:if test="${mode eq 'bestMain'}">
				    <span class="rank-badge top1">
				        1위 평균 <c:out value="${acc.placeDTO.avg_rating}" default="0"/>점
				    </span>
				</c:if>
            </div>

            <div class="place-card__body">
                <div class="place-card__title">${acc.placeDTO.name}</div>

                <div class="place-card__address">
                    <i class="bi bi-geo-alt-fill text-danger"></i>
                    ${acc.placeDTO.address}
                </div>

                <div class="place-card__meta">
                    <span>
                        <i class="fa-regular fa-eye"></i>
                        ${acc.placeDTO.view_count}
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
                
                <div class="place-card__price">
			        <fmt:formatNumber value="${acc.price}" type="number" />원
			    </div>
            </div>
        </a>
    </div>
</div>
