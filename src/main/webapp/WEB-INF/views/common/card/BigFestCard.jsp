<!-- 
 * @author 송영은
 * 최초작성일: 2026-03-20
 * 최종수정일: 2026-03-23
 * 참고 코드: bestRestCard.jsp
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- [랭킹 페이지 공통 카드 컴포넌트]
     TOP5, 더보기 초기 리스트, 더보기 AJAX 카드에서 공통으로 재사용하기 위해 사용
     FestivalDTO 내부의 placeDTO 기준으로 카드 정보를 출력
--%>

<c:set var="placeId" value="${fest.placeDTO.place_id}" /> <%-- 상세 페이지 이동 링크에 사용할 place_id 추출 --%>

<div class="${empty cardWrapClass ? 'col-12' : cardWrapClass}"> <%-- 외부에서 카드 너비를 제어하지 않으면 기본값 col-12 사용 --%>
    <div class="place-card-wrap position-relative big-rest-card-wrap">

        <a href="${path}/festivalDetail.fe?place_id=${placeId}"
           class="place-card big-rest-card text-decoration-none text-dark d-block"> <%-- 카드 전체를 상세 페이지 링크로 사용 --%>

            <div class="place-card__thumb-wrap position-relative">
                <img src="${fest.placeDTO.image_url}"
                     alt="${fest.placeDTO.name}"
                     loading="lazy"
                     class="thumb-img"
                     onerror="this.src='${path}/resources/images/common/no-image.png';" /> <%-- 이미지가 없거나 깨질 경우 기본 이미지로 대체 --%>

                <c:if test="${not empty rank}">
                    <span class="rank-badge ${rankCls}">${rank}위</span> <%-- rank 값이 있을 때만 순위 배지 표시 --%>
                </c:if>
            </div>

            <div class="place-card__body">
                <div class="place-card__title">${fest.placeDTO.name}</div> <%-- 맛집 이름 출력 --%>
				<%-- 주소가 있는 경우에만 표시 --%>
				<c:if test="${not empty fest.placeDTO.address}">
					<div class="place-card__address">
	                    <i class="bi bi-geo-alt-fill text-danger"></i>
	                    ${fest.placeDTO.address}
	                </div> 
				</c:if>

				<%-- 설명 문구가 있는 경우에만 표시 --%>
                <c:if test="${not empty fest.description}">
                    <div class="big-rest-card__desc">
                        ${fest.description}
                    </div> 
                </c:if>

                <div class="place-card__meta">
                    <span>
                        <i class="fa-regular fa-eye"></i>
                        <c:out value="${fest.placeDTO.view_count}" default="0"/> <%-- 조회수가 없으면 0 출력 --%>
                    </span>
                    <span>
                        <i class="fa-regular fa-star"></i>
                        <c:out value="${fest.placeDTO.avg_rating}" default="0"/> <%-- 평균 평점이 없으면 0 출력 --%>
                    </span>
                    <span>
                        <i class="fa-regular fa-comment"></i>
                        <c:out value="${fest.placeDTO.review_count}" default="0"/> <%-- 리뷰 수가 없으면 0 출력 --%>
                    </span>
                </div>

				<!-- start_date 혹은 end_date 있는 경우에만 표시 -->
                <c:if test="${not empty fest.start_date || not empty fest.end_date}">
                    <div class="big-rest-card__phone">
                        <i class="bi bi-calendar-event"></i>
                        <fmt:formatDate value="${fest.start_date}" pattern="M.dd"/>
                        ~
                        <fmt:formatDate value="${fest.end_date}" pattern="M.dd"/>
                    </div> <%-- 연락처 정보가 있을 때만 표시 --%>
                </c:if>

                <c:if test="${not empty fest.status}">
                    <div class="big-rest-card__status">
                        ${fest.status}
                    </div> <%-- 영업 상태 등 추가 상태값이 있을 때만 표시 --%>
                </c:if>
            </div>
        </a>
    </div>
</div>