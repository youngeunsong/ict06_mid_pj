<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>${accommodation.placeDTO.name} | 숙소 상세</title>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    :root{
      --r-text:#111827;
      --r-muted:#6b7280;
      --r-line:#e5e7eb;
      --r-brand:#10b981;
      --r-brand2:#059669;
      --r-pill:#f3f4f6;
    }

    .r-muted{ color: var(--r-muted); }
    .r-pill{
      font-size:12px;
      color:var(--r-muted);
      background:var(--r-pill);
      padding:6px 10px;
      border-radius:999px;
      border:1px solid var(--r-line);
      display:inline-flex;
      align-items:center;
      gap:6px;
    }

    .r-placeName{
      font-size:34px;
      line-height:1.15;
      font-weight:800;
      letter-spacing:-.02em;
      margin:0;
    }
    .r-score{ font-weight:800; color:var(--r-text); }

    .r-hero{
      border-radius:18px;
      overflow:hidden;
      border:1px solid var(--r-line);
      background:#f9fafb;
      position:relative;
      min-height:420px;
    }
    .r-hero img{
      width:100%;
      height:100%;
      object-fit:cover;
      display:block;
    }
    .r-heroCount{
      position:absolute;
      bottom:14px;
      right:14px;
      background:rgba(17,24,39,.75);
      color:#fff;
      padding:8px 10px;
      border-radius:12px;
      font-size:13px;
      display:flex;
      align-items:center;
      gap:8px;
    }

    .r-section{
      padding:18px 0;
      border-bottom:1px solid var(--r-line);
    }
    .r-section:last-child{ border-bottom:none; }

    .r-sectionTitle{
      font-size:22px;
      font-weight:900;
      letter-spacing:-.02em;
      margin:0 0 10px;
    }
    .r-lead{
      color:var(--r-muted);
      font-size:14px;
      line-height:1.7;
      margin:0;
    }

    .r-chip{
      border:1px solid var(--r-line);
      background:#fff;
      border-radius:999px;
      padding:8px 12px;
      font-size:13px;
      color:var(--r-muted);
      display:inline-flex;
      gap:8px;
      align-items:center;
      margin-right:8px;
      margin-bottom:8px;
    }
    .r-chip i{ color:var(--r-brand); }

    .r-mapBox{
      border:1px solid var(--r-line);
      border-radius:18px;
      overflow:hidden;
      height:240px;
      background:#f9fafb;
    }

    .r-infoItem{
      display:flex;
      align-items:flex-start;
      justify-content:space-between;
      gap:12px;
      padding:12px 0;
      border-bottom:1px dashed var(--r-line);
    }
    .r-infoItem:last-child{ border-bottom:none; }

    .r-infoName{
      font-weight:900;
      letter-spacing:-.01em;
      min-width:110px;
    }

    .r-infoValue{
      flex:1;
      text-align:right;
      color:var(--r-muted);
      line-height:1.6;
    }

    .r-reserveBtn{
      width:220px;
      height:44px;
      border-radius:999px;
      font-weight:900;
    }

    @media (min-width: 992px){
      .r-sticky{ position:sticky; top:14px; }
    }

    #btnFavorite.is-on,
    #btnFavoriteSide.is-on{
      border-color:#ef4444;
      color:#ef4444;
    }

    #btnFavorite.is-on i,
    #btnFavoriteSide.is-on i{
      color:#ef4444;
    }
  </style>
</head>

