<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- 반응형 웹 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 - 공지사항</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/community/notice.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script><!-- 아이콘 -->

<script src="${path}/resources/js/community/notice.js" defer></script>
 
</head>
<body>
<div class="wrap">

    <!-- header -->
    <%@ include file="../../common/header.jsp" %>

    <!-- 커뮤니티 상단 탭 -->
    <div class="comm-tabs">
      <div class="container">
        <a href="${path}/community_free.co" class="tab ${tab eq 'free' ? 'on' : ''}">자유게시판</a>
        <a href="${path}/community_notice.co" class="tab ${tab eq 'notice' ? 'on' : ''}">공지사항</a>
        <a href="${path}/community_event.co" class="tab ${tab eq 'event' ? 'on' : ''}">이벤트</a>
      </div>
    </div>

    <!-- 본문 -->
    <div class="page-body">
      <div class="container">

        <!-- 경로 -->
        <div class="breadcrumb-area">
          <a href="${path}/community_free.co">커뮤니티</a>
          <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
          <span class="cur">공지사항</span>
        </div>

        <!-- 타이틀 -->
        <div class="page-title-row">
          <span class="page-title">
            <i class="bi bi-megaphone-fill text-success me-1"></i> 공지사항
          </span>
        </div>

        <!-- 공지사항 목록 -->
        <div class="board-card">

          <!-- 컬럼 헤더 -->
          <div class="tbl-head">
            <span>구분</span>
            <span>제목</span>
            <span class="c">작성자</span>
            <span class="c">조회</span>
            <span class="r">날짜</span>
          </div>

          <!-- 상단 고정 -->
          <a href="#" class="tbl-row pinned">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">맛집내 서비스 이용약관 개정 안내</span>
              <span class="bdg-pin">📌 고정</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">5,210</span>
            <span class="r meta">2026.01.15</span>
          </a>

          <a href="#" class="tbl-row pinned">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">개인정보처리방침 변경 안내 (2026년 1월 기준)</span>
              <span class="bdg-pin">📌 고정</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">3,874</span>
            <span class="r meta">2026.01.15</span>
          </a>

          <!-- 구분선 -->
          <div style="border-top: 2px dashed #e9ecef; margin: 0;"></div>

          <!-- 일반 목록 -->
          <a href="#" class="tbl-row">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">2026년 3월 정기 점검 안내</span>
              <span class="bdg-new">N</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">1,034</span>
            <span class="r meta">2026.03.08</span>
          </a>

          <a href="#" class="tbl-row">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">맛집내 앱 v2.3.0 업데이트 안내</span>
              <span class="bdg-new">N</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">876</span>
            <span class="r meta">2026.03.05</span>
          </a>

          <a href="#" class="tbl-row">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">고객센터 운영시간 변경 안내 (주말 포함)</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">2,450</span>
            <span class="r meta">2026.02.20</span>
          </a>

          <a href="#" class="tbl-row">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">포인트 정책 개편 안내 – 리뷰·로그인 적립 변경</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">3,100</span>
            <span class="r meta">2026.02.10</span>
          </a>

          <a href="#" class="tbl-row">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">결제 오류 관련 긴급 안내 및 조치 사항</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">4,820</span>
            <span class="r meta">2026.01.30</span>
          </a>

          <a href="#" class="tbl-row">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">2026년 설 연휴 고객센터 운영 안내</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">1,980</span>
            <span class="r meta">2026.01.22</span>
          </a>

          <a href="#" class="tbl-row">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">맛집내 커뮤니티 운영 정책 안내</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">6,320</span>
            <span class="r meta">2026.01.02</span>
          </a>

          <a href="#" class="tbl-row">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">리뷰 작성 가이드라인 업데이트 안내</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">2,710</span>
            <span class="r meta">2025.12.15</span>
          </a>

          <a href="#" class="tbl-row">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">2025년 연말 점검 일정 안내</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">1,640</span>
            <span class="r meta">2025.12.01</span>
          </a>

          <a href="#" class="tbl-row">
            <span><span class="bdg bdg-notice"><i class="bi bi-megaphone"></i> 공지</span></span>
            <span class="notice-ttl">
              <span class="t">예약 취소·환불 정책 개편 안내</span>
            </span>
            <span class="c meta">관리자</span>
            <span class="c meta">5,130</span>
            <span class="r meta">2025.11.20</span>
          </a>

        </div>

        <!-- 페이지네이션 -->
        <div class="paging">
          <a class="pg">‹</a>
          <a class="pg on">1</a>
          <a class="pg">2</a>
          <a class="pg">3</a>
          <a class="pg">›</a>
        </div>

        <!-- 검색 -->
        <div class="search-row">
          <div class="search-box">
            <input type="text" placeholder="공지사항 검색">
            <button type="button"><i class="bi bi-search"></i></button>
          </div>
        </div>

      </div>
    </div>

    <!-- footer -->
    <%@ include file="../../common/footer.jsp" %>

</div>
</body>
</html>