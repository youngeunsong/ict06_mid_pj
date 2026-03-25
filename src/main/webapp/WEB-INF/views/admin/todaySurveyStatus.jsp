<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-23
 * 최종수정일: 2026-03-24
 
 현 페이지 미사용/ 추후 작업 중 필요 시 사용하기 위해 파일만 유지
 
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>금일 사용자 만족도 표</title>

<link rel="stylesheet" href="${path}/resources/css/admin/today_survey_status.css">
<script src="${path}/resources/js/admin/adTodaySurveyStatus.js" defer></script>
</head>

<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

    <!-- Preloader -->
    <div class="preloader flex-column justify-content-center align-items-center">
        <img src="${path}/resources/admin/dist/img/AdminLTELogo.png" height="60" width="60" alt="AdminLTE Logo">
    </div>

    <!-- HEADER -->
    <%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>

    <!-- SIDEBAR -->
    <%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

    <!-- CONTENT -->
    <div class="content-wrapper">
        <section class="content-header">
            <div class="container-fluid survey-status-header">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                    <div>
                        <h1 class="survey-status-title">금일 사용자 만족도 표</h1>
                        <p class="survey-status-subtitle mb-0">금일 취합된 만족도 설문 결과를 최신순으로 확인합니다.</p>
                    </div>
                    <div>
                        <a href="${path}/adminHome.ad" class="btn btn-outline-primary btn-sm">대시보드로 돌아가기</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid survey-status-wrap">

                <!-- 요약 카드 -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6">
                        <div class="card summary-card accent-blue">
                            <div class="card-body">
                                <h6>금일 총 응답 수</h6>
                                <h3>${surveyCnt}</h3>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 표 -->
                <div class="card survey-table-card">
                    <div class="card-header d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <h5 class="mb-0">금일 사용자 만족도 목록</h5>
                        <span class="table-count-text">총 ${surveyCnt}건</span>
                    </div>

                    <div class="card-body table-responsive">
                        <table class="table survey-table align-middle text-center">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>NPS</th>
                                    <th>맛집만족도</th>
                                    <th>정보신뢰도</th>
                                    <th>제출일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="survey" items="${surveyList}" varStatus="status">
                                    <tr>
                                        <td>
                                            ${surveyCnt - ((paging.currentPage - 1) * paging.pageSize) - status.index}
                                        </td>
                                        <td>${survey.nps_score}</td>
                                        <td>${survey.satisfaction_score}</td>
                                        <td>${survey.info_reliability_score}</td>
                                        <td>
                                            <fmt:formatDate value="${survey.surveyDate}" pattern="yyyy-MM-dd HH:mm" />
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty surveyList}">
                                    <tr>
                                        <td colspan="5" class="empty-row">금일 집계된 설문 데이터가 없습니다.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 페이징 -->
                <c:if test="${surveyCnt > 0}">
                    <nav aria-label="Page navigation" class="paging-wrap">
                        <ul class="pagination justify-content-center">

                            <!-- 이전 -->
                            <c:if test="${paging.startPage > paging.pageBlock}">
                                <li class="page-item">
                                    <a class="page-link" href="${path}/todaySurveyStatus.ad?pageNum=${paging.startPage - paging.pageBlock}">
                                        이전
                                    </a>
                                </li>
                            </c:if>

                            <!-- 페이지 번호 -->
                            <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                                <c:choose>
                                    <c:when test="${i == paging.currentPage}">
                                        <li class="page-item active">
                                            <span class="page-link">${i}</span>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item">
                                            <a class="page-link" href="${path}/todaySurveyStatus.ad?pageNum=${i}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <!-- 다음 -->
                            <c:if test="${paging.pageCount > paging.endPage}">
                                <li class="page-item">
                                    <a class="page-link" href="${path}/todaySurveyStatus.ad?pageNum=${paging.startPage + paging.pageBlock}">
                                        다음
                                    </a>
                                </li>
                            </c:if>

                        </ul>
                    </nav>
                </c:if>

            </div>
        </section>
    </div>

    <!-- FOOTER -->
    <footer class="main-footer">
        <strong>Copyright &copy; 2026</strong>
    </footer>
</div>

<!-- OverlayScrollbars -->
<script>
    const SELECTOR_SIDEBAR_WRAPPER = '.sidebar-wrapper';
    document.addEventListener('DOMContentLoaded', function () {
        const sidebarWrapper = document.querySelector(SELECTOR_SIDEBAR_WRAPPER);
        if (sidebarWrapper && typeof OverlayScrollbarsGlobal !== 'undefined'
                && OverlayScrollbarsGlobal.OverlayScrollbars !== undefined) {
            OverlayScrollbarsGlobal.OverlayScrollbars(sidebarWrapper, {
                scrollbars: {
                    theme: 'os-theme-light',
                    autoHide: 'leave',
                    clickScroll: true,
                },
            });
        }
    });
</script>

</body>
</html>