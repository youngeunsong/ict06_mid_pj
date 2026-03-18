<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- TOP5 -->
<section class="rk-section">
  <c:choose>
    <c:when test="${currentTab eq 'region'}">
      <h2 class="rk-sectionTitle">📍 지역 TOP 5</h2>
      <div class="rk-sectionSub">
        <c:choose>
          <c:when test="${not empty currentRegion and currentRegion ne 'all'}">
            ${currentRegion} 지역 기준 인기 맛집
          </c:when>
          <c:otherwise>
            전체 지역 기준 인기 맛집
          </c:otherwise>
        </c:choose>
      </div>
    </c:when>

    <c:when test="${currentTab eq 'recommend'}">
      <h2 class="rk-sectionTitle">🧭 추천 TOP 5</h2>
      <div class="rk-sectionSub">지역과 추천 필터 기준으로 보는 인기 맛집</div>
    </c:when>

    <c:otherwise>
      <h2 class="rk-sectionTitle">🔥 실시간 인기 TOP 5</h2>
      <div class="rk-sectionSub">조회수와 반응이 빠르게 상승 중인 맛집</div>
    </c:otherwise>
  </c:choose>

  <div class="rk-topWrap">

    <!-- TOP 1 -->
    <c:forEach var="item" items="${topList}" begin="0" end="0">
      <div class="rk-top1 mb-4">
        <c:set var="rest" value="${item}" scope="request"/>
        <c:set var="mode" value="top10" scope="request"/>
        <c:set var="rank" value="1" scope="request"/>
        <c:set var="rankCls" value="rank-1" scope="request"/>
        <c:set var="cardWrapClass" value="" scope="request"/>

        <jsp:include page="/WEB-INF/views/common/card/restCard.jsp"/>
      </div>
    </c:forEach>

    <!-- TOP 2 ~ 5 -->
    <div class="row g-4">
      <c:forEach var="item" items="${topList}" begin="1" end="4" varStatus="st">
        <div class="col-12 col-md-6 rk-topSub">
          <c:set var="rest" value="${item}" scope="request"/>
          <c:set var="mode" value="top10" scope="request"/>
          <c:set var="rank" value="${st.index + 1}" scope="request"/>
          <c:set var="cardWrapClass" value="" scope="request"/>

          <c:choose>
            <c:when test="${st.index + 1 == 2}">
              <c:set var="rankCls" value="rank-2" scope="request"/>
            </c:when>
            <c:when test="${st.index + 1 == 3}">
              <c:set var="rankCls" value="rank-3" scope="request"/>
            </c:when>
            <c:otherwise>
              <c:set var="rankCls" value="rank-default" scope="request"/>
            </c:otherwise>
          </c:choose>

          <jsp:include page="/WEB-INF/views/common/card/restCard.jsp"/>
        </div>
      </c:forEach>
    </div>

  </div>
</section>

<!-- 더보기 -->
<h2 class="rk-moreTitle">더보기+</h2>

<div class="row g-4 rk-moreGrid" id="moreListWrap">
  <c:forEach var="item" items="${pageList}">
    <div class="col-6 col-md-4 col-lg-3">
      <c:set var="rest" value="${item}" scope="request"/>
      <c:set var="mode" value="default" scope="request"/>
      <c:set var="cardWrapClass" value="" scope="request"/>
      <jsp:include page="/WEB-INF/views/common/card/restCard.jsp"/>
    </div>
  </c:forEach>
</div>

<div class="text-center mt-4 d-flex justify-content-center gap-2">
  <button type="button"
          id="moreBtn"
          class="btn btn-outline-dark px-4 py-2"
          data-offset="${nextOffset}"
          data-initial-offset="${nextOffset}"
          data-limit="${limit}">
    더보기
  </button>

  <button type="button"
          id="collapseBtn"
          class="btn btn-outline-secondary px-4 py-2"
          style="display:none;">
    접기
  </button>
</div>