<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>맛집 랭킹</title>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    :root{
      --rk-text:#111827;
      --rk-muted:#6b7280;
      --rk-line:#e5e7eb;
      --rk-bg:#f9fafb;
      --rk-brand:#10b981;
      --rk-brand2:#059669;
      --rk-soft:#ecfdf5;
      --rk-orange-soft:#fff7ed;
    }

    .rk-page{
      padding:32px 0 60px;
      background:#fff;
      color:var(--rk-text);
    }

    .rk-head{
      margin-bottom:24px;
    }

    .rk-title{
      margin:0;
      font-size:40px;
      font-weight:900;
      letter-spacing:-0.03em;
    }

    .rk-sub{
      margin-top:8px;
      color:var(--rk-muted);
      font-size:15px;
    }

    .rk-tabs{
      display:flex;
      flex-wrap:wrap;
      width:fit-content;
      border:1px solid var(--rk-line);
      border-radius:18px;
      overflow:hidden;
      background:#fff;
      box-shadow:0 8px 20px rgba(17,24,39,.04);
      margin-bottom:18px;
    }

    .rk-tab{
      min-width:170px;
      padding:16px 22px;
      border:none;
      border-right:1px solid var(--rk-line);
      background:#fff;
      font-size:17px;
      font-weight:800;
      color:#374151;
      cursor:pointer;
    }

    .rk-tab:last-child{
      border-right:none;
    }

    .rk-tab.active{
      background:var(--rk-orange-soft);
    }

    .rk-filterRow{
      display:flex;
      flex-wrap:wrap;
      justify-content:space-between;
      align-items:center;
      gap:14px;
      margin-bottom:24px;
    }

    .rk-chipWrap{
      display:flex;
      flex-wrap:wrap;
      gap:10px;
    }

    .rk-chip{
      padding:9px 16px;
      border-radius:14px;
      border:1px solid var(--rk-line);
      background:#fff;
      color:#374151;
      font-size:14px;
      font-weight:700;
      cursor:pointer;
    }

    .rk-chip.active{
      background:var(--rk-soft);
      border-color:#b7f0d5;
      color:var(--rk-brand2);
    }

    .rk-section{
      border:1px solid var(--rk-line);
      border-radius:24px;
      background:#fff;
      padding:28px;
      box-shadow:0 10px 30px rgba(17,24,39,.04);
    }

    .rk-sectionTitle{
      margin:0;
      font-size:30px;
      font-weight:900;
      letter-spacing:-0.02em;
    }

    .rk-sectionSub{
      margin-top:8px;
      color:var(--rk-muted);
      font-size:17px;
    }

    .rk-topWrap{
      margin-top:22px;
      padding-top:18px;
      border-top:1px solid var(--rk-line);
    }

    .rk-moreTitle{
      margin:36px 0 18px;
      font-size:28px;
      font-weight:900;
      letter-spacing:-0.02em;
    }

    .rk-pagination{
      margin-top:24px;
      display:flex;
      justify-content:flex-end;
      gap:8px;
    }

    .rk-pageBtn{
      min-width:42px;
      height:42px;
      border:1px solid var(--rk-line);
      border-radius:12px;
      background:#fff;
      font-weight:800;
      color:#374151;
    }

    .rk-pageBtn.active{
      background:#fbbf24;
      border-color:#fbbf24;
      color:#111827;
    }

    .rk-top1 .thumb-img{
      width:100%;
      height:320px;
      object-fit:cover;
      display:block;
    }

    .rk-top1 .place-card__body{
      padding:20px;
    }

    .rk-top1 .place-card__title{
      font-size:1.25rem;
      font-weight:900;
    }

    .rk-topSub .thumb-img{
      width:100%;
      height:220px;
      object-fit:cover;
      display:block;
    }

    .rk-topSub .place-card__body{
      padding:16px;
    }

    .rk-topSub .place-card__title{
      font-size:1.05rem;
      font-weight:800;
    }

    .rk-moreGrid .thumb-img{
      width:100%;
      height:180px;
      object-fit:cover;
      display:block;
    }

    @media (max-width: 991.98px){
      .rk-title{
        font-size:34px;
      }

      .rk-section{
        padding:22px;
      }
    }

    @media (max-width: 575.98px){
      .rk-page{
        padding-top:22px;
      }

      .rk-title{
        font-size:28px;
      }

      .rk-sectionTitle{
        font-size:24px;
      }

      .rk-pagination{
        justify-content:center;
      }
    }
    
    #regionSelect {
	  margin-left: auto;
	}
	
	/* 랭킹 페이지 TOP1 카드 하단 영역 과확장 방지 */
	.rk-top1 .place-card,
	.rk-top1 .place-card-wrap {
	  height: auto !important;
	  min-height: 0 !important;
	}
	
	.rk-top1 .place-card__body {
	  padding: 14px 16px !important;
	  height: auto !important;
	  min-height: 0 !important;
	  flex: 0 0 auto !important;
	}
	
	.rk-top1 .place-card__title {
	  margin-bottom: 6px;
	  line-height: 1.35;
	}
	
	.rk-top1 .place-card__address {
	  margin-bottom: 8px;
	}
	
	.rk-top1 .place-card__meta {
	  margin-top: 0 !important;
	}
  </style>
