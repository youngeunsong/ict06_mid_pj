<!-- 
 * @author 송영은
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: bestRestaurantsContent.jsp
 현재 OPEN 상태인 숙소를 최근 30일 이내 매겨진 평점 순으로 조회. 지역에 따라 필터를 걸어 평점 순으로도 조회 가능.   
-->

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- [랭킹 상단 TOP5 영역]
     현재 선택된 탭에 따라 제목과 설명 문구를 다르게 보여주기 위해 사용
--%>
<section class="rk-section">
  <c:choose>
    <c:when test="${currentTab eq 'region'}">
      <h2 class="rk-sectionTitle">📍 지역 TOP 5</h2>
      <div class="rk-sectionSub">
        <c:choose>
          <c:when test="${not empty currentRegion and currentRegion ne 'all'}">
            ${currentRegion} 지역 기준 인기 숙소 <%-- 특정 지역 선택 시 해당 지역 안내 문구 출력 --%>
          </c:when>
          <c:otherwise>
            전체 지역 기준 인기 숙소 <%-- 지역 미선택 또는 전체 선택 시 기본 문구 출력 --%>
          </c:otherwise>
        </c:choose>
      </div>
    </c:when>

    <c:otherwise>
      <h2 class="rk-sectionTitle">🔥 실시간 인기 TOP 5</h2>
      <div class="rk-sectionSub">조회수와 반응이 빠르게 상승 중인 맛집</div>
    </c:otherwise>
  </c:choose>

  <div class="rk-topWrap">

    <%-- [TOP 1 카드]
         랭킹 1위는 가장 크게 강조해서 보여주기 위해 별도 영역으로 분리
    --%>
    <c:forEach var="item" items="${topList}" begin="0" end="0">
      <div class="rk-top1 mb-4">
        <c:set var="acc" value="${item}" scope="request"/>
        <c:set var="mode" value="top10" scope="request"/> <%-- BigRestCard에서 TOP 전용 스타일 구분 시 사용 --%>
        <c:set var="rank" value="1" scope="request"/> <%-- 1위 고정 표시 --%>
        <c:set var="rankCls" value="rank-1" scope="request"/> <%-- 1위 전용 뱃지 스타일 적용 --%>
        <c:set var="cardWrapClass" value="" scope="request"/>

        <jsp:include page="/WEB-INF/views/common/card/BigAccCard.jsp"/> <%-- 공통 카드 컴포넌트 재사용 --%>
      </div>
    </c:forEach>

    <%-- [TOP 2 ~ 5 카드]
         상위권 카드를 2열 구조로 보여주면서 순위별 뱃지 스타일을 다르게 적용하기 위해 사용
    --%>
    <div class="row g-4">
      <c:forEach var="item" items="${topList}" begin="1" end="4" varStatus="st">
        <div class="col-12 col-md-6 rk-topSub">
          <c:set var="acc" value="${item}" scope="request"/>
          <c:set var="mode" value="top10" scope="request"/>
          <c:set var="rank" value="${st.index + 1}" scope="request"/> <%-- begin=1 상태라 실제 순위에 맞게 +1 처리 --%>
          <c:set var="cardWrapClass" value="" scope="request"/>

          <c:choose>
            <c:when test="${st.index + 1 == 2}">
              <c:set var="rankCls" value="rank-2" scope="request"/> <%-- 2위 전용 스타일 --%>
            </c:when>
            <c:when test="${st.index + 1 == 3}">
              <c:set var="rankCls" value="rank-3" scope="request"/> <%-- 3위 전용 스타일 --%>
            </c:when>
            <c:otherwise>
              <c:set var="rankCls" value="rank-default" scope="request"/> <%-- 4~5위 기본 스타일 --%>
            </c:otherwise>
          </c:choose>

          <jsp:include page="/WEB-INF/views/common/card/BigAccCard.jsp"/>
        </div>
      </c:forEach>
    </div>

  </div>
</section>

<%-- [더보기 기본 리스트 제목]
     TOP5 아래에 이어서 보여주는 일반 랭킹 구간임을 구분하기 위해 사용
--%>
<h2 class="rk-moreTitle">더보기+</h2>

<%-- [더보기 초기 카드 리스트]
     TOP5 이후 데이터를 같은 카드 컴포넌트로 출력하고, 순위는 6위부터 이어서 표시하기 위해 사용
--%>
<div class="row g-4 rk-moreGrid" id="moreListWrap">
  <c:forEach var="item" items="${pageList}" varStatus="st">
    <div class="col-6 col-md-4 col-lg-3">
      <c:set var="acc" value="${item}" scope="request"/>
      <c:set var="mode" value="default" scope="request"/> <%-- 일반 카드 구간 표시용 모드값 --%>
      <c:set var="rank" value="${st.index + 6}" scope="request"/> <%-- TOP5 이후 시작이므로 6위부터 계산 --%>
      <c:set var="rankCls" value="rank-default" scope="request"/> <%-- 더보기 구간은 공통 뱃지 스타일 사용 --%>
      <c:set var="cardWrapClass" value="" scope="request"/>
      <jsp:include page="/WEB-INF/views/common/card/BigAccCard.jsp"/>
    </div>
  </c:forEach>
</div>

<%-- [더보기 / 접기 버튼 영역]
     추가 데이터 조회와 초기 상태 복원을 같은 위치에서 제어하기 위해 사용
--%>
<div class="text-center mt-4 d-flex justify-content-center gap-2">
  <button type="button"
          id="moreBtn"
          class="btn btn-outline-dark px-4 py-2"
          data-offset="${nextOffset}" <%-- 다음 AJAX 요청 시작 위치 --%>
          data-initial-offset="${nextOffset}" <%-- 접기 후 복원할 초기 offset 값 --%>
          data-limit="${limit}"> <%-- 한 번에 불러올 카드 개수 --%>
    더보기
  </button>

  <button type="button"
          id="collapseBtn"
          class="btn btn-outline-secondary px-4 py-2"
          style="display:none;"> <%-- 초기에는 추가 카드가 없으므로 숨김 처리 --%>
    접기
  </button>
</div>