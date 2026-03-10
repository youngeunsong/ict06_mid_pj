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
  <title>${restaurant.name} | 맛집 상세</title>

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

    /* 공통 */
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

    /* 상단 타이틀 */
    .r-placeName{
      font-size:34px;
      line-height:1.15;
      font-weight:800;
      letter-spacing:-.02em;
      margin:0;
    }
    .r-stars i{ color:#22c55e; }
    .r-score{ font-weight:800; color:var(--r-text); }

    /* 갤러리 */
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
      height: 124px;
      display:grid;
      grid-template-columns: 110px 1fr;
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

    /* 섹션 */
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

    /* 지도 */
    .r-mapBox{
      border:1px solid var(--r-line);
      border-radius:18px;
      overflow:hidden;
      height:240px;
      background:#f9fafb;
    }

    /* 메뉴 */
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

    /* 오른쪽 예약 버튼 */
    .r-reserveBtn{
      width: 220px;
      height: 44px;
      border-radius:999px;
      font-weight:900;
    }

    /* sticky 사이드 */
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

    <!-- ===== 상단 헤더 ===== -->
    <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">
      <div>
        <div class="d-flex flex-wrap align-items-center gap-2">
          <h1 class="r-placeName">${restaurant.name}</h1>
          <span class="r-pill">${restaurant.place_type}</span>
          <span class="r-pill">${restaurant.address}</span>
        </div>

        <div class="d-flex flex-wrap align-items-center gap-2 mt-2 r-muted">
          <div class="d-flex align-items-center gap-2 r-stars">
            <i class="fa-solid fa-star"></i>
            <span class="r-score">0.0</span>
			<span>(0개)</span>
          </div>
          <span>·</span>
          <span>${restaurant.address}</span>
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

    <!-- ===== 이미지 갤러리 ===== -->
    <div class="row g-3 mb-3">
      <div class="col-lg-8">
        <div class="r-hero shadow-sm">
          <img src="<c:out value='${restaurant.image_url}' default='/resources/img/sample_food.jpg'/>" alt="대표 이미지"/>
          <div class="r-heroCount">
            <i class="fa-regular fa-images"></i>
            <span>0+</span>
          </div>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="d-flex flex-lg-column flex-row gap-3">
          <div class="r-thumb shadow-sm">
            <img src="<c:out value='${restaurant.image_url}' default='/resources/img/sample_thumb1.jpg'/>" alt="thumb1"/>
            <div class="r-thumbInfo">
              <div class="r-thumbTitle">인테리어</div>
              <div class="r-thumbSub"><i class="fa-regular fa-image"></i><span> 0</span></div>
            </div>
          </div>

          <div class="r-thumb shadow-sm">
           <img src="<c:out value='${restaurant.image_url}' default='/resources/img/sample_thumb1.jpg'/>" alt="thumb1"/>
            <div class="r-thumbInfo">
              <div class="r-thumbTitle">음식</div>
              <div class="r-thumbSub"><i class="fa-regular fa-image"></i><span> 0</span></div>
            </div>
          </div>

          <div class="r-thumb shadow-sm">
            <img src="<c:out value='${restaurant.image_url}' default='/resources/img/sample_thumb1.jpg'/>" alt="thumb1"/>
            <div class="r-thumbInfo">
              <div class="r-thumbTitle">메뉴</div>
              <div class="r-thumbSub"><i class="fa-regular fa-image"></i> <span>0</span></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== Bootstrap 탭 ===== -->
    <ul class="nav nav-tabs mb-3" id="detailTabs" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active fw-bold" id="tab-overview" data-bs-toggle="tab" data-bs-target="#pane-overview" type="button" role="tab">
          개요
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold" id="tab-time" data-bs-toggle="tab" data-bs-target="#pane-time" type="button" role="tab">
          시간
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
				  이곳은 따뜻한 분위기에서 식사를 즐길 수 있는 공간입니다.
			  </p>

              <div class="mt-3">
				  <span class="r-chip"><i class="fa-solid fa-check"></i> 깔끔한 매장</span>
				  <span class="r-chip"><i class="fa-solid fa-check"></i> 친절한 서비스</span>
				  <span class="r-chip"><i class="fa-solid fa-check"></i> 인기 메뉴</span>
				</div>
            </section>
          </div>

          <!-- 시간 -->
          <div class="tab-pane fade" id="pane-time" role="tabpanel" aria-labelledby="tab-time">
            <section class="r-section">
              <h2 class="r-sectionTitle">시간</h2>
              <p class="r-lead">
				  월~일 10:00 ~ 22:00 (라스트오더 21:00)
				</p>
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
                  src="https://www.google.com/maps?q=${restaurant.latitude},${restaurant.longitude}&hl=ko&z=16&output=embed">
                </iframe>
              </div>

              <div class="d-flex justify-content-between align-items-start gap-3">
                <div class="r-muted">
                  <div class="fw-bold text-dark mb-1">
                    <i class="fa-solid fa-location-dot" style="color:var(--r-brand);"></i>
                    ${restaurant.address}
                  </div>
                  <div>-</div>
                </div>

                <button class="btn btn-outline-secondary fw-bold" type="button">길찾기</button>
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
                <div class="fw-bold">${rv.user_id}</div>
                <div class="text-muted" style="font-size:12px;">
                  <fmt:formatDate value="${rv.reviewDate}" pattern="yyyy-MM-dd HH:mm"/>
                </div>
                <div class="mt-2">${rv.content}</div>
              </div>
            </c:forEach>
          </div>

          <c:if test="${not empty reviews}">
            <button id="btnMoreReviews" class="btn btn-outline-secondary w-100 mt-2"
                    data-place-id="${place_id}"
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

    </div> <!-- ✅ /.tab-content -->
  </div>   <!-- ✅ /.col-lg-8 -->

	  <!-- Right -->
	  <div class="col-lg-4">
        <div class="r-sticky d-flex flex-column gap-3">

          <!-- 예약 카드 -->
          <div class="card shadow-sm border-0" style="border-radius:18px;">
            <div class="card-body">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <div class="fw-bold fs-5">테이블 예약하기</div>
                <span class="badge bg-light text-dark">
                  <i class="fa-solid fa-bolt me-1"></i>빠른예약
                </span>
              </div>

              <div class="text-center mt-3">
                <button class="btn btn-success r-reserveBtn">
                  예약하기
                </button>
              </div>
            </div>
          </div>

          <!-- 저장 카드 -->
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

          <!-- 영업시간 카드 -->
          <div class="card shadow-sm border-0" style="border-radius:18px;">
            <div class="card-body">
              <div class="fw-bold fs-5 mb-2">영업시간</div>
              <div class="r-muted" style="font-size:14px; line-height:1.8;">
                <div><b class="text-dark">월요일</b> 10:00 - 22:00</div>
                <div><b class="text-dark">화요일</b> 10:00 - 22:00</div>
                <div><b class="text-dark">수요일</b> 10:00 - 22:00</div>
                <div><b class="text-dark">목요일</b> 10:00 - 22:00</div>
                <div><b class="text-dark">금요일</b> 10:00 - 23:00</div>
                <div><b class="text-dark">토요일</b> 10:00 - 23:00</div>
                <div><b class="text-dark">일요일</b> 10:00 - 22:00</div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

  </div>
  <script>
  var CTX = '<c:out value="${pageContext.request.contextPath}"/>';
	</script>
<script>
document.addEventListener("DOMContentLoaded", function(){
  var CTX = '<c:out value="${pageContext.request.contextPath}"/>';
  var PLACE_ID = '<c:out value="${place_id}"/>';

  // =========================
  // 1) 더보기 / 접기
  // =========================
  var btnMore = document.getElementById("btnMoreReviews");
  if(btnMore){
    btnMore.dataset.mode = "more";

    btnMore.addEventListener("click", function(){
      if(btnMore.dataset.mode === "collapse"){
        collapseReviews();
        return;
      }
      loadMore();
    });

    function loadMore(){
      var offset = parseInt(btnMore.getAttribute("data-offset") || "0", 10);
      var limit = 5;
      var total = parseInt(btnMore.getAttribute("data-total") || "0", 10);

      if(!PLACE_ID){
        console.error("PLACE_ID is empty. model.addAttribute('place_id', place_id) 확인");
        return;
      }

      var url = CTX + "/restaurantReviewMore.rs"
              + "?place_id=" + encodeURIComponent(PLACE_ID)
              + "&offset=" + encodeURIComponent(offset)
              + "&limit=" + encodeURIComponent(limit);

      fetch(url)
        .then(function(res){
          if(!res.ok){
            return res.text().then(function(t){ throw new Error("HTTP " + res.status + ": " + t); });
          }
          return res.json();
        })
        .then(function(list){
          if(!list || list.length === 0){
            btnMore.textContent = "접기";
            btnMore.dataset.mode = "collapse";
            return;
          }

          var wrap = document.getElementById("reviewList");

          list.forEach(function(rv){
            var div = document.createElement("div");
            div.className = "review-item border rounded-3 p-3 mb-2";
            div.setAttribute("data-loaded", "1");

            div.innerHTML =
                '<div class="fw-bold">' + escapeHtml(rv.user_id || "") + '</div>'
              + '<div class="text-muted" style="font-size:12px;">' + formatDate(rv.reviewDate) + '</div>'
              + '<div class="mt-2">' + escapeHtml(rv.content || "") + '</div>';

            wrap.appendChild(div);
          });

          var newOffset = offset + list.length;
          btnMore.setAttribute("data-offset", String(newOffset));

          if(total > 0 && newOffset >= total){
            btnMore.textContent = "접기";
            btnMore.dataset.mode = "collapse";
          }
        })
        .catch(function(err){
          console.error(err);
        });
    }

    function collapseReviews(){
      var wrap = document.getElementById("reviewList");
      wrap.querySelectorAll('[data-loaded="1"]').forEach(function(el){ el.remove(); });

      btnMore.setAttribute("data-offset", "5");
      btnMore.textContent = "더보기";
      btnMore.dataset.mode = "more";
    }
  }

  // =========================
  // 2) 즐겨찾기(저장) 토글
  // =========================
  var btnFav = document.getElementById("btnFavorite");
  var btnFavSide = document.getElementById("btnFavoriteSide");

  function applyFavoriteState(isOn){
    [btnFav, btnFavSide].forEach(function(btn){
      if(!btn) return;

      var icon = btn.querySelector("i");
      if(isOn){
        btn.classList.add("is-on");
        if(icon){
          icon.classList.remove("fa-regular");
          icon.classList.add("fa-solid");
        }
      }else{
        btn.classList.remove("is-on");
        if(icon){
          icon.classList.remove("fa-solid");
          icon.classList.add("fa-regular");
        }
      }
    });
  }

  function bindFavoriteButton(btn){
    if(!btn) return;

    btn.addEventListener("click", function(){
      if(!PLACE_ID){
        console.error("PLACE_ID is empty");
        return;
      }

      fetch(CTX + "/favoriteToggle.rs?place_id=" + encodeURIComponent(PLACE_ID))
        .then(function(res){
          if(!res.ok){
            return res.text().then(function(t){ throw new Error("HTTP " + res.status + ": " + t); });
          }
          return res.json();
        })
        .then(function(data){
          if(data.needLogin){
            alert("로그인이 필요합니다.");
            location.href = CTX + "/login.do";
            return;
          }
          if(!data.ok) return;

          applyFavoriteState(data.favorite);
        })
        .catch(function(err){
          console.error(err);
        });
    });
  }

  bindFavoriteButton(btnFav);
  bindFavoriteButton(btnFavSide);

  // =========================
  // util
  // =========================
  function formatDate(v){
    if(v === null || v === undefined || v === "") return "";

    var d = new Date(Number(v));
    if(isNaN(d.getTime())) d = new Date(v);
    if(isNaN(d.getTime())) return String(v);

    var y = d.getFullYear();
    var m = String(d.getMonth()+1).padStart(2,"0");
    var day = String(d.getDate()).padStart(2,"0");
    var hh = String(d.getHours()).padStart(2,"0");
    var mm = String(d.getMinutes()).padStart(2,"0");
    return y + "-" + m + "-" + day + " " + hh + ":" + mm;
  }

  function escapeHtml(s){
    return String(s).replace(/[&<>"']/g, function(c){
      return {"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c];
    });
  }
});
</script>
  <%@ include file="../../common/footer.jsp" %>
</body>
</html>