</head>
<body>
  <%@ include file="../../common/header.jsp" %>

  <main class="rk-page">
    <div class="container">

      <!-- 제목 -->
      <div class="rk-head">
        <h1 class="rk-title">
          <i class="fa-solid fa-utensils me-2" style="color:var(--rk-brand);"></i>
          맛집 랭킹
        </h1>
        <div class="rk-sub">실시간 인기, 지역별 TOP, 추천 맛집을 한눈에 확인해보세요.</div>
      </div>

      <!-- 탭 -->
      <div class="rk-tabs">
		  <button type="button" class="rk-tab active" data-tab="realtime">🔥 실시간 인기</button>
		  <button type="button" class="rk-tab" data-tab="region">
		    <i class="fa-solid fa-location-dot text-danger me-1"></i> 지역 TOP
		  </button>
		  <button type="button" class="rk-tab" data-tab="recommend">
		    <i class="fa-solid fa-compass me-1" style="color:var(--rk-brand);"></i> 추천
		  </button>
		</div>

      <!-- 필터 -->
      <div class="rk-filterRow">

  <!-- 추천 탭 전용 필터 -->
	  <div id="recommendFilterArea" style="display:none; width:100%;">
	    <div class="rk-chipWrap" id="recommendChipWrap">
	      <button type="button" class="rk-chip active" data-category="ALL">전체</button>
	      <button type="button" class="rk-chip" data-category="한식">한식</button>
	      <button type="button" class="rk-chip" data-category="카페/디저트">카페</button>
	      <button type="button" class="rk-chip" data-category="일식">일식</button>
	      <button type="button" class="rk-chip" data-category="양식">양식</button>
	
	      <!-- 처음엔 숨길 추가 필터 -->
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
	
	  <!-- 지역 탭 전용 셀렉트 -->
	  <select id="regionSelect" class="form-select" style="width:160px; display:none;">
	    <option value="all">전체 지역</option>
	    <option value="서울">서울</option>
	    <option value="인천">인천</option>
	    <option value="부산">부산</option>
	    <option value="대전">대전</option>
	  </select>

      </div>

      <!-- AJAX/Fragment 교체 영역 -->
      <div id="rankingContent">
        <jsp:include page="/WEB-INF/views/user/restaurant/bestRestaurantsContent.jsp"/>
      </div>

    </div>
  </main>

  <script>
    const path = "${path}";
  </script>

  <script src="${path}/resources/js/restaurant/bestRestaurants.js"></script>
  <%@ include file="../../common/footer.jsp" %>
</body>
</html>