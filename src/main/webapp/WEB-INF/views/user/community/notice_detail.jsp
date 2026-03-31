<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-18
 * 최종수정일: 2026-03-20
 
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${noticeDTO.title} - 공지사항</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/community/community-common.css">
<link rel="stylesheet" href="${path}/resources/css/user/community/notice.css">
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
                <a href="${path}/community_notice.co">공지사항</a>
                <i class="bi bi-chevron-right"></i>
                <span class="cur">공지 상세</span>
            </div>

            <!-- detail -->
            <div class="notice-box">
                <div class="notice-header">
                    <div class="notice-badges">
                        <span class="bdg bdg-notice">
                            <i class="bi bi-megaphone"></i> 공지
                        </span>

                        <c:if test="${noticeDTO.is_top eq 'Y'}">
                            <span class="bdg bdg-pin">📌 고정</span>
                        </c:if>
                    </div>

                    <h1 class="notice-title">${noticeDTO.title}</h1>

                    <div class="notice-meta">
                        <div class="meta-author">
                            <div class="admin-avatar">AD</div>
                            <div>
                                <div style="display:flex; align-items:center; gap:6px;">
                                    <span class="author-name">${noticeDTO.admin_id}</span>
                                    <span class="author-role notice-role">관리자</span>
                                </div>
                                <div class="author-date">
                                    <fmt:formatDate value="${noticeDTO.noticeRegDate}" pattern="yyyy.MM.dd HH:mm"/>
                                </div>
                            </div>
                        </div>

                        <div class="meta-stats">
                            <span><i class="bi bi-eye"></i> ${noticeDTO.view_count}</span>
                        </div>
                    </div>
                </div>
				
                <div class="notice-body">
                	<!-- 이미지 -->
                	<c:if test="${not empty noticeDTO.image_url}">
                		<div class="mb-3 d-flex flex-wrap gap-2">
                			<c:forEach var="img" items="${fn:split(noticeDTO.image_url, ',')}">
                				<img src="${img}" class="img-fluid" style="max-height:300px; margin-right:8px; margin-bottom:8px;">
                			</c:forEach>
                		</div>
                	</c:if>
                	<!-- 내용 -->
                    ${noticeDTO.content}
                </div>

                <div class="notice-footer">
                    <a href="${path}/community_notice.co" class="btn-list">
                        <i class="bi bi-list"></i> 목록
                    </a>
                </div>
            </div>

        </div>
    </div>

    <%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>