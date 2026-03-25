<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 상세</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<link rel="stylesheet" href="${path}/resources/css/user/mypage/inquiryDetail.css">
</head>
<body>
<div class="wrap">
    <%@ include file="../../common/header.jsp"%>

    <section class="inquiry-detail-section">
        <div class="page-header">
            <h2><i class="bi bi-flower1"></i>1:1 문의 상세</h2>
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
                                <div class="answer-card">
                                    <div class="answer-header">
                                        <h3 class="answer-title">
                                            <i class="bi bi-chat-dots me-2"></i>관리자 답변
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
                                    <i class="bi bi-hourglass-split"></i>
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
                    <i class="bi bi-x-circle"></i>
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