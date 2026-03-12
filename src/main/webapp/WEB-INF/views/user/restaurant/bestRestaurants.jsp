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
    }

    .rk-chip.active{
      background:var(--rk-soft);
      border-color:#b7f0d5;
      color:var(--rk-brand2);
    }

    .rk-meta{
      color:var(--rk-muted);
      font-size:14px;
      font-weight:600;
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

    /* TOP 영역에서 restCard를 조금 더 크게 보이게 */
    
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
        <div class="rk-sub">실시간 인기, 지역별 TOP, 테마별 추천 맛집을 한눈에 확인해보세요.</div>
      </div>

      <!-- 탭 -->
      <div class="rk-tabs">
        <button type="button" class="rk-tab active">🔥 실시간 인기</button>
        <button type="button" class="rk-tab">
          <i class="fa-solid fa-location-dot text-danger me-1"></i> 지역 TOP
        </button>
        <button type="button" class="rk-tab">
          <i class="fa-solid fa-compass me-1" style="color:var(--rk-brand);"></i> 테마 추천
        </button>
      </div>

      <!-- 필터 -->
      <div class="rk-filterRow">
        <div class="rk-chipWrap">
          <button type="button" class="rk-chip active">전체</button>
          <button type="button" class="rk-chip">한식</button>
          <button type="button" class="rk-chip">카페</button>
          <button type="button" class="rk-chip">술집</button>
          <button type="button" class="rk-chip">양식</button>
        </div>

        <div class="rk-meta">신촌 · 강남 · TOP50 · 00:00 기준 실시간 집계</div>
      </div>

      <!-- TOP5 -->
      <section class="rk-section">
		  <h2 class="rk-sectionTitle">🔥 실시간 인기 TOP 5</h2>
		  <div class="rk-sectionSub">조회수와 반응이 빠르게 상승 중인 맛집</div>
		
		  <div class="rk-topWrap">
		
		    <!-- TOP 1 -->
		    <c:forEach var="item" items="${top5List}" begin="0" end="0">
		      <div class="rk-top1 mb-4">
		        <c:set var="place" value="${item}" scope="request"/>
		        <c:set var="mode" value="top10" scope="request"/>
		        <c:set var="rank" value="1" scope="request"/>
		        <c:set var="rankCls" value="rank-1" scope="request"/>
		
		        <jsp:include page="/WEB-INF/views/common/card/restCard.jsp"/>
		      </div>
		    </c:forEach>
		
		    <!-- TOP 2 ~ 5 -->
		    <div class="row g-4">
		      <c:forEach var="item" items="${top5List}" begin="1" end="4" varStatus="st">
		        <div class="col-12 col-md-6 rk-topSub">
		          <c:set var="place" value="${item}" scope="request"/>
		          <c:set var="mode" value="top10" scope="request"/>
		          <c:set var="rank" value="${st.index + 2}" scope="request"/>
		
		          <c:choose>
		            <c:when test="${st.index + 2 == 2}">
		              <c:set var="rankCls" value="rank-2" scope="request"/>
		            </c:when>
		            <c:when test="${st.index + 2 == 3}">
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

      <div class="row g-4 rk-moreGrid">
		  <c:forEach var="item" items="${pageList}">
			  <div class="col-6 col-md-4 col-lg-3">
			    <c:set var="place" value="${item}" scope="request"/>
			    <c:set var="mode" value="default" scope="request"/>
			    <jsp:include page="/WEB-INF/views/common/card/restCard.jsp"/>
			  </div>
			</c:forEach>
		</div>

      <!-- 페이지네이션 -->
      <%@ include file="/WEB-INF/views/common/pagination.jsp" %>

    </div>
  </main>

  <%@ include file="../../common/footer.jsp" %>
</body>
</html>