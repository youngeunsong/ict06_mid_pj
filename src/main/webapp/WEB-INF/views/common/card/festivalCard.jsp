<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!-- ==============================================
[공통 카드 구조]
축제 전용 카드
- mode = festival
=============================================== -->

<div class="
    ${mode eq 'festival' ? 'festival-card-wrap' : ''}
    ${mode eq 'best' ? 'best-card-wrap' : ''}
    ${mode eq 'bestMain' ? 'best-main-card-wrap' : ''}
">
    <a href="${path}/festivalDetail.fe?place_id=${fest.placeDTO.place_id}" class="place-card text-decoration-none text-dark">
        
        <!-- [유지] JS/공통 card.css용 썸네일 영역 -->
        <div class="place-card__thumb-wrap position-relative">
    		<img src="${fest.placeDTO.image_url}" alt="${fest.placeDTO.name}" loading="lazy" class="thumb-img" />
                 
            <!-- main.js BEST 추천 빅카드용  -->
			<c:if test="${mode eq 'bestMain'}">
			    <span class="rank-badge top1">
			        1위 평균 <c:out value="${avgRatingMap[fest.placeDTO.place_id]}" default="0"/>점
			    </span>
			</c:if>
            
            <!-- [유지] bookmark.js 대응 -->
            <button type="button"
                    class="bookmark-btn"
                    data-place-id="${fest.placeDTO.place_id}"
                    onclick="toggleBookmark(event, this)">
                <i class="${favoritePlaceIds.contains(fest.placeDTO.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
            </button>

            <!-- [수정] 상태 뱃지 공통 클래스 사용 -->
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

            <!-- [수정] 공통 meta 구조로 통일 -->
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