<body>
<%@ include file="../../common/header.jsp" %>

  <div class="container py-4 pb-5">

    <!-- 상단 헤더 -->
    <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">
      <div>
        <div class="d-flex flex-wrap align-items-center gap-2">
          <h1 class="r-placeName">${accommodation.placeDTO.name}</h1>
          <span class="r-pill">${accommodation.placeDTO.place_type}</span>
          <span class="r-pill"><c:out value="${accommodation.category}" default="숙소"/></span>
        </div>

        <div class="d-flex flex-wrap align-items-center gap-2 mt-2 r-muted">
          <span class="r-score">
			  <i class="fa-solid fa-star me-1" style="color:#22c55e;"></i>
			  ${accommodation.placeDTO.avg_rating} (${reviewCount}개)
			</span>
			<span>·</span>
			<span>${accommodation.placeDTO.address}</span>
          <span>·</span>
          <span>
            1박 기준
            <b class="text-dark">
              <fmt:formatNumber value="${accommodation.price}" type="number"/>
            </b>원
          </span>
        </div>
      </div>

      <div class="d-flex gap-2">
        <button
            id="btnFavorite"
            class="btn btn-outline-secondary rounded-pill px-3 fw-bold ${isFavorite ? 'is-on' : ''}"
            type="button">
          <i class="${isFavorite ? 'fa-solid' : 'fa-regular'} fa-heart me-1"></i> 저장
        </button>
      </div>
    </div>

    <!-- 이미지 + 요약 카드 -->
    <div class="row g-3 mb-3">
      <div class="col-lg-8">
        <div class="r-hero shadow-sm">
          <c:choose>
            <c:when test="${not empty accommodation.placeDTO.image_url}">
              <img src="${accommodation.placeDTO.image_url}" alt="대표 이미지"/>
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}/resources/img/sample_stay.jpg" alt="기본 이미지"/>
            </c:otherwise>
          </c:choose>
          <div class="r-heroCount">
            <i class="fa-regular fa-images"></i>
            <span>대표 이미지</span>
          </div>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="card shadow-sm border-0 h-100" style="border-radius:18px;">
          <div class="card-body p-3">
            <div class="d-flex justify-content-between align-items-center mb-2">
              <div class="fw-bold" style="font-size:18px;">숙소 요약 정보</div>
              <span class="badge bg-light text-dark">상세</span>
            </div>

            <div class="r-infoItem">
              <div class="r-infoName">카테고리</div>
              <div class="r-infoValue"><c:out value="${accommodation.category}" default="정보 없음"/></div>
            </div>
            <div class="r-infoItem">
              <div class="r-infoName">상태</div>
              <div class="r-infoValue"><c:out value="${accommodation.status}" default="정보 없음"/></div>
            </div>
            <div class="r-infoItem">
              <div class="r-infoName">연락처</div>
              <div class="r-infoValue"><c:out value="${accommodation.phone}" default="정보 없음"/></div>
            </div>
            <div class="r-infoItem">
              <div class="r-infoName">지역</div>
              <div class="r-infoValue"><c:out value="${accommodation.areaCode}" default="정보 없음"/></div>
            </div>
            <div class="r-infoItem">
              <div class="r-infoName">가격</div>
              <div class="r-infoValue">
                <fmt:formatNumber value="${accommodation.price}" type="number"/>원
              </div>
            </div>

            <div class="r-muted mt-3" style="font-size:12px;">
              객실/예약 상세 정보는 예약 페이지에서 추가로 확인할 수 있습니다.
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 탭 -->
    <ul class="nav nav-tabs mb-3" id="detailTabs" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active fw-bold" id="tab-overview" data-bs-toggle="tab" data-bs-target="#pane-overview" type="button" role="tab">
          개요
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold" id="tab-info" data-bs-toggle="tab" data-bs-target="#pane-info" type="button" role="tab">
          숙소 정보
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold" id="tab-location" data-bs-toggle="tab" data-bs-target="#pane-location" type="button" role="tab">
          위치
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold" id="tab-guide" data-bs-toggle="tab" data-bs-target="#pane-guide" type="button" role="tab">
          이용 안내
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold" id="tab-review" data-bs-toggle="tab" data-bs-target="#pane-review" type="button" role="tab">
          리뷰
        </button>
      </li>
    </ul>

    <div class="row g-4">
      <!-- Left -->
      <div class="col-lg-8">
        <div class="tab-content">

          <!-- 개요 -->
          <div class="tab-pane fade show active" id="pane-overview" role="tabpanel" aria-labelledby="tab-overview">
            <section class="r-section">
              <h2 class="r-sectionTitle">숙소 소개</h2>
              <p class="r-lead">
                <c:out value="${accommodation.description}" default="등록된 숙소 소개 정보가 없습니다."/>
              </p>

              <div class="mt-3">
                <span class="r-chip"><i class="fa-solid fa-hotel"></i> <c:out value="${accommodation.category}" default="숙소 정보 없음"/></span>
                <span class="r-chip"><i class="fa-solid fa-phone"></i> <c:out value="${accommodation.phone}" default="연락처 정보 없음"/></span>
                <span class="r-chip"><i class="fa-solid fa-bed"></i> 1박 기준 <fmt:formatNumber value="${accommodation.price}" type="number"/>원</span>
                <span class="r-chip"><i class="fa-solid fa-circle-check"></i> <c:out value="${accommodation.status}" default="상태 정보 없음"/></span>
              </div>
            </section>
          </div>

          <!-- 숙소 정보 -->
          <div class="tab-pane fade" id="pane-info" role="tabpanel" aria-labelledby="tab-info">
            <section class="r-section">
              <h2 class="r-sectionTitle">숙소 정보</h2>

              <div class="r-lead mb-2">
                <b class="text-dark">숙소 상태</b> :
                <c:out value="${accommodation.status}" default="정보 없음"/>
              </div>

              <div class="r-lead mb-2">
                <b class="text-dark">카테고리</b> :
                <c:out value="${accommodation.category}" default="정보 없음"/>
              </div>

              <div class="r-lead mb-2">
                <b class="text-dark">전화번호</b> :
                <c:out value="${accommodation.phone}" default="정보 없음"/>
              </div>

              <div class="r-lead mb-2">
                <b class="text-dark">지역</b> :
                <c:out value="${accommodation.areaCode}" default="정보 없음"/>
              </div>

              <div class="r-lead">
                <b class="text-dark">기준 가격</b> :
                <fmt:formatNumber value="${accommodation.price}" type="number"/>원
              </div>
            </section>
          </div>

          <!-- 위치 -->
          <div class="tab-pane fade" id="pane-location" role="tabpanel" aria-labelledby="tab-location">
            <section class="r-section">
              <h2 class="r-sectionTitle">위치</h2>

              <div class="r-mapBox mb-3">
                <iframe
                  title="map"
                  width="100%"
                  height="240"
                  style="border:0"
                  loading="lazy"
                  referrerpolicy="no-referrer-when-downgrade"
                  src="https://www.google.com/maps?q=${accommodation.placeDTO.latitude},${accommodation.placeDTO.longitude}&hl=ko&z=16&output=embed">
                </iframe>
              </div>

              <div class="d-flex justify-content-between align-items-start gap-3">
                <div class="r-muted">
                  <div class="fw-bold text-dark mb-1">
                    <i class="fa-solid fa-location-dot" style="color:var(--r-brand);"></i>
                    ${accommodation.placeDTO.address}
                  </div>
                </div>

                <button class="btn btn-outline-secondary fw-bold" type="button"
                        onclick="window.open('https://map.naver.com/v5/search/' + encodeURIComponent('${accommodation.placeDTO.address}'));">
                  길찾기
                </button>
              </div>
            </section>
          </div>

          <!-- 이용 안내 -->
          <div class="tab-pane fade" id="pane-guide" role="tabpanel" aria-labelledby="tab-guide">
            <section class="r-section">
              <h2 class="r-sectionTitle">이용 안내</h2>

              <div class="r-infoItem">
                <div class="r-infoName">체크인/아웃</div>
                <div class="r-infoValue">예약 페이지에서 확인</div>
              </div>
              <div class="r-infoItem">
                <div class="r-infoName">객실 안내</div>
                <div class="r-infoValue">객실 타입 및 인원 정보는 예약 단계에서 제공 예정</div>
              </div>
              <div class="r-infoItem">
                <div class="r-infoName">결제 안내</div>
                <div class="r-infoValue">최종 확인 페이지에서 결제 정보 확인 후 진행</div>
              </div>
              <div class="r-infoItem">
                <div class="r-infoName">문의</div>
                <div class="r-infoValue"><c:out value="${accommodation.phone}" default="연락처 정보 없음"/></div>
              </div>
            </section>
          </div>

          <!-- 리뷰 -->
          <div class="tab-pane fade" id="pane-review" role="tabpanel" aria-labelledby="tab-review">
            <section class="r-section">
              <h2 class="r-sectionTitle">리뷰</h2>

              <div id="reviewList">
                <c:forEach var="rv" items="${reviews}">
                  <div class="review-item border rounded-3 p-3 mb-2" data-initial="1">
                    <div class="d-flex justify-content-between align-items-center">
                      <div class="fw-bold">${rv.user_id}</div>
                      <div style="color:#22c55e; font-weight:700;">
                        <i class="fa-solid fa-star"></i> ${rv.rating}
                      </div>
                    </div>
                    <div class="text-muted" style="font-size:12px;">
                      <fmt:formatDate value="${rv.reviewDate}" pattern="yyyy-MM-dd HH:mm"/>
                    </div>
                    <div class="mt-2">${rv.content}</div>
                  </div>
                </c:forEach>
              </div>

              <c:if test="${not empty reviews}">
				  <button id="btnMoreReviews" class="btn btn-outline-secondary w-100 mt-2"
				          data-place-id="${accommodation.placeDTO.place_id}"
				          data-offset="${reviewNextOffset}"
				          data-total="${reviewCount}">
				    더보기
				  </button>
				</c:if>

              <c:if test="${empty reviews}">
                <div class="r-muted">아직 등록된 리뷰가 없습니다.</div>
              </c:if>
            </section>
          </div>

        </div>
      </div>

      <!-- Right -->
      <div class="col-lg-4">
        <div class="r-sticky d-flex flex-column gap-3">

          <div class="card shadow-sm border-0" style="border-radius:18px;">
            <div class="card-body">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <div class="fw-bold fs-5">숙소 예약하기</div>
                <span class="badge bg-light text-dark">
                  <i class="fa-solid fa-bolt me-1"></i>빠른예약
                </span>
              </div>

              <div class="r-muted mb-3" style="font-size:14px;">
                기본 숙소 정보를 확인한 뒤 예약 페이지로 이동합니다.
              </div>

              <div class="text-center mt-3">
                <button class="btn btn-success r-reserveBtn"
                        type="button"
                        onclick="location.href='${pageContext.request.contextPath}/accReservation.rv?place_id=${accommodation.placeDTO.place_id}'">
                  예약하기
                </button>
              </div>
            </div>
          </div>

          <div class="card shadow-sm border-0" style="border-radius:18px;">
            <div class="card-body">
              <div class="fw-bold fs-5 mb-2">이 숙소 저장하기</div>
              <button id="btnFavoriteSide"
                        class="btn btn-outline-secondary w-100 fw-bold ${isFavorite ? 'is-on' : ''}"
                        type="button"
                        style="border-radius:14px;">
                <i class="${isFavorite ? 'fa-solid' : 'fa-regular'} fa-heart me-1"></i> 저장
              </button>
            </div>
          </div>

          <div class="card shadow-sm border-0" style="border-radius:18px;">
            <div class="card-body">
              <div class="fw-bold fs-5 mb-2">기본 정보</div>
              <div class="r-muted" style="font-size:14px; line-height:1.8;">
                <div><b class="text-dark">카테고리</b> <c:out value="${accommodation.category}" default="정보 없음"/></div>
                <div><b class="text-dark">숙소 상태</b> <c:out value="${accommodation.status}" default="정보 없음"/></div>
                <div><b class="text-dark">연락처</b> <c:out value="${accommodation.phone}" default="정보 없음"/></div>
                <div><b class="text-dark">가격</b> <fmt:formatNumber value="${accommodation.price}" type="number"/>원</div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

  </div>

<script>
  const CTX = '<c:out value="${pageContext.request.contextPath}"/>';
  const PLACE_ID = '<c:out value="${accommodation.placeDTO.place_id}"/>';
</script>

<script src="${pageContext.request.contextPath}/resources/js/accommodation/accommodationDetail.js"></script>

<%@ include file="../../common/footer.jsp" %>
</body>
</html>