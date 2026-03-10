<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!-- ==============================================

[사용 시 참고 사항]
축제 전용 사용
=============================================== -->


<div class="${mode eq 'top10' ? 'top10-card-wrap' : ''}">
    <a href="${path}/festival.fe" class="place-card text-decoration-none text-dark">
        <div class="place-card__thumb-wrap position-relative">
            <img src="${fest.placeDTO.image_url}" alt="${fest.placeDTO.name}" loading="lazy" class="thumb-img" />

            <c:if test="${mode eq 'top10'}">
                <span class="rank-badge ${rankCls}">${rank}위</span>
            </c:if>

            <button type="button"
                    class="bookmark-btn"
                    data-place-id="${fest.placeDTO.place_id}"
                    onclick="toggleBookmark(event, this)">
                <i class="${favoritePlaceIds.contains(fest.placeDTO.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
            </button>
        </div>

        <div class="place-card__body">
            <div class="place-card__title">${fest.placeDTO.name}</div>

            <div class="place-card__address">
                <i class="bi bi-geo-alt-fill text-danger"></i>
                ${fest.placeDTO.address}
            </div>

            <div class="d-flex flex-column gap-1 text-muted small mt-2">
                <span><i class="bi bi-calendar-event"></i> ${fest.start_date} ~ ${fest.end_date}</span>
                <span><i class="bi bi-flag"></i> ${fest.status}</span>
            </div>
        </div>
    </a>
</div>