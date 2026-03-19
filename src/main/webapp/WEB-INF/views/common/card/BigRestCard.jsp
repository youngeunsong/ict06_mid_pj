<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 랭킹 페이지 전용 카드 (RestaurantDTO 기준) --%>

<c:set var="placeId" value="${rest.placeDTO.place_id}" />

<div class="${empty cardWrapClass ? 'col-12' : cardWrapClass}">
    <div class="place-card-wrap position-relative big-rest-card-wrap">

        <a href="${path}/restaurantDetail.rs?place_id=${placeId}"
           class="place-card big-rest-card text-decoration-none text-dark d-block">

            <div class="place-card__thumb-wrap position-relative">
                <img src="${rest.placeDTO.image_url}"
                     alt="${rest.placeDTO.name}"
                     loading="lazy"
                     class="thumb-img"
                     onerror="this.src='${path}/resources/images/common/no-image.png';" />

                <c:if test="${not empty rank}">
                    <span class="rank-badge ${rankCls}">${rank}위</span>
                </c:if>
            </div>

            <div class="place-card__body">
                <div class="place-card__title">${rest.placeDTO.name}</div>

                <c:if test="${not empty rest.category}">
                    <div class="big-rest-card__category">
                        ${rest.category}
                    </div>
                </c:if>

                <div class="place-card__address">
                    <i class="bi bi-geo-alt-fill text-danger"></i>
                    ${rest.placeDTO.address}
                </div>

                <c:if test="${not empty rest.description}">
                    <div class="big-rest-card__desc">
                        ${rest.description}
                    </div>
                </c:if>

                <div class="place-card__meta">
                    <span>
                        <i class="fa-regular fa-eye"></i>
                        <c:out value="${rest.placeDTO.view_count}" default="0"/>
                    </span>
                    <span>
                        <i class="fa-regular fa-heart"></i>
                        <c:out value="${rest.placeDTO.avg_rating}" default="0"/>
                    </span>
                    <span>
                        <i class="fa-regular fa-comment"></i>
                        <c:out value="${rest.placeDTO.review_count}" default="0"/>
                    </span>
                </div>

                <c:if test="${not empty rest.phone}">
                    <div class="big-rest-card__phone">
                        <i class="fa-solid fa-phone"></i>
                        ${rest.phone}
                    </div>
                </c:if>

                <c:if test="${not empty rest.status}">
                    <div class="big-rest-card__status">
                        ${rest.status}
                    </div>
                </c:if>
            </div>
        </a>
    </div>
</div>