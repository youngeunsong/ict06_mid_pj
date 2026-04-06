<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-05
 * 최종수정일: 2026-03-10
 
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="setting.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- 반응형 웹 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>main</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/common/main.css">
<link rel="stylesheet" href="${path}/resources/css/common/bookmark.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script> <!-- 아이콘 -->


<script src="${path}/resources/js/user/main.js" defer></script>
<script src="${path}/resources/js/search/bookmark.js" defer></script>
<script> const CTX = '${path}'; </script>

</head>
<body>
<div class="wrap">

  <%-- 관리자 접근 차단 알림 --%>
  <%
    String alertMsg = (String) session.getAttribute("alertMsg");
    if(alertMsg != null) {
        session.removeAttribute("alertMsg");
  %>
<div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index:9999">
	<div id="adminToast" class="toast align-items-center text-bg-danger border-0" role="alert">
		<div class="d-flex">
			<div class="toast-body fw-bold">
				⚠️ <%= alertMsg %>
			</div>
			<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
		</div>
	</div>
</div>
<script>
	window.onload = function() {
		var toastEl = document.getElementById('adminToast');
		var toast = new bootstrap.Toast(toastEl, {
			delay: 5000,
			autohide: false
		});
		toast.show();
		
		//모달 밖 클릭 시 닫기
		toastEl.addEventListener('click', function(e) {
			if(e.target === toastEl) toast.hide();
		});
	};
</script>
<% } %>
		<!-- isMain 변수를 request 범위로 세팅하여 헤더에서 검색바 렌더링을 제어 -->
		<c:set var="isMain" value="true" scope="request" />
		<!-- header -->
		<%@ include file="header.jsp"%>

		<!-- 컨텐츠 시작 -->
		
		<!-- 메인 배너S -->
		<section class="position-relative">
			<div id="heroCarousel" class="carousel slide" data-bs-ride="carousel"
				data-bs-interval="4000">

				<!-- [메인배너] 전체 이미지 -->
				<div class="carousel-inner">
					<!-- 배너1 -->
					<div class="carousel-item active">
						<img src="${path}/resources/upload/1.jpg" alt="전통" />
						<div class="carousel-caption hero-content-caption">
							<p class="hero-subtitle mb-2 fw-semibold opacity-75"> 전통과 즐거움이 어우러진 순간</p>
							<h2 class="hero-title fw-bold">다양한 축제를 경험하세요</h2>
						</div>
					</div>

					<!-- 배너2 -->
					<div class="carousel-item">
						<img src="${path}/resources/upload/2.jpg" alt="자연" />
						<div class="carousel-caption hero-content-caption">
							<p class="hero-subtitle mb-2 fw-semibold opacity-75"> 나를 위한 자연의 아름다운 경치</p>
							<h2 class="hero-title fw-bold">힐링이 되는 숙소를 경험하세요</h2>
						</div>
					</div>

					<!-- 배너3 -->
					<div class="carousel-item">
						<img src="${path}/resources/upload/4.jpg" alt="레스토랑" />
						<div class="carousel-caption hero-content-caption">
							<p class="hero-subtitle mb-2 fw-semibold opacity-75"> 눈과 입이 모두 즐거운 경험</p>
							<h2 class="hero-title fw-bold">소중한 사람과 함께 공유하세요</h2>
						</div>
					</div>

					<!-- 배너4 -->
					<div class="carousel-item">
						<img src="${path}/resources/upload/6.jpg" alt="카페" />
						<div class="carousel-caption hero-content-caption">
							<p class="hero-subtitle mb-2 fw-semibold opacity-75"> 소소하지만 특별한 경험</p>
							<h2 class="hero-title fw-bold">여유로운 한 끼를 만나보세요</h2>
						</div>
					</div>
					
					<!-- 배너5 -->
					<div class="carousel-item">
						<img src="${path}/resources/upload/7.jpg" alt="숙소" />
						<div class="carousel-caption hero-content-caption">
							<p class="hero-subtitle mb-2 fw-semibold opacity-75"> 오늘의 피로를 내려놓는 순간</p>
							<h2 class="hero-title fw-bold">편안한 숙소를 경험하세요</h2>
						</div>
					</div>
					
					<!-- 배너6 -->
					<div class="carousel-item">
						<img src="${path}/resources/upload/8.jpg" alt="자유" />
						<div class="carousel-caption hero-content-caption">
							<p class="hero-subtitle mb-2 fw-semibold opacity-75"> 자유롭고 떠들석한 이 순간</p>
							<h2 class="hero-title fw-bold">지금, 축제를 즐겨보세요</h2>
						</div>
					</div>
				</div>

				<!-- [메인배너] 스크롤 버튼 -->
				<button class="carousel-control-prev" type="button"
					data-bs-target="#heroCarousel" data-bs-slide="prev">
					<span class="carousel-control-prev-icon"></span>
				</button>
				<button class="carousel-control-next" type="button"
					data-bs-target="#heroCarousel" data-bs-slide="next">
					<span class="carousel-control-next-icon"></span>
				</button>
			</div>
            
            <!-- 메인 배너 내 통합 검색창 (텍스트는 각 슬라이드로 분리, 폼은 단일 1세트 공통 유지) -->
            <div class="main-search-wrap">
                <form class="main-search-form search-module" role="search" action="${path}/search.do" method="get">
                    <div class="input-group input-group-lg main-search-input-group">
                        <span class="input-group-text bg-white border-0 ps-4"></span>
                        <input class="search-keyword-input form-control border-0 bg-white" type="search" name="keyword" autocomplete="off"
                               placeholder="방문하실 목적지, 숙소, 축제를 검색해보세요" aria-label="Search" style="padding: 1.25rem 1rem; font-size: 1.15rem;">
                        <button class="btn btn-primary px-5 fw-bold fs-5" type="submit">검색</button>               
                    </div>
                    
                    <!-- 자동완성 + 최근 검색어 박스 (.search-* 클래스 기반 단일 구조) -->
                    <div class="search-suggest-box main-suggest-box d-none">
                        <div class="search-recent-area main-suggest-section d-none">
                            <div class="main-suggest-title">최근 검색어</div>
                            <ul class="search-recent-list suggest-list list-unstyled mb-0 px-2"></ul>
                        </div>
                
                        <div class="search-auto-area main-suggest-section d-none">
                            <div class="main-suggest-title">추천 검색어</div>
                            <ul class="search-auto-list suggest-list list-unstyled mb-0 px-2"></ul>
                        </div>
                    </div>
                </form>
            </div>
		</section>
		<!-- 메인 배너E -->


		<!-- 금주의 TOP10S -->
		<section class="section-wrap">
			<div class="container">

				<!-- [금주의 TOP10] 헤더S -->
				<div class="d-flex align-items-center justify-content-between mb-3">
					<div>
						<div class="section-title">
							금주의

							<!-- 드롭다운 버튼 : 맛집/ 숙소S -->
							<div class="dropdown d-inline-block mx-1">
								<button
									class="btn btn-sm btn-outline-success dropdown-toggle fw-bold px-2 py-0"
									type="button" id="categoryDropdown" data-bs-toggle="dropdown"
									aria-expanded="false"
									style="font-size: 1rem; border-radius: 6px;">
									맛집
								</button>
								<ul class="dropdown-menu dropdown-menu-start shadow-sm"
									aria-labelledby="categoryDropdown"
									style="min-width: 100px; font-size: .88rem;">
									<li>
										<a class="dropdown-item active" href="#" data-category="REST">
											<i class="bi bi-shop me-1"></i>맛집
										</a>
									</li>
									<li>
										<a class="dropdown-item" href="#" data-category="ACC">
											<i class="bi bi-house me-1"></i>숙소
										</a>
									</li>
								</ul>
							</div>
							<!-- 드롭다운 버튼 : 맛집/ 숙소E -->

							TOP10
							<span class="badge-new">NEW</span>
							<i class="bi bi-fire text-warning ms-1" style="font-size: 1rem;"></i>
						</div>

						<!-- 하단 설명 글 -->
						<p class="section-subtitle" id="top10Subtitle">이번 달 가장 많은 사람들이 찾아본 맛집 TOP 10</p>
					</div>

					<a href="${path}/restaurant.rs" id="top10ViewAllLink" class="view-all">
						전체보기 <i class="bi bi-chevron-right"></i>
					</a>
				</div>
				<!-- [금주의 TOP10] 헤더E -->

				<!-- [금주의 TOP10] 카드S -->
				<div class="section-carousel-wrap">
					<!-- 왼쪽 버튼(prev) -->
					<button class="scroll-btn prev" onclick="scrollCards(-1)">
						<i class="bi bi-chevron-left"></i>
					</button>

					<!-- 카드 노출 -->
					<!-- 맛집 : 기본 -->
					<div class="top10-viewport">
					    <div id="top10Row" data-active="REST">
					        <c:forEach var="restDTO" items="${RESTtop10}" varStatus="st">
					            <c:set var="rest" value="${restDTO}" scope="request" />
					            <c:set var="mode" value="top10" scope="request" />
					            <c:set var="cardWrapClass" value="top10-card-wrap" scope="request" />
					
					            <c:set var="rank" value="${st.index + 1}" scope="request" />
					            <c:set var="rankCls" value="" scope="request" />
					            <c:if test="${st.index == 0}">
					                <c:set var="rankCls" value="top1" scope="request" />
					            </c:if>
					            <c:if test="${st.index == 1}">
					                <c:set var="rankCls" value="top2" scope="request" />
					            </c:if>
					            <c:if test="${st.index == 2}">
					                <c:set var="rankCls" value="top3" scope="request" />
					            </c:if>
					
					            <jsp:include page="card/restCard.jsp" />
					        </c:forEach>
					    </div>
					</div>

					<!-- 맛집 : 히든 -->
					<div id="top10Row_REST" class="d-none">
					    <c:forEach var="restDTO" items="${RESTtop10}" varStatus="st">
					        <c:set var="rest" value="${restDTO}" scope="request" />
					        <c:set var="mode" value="top10" scope="request" />
					        <c:set var="cardWrapClass" value="top10-card-wrap" scope="request" />
					
					        <c:set var="rank" value="${st.index + 1}" scope="request" />
					        <c:set var="rankCls" value="" scope="request" />
					        <c:if test="${st.index == 0}">
					            <c:set var="rankCls" value="top1" scope="request" />
					        </c:if>
					        <c:if test="${st.index == 1}">
					            <c:set var="rankCls" value="top2" scope="request" />
					        </c:if>
					        <c:if test="${st.index == 2}">
					            <c:set var="rankCls" value="top3" scope="request" />
					        </c:if>
					
					        <jsp:include page="card/restCard.jsp" />
					    </c:forEach>
					</div>

					<!-- 숙소 : 히든 -->
					<div id="top10Row_ACC" class="d-none">
					    <c:forEach var="accDTO" items="${ACCtop10}" varStatus="st">
					        <c:set var="acc" value="${accDTO}" scope="request" />
					        <c:set var="mode" value="top10" scope="request" />
					        <c:set var="cardWrapClass" value="top10-card-wrap" scope="request" />
					
					        <c:set var="rank" value="${st.index + 1}" scope="request" />
					        <c:set var="rankCls" value="" scope="request" />
					        <c:if test="${st.index == 0}">
					            <c:set var="rankCls" value="top1" scope="request" />
					        </c:if>
					        <c:if test="${st.index == 1}">
					            <c:set var="rankCls" value="top2" scope="request" />
					        </c:if>
					        <c:if test="${st.index == 2}">
					            <c:set var="rankCls" value="top3" scope="request" />
					        </c:if>
					
					        <jsp:include page="card/accCard.jsp" />
					    </c:forEach>
					</div>

					<!-- 오른쪽 버튼(next) -->
					<button class="scroll-btn next" onclick="scrollCards(1)">
						<i class="bi bi-chevron-right"></i>
					</button>
				</div>

				<div class="dot-pager mt-3" id="top10Dots">
					<span class="active"></span>
				</div>
			</div>
		</section>
		<!-- 금주의 TOP10E -->


		<!-- BEST 추천S -->
		<section class="section-wrap">
		    <div class="container">
		        <div class="d-flex justify-content-between align-items-center mb-3">
		            <h2 class="section-title">BEST 추천 <span class="badge-new">BEST</span></h2>
		
		            <ul id="bestTabs" class="nav best-tabs">
		                <li class="nav-item"><a class="nav-link active" href="#" data-best-type="ALL">전체</a></li>
		                <li class="nav-item"><a class="nav-link" href="#" data-best-type="REST">맛집</a></li>
		                <li class="nav-item"><a class="nav-link" href="#" data-best-type="ACC">숙소</a></li>
		                <li class="nav-item"><a class="nav-link" href="#" data-best-type="FEST">축제</a></li>
		            </ul>
		        </div>
		
		        <div id="bestContentWrap">
		            <c:choose>
		
		                <%-- =====================================================
		                     [BEST 추천 전체]
		                     좌측: 하드코딩
		                     우측: 통합 상위 4개
		                ====================================================== --%>
		                <c:when test="${bestType eq 'ALL' or empty bestType}">
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
		                                            <div class="best-sub-card card text-decoration-none text-dark position-relative">
		                                                <button type="button"
													        class="bookmark-btn" data-place-id="${item.PLACE_ID}">
		                                                    <i class="${not empty favoritePlaceIds and favoritePlaceIds.contains(item.PLACE_ID) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
		                                                </button>
		
		                                                <a href="${detailUrl}" class="text-decoration-none text-dark d-block">
		                                                    <div class="img-wrap position-relative">
		                                                        <img src="${item.IMAGE_URL}"
		                                                             alt="${item.NAME}"
		                                                             onerror="this.src='${path}/resources/images/common/no-image.png';" />
		
		                                                        <span class="best-rank-badge best-rank-${st.index + 1}">
		                                                            ${st.index + 1}위
		                                                        </span>
		                                                    </div>
		
		                                                    <div class="card-body">
		                                                        <div class="card-region">
		                                                            <i class="fa-regular fa-star me-1"></i>평균 ${item.AVG_RATING}점
		                                                            &nbsp;·&nbsp;
		                                                            <i class="fa-regular fa-comment me-1"></i>${item.REVIEW_COUNT}개
		                                                        </div>
		                                                        <div class="card-title">${item.NAME}</div>
		                                                    </div>
		                                                </a>
		                                            </div>
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
		                ====================================================== --%>
		                <c:when test="${bestType eq 'REST'}">
		                    <c:if test="${not empty bestRestList}">
		                        <div class="row g-3">
		                            <%-- 좌측 큰 카드 --%>
		                            <div class="col-12 col-md-4">
		                                <c:set var="rest" value="${bestRestList[0]}" scope="request" />
		                                <c:set var="mode" value="bestMain" scope="request" />
		                                <c:set var="cardWrapClass" value="best-main-card-wrap" scope="request" />
		                                <jsp:include page="card/restCard.jsp" />
		                            </div>
		
		                            <%-- 우측 작은 카드들 --%>
		                            <div class="col-12 col-md-8">
		                                <div class="row g-3">
		                                    <c:forEach var="restDTO" items="${bestRestList}" begin="1" end="4">
		                                        <div class="col-6">
		                                            <c:set var="rest" value="${restDTO}" scope="request" />
		                                            <c:set var="mode" value="best" scope="request" />
		                                            <c:set var="cardWrapClass" value="best-card-wrap" scope="request" />
		                                            <jsp:include page="card/restCard.jsp" />
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
		                ====================================================== --%>
		                <c:when test="${bestType eq 'ACC'}">
		                    <c:if test="${not empty bestAccList}">
		                        <div class="row g-3">
		                            <%-- 좌측 큰 카드 --%>
		                            <div class="col-12 col-md-4">
		                                <c:set var="acc" value="${bestAccList[0]}" scope="request" />
		                                <c:set var="mode" value="bestMain" scope="request" />
		                                <c:set var="cardWrapClass" value="best-main-card-wrap" scope="request" />
		                                <jsp:include page="card/accCard.jsp" />
		                            </div>
		
		                            <%-- 우측 작은 카드들 --%>
		                            <div class="col-12 col-md-8">
		                                <div class="row g-3">
		                                    <c:forEach var="accDTO" items="${bestAccList}" begin="1" end="4">
		                                        <div class="col-6">
		                                            <c:set var="acc" value="${accDTO}" scope="request" />
		                                            <c:set var="mode" value="best" scope="request" />
		                                            <c:set var="cardWrapClass" value="best-card-wrap" scope="request" />
		                                            <jsp:include page="card/accCard.jsp" />
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
		                ====================================================== --%>
		                <c:otherwise>
		                    <c:if test="${not empty bestFestList}">
		                        <div class="row g-3">
		                            <%-- 좌측 큰 카드 --%>
		                            <div class="col-12 col-md-4">
		                                <c:set var="fest" value="${bestFestList[0]}" scope="request" />
		                                <c:set var="mode" value="bestMain" scope="request" />
		                                <c:set var="cardWrapClass" value="best-main-card-wrap" scope="request" />
		                                <jsp:include page="card/festivalCard.jsp" />
		                            </div>
		
		                            <%-- 우측 작은 카드들 --%>
		                            <div class="col-12 col-md-8">
		                                <div class="row g-3">
		                                    <c:forEach var="festDTO" items="${bestFestList}" begin="1" end="4">
		                                        <div class="col-6">
		                                            <c:set var="fest" value="${festDTO}" scope="request" />
		                                            <c:set var="mode" value="best" scope="request" />
		                                            <c:set var="cardWrapClass" value="best-card-wrap" scope="request" />
		                                            <jsp:include page="card/festivalCard.jsp" />
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
		        </div>
		    </div>
		</section>
		<!-- BEST 추천E -->


		<!-- 이달의 추천 국내 축제S -->
		<section class="section-wrap festival-section">
			<div class="container">
				<!-- 헤더 -->
				<div class="d-flex align-items-center justify-content-between mb-3">
					<div>
						<h2 class="section-title">
							<i class="bi bi-calendar-event-fill me-1" style="color: var(--primary);"></i>
							이달의 추천 국내 축제
						</h2>

						<!-- 해당 월에 맞춰 자동으로 월 변경 -->
						<jsp:useBean id="now" class="java.util.Date" />
						<p class="section-subtitle">
							<fmt:formatDate value="${now}" pattern="M" />월에 꼭 가봐야 할 국내 축제 모음
						</p>
					</div>

					<a href="${path}/festival.fe" class="view-all">
						전체보기 <i class="bi bi-chevron-right"></i>
					</a>
				</div>

				<!-- 카드 -->
				<div class="row g-3">
					<c:forEach var="fest" items="${festivalList}">
						<div class="col-6 col-md-3">
							<c:set var="mode" value="festival" scope="request" />
							<c:set var="fest" value="${fest}" scope="request" />
								<c:set var="cardWrapClass" value="festival-card-wrap" scope="request" />
							<jsp:include page="card/festivalCard.jsp" />
						</div>
					</c:forEach>
				</div>
			</div>
		</section>
		<!-- 이달의 추천 국내 축제E -->


		<!-- 공지&이벤트S -->
		<section class="notice-section py-4">
			<div class="container">
				<div class="d-flex justify-content-between align-items-center mb-3">
					<ul class="nav notice-tabs border-bottom mb-3">
					    <li class="nav-item">
					        <button type="button" class="nav-link active" id="noticeTabBtn">공지</button>
					    </li>
					    <li class="nav-item">
					        <button type="button" class="nav-link" id="eventTabBtn">이벤트</button>
					    </li>
					</ul>
	
					<a href="${path}/community_free.co" class="view-all text-decoration-none">
						전체보기 <i class="bi bi-chevron-right"></i>
					</a>
				</div>
	
				<div class="card border-0 shadow-sm rounded-4 overflow-hidden">
					<div class="card-body p-0">
	
						<!-- 공지 영역 -->
						<div id="noticeContent">
							<table class="table notice-table mb-0">
								<tbody>
									<c:choose>
										<c:when test="${not empty mainNoticeList}">
											<c:forEach var="notice" items="${mainNoticeList}">
											    <tr>
											        <td width="70">
											            <span class="badge bg-success" style="font-size:.7rem;">공지</span>
											        </td>
											        <td>
											            <a href="${path}/community_notice_detail.co?notice_id=${notice.notice_id}" class="notice-title text-decoration-none text-dark">
											                ${notice.title}
											            </a>
											        </td>
											        <td class="date-col text-end">
											            <fmt:formatDate value="${notice.noticeRegDate}" pattern="yyyy.MM.dd" />
											        </td>
											    </tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr>
												<td colspan="3" class="text-center text-muted py-4">
													등록된 공지글이 없습니다.
												</td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>
	
						<!-- 이벤트 영역 -->
						<div id="eventContent" style="display:none;">
						    <table class="table notice-table mb-0">
						        <tbody>
						            <c:choose>
						                <c:when test="${not empty mainEventList}">
						                    <c:forEach var="event" items="${mainEventList}">
						                        <tr>
						                            <td width="50">
						                                <span class="badge bg-warning text-dark" style="font-size:.7rem;">이벤트</span>
						                            </td>
						                            <td>
						                                <a href="${path}/community_event_detail.co?notice_id=${event.notice_id}" class="notice-title">
						                                    ${event.title}
						                                </a>
						                            </td>
						                            <td class="date-col text-end">
						                                <fmt:formatDate value="${event.noticeRegDate}" pattern="yyyy.MM.dd"/>
						                            </td>
						                        </tr>
						                    </c:forEach>
						                </c:when>
						                <c:otherwise>
						                    <tr>
						                        <td colspan="3" class="text-center text-muted py-4">등록된 이벤트글이 없습니다.</td>
						                    </tr>
						                </c:otherwise>
						            </c:choose>
						        </tbody>
						    </table>
						</div>
						
						
					</div>
				</div>
			</div>
		</section>
		<!-- 공지&이벤트E -->


		<!-- 프로모션 배너 -->
		<section class="py-4">
			<div class="container">
				<div class="row g-3">
					<div class="col-12 col-md-6">
						<div class="promo-banner promo-banner-a">
							<div class="promo-overlay">
								<div class="promo-title">
									✈️ 얼리버드 특가<br />항공+숙박 묶음
								</div>
								<div class="promo-sub">지금 예약하면 최대 50% 할인!</div>
							</div>
						</div>
					</div>

					<div class="col-12 col-md-6">
						<div class="promo-banner promo-banner-b">
							<div class="promo-overlay">
								<div class="promo-title">
									🎁 신규 회원 가입 혜택<br />즉시 5만원 쿠폰 지급
								</div>
								<div class="promo-sub">오늘만! 가입 즉시 사용 가능</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		<!-- 컨텐츠 끝 -->

		<!-- footer -->
		<%@ include file="footer.jsp"%>

		<!-- 설문 모달 -->
		<%@ include file="/WEB-INF/views/user/mypage/surveyModal.jsp"%>
		<script>
			const path = "${pageContext.request.contextPath}";
		</script>
		<script src="${path}/resources/js/user/survey.js"></script>
	</div>
</body>
</html>
