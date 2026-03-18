<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- ==============================================
[공통 카드 구조]
축제 전용 카드
- mode = bestMain  / BEST 추천 빅카드용
- mode = best      / BEST 추천 우측 카드용
- mode = festival  / 메인 이달의 추천 축제
- mode = search    / 검색 화면 카드용
=============================================== -->

<div class="${cardWrapClass}">
    <div class="place-card-wrap position-relative">

		<button type="button"
		        class="bookmark-btn"
		        data-place-id="${fest.placeDTO.place_id}">
		    <i class="${not empty favoritePlaceIds and favoritePlaceIds.contains(fest.placeDTO.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
		</button>

        <a href="${path}/festivalDetail.fe?place_id=${fest.placeDTO.place_id}"
           class="place-card text-decoration-none text-dark d-block">

            <div class="place-card__thumb-wrap position-relative">
                <img src="${fest.placeDTO.image_url}"
                     alt="${fest.placeDTO.name}"
                     loading="lazy"
                     class="thumb-img"
                     onerror="this.src='${path}/resources/images/common/no-image.png';" />

				 <c:if test="${mode eq 'bestMain'}">
				    <span class="rank-badge top1">
				        1위 평균 <c:out value="${fest.placeDTO.avg_rating}" default="0"/>점
				    </span>
				</c:if>

                <span class="status-badge">
                    ${fest.status}
                </span>
            </div>

            <div class="place-card__body">
                <div class="place-card__title">${fest.placeDTO.name}</div>

                <div class="place-card__address">
                    <i class="bi bi-geo-alt-fill text-danger"></i>
                    ${fest.placeDTO.address}
                </div>

                <div class="place-card__meta">
                    <span>
                        <i class="bi bi-calendar-event"></i>
                        <fmt:formatDate value="${fest.start_date}" pattern="M.dd"/>
                        ~
                        <fmt:formatDate value="${fest.end_date}" pattern="M.dd"/>
                    </span>
                </div>
            </div>
        </a>
    </div>
</div>
