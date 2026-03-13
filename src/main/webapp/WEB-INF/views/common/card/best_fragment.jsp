<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<c:choose>

    <%-- =====================================================
         전체 탭
         좌측: 하드코딩
         우측: 통합 상위 4개
    ====================================================== --%>
    <c:when test="${bestType eq 'ALL'}">
        <c:if test="${not empty bestAllList}">
            <div class="row g-3">
                <div class="col-12 col-md-4">
                    <div class="best-feature-banner h-100">
                        <div>
                            <div class="quote-icon">"</div>
                            <p class="feature-text">
                                사람들은 언제나 한 곳에<br/>
                                오래있으면 더 멀리, 더<br/>
                                문득 떠나고싶어 지기도 합니다.<br/>
                                그럴 땐 망설이지 마세요.
                            </p>
                        </div>
                        <div>
                            <div class="feature-img-wrap">
                                <img src="https://images.unsplash.com/photo-1531366936337-7c912a4589a7?w=600&q=80" alt="오로라"/>
                            </div>
                            <button class="btn-more mt-3">지금 떠나기 →</button>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-md-8">
                    <div class="row g-3">
                        <c:forEach var="item" items="${bestAllList}" varStatus="st">
						    <c:choose>
						        <c:when test="${item.PLACE_TYPE eq 'REST'}">
						            <c:set var="detailUrl" value="${path}/restaurantDetail.rs?place_id=${item.PLACE_ID}" />
						        </c:when>
						        <c:when test="${item.PLACE_TYPE eq 'ACC'}">
						            <c:set var="detailUrl" value="${path}/accommodationDetail.ac?place_id=${item.PLACE_ID}" />
						        </c:when>
						        <c:otherwise>
						            <c:set var="detailUrl" value="${path}/festivalDetail.fe?place_id=${item.PLACE_ID}" />
						        </c:otherwise>
						    </c:choose>
						
						    <div class="col-6">
						        <a href="${detailUrl}" class="best-sub-card card text-decoration-none text-dark">
						            <div class="img-wrap position-relative">
						                <img src="${item.IMAGE_URL}" alt="${item.NAME}" />
						
						                <span class="best-rank-badge best-rank-${st.index + 1}">
						                    ${st.index + 1}위
						                </span>
						
						                <button type="button"
						                        class="bookmark-btn"
						                        data-place-id="${item.PLACE_ID}"
						                        onclick="toggleBookmark(event, this)">
						                    <i class="${not empty favoritePlaceIds and favoritePlaceIds.contains(item.PLACE_ID) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
						                </button>
						            </div>
						
						            <div class="card-body">
						                <div class="card-region">
						                    <i class="fa-regular fa-heart me-1"></i>평균 ${item.AVG_RATING}점
						                    &nbsp;·&nbsp;
						                    <i class="fa-regular fa-comment me-1"></i>${item.REVIEW_COUNT}개
						                </div>
						                <div class="card-title">${item.NAME}</div>
						            </div>
						        </a>
						    </div>
						</c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${empty bestAllList}">
            <div class="text-center text-muted py-5">최근 1주일 기준 추천 데이터가 없습니다.</div>
        </c:if>
    </c:when>


    <%-- =====================================================
         맛집 탭
         기존 restCard.jsp 재사용
    ====================================================== --%>
    <c:when test="${bestType eq 'REST'}">
        <c:if test="${not empty bestRestList}">
            <div class="row g-3">
                <div class="col-12 col-md-4">
                    <c:set var="place" value="${bestRestList[0]}" />
                    <c:set var="mode" value="bestMain" />
                    <%@ include file="restCard.jsp" %>
                </div>

                <div class="col-12 col-md-8">
                    <div class="row g-3">
                        <c:forEach var="place" items="${bestRestList}" begin="1" end="4">
                            <div class="col-6">
                                <c:set var="mode" value="best" />
                                <%@ include file="restCard.jsp" %>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${empty bestRestList}">
            <div class="text-center text-muted py-5">최근 1주일 기준 추천 맛집이 없습니다.</div>
        </c:if>
    </c:when>


    <%-- =====================================================
         숙소 탭
         기존 accCard.jsp 재사용
    ====================================================== --%>
    <c:when test="${bestType eq 'ACC'}">
        <c:if test="${not empty bestAccList}">
            <div class="row g-3">
                <div class="col-12 col-md-4">
                    <c:set var="place" value="${bestAccList[0]}" />
                    <c:set var="mode" value="bestMain" />
                    <%@ include file="accCard.jsp" %>
                </div>

                <div class="col-12 col-md-8">
                    <div class="row g-3">
                        <c:forEach var="place" items="${bestAccList}" begin="1" end="4">
                            <div class="col-6">
                                <c:set var="mode" value="best" />
                                <%@ include file="accCard.jsp" %>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${empty bestAccList}">
            <div class="text-center text-muted py-5">최근 1주일 기준 추천 숙소가 없습니다.</div>
        </c:if>
    </c:when>


    <%-- =====================================================
         축제 탭
         기존 festivalCard.jsp 재사용
    ====================================================== --%>
    <c:otherwise>
        <c:if test="${not empty bestFestList}">
            <div class="row g-3">
                <div class="col-12 col-md-4">
                    <c:set var="fest" value="${bestFestList[0]}" />
                    <c:set var="mode" value="bestMain" />
                    <%@ include file="festivalCard.jsp" %>
                </div>

                <div class="col-12 col-md-8">
                    <div class="row g-3">
                        <c:forEach var="fest" items="${bestFestList}" begin="1" end="4">
                            <div class="col-6">
                                <c:set var="mode" value="best" />
                                <%@ include file="festivalCard.jsp" %>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${empty bestFestList}">
            <div class="text-center text-muted py-5">최근 1주일 기준 추천 축제가 없습니다.</div>
        </c:if>
    </c:otherwise>

</c:choose>