<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - 북마크</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<link rel="stylesheet" href="${path}/resources/css/user/mypage/viewBookmarks.css">
</head>
<body>
<div class="wrap">
    <%@ include file="../../common/header.jsp"%>

    <section class="my-favorite-section">
        <div class="page-header">
            <h2><img src="${path}/resources/images/common/locationMarker.png" class="title-marker"> 내 북마크</h2>
        </div>

        <!-- 카테고리 필터 -->
        <div class="filter-tabs">
            <button class="filter-tab ${empty category or category eq 'all' ? 'active' : ''}"
                    onclick="filterBookmark('all')">전체</button>

            <button class="filter-tab ${category eq 'REST' ? 'active' : ''}"
                    onclick="filterBookmark('REST')">맛집</button>

            <button class="filter-tab ${category eq 'FEST' ? 'active' : ''}"
                    onclick="filterBookmark('FEST')">축제</button>

            <button class="filter-tab ${category eq 'ACC' ? 'active' : ''}"
                    onclick="filterBookmark('ACC')">숙소</button>
        </div>

        <!-- 북마크 카드 목록 -->
        <div class="bookmark-grid">
            <c:forEach var="place" items="${list}">

                <c:choose>
                    <c:when test="${place.place_type eq 'REST'}">
                        <c:set var="detailUrl" value="${path}/restaurantDetail.rs?place_id=${place.place_id}" />
                    </c:when>
                    <c:when test="${place.place_type eq 'ACC'}">
                        <c:set var="detailUrl" value="${path}/accommodationDetail.ac?place_id=${place.place_id}" />
                    </c:when>
                    <c:when test="${place.place_type eq 'FEST'}">
                        <c:set var="detailUrl" value="${path}/festivalDetail.fe?place_id=${place.place_id}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="detailUrl" value="javascript:void(0);" />
                    </c:otherwise>
                </c:choose>

                <a href="${detailUrl}" class="bookmark-card-link">
                    <div class="bookmark-card" data-place-id="${place.place_id}">
                        <div class="bookmark-img-wrap">
                        	            <!-- 북마크 버튼 -->
								<button type="button" class="bookmark-btn"
									onclick="toggleBookmark(event, this)"
									data-place-id="${place.place_id}">
									<i class="bi bi-bookmark-fill"></i>
								</button>

								<c:choose>
                                <c:when test="${not empty place.image_url}">
                                    <img src="${place.image_url}" alt="${place.name}" class="bookmark-img">
                                </c:when>
                                <c:otherwise>
                                    <img src="${path}/resources/images/noimage.jpg" alt="기본 이미지" class="bookmark-img">
                                </c:otherwise>
                            </c:choose>

                            <c:choose>
                                <c:when test="${place.place_type eq 'REST'}">
                                    <span class="type-tag type-rest">
                                        <i class="bi bi-cup-hot me-1"></i> 맛집
                                    </span>
                                </c:when>
                                <c:when test="${place.place_type eq 'ACC'}">
                                    <span class="type-tag type-acc">
                                        <i class="bi bi-building me-1"></i> 숙소
                                    </span>
                                </c:when>
                                <c:when test="${place.place_type eq 'FEST'}">
                                    <span class="type-tag type-fest">
                                        <i class="bi bi-emoji-smile me-1"></i> 축제
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="type-tag type-etc">
                                        <i class="bi bi-geo-alt me-1"></i> 기타
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="bookmark-content">
                            <div class="place-title">${place.name}</div>

                            <div class="place-address">
                                <i class="bi bi-geo-alt me-1"></i> ${place.address}
                            </div>

                            <div class="place-meta">
                                <span class="meta-item">
                                    <i class="bi bi-star me-1"></i> 평점 ${place.avg_rating}
                                </span>
                                <span class="meta-item">
                                    <i class="bi bi-chat-dots me-1"></i> 리뷰 ${place.review_count}
                                </span>
                                <span class="meta-item">
                                    <i class="bi bi-eye me-1"></i> 조회 ${place.view_count}
                                </span>
                            </div>
                        </div>
                    </div>
                </a>
            </c:forEach>

            <!-- 데이터 없을 때 -->
            <c:if test="${empty list}">
                <div class="no-data">
                    <i class="bi bi-heart"></i>
                    <p>
                        아직 북마크에 담은 장소가 없네요.<br>
                        당신만의 특별한 장소를 찾아보세요!
                    </p>
                    <a href="${path}/main.do" class="btn btn-sig">홈 화면으로 가기</a>
                </div>
            </c:if>
        </div>

        <!-- 페이징 -->
        <c:if test="${not empty paging and paging.count > 0}">
            <div class="paging-wrap">

                <!-- 이전 -->
                <c:if test="${paging.startPage > paging.pageBlock}">
                    <a class="paging-btn"
                       href="${path}/viewBookmarks.do?pageNum=${paging.startPage - paging.pageBlock}&category=${category}">
                        이전
                    </a>
                </c:if>

                <!-- 페이지 번호 -->
                <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                    <c:choose>
                        <c:when test="${i == paging.currentPage}">
                            <span class="paging-btn active">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a class="paging-btn"
                               href="${path}/viewBookmarks.do?pageNum=${i}&category=${category}">
                                ${i}
                            </a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <!-- 다음 -->
                <c:if test="${paging.pageCount > paging.endPage}">
                    <a class="paging-btn"
                       href="${path}/viewBookmarks.do?pageNum=${paging.startPage + paging.pageBlock}&category=${category}">
                        다음
                    </a>
                </c:if>
            </div>
        </c:if>
    </section>
    <%@ include file="../../common/footer.jsp"%>
</div>
<script>
    const contextPath = '${path}';
</script>
<script src="${path}/resources/js/user/mypage/viewBookmarks.js"></script>
</body>
</html>