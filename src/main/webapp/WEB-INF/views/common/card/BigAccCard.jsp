<!-- 
 * @author 송영은
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: bigRestCard.jsp
 랭킹에 보일 카드 파일   
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="placeId" value="${acc.placeDTO.place_id}" /> <%-- 상세 페이지 이동 링크에 사용할 place_id 추출 --%>

<div class="${empty cardWrapClass ? 'col-12' : cardWrapClass}"> <%-- 외부에서 카드 너비를 제어하지 않으면 기본값 col-12 사용 --%>
    <div class="place-card-wrap position-relative big-rest-card-wrap">

        <a href="${path}/accommodationDetail.ac?place_id=${placeId}"
           class="place-card big-rest-card text-decoration-none text-dark d-block"> <%-- 카드 전체를 상세 페이지 링크로 사용 --%>

            <div class="place-card__thumb-wrap position-relative">
                <img src="${acc.placeDTO.image_url}"
                     alt="${acc.placeDTO.name}"
                     loading="lazy"
                     class="thumb-img"
                     onerror="this.src='${path}/resources/images/common/no-image.png';" /> <%-- 이미지가 없거나 깨질 경우 기본 이미지로 대체 --%>

                <c:if test="${not empty rank}">
                    <span class="rank-badge ${rankCls}">${rank}위</span> <%-- rank 값이 있을 때만 순위 배지 표시 --%>
                </c:if>
            </div>

            <div class="place-card__body">
                <div class="place-card__title">${acc.placeDTO.name}</div> <%-- 맛집 이름 출력 --%>

                <div class="place-card__address">
                    <i class="bi bi-geo-alt-fill text-danger"></i>
                    ${acc.placeDTO.address}
                </div> <%-- 주소는 기본 정보라 항상 출력 --%>

                <c:if test="${not empty acc.description}">
                    <div class="big-rest-card__desc">
                        ${acc.description}
                    </div> <%-- 설명 문구가 있는 경우에만 표시 --%>
                </c:if>

                <div class="place-card__meta">
                    <span>
                        <i class="fa-regular fa-eye"></i>
                        <c:out value="${acc.placeDTO.view_count}" default="0"/> <%-- 조회수가 없으면 0 출력 --%>
                    </span>
                    <span>
                        <i class="fa-regular fa-heart"></i>
                        <c:out value="${acc.placeDTO.avg_rating}" default="0"/> <%-- 평균 평점이 없으면 0 출력 --%>
                    </span>
                    <span>
                        <i class="fa-regular fa-comment"></i>
                        <c:out value="${acc.placeDTO.review_count}" default="0"/> <%-- 리뷰 수가 없으면 0 출력 --%>
                    </span>
                </div>

                <c:if test="${not empty acc.phone}">
                    <div class="big-rest-card__phone">
                        <i class="fa-solid fa-phone"></i>
                        ${acc.phone}
                    </div> <%-- 연락처 정보가 있을 때만 표시 --%>
                </c:if>

                <div class="place-card__price">
			        <fmt:formatNumber value="${acc.price}" type="number" />원
			    </div>
            </div>
        </a>
    </div>
</div>