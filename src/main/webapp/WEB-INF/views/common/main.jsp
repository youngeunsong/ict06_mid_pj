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
						<img
							src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=1400&q=80"
							alt="도쿄" />
						<div class="carousel-caption">
							<h5>도쿄의 빛나는 야경</h5>
							<p>일본의 심장, 도쿄에서 특별한 밤을</p>
						</div>
					</div>

					<!-- 배너2 -->
					<div class="carousel-item">
						<img
							src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=1400&q=80"
							alt="사막" />
						<div class="carousel-caption">
							<h5>황금빛 사막의 노을</h5>
							<p>대자연이 선사하는 감동의 풍경</p>
						</div>
					</div>

					<!-- 배너3 -->
					<div class="carousel-item">
						<img
							src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1400&q=80"
							alt="설산" />
						<div class="carousel-caption">
							<h5>웅장한 설산의 경치</h5>
							<p>하늘과 맞닿은 그곳으로</p>
						</div>
					</div>

					<!-- 배너4 -->
					<div class="carousel-item">
						<img
							src="https://images.unsplash.com/photo-1501854140801-50d01698950b?w=1400&q=80"
							alt="산" />
						<div class="carousel-caption">
							<h5>초록 숲의 힐링 여행</h5>
							<p>자연 속에서 찾는 완전한 휴식</p>
						</div>
					</div>

					<!-- 배너5 -->
					<div class="carousel-item">
						<img
							src="https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=1400&q=80"
							alt="바다" />
						<div class="carousel-caption">
							<h5>에메랄드빛 해변</h5>
							<p>눈부신 바다가 기다리는 그곳</p>
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

				<!-- [메인배너] 미리보기 이미지 -->
				<div class="hero-thumbs d-none d-md-flex">
					<img class="hero-thumb active"
						src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=200&q=60"
						data-bs-target="#heroCarousel" data-bs-slide-to="0" />
					<img class="hero-thumb"
						src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=60"
						data-bs-target="#heroCarousel" data-bs-slide-to="1" />
					<img class="hero-thumb"
						src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&q=60"
						data-bs-target="#heroCarousel" data-bs-slide-to="2" />
					<img class="hero-thumb"
						src="https://images.unsplash.com/photo-1501854140801-50d01698950b?w=200&q=60"
						data-bs-target="#heroCarousel" data-bs-slide-to="3" />
					<img class="hero-thumb"
						src="https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=200&q=60"
						data-bs-target="#heroCarousel" data-bs-slide-to="4" />
				</div>
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
													        class="bookmark-btn"
													        data-place-id="${item.PLACE_ID}">
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
		                                                            <i class="fa-regular fa-heart me-1"></i>평균 ${item.AVG_RATING}점
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
