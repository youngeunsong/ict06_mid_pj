<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-18
 * 최종수정일: 2026-03-20
 
진행 중 이벤트 : 별도 조회/ 항상 최상단 고정/ 카드형
(메인 carousel처럼 강조)
CATEGORY='EVENT' AND IS_TOP='Y'

종료 이벤트 : 검색 + 페이징/ 카드형 리스트
CATEGORY='EVENT' AND IS_TOP='N'
 
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 > 이벤트</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/community/community-common.css">
<link rel="stylesheet" href="${path}/resources/css/user/community/event.css">

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

            <div class="breadcrumb-area">
                <a href="${path}/community_free.co">커뮤니티</a>
                <i class="bi bi-chevron-right"></i>
                <span class="cur">이벤트</span>
            </div>

            <div class="page-title-row">
                <span class="page-title">
                    <i class="bi bi-gift-fill text-danger me-1"></i> 이벤트
                </span>
            </div>

            <div class="info-card">
                <div style="display:flex; align-items:flex-start; gap:10px;">
                    <div style="font-size:1.1rem; color:#dc3545; line-height:1;">
                        <i class="bi bi-stars"></i>
                    </div>
                    <div>
                        <div style="font-size:.9rem; font-weight:700; color:#212529; margin-bottom:4px;">
                            현재 진행 중인 혜택과 지난 이벤트를 확인하세요
                        </div>
                        <div style="font-size:.8rem; color:#6c757d; line-height:1.7;">
                            상단에는 현재 진행 중인 이벤트가 먼저 노출되며,
                            아래에서는 종료된 이벤트를 검색하고 확인할 수 있습니다.
                        </div>
                    </div>
                </div>
            </div>

            <!-- 진행 중 이벤트 -->
            <c:if test="${not empty ongoingEventList}">
                <section class="event-section">
                    <div class="event-section-title">
                        <i class="bi bi-lightning-charge-fill"></i>
                        진행 중인 이벤트
                    </div>

                    <div id="ongoingEventCarousel" class="carousel slide ongoing-carousel" data-bs-interval="false">
                        <div class="carousel-inner">

                            <c:forEach var="i" begin="0" end="${ongoingEventList.size() - 1}" step="3">
                                <div class="carousel-item ${i == 0 ? 'active' : ''}">
                                    <div class="ongoing-event-grid multi">

                                        <c:forEach var="j" begin="${i}" end="${i + 2}">
                                            <c:if test="${j < ongoingEventList.size()}">
                                                <c:set var="dto" value="${ongoingEventList[j]}" />

                                                <a href="${path}/community_event_detail.co?notice_id=${dto.notice_id}" class="ongoing-event-card">
                                                    <div class="ongoing-event-thumb">
                                                        <c:choose>
                                                            <c:when test="${not empty dto.image_url}">
                                                                <img src="${path}/resources/upload/${dto.image_url}" alt="${dto.title}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="no-image-box">
                                                                    <i class="bi bi-gift"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <span class="ongoing-badge">진행중</span>
                                                    </div>

                                                    <div class="ongoing-event-body">
                                                        <div class="ongoing-top-row">
                                                            <span class="bdg bdg-event">
                                                                <i class="bi bi-gift"></i> 이벤트
                                                            </span>
                                                        </div>

                                                        <div class="ongoing-event-title">${dto.title}</div>

                                                        <div class="ongoing-event-desc">
                                                            <c:out value="${dto.content}" />
                                                        </div>

                                                        <div class="ongoing-event-meta">
                                                            <span><i class="bi bi-eye"></i> ${dto.view_count}</span>
                                                            <span>
                                                                <i class="bi bi-calendar3"></i>
                                                                <fmt:formatDate value="${dto.noticeRegDate}" pattern="yyyy.MM.dd"/>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </a>
                                            </c:if>
                                        </c:forEach>

                                    </div>
                                </div>
                            </c:forEach>

                        </div>

                        <c:if test="${ongoingEventList.size() > 3}">
                            <button class="carousel-control-prev" type="button" data-bs-target="#ongoingEventCarousel" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">이전</span>
                            </button>

                            <button class="carousel-control-next" type="button" data-bs-target="#ongoingEventCarousel" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">다음</span>
                            </button>
                        </c:if>
                    </div>
                </section>
            </c:if>

            <!-- 종료된 이벤트 -->
            <section class="event-section">
                <div class="board-card ended-event-card-wrap">

                    <div class="board-section-title normal">
                        <i class="bi bi-archive"></i>
                        종료된 이벤트
                    </div>

                    <div class="ended-event-grid">
                        <c:choose>
                            <c:when test="${empty endedEventList}">
                                <div class="empty">
                                    <i class="bi bi-gift"></i>
                                    종료된 이벤트가 없습니다.
                                </div>
                            </c:when>

                            <c:otherwise>
                                <c:forEach var="dto" items="${endedEventList}">
                                    <a href="${path}/community_event_detail.co?notice_id=${dto.notice_id}" class="ended-event-card">
                                        <div class="ended-event-thumb">
                                            <c:choose>
                                                <c:when test="${not empty dto.image_url}">
                                                    <img src="${path}/resources/upload/${dto.image_url}" alt="${dto.title}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="no-image-box">
                                                        <i class="bi bi-image"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="ended-badge">종료</span>
                                        </div>

                                        <div class="ended-event-body">
                                            <div class="ended-event-title">${dto.title}</div>

                                            <div class="ended-event-meta">
                                                <span><i class="bi bi-eye"></i> ${dto.view_count}</span>
                                                <span><fmt:formatDate value="${dto.noticeRegDate}" pattern="yyyy.MM.dd"/></span>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>

            <!-- pagination -->
            <c:if test="${paging.count > 0}">
                <nav class="paging">

                    <c:if test="${paging.startPage > paging.pageBlock}">
                        <c:url var="prevUrl" value="/community_event.co">
                            <c:param name="pageNum" value="${paging.prev}" />
                            <c:param name="searchType" value="${searchType}" />
                            <c:param name="searchKeyword" value="${searchKeyword}" />
                        </c:url>
                        <a class="pg" href="${prevUrl}">‹</a>
                    </c:if>

                    <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                        <c:url var="pageUrl" value="/community_event.co">
                            <c:param name="pageNum" value="${i}" />
                            <c:param name="searchType" value="${searchType}" />
                            <c:param name="searchKeyword" value="${searchKeyword}" />
                        </c:url>

                        <a class="pg ${paging.currentPage == i ? 'on' : ''}" href="${pageUrl}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${paging.endPage < paging.pageCount}">
                        <c:url var="nextUrl" value="/community_event.co">
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
                <form class="search-box" action="${path}/community_event.co" method="get">

                    <select name="searchType">
                        <option value="title" ${searchType eq 'title' ? 'selected' : ''}>제목</option>
                        <option value="content" ${searchType eq 'content' ? 'selected' : ''}>내용</option>
                        <option value="title_content" ${searchType eq 'title_content' ? 'selected' : ''}>제목+내용</option>
                    </select>

                    <input type="text"
                           name="searchKeyword"
                           value="${searchKeyword}"
                           placeholder="종료된 이벤트 검색어를 입력하세요">

                    <button type="submit">검색</button>
                </form>
            </div>

        </div>
    </div>

    <%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>