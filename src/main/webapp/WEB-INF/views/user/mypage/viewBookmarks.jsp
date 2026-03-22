<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - 즐겨찾기</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>

<style>
    .my-favorite-section {
        max-width: 1200px;
        margin: 50px auto;
        padding: 0 20px;
        min-height: 600px;
    }

    .page-header {
        margin-bottom: 35px;
        border-bottom: 3px solid #0CB574;
        padding-bottom: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 10px;
    }

    .page-header h2 {
        font-size: 28px;
        font-weight: 800;
        color: #222;
        margin: 0;
    }

    .page-header h2 i {
        color: #0CB574;
        margin-right: 12px;
    }

    .count-info {
        font-size: 16px;
        color: #666;
    }

    .count-info strong {
        color: #0CB574;
        font-size: 20px;
        font-weight: 800;
    }

    .bookmark-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
        gap: 24px;
    }

    .bookmark-card-link {
        text-decoration: none;
        color: inherit;
        display: block;
    }

    .bookmark-card {
        background-color: #fff;
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 4px 14px rgba(0, 0, 0, 0.08);
        transition: all 0.25s ease;
        border: 1px solid #edf1ef;
        height: 100%;
    }

    .bookmark-card-link:hover .bookmark-card {
        transform: translateY(-6px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
    }

    .bookmark-img-wrap {
        position: relative;
        width: 100%;
        height: 160px;
        overflow: hidden;
        background-color: #f4f4f4;
    }

    .bookmark-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }

    .type-tag {
        position: absolute;
        top: 12px;
        left: 12px;
        z-index: 10;
        color: #fff;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 700;
        box-shadow: 0 2px 5px rgba(0,0,0,0.15);
    }

    .type-rest {
        background-color: #ff7a59;
    }

    .type-acc {
        background-color: #4b7bec;
    }

    .type-fest {
        background-color: #a55eea;
    }

    .type-etc {
        background-color: #7f8c8d;
    }

    .bookmark-content {
        padding: 16px;
    }

    .place-title {
        font-size: 19px;
        font-weight: 800;
        margin-bottom: 10px;
        line-height: 1.4;
        min-height: 52px;
        color: #222;
    }

    .place-address {
        font-size: 13px;
        color: #777;
        line-height: 1.5;
        min-height: 40px;
        margin-bottom: 14px;
    }

    .place-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        font-size: 13px;
        color: #444;
    }

    .meta-item {
        background-color: #f7f8f9;
        border-radius: 20px;
        padding: 5px 10px;
    }

    .no-data {
        grid-column: 1 / -1;
        text-align: center;
        padding: 120px 0;
        background-color: #f0fbf7;
        border-radius: 15px;
        border: 1px dashed #0CB574;
    }

    .no-data i {
        font-size: 60px;
        color: #0CB574;
        margin-bottom: 25px;
        opacity: 0.7;
    }

    .no-data p {
        font-size: 18px;
        color: #555;
        margin-bottom: 25px;
        line-height: 1.7;
    }

    .btn-sig {
        background-color: #0CB574;
        color: white !important;
        padding: 12px 40px;
        border-radius: 5px;
        font-weight: 600;
        font-size: 16px;
        transition: 0.3s;
        border: none;
        display: inline-block;
        text-decoration: none;
    }

    .btn-sig:hover {
        background-color: #098a58;
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(12, 181, 116, 0.3);
    }

    @media screen and (max-width: 768px) {
        .page-header {
            align-items: flex-start;
        }

        .page-header h2 {
            font-size: 24px;
        }

        .bookmark-img-wrap {
            height: 150px;
        }
    }
</style>
</head>
<body>
<div class="wrap">
    <%@ include file="../../common/header.jsp"%>

    <section class="my-favorite-section">
        <div class="page-header">
            <h2><i class="fa-solid fa-seedling"></i>내 즐겨찾기</h2>

            <div class="count-info">
                전체 <strong>${fn:length(list)}</strong>곳의 소중한 장소들
            </div>
        </div>

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
                    <div class="bookmark-card">
                        <div class="bookmark-img-wrap">
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
                                        <i class="fa-solid fa-utensils me-1"></i> 맛집
                                    </span>
                                </c:when>
                                <c:when test="${place.place_type eq 'ACC'}">
                                    <span class="type-tag type-acc">
                                        <i class="fa-solid fa-hotel me-1"></i> 숙소
                                    </span>
                                </c:when>
                                <c:when test="${place.place_type eq 'FEST'}">
                                    <span class="type-tag type-fest">
                                        <i class="fa-solid fa-masks-theater me-1"></i> 축제
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="type-tag type-etc">
                                        <i class="fa-solid fa-location-dot me-1"></i> 기타
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="bookmark-content">
                            <div class="place-title">${place.name}</div>

                            <div class="place-address">
                                <i class="fa-solid fa-location-dot me-1"></i> ${place.address}
                            </div>

                            <div class="place-meta">
                                <span class="meta-item">
                                    <i class="fa-solid fa-star me-1"></i> 평점 ${place.avg_rating}
                                </span>
                                <span class="meta-item">
                                    <i class="fa-solid fa-comment-dots me-1"></i> 리뷰 ${place.review_count}
                                </span>
                                <span class="meta-item">
                                    <i class="fa-solid fa-eye me-1"></i> 조회 ${place.view_count}
                                </span>
                            </div>
                        </div>
                    </div>
                </a>
            </c:forEach>

            <c:if test="${empty list}">
                <div class="no-data">
                    <i class="fa-solid fa-heart-circle-plus"></i>
                    <p>
                        아직 즐겨찾기에 담은 장소가 없네요.<br>
                        당신만의 특별한 장소를 찾아보세요!
                    </p>
                    <a href="${path}/main.do" class="btn btn-sig">홈 화면으로 가기</a>
                </div>
            </c:if>
        </div>
    </section>

    <%@ include file="../../common/footer.jsp"%>
</div>
</body>
</html>