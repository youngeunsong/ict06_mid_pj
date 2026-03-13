<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><c:choose><c:when test="${category == 'EVENT'}">이벤트</c:when><c:otherwise>공지사항</c:otherwise></c:choose> - 맛집내</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<link rel="stylesheet" href="${path}/resources/css/common/main.css">
<style>
  * { box-sizing: border-box; }
  body { font-family: 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif; background: #f4f6f8; margin: 0; font-size: 14px; }
  :root { --primary: #198754; --primary-dark: #0f5c38; --primary-light: #e8f5e9; --event: #f59e0b; --event-light: #fff8e1; }

  /* ── 헤더 ── */
  .site-header {
    background: #fff; border-bottom: 1px solid #e9ecef;
    height: 56px; display: flex; align-items: center;
    padding: 0 32px; justify-content: space-between;
    position: sticky; top: 0; z-index: 200;
    box-shadow: 0 1px 4px rgba(0,0,0,.05);
  }
  .logo  { font-weight: 800; font-size: 1.15rem; color: var(--primary); letter-spacing: -0.5px; }
  .gnb   { display: flex; gap: 24px; }
  .gnb a { font-size: .875rem; color: #495057; text-decoration: none; font-weight: 500; }
  .gnb a.on { color: var(--primary); font-weight: 700; border-bottom: 2px solid var(--primary); padding-bottom: 1px; }
  .hd-btns { display: flex; gap: 8px; }
  .btn-sm-outline { border: 1px solid #dee2e6; background: #fff; border-radius: 6px; padding: 5px 13px; font-size: .8rem; color: #495057; cursor: pointer; }
  .btn-sm-green   { border: none; background: var(--primary); border-radius: 6px; padding: 5px 13px; font-size: .8rem; color: #fff; font-weight: 600; cursor: pointer; }

  /* ── 탭 ── */
  .comm-tabs { background: #fff; border-bottom: 2px solid #e9ecef; }
  .comm-tabs .tab {
    display: inline-block; padding: 11px 20px; font-size: .875rem;
    color: #868e96; font-weight: 500; text-decoration: none;
    border-bottom: 2px solid transparent; margin-bottom: -2px; cursor: pointer;
  }
  .comm-tabs .tab.on   { color: var(--primary); border-bottom-color: var(--primary); font-weight: 700; }
  .comm-tabs .tab:hover { color: var(--primary); }

  /* ── 본문 ── */
  .page-body { padding: 28px 0 64px; }

  /* ── 경로 ── */
  .breadcrumb-area { font-size: .75rem; color: #adb5bd; margin-bottom: 16px; display: flex; align-items: center; gap: 5px; }
  .breadcrumb-area a    { color: #adb5bd; text-decoration: none; }
  .breadcrumb-area a:hover { color: var(--primary); }
  .breadcrumb-area .cur { color: #495057; }

  /* ── 이벤트 박스 ── */
  .event-box { background: #fff; border: 1px solid #e9ecef; border-radius: 12px; overflow: hidden; margin-bottom: 14px; }

  /* ── 히어로 이미지 (NOTICE.image_url) ── */
  .event-hero { position: relative; overflow: hidden; cursor: pointer; background: #212529; }
  .event-hero img {
    width: 100%; max-height: 420px; object-fit: cover; display: block;
    transition: opacity .2s, transform .3s;
  }
  .event-hero:hover img { opacity: .92; transform: scale(1.01); }
  .event-hero-overlay {
    position: absolute; bottom: 0; left: 0; right: 0;
    background: linear-gradient(to top, rgba(0,0,0,.6) 0%, transparent 100%);
    padding: 28px 26px 20px;
  }
  .event-hero-badge {
    display: inline-flex; align-items: center; gap: 4px;
    background: var(--event); color: #fff;
    font-size: .75rem; font-weight: 700; padding: 3px 10px;
    border-radius: 20px; margin-bottom: 8px;
  }
  .event-hero-title {
    font-size: 1.25rem; font-weight: 800; color: #fff;
    line-height: 1.4; text-shadow: 0 1px 4px rgba(0,0,0,.4);
  }
  .hero-pin-badge {
    position: absolute; top: 14px; right: 16px;
    background: rgba(0,0,0,.45); color: #fff; border-radius: 20px;
    font-size: .72rem; font-weight: 700; padding: 3px 10px;
  }
  .zoom-hint {
    position: absolute; bottom: 14px; right: 16px;
    background: rgba(0,0,0,.4); color: rgba(255,255,255,.75);
    font-size: .68rem; border-radius: 20px; padding: 3px 10px;
    display: flex; align-items: center; gap: 4px;
  }

  /* ── 이벤트 정보 바 ── */
  .event-info-bar {
    padding: 14px 26px; background: var(--event-light);
    border-bottom: 1px solid #ffe082;
    display: flex; flex-wrap: wrap; gap: 18px; align-items: center;
  }
  .info-item { display: flex; align-items: center; gap: 7px; font-size: .82rem; color: #6d4c00; }
  .info-item i { color: var(--event); }
  .info-item strong { font-weight: 700; }
  .status-ongoing {
    margin-left: auto;
    display: inline-flex; align-items: center; gap: 5px;
    background: var(--primary); color: #fff;
    font-size: .78rem; font-weight: 700; padding: 4px 12px; border-radius: 20px;
  }
  .status-dot { width: 6px; height: 6px; border-radius: 50%; background: #fff; animation: blink 1.4s infinite; }
  @keyframes blink { 0%,100%{opacity:1;} 50%{opacity:.3;} }

  /* ── 메타 ── */
  .event-meta {
    padding: 13px 26px; border-bottom: 1px solid #f1f3f5;
    display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 8px;
  }
  .meta-author { display: flex; align-items: center; gap: 8px; }
  .admin-avatar {
    width: 32px; height: 32px; border-radius: 50%; flex-shrink: 0;
    background: linear-gradient(135deg, #495057, #212529);
    display: flex; align-items: center; justify-content: center;
    color: #fff; font-size: .72rem; font-weight: 700;
  }
  .author-name { font-size: .875rem; font-weight: 700; color: #343a40; }
  .author-role { font-size: .68rem; color: var(--primary); background: var(--primary-light); border-radius: 3px; padding: 1px 5px; font-weight: 700; }
  .author-date { font-size: .72rem; color: #adb5bd; margin-top: 1px; }
  .meta-stats  { display: flex; gap: 12px; font-size: .78rem; color: #adb5bd; }
  .meta-stats span { display: flex; align-items: center; gap: 4px; }

  /* ── 본문 ── */
  .event-body { padding: 26px 26px; font-size: .9rem; line-height: 1.9; color: #343a40; border-bottom: 1px solid #f1f3f5; }
  .event-body p { margin-bottom: 14px; }
  .event-body p:last-child { margin-bottom: 0; }
  .event-body ul { padding-left: 20px; margin-bottom: 14px; }
  .event-body ul li { margin-bottom: 6px; }
  .event-body .highlight {
    background: var(--event-light); border-left: 3px solid var(--event);
    padding: 12px 16px; border-radius: 0 6px 6px 0;
    margin: 16px 0; font-size: .875rem; color: #6d4c00;
  }
  .event-body table { width: 100%; border-collapse: collapse; margin: 16px 0; font-size: .85rem; }
  .event-body table th { background: var(--event-light); border: 1px solid #ffe082; padding: 8px 12px; font-weight: 700; color: #6d4c00; text-align: left; }
  .event-body table td { border: 1px solid #dee2e6; padding: 8px 12px; color: #343a40; }

  /* ── 참여 CTA ── */
  .event-cta {
    margin-top: 24px;
    background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
    border-radius: 10px; padding: 20px 22px;
    display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px;
  }
  .cta-text h3 { font-size: .95rem; font-weight: 700; color: #fff; margin: 0 0 3px; }
  .cta-text p  { font-size: .78rem; color: rgba(255,255,255,.8); margin: 0; }
  .btn-cta {
    background: #fff; color: var(--primary); border: none; border-radius: 8px;
    padding: 9px 20px; font-size: .82rem; font-weight: 700; cursor: pointer;
    text-decoration: none; white-space: nowrap;
    display: inline-flex; align-items: center; gap: 5px; transition: background .15s;
  }
  .btn-cta:hover { background: var(--primary-light); color: var(--primary); }

  /* ── 하단 버튼 ── */
  .event-footer { padding: 13px 26px; }
  .btn-list {
    border: 1px solid #dee2e6; background: #fff; border-radius: 7px;
    padding: 7px 16px; font-size: .8rem; color: #495057; text-decoration: none;
    display: inline-flex; align-items: center; gap: 5px; transition: background .13s;
  }
  .btn-list:hover { background: #f8f9fa; }

  /* ── 이전 / 다음 ── */
  .post-nav-box { background: #fff; border: 1px solid #e9ecef; border-radius: 12px; overflow: hidden; }
  .post-nav-item {
    display: grid; grid-template-columns: 72px 1fr 80px;
    align-items: center; gap: 12px; padding: 13px 22px;
    text-decoration: none; border-bottom: 1px solid #f1f3f5; transition: background .12s;
  }
  .post-nav-item:last-child  { border-bottom: none; }
  .post-nav-item:hover       { background: #f8fff8; }
  .post-nav-label { font-size: .75rem; font-weight: 700; color: #adb5bd; display: flex; align-items: center; gap: 4px; white-space: nowrap; }
  .post-nav-item:not(.prev) .post-nav-label { color: var(--primary); }
  .post-nav-title { font-size: .875rem; color: #343a40; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .post-nav-item:hover .post-nav-title { color: var(--primary); }
  .post-nav-date  { font-size: .75rem; color: #adb5bd; text-align: right; white-space: nowrap; }

  /* ── 라이트박스 ── */
  .lightbox { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.92); z-index: 9999; align-items: center; justify-content: center; }
  .lightbox.show { display: flex; }
  .lightbox img  { max-width: 92vw; max-height: 88vh; border-radius: 8px; object-fit: contain; }
  .lightbox-close { position: absolute; top: 20px; right: 24px; color: #fff; font-size: 1.6rem; cursor: pointer; background: none; border: none; }

  /* ── 푸터 ── */
  .site-footer { background: #212529; color: #6c757d; padding: 28px 32px; font-size: .78rem; }
</style>
</head>
<body>

<!-- 헤더 -->
<header class="site-header">
  <div style="display:flex;align-items:center;gap:32px;">
    <span class="logo">맛집내</span>
    <nav class="gnb">
      <a href="#">맛집</a><a href="#">숙소</a><a href="#">축제</a>
      <a href="#" class="on">커뮤니티</a><a href="#">고객지원</a>
    </nav>
  </div>
  <div class="hd-btns">
    <button class="btn-sm-outline">회원가입</button>
    <button class="btn-sm-green">로그인</button>
  </div>
</header>

<!-- 탭 -->
<div class="comm-tabs">
  <div class="container">
    <a class="tab" href="#">자유게시판</a>
    <a class="tab" href="#">공지사항</a>
    <a class="tab on">이벤트</a>
  </div>
</div>

<!-- 본문 -->
<div class="page-body">
  <div class="container" style="max-width:860px;">

    <!-- 경로 -->
    <div class="breadcrumb-area">
      <a href="#">커뮤니티</a>
      <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
      <a href="#">이벤트</a>
      <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
      <span class="cur">이벤트 상세</span>
    </div>

    <!-- ── 이벤트 박스 ── -->
    <div class="event-box">

      <!-- 히어로 이미지 -->
      <div class="event-hero" onclick="openLightbox()">
        <img src="https://images.unsplash.com/photo-1506929562872-bb421503ef21?w=900&q=80" alt="봄맞이 여행 후기 이벤트">
        <div class="event-hero-overlay">
          <div class="event-hero-badge"><i class="bi bi-gift-fill"></i> 이벤트</div>
          <div class="event-hero-title">🌸 봄맞이 여행 후기 이벤트<br>– 최대 5만 포인트 증정</div>
        </div>
        <div class="hero-pin-badge">📌 상단 고정</div>
        <div class="zoom-hint"><i class="bi bi-zoom-in"></i> 크게 보기</div>
      </div>

      <!-- 이벤트 정보 바 -->
      <div class="event-info-bar">
        <div class="info-item">
          <i class="bi bi-calendar-range"></i>
          <span><strong>기간</strong>&nbsp; 2026.03.01 ~ 2026.03.31</span>
        </div>
        <div class="info-item">
          <i class="bi bi-people-fill"></i>
          <span><strong>대상</strong>&nbsp; 맛집내 전체 회원</span>
        </div>
        <div class="status-ongoing">
          <div class="status-dot"></div> 진행 중
        </div>
      </div>

      <!-- 메타 -->
      <div class="event-meta">
        <div class="meta-author">
          <div class="admin-avatar">관</div>
          <div>
            <div style="display:flex;align-items:center;gap:6px;">
              <span class="author-name">관리자</span>
              <span class="author-role">ADMIN</span>
            </div>
            <div class="author-date">2026.03.01</div>
          </div>
        </div>
        <div class="meta-stats">
          <span><i class="bi bi-eye"></i> 8,420</span>
        </div>
      </div>

      <!-- 본문 -->
      <div class="event-body">
        <p>안녕하세요, 맛집내 운영팀입니다! 🌸</p>
        <p>따뜻한 봄을 맞아 <strong>여행 후기 이벤트</strong>를 진행합니다.<br>
        나만의 봄 여행 이야기를 자유게시판에 올려주시면, 추첨을 통해 풍성한 혜택을 드립니다!</p>

        <div class="highlight">
          🎁 <strong>이벤트 기간 :</strong> 2026년 3월 1일 ~ 3월 31일<br>
          🏆 <strong>당첨 발표 :</strong> 2026년 4월 10일 (공지사항 게시)
        </div>

        <p><strong>■ 참여 방법</strong></p>
        <ul>
          <li>맛집내 로그인 후 자유게시판으로 이동</li>
          <li>카테고리를 <strong>여행후기</strong>로 선택하여 게시글 작성</li>
          <li>이미지 1장 이상 반드시 첨부</li>
          <li>이벤트 기간 내 작성된 게시글만 인정</li>
        </ul>

        <p><strong>■ 경품 안내</strong></p>
        <table>
          <thead>
            <tr><th>등수</th><th>경품</th><th>인원</th></tr>
          </thead>
          <tbody>
            <tr><td>🥇 최우수상</td><td>포인트 50,000점</td><td>1명</td></tr>
            <tr><td>🥈 우수상</td><td>포인트 30,000점</td><td>3명</td></tr>
            <tr><td>🥉 장려상</td><td>포인트 10,000점</td><td>10명</td></tr>
            <tr><td>🎀 참여상</td><td>포인트 1,000점</td><td>참여 전원</td></tr>
          </tbody>
        </table>

        <p><strong>■ 유의사항</strong></p>
        <ul>
          <li>본인이 직접 촬영한 사진만 첨부 가능합니다.</li>
          <li>타인의 저작물 무단 사용 시 당첨이 취소될 수 있습니다.</li>
          <li>부적절한 내용이 포함된 게시글은 이벤트 대상에서 제외됩니다.</li>
          <li>경품은 당첨 발표 후 7일 이내 포인트로 지급됩니다.</li>
        </ul>

        <!-- 참여 CTA -->
        <div class="event-cta">
          <div class="cta-text">
            <h3>✏️ 지금 바로 후기를 작성하고 경품에 도전하세요!</h3>
            <p>카테고리를 <strong style="color:#b7dfca;">여행후기</strong>로 선택하고 이미지를 꼭 첨부해주세요.</p>
          </div>
          <a href="#" class="btn-cta">
            <i class="bi bi-pencil-fill" style="font-size:.75rem;"></i> 후기 작성하기
          </a>
        </div>

      </div><!-- /event-body -->

      <!-- 하단 버튼 -->
      <div class="event-footer">
        <a href="#" class="btn-list">
          <i class="bi bi-list-ul"></i> 목록
        </a>
      </div>

    </div><!-- /event-box -->

    <!-- 이전 / 다음 -->
    <div class="post-nav-box">
      <a href="#" class="post-nav-item">
        <div class="post-nav-label"><i class="bi bi-chevron-up"></i> 다음글</div>
        <div class="post-nav-title">친구 초대하고 포인트 받기 이벤트 (~ 3/31)</div>
        <div class="post-nav-date">2026.02.28</div>
      </a>
      <a href="#" class="post-nav-item prev">
        <div class="post-nav-label"><i class="bi bi-chevron-down"></i> 이전글</div>
        <div class="post-nav-title">설날 특집 여행지 추천 이벤트 – 당첨자 발표</div>
        <div class="post-nav-date">2026.02.01</div>
      </a>
    </div>

  </div>
</div>

<!-- 라이트박스 -->
<div class="lightbox" id="lightbox" onclick="closeLightbox()">
  <button class="lightbox-close" onclick="closeLightbox()"><i class="bi bi-x-lg"></i></button>
  <img src="https://images.unsplash.com/photo-1506929562872-bb421503ef21?w=1200&q=90" alt="">
</div>

<!-- 푸터 -->
<footer class="site-footer">
  <div>© 2026 맛집내. All rights reserved.</div>
</footer>

<script>
  function openLightbox() { document.getElementById('lightbox').classList.add('show'); }
  function closeLightbox() { document.getElementById('lightbox').classList.remove('show'); }
  document.addEventListener('keydown', e => { if (e.key === 'Escape') closeLightbox(); });
</script>
</body>
</html>
