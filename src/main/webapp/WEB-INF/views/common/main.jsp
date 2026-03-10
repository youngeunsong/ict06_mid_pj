<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="setting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>main</title>

<%@ include file="bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/common/main.css">
<link rel="stylesheet" href="${path}/resources/css/common/bookmark.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script><!-- 아이콘 -->

<script src="${path}/resources/js/user/main.js" defer></script>
<script src="${path}/resources/js/search/bookmark.js" defer></script>

</head>
<body>
<div class="wrap">

  <!-- header -->
  <%@ include file="header.jsp" %>

  <!-- 컨텐츠 시작 -->
  <!-- 메인 배너S -->
  <section class="position-relative">
    <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4000">
      <!-- [메인배너] 전체 이미지 -->
      <div class="carousel-inner">
		<!-- 배너1 -->
        <div class="carousel-item active">
          <img src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=1400&q=80" alt="도쿄"/>
          <div class="carousel-caption">
            <h5>도쿄의 빛나는 야경</h5>
            <p>일본의 심장, 도쿄에서 특별한 밤을</p>
          </div>
        </div>

		<!-- 배너2 -->
        <div class="carousel-item">
          <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=1400&q=80" alt="사막"/>
          <div class="carousel-caption">
            <h5>황금빛 사막의 노을</h5>
            <p>대자연이 선사하는 감동의 풍경</p>
          </div>
        </div>
        
		<!-- 배너3 -->
        <div class="carousel-item">
          <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1400&q=80" alt="설산"/>
          <div class="carousel-caption">
            <h5>웅장한 설산의 경치</h5>
            <p>하늘과 맞닿은 그곳으로</p>
          </div>
        </div>

		<!-- 배너4 -->
        <div class="carousel-item">
          <img src="https://images.unsplash.com/photo-1501854140801-50d01698950b?w=1400&q=80" alt="산"/>
          <div class="carousel-caption">
            <h5>초록 숲의 힐링 여행</h5>
            <p>자연 속에서 찾는 완전한 휴식</p>
          </div>
        </div>

		<!-- 배너5 -->
        <div class="carousel-item">
          <img src="https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=1400&q=80" alt="바다"/>
          <div class="carousel-caption">
            <h5>에메랄드빛 해변</h5>
            <p>눈부신 바다가 기다리는 그곳</p>
          </div>
        </div>
      </div>

	  <!-- [메인배너] 스크롤 버튼 -->
      <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>

	  <!-- [메인배너] 미리보기 이미지 -->
      <div class="hero-thumbs d-none d-md-flex">
        <img class="hero-thumb active" src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=200&q=60" data-bs-target="#heroCarousel" data-bs-slide-to="0"/>
        <img class="hero-thumb" src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=60" data-bs-target="#heroCarousel" data-bs-slide-to="1"/>
        <img class="hero-thumb" src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200&q=60" data-bs-target="#heroCarousel" data-bs-slide-to="2"/>
        <img class="hero-thumb" src="https://images.unsplash.com/photo-1501854140801-50d01698950b?w=200&q=60" data-bs-target="#heroCarousel" data-bs-slide-to="3"/>
        <img class="hero-thumb" src="https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=200&q=60" data-bs-target="#heroCarousel" data-bs-slide-to="4"/>
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
              <button class="btn btn-sm btn-outline-success dropdown-toggle fw-bold px-2 py-0"
                      type="button"
                      id="categoryDropdown"
                      data-bs-toggle="dropdown"
                      aria-expanded="false"
                      style="font-size:1rem; border-radius:6px;">
                맛집
              </button>
              <ul class="dropdown-menu dropdown-menu-start shadow-sm"
                  aria-labelledby="categoryDropdown"
                  style="min-width:100px; font-size:.88rem;">
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
            <i class="bi bi-fire text-warning ms-1" style="font-size:1rem;"></i>
          </div>
          	
          <!-- 하단 설명 글 -->
          <p class="section-subtitle" id="top10Subtitle">이번 주 가장 많은 사람들이 찾아본 맛집 TOP 10</p>
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
        
        <!-- 맛집/ 숙소 카드 노출 -->
        <%@ include file="main_top10.jsp" %>
		
		<!-- 오른쪽 버튼(next) -->
        <button class="scroll-btn next" onclick="scrollCards(1)">
          <i class="bi bi-chevron-right"></i>
        </button>
      </div>

      <div class="dot-pager mt-3" id="top10Dots">
        <span class="active"></span><span></span>
      </div>

    </div>
  </section>
  <!-- 금주의 TOP10E -->


  <!-- BEST 추천 -->
  <section class="section-wrap">
    <div class="container">
      <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
        <h2 class="section-title">BEST 추천 <span class="badge-new">BEST</span></h2>
        <ul class="nav best-tabs flex-nowrap overflow-auto">
          <li class="nav-item"><a class="nav-link active" href="#">전체</a></li>
          <li class="nav-item"><a class="nav-link" href="#">맛집</a></li>
          <li class="nav-item"><a class="nav-link" href="#">숙소</a></li>
          <li class="nav-item"><a class="nav-link" href="#">축제</a></li>
        </ul>
      </div>

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

            <div class="col-6">
              <div class="best-sub-card card">
                <div class="img-wrap">
                  <img src="https://images.unsplash.com/photo-1534430480872-3498386e7856?w=400&q=80" alt="교토"/>
                </div>
                <div class="card-body">
                  <div class="card-region"><i class="bi bi-geo-alt-fill text-danger me-1"></i>일본 · 교토</div>
                  <div class="card-title">교토 전통문화 투어 2박 3일</div>
                  <div class="card-price"><span class="discount-badge">30%</span>699,000원</div>
                </div>
              </div>
            </div>

            <div class="col-6">
              <div class="best-sub-card card">
                <div class="img-wrap">
                  <img src="https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=400&q=80" alt="산토리니"/>
                </div>
                <div class="card-body">
                  <div class="card-region"><i class="bi bi-geo-alt-fill text-danger me-1"></i>그리스 · 산토리니</div>
                  <div class="card-title">산토리니 에게해 로맨스 5일</div>
                  <div class="card-price"><span class="discount-badge">20%</span>1,890,000원</div>
                </div>
              </div>
            </div>

            <div class="col-6">
              <div class="best-sub-card card">
                <div class="img-wrap">
                  <img src="https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=400&q=80" alt="인도"/>
                </div>
                <div class="card-body">
                  <div class="card-region"><i class="bi bi-geo-alt-fill text-danger me-1"></i>인도 · 타지마할</div>
                  <div class="card-title">인도 문화 탐방 6박 7일</div>
                  <div class="card-price"><span class="discount-badge">15%</span>1,290,000원</div>
                </div>
              </div>
            </div>

            <div class="col-6">
              <div class="best-sub-card card">
                <div class="img-wrap">
                  <img src="https://images.unsplash.com/photo-1548013146-72479768bada?w=400&q=80" alt="방콕"/>
                </div>
                <div class="card-body">
                  <div class="card-region"><i class="bi bi-geo-alt-fill text-danger me-1"></i>태국 · 방콕</div>
                  <div class="card-title">방콕 자유여행 3박 4일</div>
                  <div class="card-price"><span class="discount-badge">25%</span>598,000원</div>
                </div>
              </div>
            </div>

          </div>
        </div>
      </div>
    </div>
  </section>


  <!-- ====================================================
       4. 이달의 추천 국내 축제
  ===================================================== -->
  <section class="section-wrap festival-section">
    <div class="container">
      <div class="d-flex align-items-center justify-content-between mb-3">
        <div>
          <h2 class="section-title">
            <i class="bi bi-calendar-event-fill me-1" style="color:var(--primary);"></i>
            이달의 추천 국내 축제
          </h2>
          <p class="section-subtitle">3월에 꼭 가봐야 할 국내 축제 모음</p>
        </div>
        <a href="#" class="view-all">전체보기 <i class="bi bi-chevron-right"></i></a>
      </div>

      <div class="row g-3 mb-3">
        <div class="col-6 col-md-3">
          <div class="festival-card card h-100">
            <div class="img-wrap">
              <img src="https://images.unsplash.com/photo-1495562569060-2eec283d3391?w=400&q=80" alt="벚꽃축제"/>
              <span class="period-badge">3.22 ~ 3.31</span>
            </div>
            <div class="card-body">
              <div class="card-title">진해 군항제 벚꽃축제</div>
              <div class="card-loc"><i class="bi bi-geo-alt-fill"></i>경남 창원시</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="festival-card card h-100">
            <div class="img-wrap">
              <img src="https://images.unsplash.com/photo-1519750783826-e2420f4d687f?w=400&q=80" alt="산수유"/>
              <span class="period-badge">3.14 ~ 3.24</span>
            </div>
            <div class="card-body">
              <div class="card-title">구례 산수유꽃 축제</div>
              <div class="card-loc"><i class="bi bi-geo-alt-fill"></i>전남 구례군</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="festival-card card h-100">
            <div class="img-wrap">
              <img src="https://images.unsplash.com/photo-1547394765-185e1e68f34e?w=400&q=80" alt="매화"/>
              <span class="period-badge">3.08 ~ 3.17</span>
            </div>
            <div class="card-body">
              <div class="card-title">광양 매화문화축제</div>
              <div class="card-loc"><i class="bi bi-geo-alt-fill"></i>전남 광양시</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="festival-card card h-100">
            <div class="img-wrap">
              <img src="https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=400&q=80" alt="영등포"/>
              <span class="period-badge">3.28 ~ 4.06</span>
            </div>
            <div class="card-body">
              <div class="card-title">여의도 봄꽃 축제</div>
              <div class="card-loc"><i class="bi bi-geo-alt-fill"></i>서울 영등포</div>
            </div>
          </div>
        </div>
      </div>

      <div class="row g-3">
        <div class="col-6 col-md-3">
          <div class="festival-card card h-100">
            <div class="img-wrap">
              <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80" alt="대구"/>
              <span class="period-badge">3.29 ~ 4.07</span>
            </div>
            <div class="card-body">
              <div class="card-title">대구 이월드 별빛 축제</div>
              <div class="card-loc"><i class="bi bi-geo-alt-fill"></i>대구 서구</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="festival-card card h-100">
            <div class="img-wrap">
              <img src="https://images.unsplash.com/photo-1523482580672-f109ba8cb9be?w=400&q=80" alt="전주"/>
              <span class="period-badge">3.01 ~ 3.31</span>
            </div>
            <div class="card-body">
              <div class="card-title">전주 한옥마을 봄 문화제</div>
              <div class="card-loc"><i class="bi bi-geo-alt-fill"></i>전북 전주시</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="festival-card card h-100">
            <div class="img-wrap">
              <img src="https://images.unsplash.com/photo-1501854140801-50d01698950b?w=400&q=80" alt="제주"/>
              <span class="period-badge">3.15 ~ 3.25</span>
            </div>
            <div class="card-body">
              <div class="card-title">제주 유채꽃 국제걷기대회</div>
              <div class="card-loc"><i class="bi bi-geo-alt-fill"></i>제주 서귀포</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="festival-card card h-100">
            <div class="img-wrap">
              <img src="https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=400&q=80" alt="통영"/>
              <span class="period-badge">3.21 ~ 3.30</span>
            </div>
            <div class="card-body">
              <div class="card-title">통영 한산대첩 봄 문화제</div>
              <div class="card-loc"><i class="bi bi-geo-alt-fill"></i>경남 통영시</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>


  <!-- ====================================================
       5. 공지사항
  ===================================================== -->
  <section class="notice-section">
    <div class="container">
      <div class="d-flex align-items-center justify-content-between mb-2">
        <h2 class="section-title">공지사항</h2>
        <a href="#" class="view-all">전체보기 <i class="bi bi-chevron-right"></i></a>
      </div>

      <ul class="nav notice-tabs border-bottom mb-3">
        <li class="nav-item"><a class="nav-link active" href="#">공지사항</a></li>
        <li class="nav-item"><a class="nav-link" href="#">이벤트</a></li>
        <li class="nav-item"><a class="nav-link" href="#">자주묻는질문</a></li>
      </ul>

      <table class="table notice-table mb-0">
        <tbody>
          <tr>
            <td width="50"><span class="badge bg-success" style="font-size:.7rem;">공지</span></td>
            <td>
              <a href="#" class="notice-title">
                [중요] 2025년 봄 시즌 여행상품 특가 이벤트 안내
                <span class="notice-new">NEW</span>
              </a>
            </td>
            <td class="date-col text-end">2026.03.09</td>
          </tr>
          <tr>
            <td><span class="badge bg-warning text-dark" style="font-size:.7rem;">이벤트</span></td>
            <td><a href="#" class="notice-title">봄맞이 국내여행 최대 40% 할인 프로모션</a></td>
            <td class="date-col text-end">2026.03.07</td>
          </tr>
          <tr>
            <td><span class="text-muted" style="font-size:.8rem;">일반</span></td>
            <td><a href="#" class="notice-title">일본 노선 항공권 얼리버드 예약 안내</a></td>
            <td class="date-col text-end">2026.03.05</td>
          </tr>
          <tr>
            <td><span class="text-muted" style="font-size:.8rem;">일반</span></td>
            <td><a href="#" class="notice-title">3월 여행박람회 참가 업체 모집 공고</a></td>
            <td class="date-col text-end">2026.03.03</td>
          </tr>
          <tr>
            <td><span class="text-muted" style="font-size:.8rem;">일반</span></td>
            <td><a href="#" class="notice-title">앱 리뉴얼 업데이트 안내 및 이용방법 변경 사항</a></td>
            <td class="date-col text-end">2026.02.28</td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>


  <!-- ====================================================
       6. 프로모션 배너
  ===================================================== -->
  <section class="py-4">
    <div class="container">
      <div class="row g-3">
        <div class="col-12 col-md-6">
          <div class="promo-banner promo-banner-a">
            <div class="promo-overlay">
              <div class="promo-title">✈️ 얼리버드 특가<br/>항공+숙박 묶음</div>
              <div class="promo-sub">지금 예약하면 최대 50% 할인!</div>
            </div>
          </div>
        </div>
        <div class="col-12 col-md-6">
          <div class="promo-banner promo-banner-b">
            <div class="promo-overlay">
              <div class="promo-title">🎁 신규 회원 가입 혜택<br/>즉시 5만원 쿠폰 지급</div>
              <div class="promo-sub">오늘만! 가입 즉시 사용 가능</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <!-- 컨텐츠 끝 -->

  <!-- footer -->
  <%@ include file="footer.jsp" %>

</div>
</body>
</html>
