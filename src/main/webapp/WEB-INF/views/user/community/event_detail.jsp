<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-14
 * 최종수정일: 2026-03-16
 * 참고 코드: community_detail.jsp
 자유게시판 게시글에서 댓글 기능 삭제
 
 * 적용 외부 API : Kakao 공유 API
 (PC : 정상 작동/ 모바일 : URL 올바르게 들어가나 페이지 못 불러옴 <= 정상)
  ㄴ localhost 링크 대상 서버가 모바일에서 접근 불가 	
  
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 > 이벤트 > 게시글</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/community/community-common.css">
<link rel="stylesheet" href="${path}/resources/css/user/community/event.css">

<!-- 컨트롤러에서 카카오 공유 API 키 가져오기  -->
<script type="text/javascript">
	var kakaoShareApiKey = "${kakaoShareApiKey}";
</script>

<!-- 카카오 공유 API -->
<c:set var="shareUrl"
       value="${pageContext.request.scheme}://${pageContext.request.serverName}${path}/community_event_detail.co?notice_id=${noticeDTO.notice_id}" />

<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.5/kakao.min.js"
        crossorigin="anonymous"></script>

<script>
	window.kakaoShareData = {
	    title: '맛침내 커뮤니티', // 실제 제목은 event.js에서 DOM의 .event-title 텍스트를 읽어 업데이트함 (따옴표 오류 방지)
	    description: '맛침내 커뮤니티 이벤트 게시판',
	    imageUrl: 'https://developers.kakao.com/assets/img/about/logos/kakaolink/kakaolink_btn_small.png',
	    webUrl: '${shareUrl}',
	    mobileWebUrl: '${shareUrl}'
	};
	/* 실제 imageUrl은 event.js DOMContentLoaded에서 image_url 기준으로 덮어씀 */
</script>

<script src="${path}/resources/js/common/kakaoShare.js"></script>
<!-- 카카오 공유 API -->

</head>
<body>
<div class="wrap">

    <%@ include file="../../common/header.jsp" %>

    <div class="comm-tabs">
        <div class="container">
            <a href="${path}/community_free.co" class="tab ${tab eq 'free' ? 'on' : ''}">자유게시판</a>
            <a href="${path}/community_notice.co" class="tab ${tab eq 'notice' ? 'on' : ''}">공지사항</a>
            <a href="${path}/community_event.co" class="tab ${tab eq 'event' ? 'on' : ''}">이벤트</a>
        </div>
    </div>

    <div class="page-body">
        <div class="container">

            <!-- breadcrumb -->
            <div class="breadcrumb-area">
                <a href="${path}/community_free.co">커뮤니티</a>
                <i class="bi bi-chevron-right"></i>
                <a href="${path}/community_event.co">이벤트</a>
                <i class="bi bi-chevron-right"></i>
                <span class="cur">이벤트 상세</span>
            </div>

            <!-- detail -->
            <div class="event-box">

                <c:choose>
                    <c:when test="${not empty noticeDTO.image_url}">
                        <div class="event-hero">
                            <img class="event-hero-img" data-img="${noticeDTO.image_url}" alt="${noticeDTO.title}">
                            <c:if test="${noticeDTO.is_top eq 'Y'}">
                                <div class="hero-pin-badge">진행중</div>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="event-hero-placeholder">
                            <i class="bi bi-gift"></i>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="event-header">
                    <div class="event-badges">
                        <span class="bdg bdg-event">
                            <i class="bi bi-gift"></i> 이벤트
                        </span>

                        <c:if test="${noticeDTO.is_top eq 'Y'}">
                            <span class="bdg bdg-pin">진행중</span>
                        </c:if>
                    </div>

                    <h1 class="event-title">${noticeDTO.title}</h1>

                    <div class="event-meta">
                        <div class="meta-author">
                            <div class="admin-avatar">AD</div>
							  <div>
							    <div style="display:flex; align-items:center; gap:8px; flex-wrap:wrap;">
							        <span class="author-name">${noticeDTO.admin_id}</span>
							        <span class="author-role event-role">관리자</span>
							        <span class="author-date">
							            <fmt:formatDate value="${noticeDTO.noticeRegDate}" pattern="yyyy.MM.dd HH:mm"/>
							        </span>
							    </div>
							</div>
                        </div>

                        <div class="meta-stats">
                            <span><i class="bi bi-eye"></i> ${noticeDTO.view_count}</span>
                        </div>
                    </div>
                </div>

                <div class="event-body">
                    <%-- Summernote HTML 원본을 그대로 렌더링 --%>
                    ${noticeDTO.content}
                </div>

				<!-- 하단 액션 버튼 영역 -->
                <div class="detail-action-wrap">
				    <div class="detail-action-bar">
				        <a href="${path}/community_event.co" class="pill-btn list-pill-btn">
				            <i class="bi bi-list"></i>
				            <span>목록</span>
				        </a>
				
				        <button type="button" id="kakaoShareBtn" class="pill-btn kakao-pill-btn">
				            <span class="kakao-dot">💬</span>
				            <span>카카오톡 공유</span>
				        </button>
				    </div>
				</div>
				<br>
				
            </div>
        </div>
    </div>

    <%@ include file="../../common/footer.jsp" %>
</div>
<script>var APP_PATH = '${path}';</script>
<script src="${path}/resources/js/community/event.js"></script>
</body>
</html>