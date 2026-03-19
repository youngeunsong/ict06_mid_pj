<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 상세</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>

<style>
    .inquiry-detail-section {
        max-width: 1000px;
        margin: 50px auto;
        padding: 0 20px;
        min-height: 600px;
    }

    .page-header {
        margin-bottom: 35px;
        border-bottom: 3px solid #0CB574;
        padding-bottom: 15px;
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

    .detail-card {
        background-color: #fff;
        border-radius: 18px;
        border: 1px solid #eef2f0;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
        overflow: hidden;
        margin-bottom: 25px;
    }

    .detail-top {
        padding: 28px 30px 22px;
        border-bottom: 1px solid #f1f3f5;
    }

    .detail-category {
        display: inline-block;
        margin-bottom: 14px;
        background-color: #f0fbf7;
        color: #0CB574;
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 700;
    }

    .detail-title {
        font-size: 28px;
        font-weight: 800;
        color: #222;
        margin-bottom: 18px;
        line-height: 1.5;
    }

    .detail-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        font-size: 14px;
        color: #666;
    }

    .meta-box {
        background-color: #f8f9fa;
        border-radius: 20px;
        padding: 7px 14px;
    }

    .badge-status {
        padding: 6px 14px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 700;
    }

    .badge-waiting {
        background-color: #fff4e6;
        color: #ff922b;
    }

    .badge-done {
        background-color: #0CB574;
        color: #fff;
    }

    .detail-body {
        padding: 30px;
    }

    .detail-label {
        font-size: 16px;
        font-weight: 800;
        color: #222;
        margin-bottom: 14px;
    }

    .detail-content-box {
        background-color: #fafafa;
        border: 1px solid #f0f0f0;
        border-radius: 12px;
        padding: 22px;
        line-height: 1.9;
        color: #444;
        min-height: 180px;
        white-space: pre-wrap;
        word-break: break-word;
    }

    .answer-card {
        background-color: #f0fbf7;
        border: 1px solid #dff5eb;
        border-radius: 18px;
        padding: 28px 30px;
        margin-top: 25px;
    }

    .answer-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 18px;
    }

    .answer-title {
        font-size: 20px;
        font-weight: 800;
        color: #0b8f5d;
        margin: 0;
    }

    .answer-date {
        font-size: 14px;
        color: #666;
    }

    .answer-content {
        background-color: #fff;
        border-radius: 12px;
        padding: 22px;
        line-height: 1.9;
        color: #444;
        white-space: pre-wrap;
        word-break: break-word;
        border: 1px solid #e8f6f0;
    }

    .waiting-box {
        background-color: #fff8ef;
        border: 1px solid #ffe3b3;
        border-radius: 18px;
        padding: 30px;
        text-align: center;
        margin-top: 25px;
    }

    .waiting-box i {
        font-size: 34px;
        color: #ff922b;
        margin-bottom: 12px;
    }

    .waiting-box p {
        margin: 0;
        color: #8a5a00;
        font-size: 16px;
        line-height: 1.7;
    }

    .btn-area {
        margin-top: 30px;
        display: flex;
        justify-content: center;
        gap: 12px;
    }

    .btn-line,
    .btn-sig {
        min-width: 140px;
        padding: 12px 24px;
        border-radius: 8px;
        font-weight: 700;
        font-size: 15px;
        text-decoration: none;
        text-align: center;
        transition: 0.3s;
    }

    .btn-line {
        background-color: #fff;
        color: #555;
        border: 1px solid #ddd;
    }

    .btn-line:hover {
        background-color: #f8f8f8;
    }

    .btn-sig {
        background-color: #0CB574;
        color: #fff !important;
        border: none;
    }

    .btn-sig:hover {
        background-color: #098a58;
    }

    .not-found-box {
        background-color: #fff;
        border-radius: 18px;
        border: 1px solid #eef2f0;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
        padding: 100px 30px;
        text-align: center;
    }

    .not-found-box i {
        font-size: 56px;
        color: #bbb;
        margin-bottom: 20px;
    }

    .not-found-box p {
        font-size: 18px;
        color: #666;
        margin-bottom: 25px;
    }
</style>
</head>
<body>
<div class="wrap">
    <%@ include file="../../common/header.jsp"%>

    <section class="inquiry-detail-section">
        <div class="page-header">
            <h2><i class="fa-solid fa-seedling"></i>1:1 문의 상세</h2>
        </div>

        <c:choose>
            <c:when test="${not empty dto}">
                <div class="detail-card">
                    <div class="detail-top">
                        <div class="detail-category">
                            <c:choose>
                                <c:when test="${not empty dto.category}">
                                    ${dto.category}
                                </c:when>
                                <c:otherwise>
                                    일반 문의
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="detail-title">${dto.title}</div>

                        <div class="detail-meta">
                            <span class="meta-box">
                                작성자 ${dto.user_id}
                            </span>

                            <span class="meta-box">
                                작성일 <fmt:formatDate value="${dto.inquiryDate}" pattern="yyyy-MM-dd HH:mm"/>
                            </span>

                            <span class="badge-status ${dto.status eq 'ANSWERED' ? 'badge-done' : 'badge-waiting'}">
                                ${dto.status eq 'ANSWERED' ? '답변 완료' : '답변 대기'}
                            </span>
                        </div>
                    </div>

                    <div class="detail-body">
                        <div class="detail-label">문의 내용</div>
                        <div class="detail-content-box">${dto.content}</div>

                        <c:choose>
                            <c:when test="${dto.status eq 'ANSWERED' and not empty dto.admin_reply}">
                                <div class="answer-card">PlaceDTO 코드
                                    <div class="answer-header">
                                        <h3 class="answer-title">
                                            <i class="fa-solid fa-comment-dots me-2"></i>관리자 답변
                                        </h3>
                                        <div class="answer-date">
                                            답변일 :
                                            <fmt:formatDate value="${dto.answerDate}" pattern="yyyy-MM-dd HH:mm"/>
                                        </div>
                                    </div>

                                    <div class="answer-content">${dto.admin_reply}</div>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="waiting-box">
                                    <i class="fa-regular fa-hourglass-half"></i>
                                    <p>
                                        현재 문의를 확인 중입니다.<br>
                                        답변이 등록되면 이 영역에 관리자 답변이 표시됩니다.
                                    </p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="btn-area">
                            <a href="${path}/viewInquiries.do" class="btn-line">목록으로</a>
                        </div>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="not-found-box">
                    <i class="fa-regular fa-circle-xmark"></i>
                    <p>해당 문의를 찾을 수 없거나 조회 권한이 없습니다.</p>
                    <a href="${path}/viewInquiries.do" class="btn-sig">문의 목록으로</a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <%@ include file="../../common/footer.jsp"%>
</div>
</body>
</html>