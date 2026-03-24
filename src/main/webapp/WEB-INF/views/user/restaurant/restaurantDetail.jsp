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
  <title>${restaurant.placeDTO.name} | 맛집 상세</title>

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
    .r-stars i{ color:#22c55e; }
    .r-score{ font-weight:800; color:var(--r-text); }

    .r-hero{
      border-radius:18px;
      overflow:hidden;
      border:1px solid var(--r-line);
      background:#f9fafb;
      position:relative;
      min-height: 420px;
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

    .r-thumb{
      border:1px solid var(--r-line);
      border-radius:16px;
      overflow:hidden;
      background:#f9fafb;
      height:124px;
      display:grid;
      grid-template-columns:110px 1fr;
      cursor:pointer;
      transition:.15s;
    }
    .r-thumb:hover{ transform:translateY(-1px); }
    .r-thumb img{
      width:110px;
      height:100%;
      object-fit:cover;
      display:block;
    }
    .r-thumbInfo{
      padding:12px;
      display:flex;
      flex-direction:column;
      justify-content:space-between;
    }
    .r-thumbTitle{ font-weight:800; font-size:14px; letter-spacing:-.01em; }
    .r-thumbSub{ color:var(--r-muted); font-size:12px; display:flex; gap:8px; align-items:center; }

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

    .r-menuItem{
      display:flex;
      align-items:flex-start;
      justify-content:space-between;
      gap:12px;
      padding:12px 0;
      border-bottom:1px dashed var(--r-line);
    }
    .r-menuItem:last-child{ border-bottom:none; }
    .r-menuName{ font-weight:900; letter-spacing:-.01em; }
    .r-menuDesc{ margin-top:4px; color:var(--r-muted); font-size:12px; line-height:1.5; }
    .r-menuPrice{ font-weight:900; white-space:nowrap; }

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
    
    .r-dateChip{
	  min-width:72px;
	  border:1px solid var(--r-line);
	  background:#fff;
	  color:var(--r-text);
	  border-radius:14px;
	  padding:10px 8px;
	  text-align:center;
	  cursor:pointer;
	  transition:.15s;
	  flex:0 0 auto;
	}
	.r-dateChip:hover{
	  transform:translateY(-1px);
	}
	.r-dateChip.is-active{
	  background:var(--r-brand);
	  color:#fff;
	  border-color:var(--r-brand);
	}
	
	.r-dateTop{
	  font-size:12px;
	  font-weight:700;
	  opacity:.9;
	}
	.r-dateBottom{
	  font-size:15px;
	  font-weight:900;
	  margin-top:2px;
	}
	
	/* 범례 */
	.r-slotLegend{
	  display:flex;
	  gap:12px;
	  flex-wrap:wrap;
	  margin-bottom:12px;
	}
	.r-legendItem{
	  display:flex;
	  align-items:center;
	  gap:6px;
	  font-size:12px;
	  font-weight:700;
	  color:var(--r-muted);
	}
	.r-legendDot{
	  width:10px;
	  height:10px;
	  border-radius:50%;
	  display:inline-block;
	}
	.r-legendDot.is-available{
	  background:#22c55e;
	}
	.r-legendDot.is-disabled{
	  background:#9ca3af;
	}
	
	/* 시간 슬롯 */
	.r-timeSlot{
	  display:flex;
	  align-items:center;
	  justify-content:space-between;
	  gap:10px;
	  border:1px solid var(--r-line);
	  background:#fff;
	  border-radius:14px;
	  padding:12px 14px;
	  font-weight:700;
	  color:var(--r-text);
	  transition:.15s;
	}
	
	.r-timeSlot.is-available{
	  background:#f0fdf4;
	  border-color:#86efac;
	  color:#166534;
	}
	
	.r-timeSlot.is-disabled{
	  background:#f3f4f6;
	  color:#9ca3af;
	  border-color:#d1d5db;
	}
	
	.r-timeText{
	  font-weight:800;
	}
	
	.r-slotBadge{
	  font-size:12px;
	  font-weight:800;
	  padding:5px 10px;
	  border-radius:999px;
	  white-space:nowrap;
	  flex:0 0 auto;
	}
	
	.r-slotBadge.is-available{
	  background:#dcfce7;
	  color:#166534;
	}
	
	.r-slotBadge.is-disabled{
	  background:#e5e7eb;
	  color:#6b7280;
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
          <h1 class="r-placeName">${restaurant.placeDTO.name}</h1>
          <span class="r-pill">${restaurant.placeDTO.place_type}</span>
          <span class="r-pill">${restaurant.category}</span>
        </div>

        <div class="d-flex flex-wrap align-items-center gap-2 mt-2 r-muted">
          <div class="d-flex align-items-center gap-2 r-stars">
            <i class="fa-solid fa-star"></i>
            <span class="r-score">
              <fmt:formatNumber value="${restaurant.placeDTO.avg_rating}" pattern="0.0"/>
            </span>
            <span>(${restaurant.placeDTO.review_count}개)</span>
          </div>
          <span>·</span>
          <span>${restaurant.placeDTO.address}</span>
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

        <!-- 이미지 영역 -->
    <div class="row g-3 mb-3">
      <div class="col-lg-8">
        <div class="r-hero shadow-sm">
          <img src="<c:out value='${restaurant.placeDTO.image_url}' default='${pageContext.request.contextPath}/resources/img/sample_food.jpg'/>" alt="대표 이미지"/>
          <div class="r-heroCount">
            <i class="fa-regular fa-images"></i>
            <span>대표</span>
          </div>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="card shadow-sm border-0 h-100" style="border-radius:18px;">
          <div class="card-body p-3">
            <div class="d-flex justify-content-between align-items-center mb-2">
              <div class="fw-bold" style="font-size:18px;">예약 가능 일정</div>
              <span class="badge bg-light text-dark">+7일</span>
            </div>

            <!-- 날짜 슬라이드 영역 -->
            <div id="reserveDateSlider" class="d-flex gap-2 mb-2" style="overflow-x:auto; white-space:nowrap; padding-bottom:4px;">
              <!-- JS로 날짜 버튼 들어갈 자리 -->
            </div>

            <!-- 범례 -->
            <div class="r-slotLegend">
              <span class="r-legendItem">
                <span class="r-legendDot is-available"></span> 가능
              </span>
              <span class="r-legendItem">
                <span class="r-legendDot is-disabled"></span> 마감
              </span>
            </div>

            <!-- 시간 슬롯 영역 -->
            <div id="reserveTimeSlots" class="d-grid gap-2">
              <!-- JS로 시간 슬롯 들어갈 자리 -->
            </div>

            <input type="hidden" id="selectedReserveDate" value="">

            <div class="r-muted mt-2" style="font-size:12px;">
              날짜를 선택하면 예약 현황이 표시됩니다.
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
        <button class="nav-link fw-bold" id="tab-time" data-bs-toggle="tab" data-bs-target="#pane-time" type="button" role="tab">
          운영 정보
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold" id="tab-location" data-bs-toggle="tab" data-bs-target="#pane-location" type="button" role="tab">
          위치
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold" id="tab-menu" data-bs-toggle="tab" data-bs-target="#pane-menu" type="button" role="tab">
          메뉴
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
              <h2 class="r-sectionTitle">한눈에 보기</h2>
              <p class="r-lead">
                <c:out value="${restaurant.description}" default="등록된 소개 정보가 없습니다."/>
              </p>

              <div class="mt-3">
                <span class="r-chip"><i class="fa-solid fa-utensils"></i> <c:out value="${restaurant.category}" default="카테고리 정보 없음"/></span>
                <span class="r-chip"><i class="fa-solid fa-phone"></i> <c:out value="${restaurant.phone}" default="연락처 정보 없음"/></span>
                <span class="r-chip"><i class="fa-solid fa-store"></i> <c:out value="${restaurant.status}" default="영업 상태 정보 없음"/></span>
              </div>
            </section>
          </div>

          <!-- 운영 정보 -->
          <div class="tab-pane fade" id="pane-time" role="tabpanel" aria-labelledby="tab-time">
            <section class="r-section">
              <h2 class="r-sectionTitle">운영 정보</h2>

              <div class="r-lead mb-2">
                <b class="text-dark">영업 상태</b> :
                <c:out value="${restaurant.status}" default="정보 없음"/>
              </div>

              <div class="r-lead mb-2">
                <b class="text-dark">휴무/비고</b> :
                <c:out value="${restaurant.restdate}" default="정보 없음"/>
              </div>

              <div class="r-lead mb-2">
                <b class="text-dark">전화번호</b> :
                <c:out value="${restaurant.phone}" default="정보 없음"/>
              </div>

              <div class="r-lead">
                <b class="text-dark">지역 코드</b> :
                <c:out value="${restaurant.areaCode}" default="정보 없음"/>
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
                  src="https://www.google.com/maps?q=${restaurant.placeDTO.latitude},${restaurant.placeDTO.longitude}&hl=ko&z=16&output=embed">
                </iframe>
              </div>

              <div class="d-flex justify-content-between align-items-start gap-3">
                <div class="r-muted">
                  <div class="fw-bold text-dark mb-1">
                    <i class="fa-solid fa-location-dot" style="color:var(--r-brand);"></i>
                    ${restaurant.placeDTO.address}
                  </div>
                  <div>
                    위도: ${restaurant.placeDTO.latitude} / 경도: ${restaurant.placeDTO.longitude}
                  </div>
                </div>

                <button class="btn btn-outline-secondary fw-bold" type="button"
                        onclick="window.open('https://map.naver.com/v5/search/' + encodeURIComponent('${restaurant.placeDTO.address}'));">
                  길찾기
                </button>
              </div>
            </section>
          </div>

          <!-- 메뉴 -->
          <div class="tab-pane fade" id="pane-menu" role="tabpanel" aria-labelledby="tab-menu">
            <section class="r-section">
              <h2 class="r-sectionTitle">메뉴</h2>

              <div class="row">
                <div class="col-md-6">
                  <c:forEach var="m" items="${menuList}" begin="0" end="5">
                    <div class="r-menuItem">
                      <div>
                        <div class="r-menuName">${m.name}</div>
                        <div class="r-menuDesc">${m.description}</div>
                      </div>
                      <div class="r-menuPrice">
                        <fmt:formatNumber value="${m.price}" type="number"/>원
                      </div>
                    </div>
                  </c:forEach>
                </div>

                <div class="col-md-6">
                  <c:forEach var="m" items="${menuList}" begin="6" end="11">
                    <div class="r-menuItem">
                      <div>
                        <div class="r-menuName">${m.name}</div>
                        <div class="r-menuDesc">${m.description}</div>
                      </div>
                      <div class="r-menuPrice">
                        <fmt:formatNumber value="${m.price}" type="number"/>원
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </div>

              <c:if test="${empty menuList}">
                <div class="r-muted">등록된 메뉴가 없습니다.</div>
              </c:if>

              <div class="mt-3 r-muted" style="font-size:13px;">
                * 메뉴/가격은 매장 사정에 따라 변동될 수 있습니다.
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
                        data-place-id="${restaurant.placeDTO.place_id}"
                        data-offset="${reviewNextOffset}"
                        data-total="${reviewTotalCount}">
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
                <div class="fw-bold fs-5">테이블 예약하기</div>
                <span class="badge bg-light text-dark">
                  <i class="fa-solid fa-bolt me-1"></i>빠른예약
                </span>
              </div>

              <div class="text-center mt-3">
                <button class="btn btn-success r-reserveBtn"
				        type="button"
				        onclick="location.href='${pageContext.request.contextPath}/restaurantReserve.rs?place_id=${restaurant.placeDTO.place_id}'">
				  예약하기
				</button>
              </div>
            </div>
          </div>

          <div class="card shadow-sm border-0" style="border-radius:18px;">
            <div class="card-body">
              <div class="fw-bold fs-5 mb-2">이 음식점 저장하기</div>
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
              <div class="fw-bold fs-5 mb-2">운영 정보</div>
              <div class="r-muted" style="font-size:14px; line-height:1.8;">
                <div><b class="text-dark">카테고리</b> <c:out value="${restaurant.category}" default="정보 없음"/></div>
                <div><b class="text-dark">영업 상태</b> <c:out value="${restaurant.status}" default="정보 없음"/></div>
                <div><b class="text-dark">휴무/비고</b> <c:out value="${restaurant.restdate}" default="정보 없음"/></div>
                <div><b class="text-dark">연락처</b> <c:out value="${restaurant.phone}" default="정보 없음"/></div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

  </div>

<script>
  const CTX = '<c:out value="${pageContext.request.contextPath}"/>';
  const PLACE_ID = '<c:out value="${restaurant.placeDTO.place_id}"/>';
</script>

<script src="${pageContext.request.contextPath}/resources/js/restaurant/restaurantDetail.js"></script>

<%@ include file="../../common/footer.jsp" %>
</body>
</html>