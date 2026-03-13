<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${notice.title} - 맛집내</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<style>
  * { box-sizing: border-box; }
  body { font-family: 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif; background: #f4f6f8; margin: 0; font-size: 14px; }
  :root { --primary: #198754; --primary-dark: #0f5c38; --primary-light: #e8f5e9; }

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

  /* ── 공지 박스 ── */
  .notice-box { background: #fff; border: 1px solid #e9ecef; border-radius: 12px; overflow: hidden; margin-bottom: 14px; }

  /* 헤더 */
  .notice-header { padding: 22px 26px 18px; border-bottom: 1px solid #f1f3f5; }

  .notice-badges { display: flex; align-items: center; gap: 6px; margin-bottom: 10px; }
  .bdg { display: inline-flex; align-items: center; gap: 3px; font-size: .7rem; padding: 2px 8px; border-radius: 4px; font-weight: 700; white-space: nowrap; }
  .bdg-notice { background: var(--primary-light); color: var(--primary); }
  .bdg-event  { background: #fff8e1; color: #856404; }
  .bdg-pin    { background: #f3e8ff; color: #6f42c1; }

  .notice-title { font-size: 1.2rem; font-weight: 700; color: #212529; margin: 0 0 14px; line-height: 1.45; }

  .notice-meta { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 8px; }
  .meta-left   { display: flex; align-items: center; gap: 16px; }
  .meta-author { display: flex; align-items: center; gap: 8px; }
  .admin-avatar {
    width: 34px; height: 34px; border-radius: 50%; flex-shrink: 0;
    background: linear-gradient(135deg, #495057 0%, #212529 100%);
    display: flex; align-items: center; justify-content: center;
    color: #fff; font-size: .75rem; font-weight: 700;
  }
  .author-name { font-size: .875rem; font-weight: 700; color: #343a40; }
  .author-role { font-size: .72rem; color: var(--primary); background: var(--primary-light); border-radius: 3px; padding: 1px 6px; font-weight: 700; }
  .author-date { font-size: .75rem; color: #adb5bd; margin-top: 1px; }
  .meta-stats  { display: flex; gap: 14px; font-size: .78rem; color: #adb5bd; }
  .meta-stats span { display: flex; align-items: center; gap: 4px; }

  /* 본문 */
  .notice-body {
    padding: 28px 26px;
    font-size: .9rem; line-height: 1.9; color: #343a40;
    border-bottom: 1px solid #f1f3f5; min-height: 180px;
  }
  .notice-body p { margin-bottom: 14px; }
  .notice-body p:last-child { margin-bottom: 0; }
  .notice-body .highlight {
    background: var(--primary-light); border-left: 3px solid var(--primary);
    padding: 12px 16px; border-radius: 0 6px 6px 0;
    margin: 16px 0; font-size: .875rem; color: #0f5c38;
  }
  .notice-body table {
    width: 100%; border-collapse: collapse; margin: 16px 0; font-size: .85rem;
  }
  .notice-body table th {
    background: #f8f9fa; border: 1px solid #dee2e6;
    padding: 8px 12px; font-weight: 700; color: #495057; text-align: left;
  }
  .notice-body table td {
    border: 1px solid #dee2e6; padding: 8px 12px; color: #343a40;
  }

  /* 첨부 이미지 (NOTICE.image_url) */
  .notice-image-wrap {
    padding: 0 26px 24px; border-bottom: 1px solid #f1f3f5;
  }
  .notice-image-label { font-size: .75rem; font-weight: 700; color: #adb5bd; margin-bottom: 10px; display: flex; align-items: center; gap: 5px; }
  .notice-image-wrap img {
    width: 100%; max-height: 400px; object-fit: cover;
    border-radius: 10px; display: block; cursor: pointer;
    transition: opacity .2s;
  }
  .notice-image-wrap img:hover { opacity: .93; }

  /* 하단 버튼 */
  .notice-footer {
    padding: 13px 26px; display: flex; justify-content: space-between; align-items: center;
  }
  .btn-list {
    border: 1px solid #dee2e6; background: #fff; border-radius: 7px;
    padding: 7px 16px; font-size: .8rem; color: #495057; text-decoration: none;
    display: inline-flex; align-items: center; gap: 5px; transition: background .13s;
  }
  .btn-list:hover { background: #f8f9fa; color: #343a40; }

  /* 관리자 전용 버튼 */
  .admin-btns { display: flex; gap: 6px; }
  .btn-edit {
    border: 1px solid #dee2e6; background: #fff; border-radius: 7px;
    padding: 7px 14px; font-size: .8rem; color: #495057; text-decoration: none;
    display: inline-flex; align-items: center; gap: 5px; cursor: pointer; transition: background .13s;
  }
  .btn-edit:hover { background: #f8f9fa; }
  .btn-del {
    border: 1px solid #f5c6cb; background: #fff; border-radius: 7px;
    padding: 7px 14px; font-size: .8rem; color: #dc3545;
    display: inline-flex; align-items: center; gap: 5px; cursor: pointer; transition: background .13s;
  }
  .btn-del:hover { background: #fff5f5; }

  /* ── 이전글 / 다음글 ── */
  .post-nav-box { background: #fff; border: 1px solid #e9ecef; border-radius: 12px; overflow: hidden; }
  .post-nav-item {
    display: grid; grid-template-columns: 72px 1fr 80px;
    align-items: center; gap: 12px;
    padding: 13px 22px; text-decoration: none;
    border-bottom: 1px solid #f1f3f5; transition: background .12s;
  }
  .post-nav-item:last-child { border-bottom: none; }
  .post-nav-item:hover      { background: #f8fff8; }
  .post-nav-label {
    font-size: .75rem; font-weight: 700; color: #adb5bd;
    display: flex; align-items: center; gap: 4px; white-space: nowrap;
  }
  .post-nav-item:not(.prev) .post-nav-label { color: var(--primary); }
  .post-nav-title { font-size: .875rem; color: #343a40; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .post-nav-item:hover .post-nav-title { color: var(--primary); }
  .post-nav-date  { font-size: .75rem; color: #adb5bd; text-align: right; white-space: nowrap; }

  /* ── 라이트박스 ── */
  .lightbox { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.88); z-index: 9999; align-items: center; justify-content: center; }
  .lightbox.show { display: flex; }
  .lightbox img  { max-width: 90vw; max-height: 85vh; border-radius: 8px; object-fit: contain; }
  .lightbox-close {
    position: absolute; top: 20px; right: 24px;
    color: #fff; font-size: 1.6rem; cursor: pointer; background: none; border: none;
  }

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
    <a class="tab on">공지사항</a>
    <a class="tab" href="#">이벤트</a>
  </div>
</div>

<!-- 본문 -->
<div class="page-body">
  <div class="container" style="max-width:860px;">

    <!-- 경로 -->
    <div class="breadcrumb-area">
      <a href="#">커뮤니티</a>
      <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
      <a href="#">공지사항</a>
      <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
      <span class="cur">공지 상세</span>
    </div>

    <!-- ── 공지 본문 ── -->
    <div class="notice-box">

      <!-- 헤더 -->
      <div class="notice-header">
        <div class="notice-badges">
          <span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span>
          <span class="bdg bdg-pin">📌 상단 고정</span>
        </div>
        <h1 class="notice-title">맛집내 서비스 이용약관 개정 안내</h1>
        <div class="notice-meta">
          <div class="meta-left">
            <div class="meta-author">
              <div class="admin-avatar">관</div>
              <div>
                <div style="display:flex;align-items:center;gap:6px;">
                  <span class="author-name">관리자</span>
                  <span class="author-role">ADMIN</span>
                </div>
                <div class="author-date">2026.01.15</div>
              </div>
            </div>
          </div>
          <div class="meta-stats">
            <span><i class="bi bi-eye"></i> 5,210</span>
          </div>
        </div>
      </div>

      <!-- 본문 (NOTICE.content) -->
      <div class="notice-body">
        <p>안녕하세요, 맛집내 운영팀입니다.</p>

        <p>2026년 2월 1일부터 서비스 이용약관 일부가 개정됩니다.<br>
        개정 내용을 아래에 안내드리오니 확인하시기 바랍니다.</p>

        <div class="highlight">
          📢 시행일 : <strong>2026년 2월 1일 (월)</strong> 부터 적용됩니다.<br>
          변경된 약관에 동의하지 않으시는 경우, 시행일 이전에 서비스 탈퇴를 요청하실 수 있습니다.
        </div>

        <p><strong>■ 주요 개정 내용</strong></p>

        <table>
          <thead>
            <tr>
              <th>조항</th>
              <th>개정 전</th>
              <th>개정 후</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>제5조 (서비스 이용)</td>
              <td>1일 리뷰 등록 제한 없음</td>
              <td>1일 최대 5건으로 제한</td>
            </tr>
            <tr>
              <td>제9조 (포인트)</td>
              <td>포인트 유효기간 2년</td>
              <td>포인트 유효기간 1년으로 변경</td>
            </tr>
            <tr>
              <td>제12조 (계정 정지)</td>
              <td>1회 경고 후 정지</td>
              <td>3회 경고 누적 후 정지</td>
            </tr>
          </tbody>
        </table>

        <p><strong>■ 약관 전문 확인</strong><br>
        전체 약관은 <strong>설정 &gt; 이용약관</strong> 메뉴에서 확인하실 수 있습니다.</p>

        <p>이용에 불편을 드려 죄송합니다. 더 나은 서비스를 위해 최선을 다하겠습니다.<br>
        감사합니다. 🙏</p>
      </div>

      <!-- 첨부 이미지 (NOTICE.image_url — 값이 있을 때만 노출) -->
      <div class="notice-image-wrap">
        <div class="notice-image-label">
          <i class="bi bi-image"></i> 첨부 이미지
        </div>
        <img
          src="https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=900&q=80"
          alt="이용약관 개정 안내 이미지"
          onclick="openLightbox(this.src)">
      </div>

      <!-- 하단 버튼 -->
      <div class="notice-footer">
        <a href="#" class="btn-list">
          <i class="bi bi-list-ul"></i> 목록
        </a>
      </div>

    </div><!-- /notice-box -->

    <!-- ── 이전글 / 다음글 ── -->
    <div class="post-nav-box">
      <a href="#" class="post-nav-item">
        <div class="post-nav-label">
          <i class="bi bi-chevron-up"></i> 다음글
        </div>
        <div class="post-nav-title">2026년 3월 정기 점검 안내</div>
        <div class="post-nav-date">2026.03.08</div>
      </a>
      <a href="#" class="post-nav-item prev">
        <div class="post-nav-label">
          <i class="bi bi-chevron-down"></i> 이전글
        </div>
        <div class="post-nav-title">개인정보처리방침 변경 안내 (2026년 1월 기준)</div>
        <div class="post-nav-date">2026.01.15</div>
      </a>
    </div>

  </div>
</div>

<!-- 라이트박스 -->
<div class="lightbox" id="lightbox" onclick="closeLightbox()">
  <button class="lightbox-close" onclick="closeLightbox()"><i class="bi bi-x-lg"></i></button>
  <img id="lightboxImg" src="" alt="">
</div>

<!-- 푸터 -->
<footer class="site-footer">
  <div>© 2026 맛집내. All rights reserved.</div>
</footer>

<script>
  function openLightbox(src) {
    document.getElementById('lightboxImg').src = src;
    document.getElementById('lightbox').classList.add('show');
  }
  function closeLightbox() {
    document.getElementById('lightbox').classList.remove('show');
  }
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') closeLightbox();
  });
</script>
</body>
</html>
