<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-15
 * 최종수정일: 2026-03-20
 
 [공지사항] => 공지는 “읽어야 할 정보”
 상단 고정 공지 : 별도 조회
 CATEGORY='NOTICE' AND IS_TOP='Y'
	
 일반 공지 : 검색 + 페이징
 CATEGORY='NOTICE' AND IS_TOP='N'
 
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 - 공지사항</title>

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
                <span class="cur">공지사항</span>
            </div>

            <!-- page title -->
            <div class="page-title-row">
                <span class="page-title">
                    <i class="bi bi-megaphone-fill text-success me-1"></i> 공지사항
                </span>
            </div>

            <!-- intro -->
            <div class="info-card">
                <div style="display:flex; align-items:flex-start; gap:10px;">
                    <div style="font-size:1.1rem; color:#198754; line-height:1;">
                        <i class="bi bi-info-circle-fill"></i>
                    </div>
                    <div>
                        <div style="font-size:.9rem; font-weight:700; color:#212529; margin-bottom:4px;">
                            서비스 공지 및 업데이트 안내
                        </div>
                        <div style="font-size:.8rem; color:#6c757d; line-height:1.7;">
                            점검, 정책 변경, 서비스 업데이트 등 주요 안내사항을 확인할 수 있습니다.
                            상단 고정 공지는 반드시 먼저 확인해 주세요.
                        </div>
                    </div>
                </div>
            </div>

            <!-- 상단 고정 공지 -->
            <c:if test="${not empty topNoticeList}">
                <section class="board-section">
                    <div class="board-card notice-fixed-card">

                        <div class="board-section-title">
                            <i class="bi bi-pin-angle-fill"></i>
                            고정 공지
                        </div>

                        <div class="notice-table-head">
                            <span>구분</span>
                            <span>제목</span>
                            <span class="c">작성자</span>
                            <span class="c">조회</span>
                            <span class="r">날짜</span>
                        </div>

                        <div class="notice-table-body">
                            <c:forEach var="dto" items="${topNoticeList}">
                                <a href="${path}/community_notice_detail.co?notice_id=${dto.notice_id}" class="notice-row pinned">
                                    <span>
                                        <span class="bdg bdg-notice">
                                            <i class="bi bi-megaphone"></i> 공지
                                        </span>
                                    </span>

                                    <span class="notice-title-wrap">
                                        <span class="notice-title-text">${dto.title}</span>
                                        <span class="bdg bdg-pin">📌 고정</span>
                                    </span>

                                    <span class="c meta">${dto.admin_id}</span>
                                    <span class="c meta">${dto.view_count}</span>
                                    <span class="r meta">
                                        <fmt:formatDate value="${dto.noticeRegDate}" pattern="yyyy.MM.dd"/>
                                    </span>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </section>
            </c:if>

            <!-- 일반 공지 -->
            <section class="board-section">
                <div class="board-card">

                    <div class="board-section-title normal">
                        <i class="bi bi-list-ul"></i>
                        일반 공지
                    </div>

                    <div class="notice-table-head">
                        <span>구분</span>
                        <span>제목</span>
                        <span class="c">작성자</span>
                        <span class="c">조회</span>
                        <span class="r">날짜</span>
                    </div>

                    <div class="notice-table-body">
                        <c:choose>
                            <c:when test="${empty noticeList}">
                                <div class="empty">
                                    <i class="bi bi-megaphone"></i>
                                    등록된 공지사항이 없습니다.
                                </div>
                            </c:when>

                            <c:otherwise>
                                <c:forEach var="dto" items="${noticeList}">
                                    <a href="${path}/community_notice_detail.co?notice_id=${dto.notice_id}" class="notice-row">
                                        <span>
                                            <span class="bdg bdg-notice">
                                                <i class="bi bi-megaphone"></i> 공지
                                            </span>
                                        </span>

                                        <span class="notice-title-wrap">
                                            <span class="notice-title-text">${dto.title}</span>
                                        </span>

                                        <span class="c meta">${dto.admin_id}</span>
                                        <span class="c meta">${dto.view_count}</span>
                                        <span class="r meta">
                                            <fmt:formatDate value="${dto.noticeRegDate}" pattern="yyyy.MM.dd"/>
                                        </span>
                                    </a>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>

            <!-- 페이징 -->
            <c:if test="${paging.count > 0}">
                <nav class="paging">

                    <c:if test="${paging.startPage > paging.pageBlock}">
                        <c:url var="prevUrl" value="/community_notice.co">
                            <c:param name="pageNum" value="${paging.prev}" />
                            <c:param name="searchType" value="${searchType}" />
                            <c:param name="searchKeyword" value="${searchKeyword}" />
                        </c:url>
                        <a class="pg" href="${prevUrl}">‹</a>
                    </c:if>

                    <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                        <c:url var="pageUrl" value="/community_notice.co">
                            <c:param name="pageNum" value="${i}" />
                            <c:param name="searchType" value="${searchType}" />
                            <c:param name="searchKeyword" value="${searchKeyword}" />
                        </c:url>

                        <a class="pg ${paging.currentPage == i ? 'on' : ''}" href="${pageUrl}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${paging.endPage < paging.pageCount}">
                        <c:url var="nextUrl" value="/community_notice.co">
                            <c:param name="pageNum" value="${paging.next}" />
                            <c:param name="searchType" value="${searchType}" />
                            <c:param name="searchKeyword" value="${searchKeyword}" />
                        </c:url>
                        <a class="pg" href="${nextUrl}">›</a>
                    </c:if>

                </nav>
            </c:if>

            <!-- search -->
            <div class="search-row">
                <form class="search-box" action="${path}/community_notice.co" method="get">

                    <select name="searchType">
                        <option value="title" ${searchType eq 'title' ? 'selected' : ''}>제목</option>
                        <option value="content" ${searchType eq 'content' ? 'selected' : ''}>내용</option>
                        <option value="title_content" ${searchType eq 'title_content' ? 'selected' : ''}>제목+내용</option>
                    </select>

                    <input type="text"
                           name="searchKeyword"
                           value="${searchKeyword}"
                           placeholder="공지사항 검색어를 입력하세요">

                    <button type="submit">검색</button>
                </form>
            </div>

        </div>
    </div>

    <%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>