<!-- 
 * @author 송영은
 * 최초작성일: 2026-03-19
 * 최종수정일: 2026-03-20
 * 참고 코드: bestRestaurants.jsp
-->

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>맛집 랭킹</title>

<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/> -->

<%-- [랭킹 페이지 전용 스타일]
       TOP5 / 더보기 / 카드 크기 및 반응형 UI를 한 파일에서 제어하기 위해 사용
  --%>
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

    <%-- [탭 UI]
         실시간 / 지역 / 추천 전환을 버튼 형태로 구성하기 위해 사용
    --%>
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
      background:var(--rk-orange-soft); /* 선택된 탭 강조 */
    }

    <%-- [필터 영역]
         추천 카테고리, 지역 선택 UI를 한 줄로 정렬하기 위해 사용
    --%>
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
      color:var(--rk-brand2); /* 선택된 필터 강조 */
    }

    <%-- [TOP5 / 더보기 카드 영역 스타일] --%>
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
    }

    <%-- [카드 이미지 크기 제어]
         TOP1 / TOP5 / 더보기 영역별로 이미지 크기를 다르게 설정
    --%>
    .rk-top1 .thumb-img{
      height:320px;
      object-fit:cover;
    }

    .rk-topSub .thumb-img{
      height:220px;
      object-fit:cover;
    }

    .rk-moreGrid .thumb-img{
      height:180px;
      object-fit:cover;
    }

    <%-- [반응형 처리] --%>
    @media (max-width: 991.98px){
      .rk-title{
        font-size:34px;
      }

      .rk-section{
        padding:22px;
      }
    }

    @media (max-width: 575.98px){
      .rk-title{
        font-size:28px;
      }

      .rk-sectionTitle{
        font-size:24px;
      }
    }

    <%-- [지역 select 우측 정렬] --%>
    #regionSelect {
      margin-left: auto;
    }

    <%-- [TOP1 카드 높이 과확장 방지]
         카드 내부 콘텐츠 길이에 따라 레이아웃이 깨지는 것을 방지하기 위해 사용
    --%>
    .rk-top1 .place-card,
    .rk-top1 .place-card-wrap {
      height: auto !important;
    }
  </style>
</head>

<body>
	<%@ include file="../../common/header.jsp"%>

	<main class="rk-page">
		<div class="container">

			<%-- [페이지 제목 영역]
           랭킹 페이지의 목적과 기능을 사용자에게 안내하기 위해 사용
      --%>
			<div class="rk-head">
				<h1 class="rk-title">
					<i class="fa-solid fa-utensils me-2"
						style="color: var(- -rk-brand);"></i> 축제 랭킹
				</h1>
				<div class="rk-sub">실시간 인기 축제를 한눈에 확인해보세요.</div>
			</div>

			<!-- 축제에서 현재 지원하지 않음. 추후 코드 응용하여 기능 확장 가능 -->
			<%-- [탭 선택 영역]
           실시간 / 지역 / 추천 기준으로 랭킹 데이터를 전환하기 위한 UI
      --%>
			<!-- <div class="rk-tabs">
        <button type="button" class="rk-tab active" data-tab="realtime">🔥 실시간 인기</button>
        <button type="button" class="rk-tab" data-tab="region">
          <i class="fa-solid fa-location-dot text-danger me-1"></i> 지역 TOP
        </button>
        <button type="button" class="rk-tab" data-tab="recommend">
          <i class="fa-solid fa-compass me-1" style="color:var(--rk-brand);"></i> 추천
        </button>
      </div> -->

			<%-- [필터 영역]
           추천 탭: 카테고리 필터 / 지역 탭: 지역 선택
           탭 상태에 따라 JS에서 표시/숨김 처리됨
      --%>
			<%-- <div class="rk-filterRow">

				추천 필터 (카테고리)
				<div id="recommendFilterArea" style="display: none; width: 100%;">
					<div class="rk-chipWrap" id="recommendChipWrap">
						<button type="button" class="rk-chip active" data-category="ALL">전체</button>
						<button type="button" class="rk-chip" data-category="한식">한식</button>
						<button type="button" class="rk-chip" data-category="카페/디저트">카페</button>
						<button type="button" class="rk-chip" data-category="일식">일식</button>
						<button type="button" class="rk-chip" data-category="양식">양식</button>

						처음에는 숨겨두고 "필터 더보기" 클릭 시 노출
						<button type="button" class="rk-chip extra-filter d-none"
							data-category="중식">중식</button>
						<button type="button" class="rk-chip extra-filter d-none"
							data-category="술집">술집</button>
						<button type="button" class="rk-chip extra-filter d-none"
							data-category="카페/디저트">디저트</button>
						<button type="button" class="rk-chip extra-filter d-none"
							data-category="분식">분식</button>
					</div>

					<div class="mt-2">
						<button type="button" id="filterMoreBtn"
							class="btn btn-sm btn-outline-secondary">필터 더보기</button>
						<button type="button" id="filterCollapseBtn"
							class="btn btn-sm btn-outline-secondary d-none">필터 접기</button>
					</div>
				</div> --%>

				<!-- 현재 축제에서 미지원하는 기능. 추후 기능 추가 시 주석 해제하여 사용 -->
				<%-- 지역 선택 (지역 탭에서만 사용) --%>
				<!-- <select id="regionSelect" class="form-select" style="width:160px; display:none;">
			          <option value="all">전체 지역</option>
			          <option value="서울">서울</option>
			          <option value="인천">인천</option>
			          <option value="부산">부산</option>
			          <option value="대전">대전</option>
			        </select> -->
			</div>

			<!-- 현재 축제에서 미지원하는 기능. 추후 기능 추가 시 주석 해제하여 사용 -->
			<%-- [랭킹 콘텐츠 영역]
           탭 변경 시 AJAX로 해당 영역만 교체되도록 설계
      --%>
			<div id="rankingContent">
				<jsp:include
					page="/WEB-INF/views/user/festival/bestFestivalsContent.jsp" />
			</div>
		</div>
	</main>

	<%-- [JS에서 사용할 공통 path 설정] --%>
	<script>
		const path = "${path}";
	</script>

	<%-- [랭킹 페이지 전용 JS]
       더보기 기능을 담당 (탭 전환, 필터 미포함)
  --%>
	<script src="${path}/resources/js/festival/bestFestivals.js"></script>

	<%@ include file="../../common/footer.jsp"%>
</body>
</html>