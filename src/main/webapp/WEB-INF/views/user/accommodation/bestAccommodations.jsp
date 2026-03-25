<!-- 
 * @author 송영은
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: bestRestaurants.jsp
 현재 OPEN 상태인 축제를 평점/지역 별로 제공.  
-->

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>숙소 랭킹</title>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <link rel="stylesheet" href="${path}/resources/css/common/ranking.css"/>	<!-- 랭킹용 공통 css -->
</head>

<body>
  <%@ include file="../../common/header.jsp" %>

  <main class="rk-page">
    <div class="container">

      <%-- [페이지 제목 영역]
           랭킹 페이지의 목적과 기능을 사용자에게 안내하기 위해 사용
      --%>
      <div class="rk-head">
        <h1 class="rk-title">
        	<!-- 숙소 페이지에 어울리게 수정할 예정 -->
        	<i class="fa-solid fa-bed" style="color:var(--rk-brand);"></i>
          	숙소 랭킹
        </h1>
        <div class="rk-sub">실시간 인기, 지역별 TOP 숙소를 한눈에 확인해보세요.</div>
      </div>

      <%-- [탭 선택 영역]
           실시간 / 지역 기준으로 랭킹 데이터를 전환하기 위한 UI
      --%>
      <div class="rk-tabs">
        <button type="button" class="rk-tab active" data-tab="realtime">🔥 실시간 인기</button>
        <button type="button" class="rk-tab" data-tab="region">
          <i class="fa-solid fa-location-dot text-danger me-1"></i> 지역 TOP
        </button>
      </div>

      <%-- [필터 영역]
           추천 탭: 카테고리 필터 / 지역 탭: 지역 선택
           탭 상태에 따라 JS에서 표시/숨김 처리됨
      --%>
      <div class="rk-filterRow">

        <%-- 지역 선택 (지역 탭에서만 사용) --%>
        <select id="regionSelect" class="form-select" style="width:160px; display:none;">
          <option value="all">전체 지역</option>
          <option value="서울특별시">서울</option>
          <option value="인천광역시">인천</option>
          <option value="부산광역시">부산</option>
          <option value="대전광역시">대전</option>
          <option value="대구광역시">대구</option>
          <option value="광주광역시">광주</option>
          <option value="울산광역시">울산</option>
          <option value="제주특별자치도">제주</option>
          <option value="그외">그외</option>
        </select>

      </div>

      <%-- [랭킹 콘텐츠 영역]
           탭 변경 시 AJAX로 해당 영역만 교체되도록 설계
      --%>
      <div id="rankingContent">
        <jsp:include page="/WEB-INF/views/user/accommodation/bestAccommodationsContent.jsp"/>
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
  <script src="${path}/resources/js/accommodation/bestAccommodations.js"></script>

  <%@ include file="../../common/footer.jsp" %>
</body>
</html>