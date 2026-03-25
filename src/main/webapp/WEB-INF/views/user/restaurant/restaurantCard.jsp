<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<c:set var="path" value="${pageContext.request.contextPath}" scope="request" />
<%-- CSS 파일 연결 --%>
<link rel="stylesheet" href="${path}/resources/css/user/restaurant/restaurantCard.css">
<div class="row"> 
    <c:forEach var="rest" items="${restaurantList}">
        <c:set var="placeId" value="${rest.placeDTO.place_id}" />
        <c:set var="finalCardWrapClass" value="${empty cardWrapClass ? 'col-lg-4 col-md-6 col-sm-12 mb-4' : cardWrapClass}" />

        <div class="${finalCardWrapClass}">
            <div class="place-card-wrap position-relative shadow-sm border rounded bg-white h-100">
                <%-- [북마크 판별 로직] --%>
                <c:set var="isFav" value="false" />
                <c:if test="${not empty favoritePlaceIds}">
                    <c:forEach var="favId" items="${favoritePlaceIds}">
                        <c:if test="${(favId += '') eq (placeId += '')}">
                            <c:set var="isFav" value="true" />
                        </c:if>
                    </c:forEach>
                </c:if>
                <%-- [북마크 버튼] 
                     - background를 메인과 동일한 rgba(255,255,255,0.9)로 설정
                     - 위치 10px 고정 및 클릭 우선순위(z-index) 확보
                --%>
                <button type="button" class="bookmark-btn" data-place-id="${placeId}"
                        style="position:absolute; top:10px; right:10px; z-index:30 !important; 
                               background:rgba(255,255,255,0.9) !important; border:none; border-radius:50%; 
                               width:36px; height:36px; display:flex; align-items:center; justify-content:center; 
                               opacity:1 !important; cursor:pointer; padding:0; box-shadow: 0 2px 6px rgba(0,0,0,0.12);">
                    
                    <%-- 아이콘 색상은 연한 초록(#90ee90) 유지 --%>
                    <i class="${isFav ? 'fa-solid' : 'fa-regular'} fa-bookmark" 
                       style="font-size: 18px; color: ${isFav ? '#90ee90' : '#444'} !important;"></i>
                </button>

                <%-- 카드 클릭 영역 --%>
                <a href="javascript:void(0);" 
                   class="place-card text-decoration-none text-dark d-block" 
                   onclick="showMarkerDetail('${placeId}'); return false;"
                   ondblclick="location.href='${path}/restaurantDetail.rs?place_id=${placeId}';">

                    <div class="place-card__thumb-wrap" style="height:220px; overflow:hidden; border-radius: 8px 8px 0 0;">
                        <img src="${rest.placeDTO.image_url}"
                             alt="${rest.placeDTO.name}"
                             loading="lazy"
                             class="thumb-img"
                             style="width:100%; height:100%; object-fit:cover;"
                             onerror="this.src='${path}/resources/images/common/no-image.png';" />
                    </div>

                    <div class="place-card__body p-3">
                        <div class="place-card__title fw-bold fs-5 mb-2 text-truncate">${rest.placeDTO.name}</div>
                        <div class="place-card__address text-muted small mb-3 text-truncate">
                            <i class="bi bi-geo-alt-fill text-danger"></i> ${rest.placeDTO.address}
                        </div>
                        <div class="place-card__meta d-flex justify-content-between align-items-center border-top pt-2">
                            <div class="d-flex gap-3">
                                <span><i class="fa-regular fa-eye text-primary"></i> ${rest.placeDTO.view_count}</span>
                                <span><i class="fa-regular fa-star text-warning"></i> <c:out value="${rest.placeDTO.avg_rating}" default="0.0"/></span>
                                <span><i class="fa-regular fa-comment"></i> <c:out value="${rest.placeDTO.review_count}" default="0"/></span>
                            </div>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </c:forEach>
</div>
<%-- 페이징 영역 --%>
<div class="row">
    <div class="col-12 mt-4 text-center">
        <%@ include file="/WEB-INF/views/common/restaurant_pagination_ajax.jsp" %>
    </div>
</div>