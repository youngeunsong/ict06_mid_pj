<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!-- 
 * @author 송창범, 송영은
 * 최초작성일: 2026-03-19
 * 최종수정일: 2026-03-31
 맛집을 평점 순으로 조회.   
 * 변경사항
 v260324: 랭킹용 css 사용하도록 수정 
 v260331: 랭킹 페이지와 지도 페이지간 전환 가능한 토글 메뉴 추가 (송영은)
-->
<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>맛집 랭킹</title>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <link rel="stylesheet" href="${path}/resources/css/common/ranking.css"/>	<!-- 랭킹용 공통 css -->	
  <link rel="stylesheet" href="${path}/resources/css/user/restaurant/restaurant.css">	
</head>

<body>
  <%@ include file="../../common/header.jsp" %>

  <main class="rk-page">
    <div class="container">

      <%-- [페이지 제목 영역]
           랭킹 페이지의 목적과 기능을 사용자에게 안내하기 위해 사용
      --%>
      <div class="main-tab-wrapper" style="display:flex; justify-content:center; margin-bottom:30px;">
          <div class="nav-pill-group" onclick="location.href='${path}/restaurant.rs'" style="cursor:pointer;">
              <div class="nav-pill-item best-link">내 주변</div>
              <div class="nav-pill-item active">베스트 맛집</div>
          </div>
      </div>
      
      <!-- <div class="rk-head">
        <h1 class="rk-title">
          <i class="fa-solid fa-utensils me-2" style="color:var(--rk-brand);"></i>
          맛집 랭킹
        </h1>
        <div class="rk-sub">실시간 인기, 지역별 TOP, 추천 맛집을 한눈에 확인해보세요.</div>
      </div> -->

      <%-- [탭 선택 영역]
           실시간 / 지역 / 추천 기준으로 랭킹 데이터를 전환하기 위한 UI
      --%>
      <div class="rk-tabs">
        <button type="button" class="rk-tab active" data-tab="realtime">🔥 실시간 인기</button>
        <button type="button" class="rk-tab" data-tab="region">
          <i class="fa-solid fa-location-dot text-danger me-1"></i> 지역 TOP
        </button>
        <button type="button" class="rk-tab" data-tab="recommend">
          <i class="fa-solid fa-compass me-1" style="color:var(--rk-brand);"></i> 추천
        </button>
      </div>

      <%-- [필터 영역]
           추천 탭: 카테고리 필터 / 지역 탭: 지역 선택
           탭 상태에 따라 JS에서 표시/숨김 처리됨
      --%>
      <div class="rk-filterRow">

        <%-- 추천 필터 (카테고리) --%>
        <div id="recommendFilterArea" style="display:none; width:100%;">
          <div class="rk-chipWrap" id="recommendChipWrap">
            <button type="button" class="rk-chip active" data-category="ALL">전체</button>
            <button type="button" class="rk-chip" data-category="한식">한식</button>
            <button type="button" class="rk-chip" data-category="카페/디저트">카페</button>
            <button type="button" class="rk-chip" data-category="일식">일식</button>
            <button type="button" class="rk-chip" data-category="양식">양식</button>

            <%-- 처음에는 숨겨두고 "필터 더보기" 클릭 시 노출 --%>
            <button type="button" class="rk-chip extra-filter d-none" data-category="중식">중식</button>
            <button type="button" class="rk-chip extra-filter d-none" data-category="술집">술집</button>
            <button type="button" class="rk-chip extra-filter d-none" data-category="카페/디저트">디저트</button>
            <button type="button" class="rk-chip extra-filter d-none" data-category="분식">분식</button>
          </div>

          <div class="mt-2">
            <button type="button" id="filterMoreBtn" class="btn btn-sm btn-outline-secondary">
              필터 더보기
            </button>
            <button type="button" id="filterCollapseBtn" class="btn btn-sm btn-outline-secondary d-none">
              필터 접기
            </button>
          </div>
        </div>

        <%-- 지역 선택 (지역 탭에서만 사용) --%>
        <select id="regionSelect" class="form-select" style="width:160px; display:none;">
          <option value="all">전체 지역</option>
          <option value="서울">서울</option>
          <option value="인천">인천</option>
          <option value="부산">부산</option>
          <option value="대전">대전</option>
        </select>

      </div>

      <%-- [랭킹 콘텐츠 영역]
           탭 변경 시 AJAX로 해당 영역만 교체되도록 설계
      --%>
      <div id="rankingContent">
        <jsp:include page="/WEB-INF/views/user/restaurant/bestRestaurantsContent.jsp"/>
      </div>

    </div>
  </main>

  <%-- [JS에서 사용할 공통 path 설정] --%>
  <script>
    const path = "${path}";
  </script>

  <%-- [랭킹 페이지 전용 JS]
       탭 전환, 필터, 더보기 기능을 담당
  --%>
  <script src="${path}/resources/js/restaurant/bestRestaurants.js"></script>

  <%@ include file="../../common/footer.jsp" %>
</body>
</html>