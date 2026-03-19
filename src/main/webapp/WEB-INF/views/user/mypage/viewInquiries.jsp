<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 공통 설정(경로 등) 포함 --%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<%-- JSTL 태그 라이브러리 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - 1:1 문의</title>

<%-- 부트스트랩 및 공통 설정 --%>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>

<style>
    .my-inquiry-section { max-width: 1200px; margin: 50px auto; padding: 0 20px; min-height: 600px; }
    .page-header { margin-bottom: 40px; border-bottom: 3px solid #0CB574; padding-bottom: 15px; display: flex; justify-content: space-between; align-items: center; }
    .page-header h2 { font-size: 28px; font-weight: 800; color: #222; margin: 0; }
    .page-header h2 i { color: #0CB574; margin-right: 12px; }
    .filter-tabs { display: flex; gap: 10px; margin-bottom: 25px; }
    .filter-tab { padding: 8px 22px; border-radius: 30px; border: 1px solid #ddd; background-color: #fff; font-size: 14px; color: #666; cursor: pointer; transition: 0.3s; }
    .filter-tab.active { background-color: #0CB574; color: #fff; border-color: #0CB574; font-weight: 600; box-shadow: 0 4px 10px rgba(12, 181, 116, 0.2); }
    .inquiry-card-wrap { background-color: #fff; border-radius: 15px; border: 1px solid #eef2f0; box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05); overflow: hidden; }
    .inquiry-table { width: 100%; border-collapse: collapse; }
    .inquiry-table thead tr { background-color: #f0fbf7; }
    .inquiry-table thead th { padding: 18px 20px; font-size: 15px; font-weight: 700; color: #333; border-bottom: 1px solid #e6f7f0; }
    .inquiry-table tbody tr { border-bottom: 1px solid #f2f2f2; transition: 0.2s; cursor: pointer; }
    .inquiry-table tbody tr:hover { background-color: #fafffd; }
    .inquiry-table td { padding: 20px; text-align: center; vertical-align: middle; }
    .td-title { text-align: left !important; }
    .td-title a { color: #333; text-decoration: none; font-weight: 600; display: block; max-width: 500px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .td-title a:hover { color: #0CB574; }
    .badge-status { padding: 6px 15px; border-radius: 6px; font-size: 12px; font-weight: 700; }
    .badge-waiting { background-color: #fff4e6; color: #ff922b; }
    .badge-done { background-color: #0CB574; color: #fff; }
    .no-data { text-align: center; padding: 120px 0; background-color: #f0fbf7; border-radius: 15px; border: 1px dashed #0CB574; }
    .no-data i { font-size: 60px; color: #0CB574; margin-bottom: 25px; opacity: 0.7; }
    .no-data p { font-size: 18px; color: #555; margin-bottom: 25px; }
    .btn-sig { background-color: #0CB574; color: white !important; padding: 10px 30px; border-radius: 5px; font-weight: 600; font-size: 15px; transition: 0.3s; border: none; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; }
    .btn-sig:hover { background-color: #098a58; transform: translateY(-3px); box-shadow: 0 5px 15px rgba(12, 181, 116, 0.3); }
    .pagination-wrap { display: flex; justify-content: center; margin-top: 40px; gap: 8px; }
    .page-btn { width: 40px; height: 40px; border-radius: 5px; border: 1px solid #ddd; background-color: #fff; color: #666; cursor: pointer; transition: 0.3s; display: flex; align-items: center; justify-content: center; }
    .page-btn.active { background-color: #0CB574; border-color: #0CB574; color: #fff; font-weight: 700; }
    .page-btn:disabled { cursor: default; opacity: 0.3; }
</style>
</head>
<body>
    <div class="wrap">
        <%-- 헤더 포함 --%>
        <%@ include file="../../common/header.jsp"%>

        <section class="my-inquiry-section">
            <div class="page-header">
                <h2><i class="fa-solid fa-seedling"></i>1:1 문의 내역</h2>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <%-- 필터 탭: 서비스에서 넘겨준 ${status} 값에 따라 active 클래스 부여 --%>
                <div class="filter-tabs">
                    <button class="filter-tab ${status eq 'all' ? 'active' : ''}" onclick="filterInquiry('all')">전체</button>
                    <button class="filter-tab ${status eq 'PENDING' ? 'active' : ''}" onclick="filterInquiry('PENDING')">답변 대기</button>
                    <button class="filter-tab ${status eq 'ANSWERED' ? 'active' : ''}" onclick="filterInquiry('ANSWERED')">답변 완료</button>
                </div>

                <a href="${path}/inquiryWrite.do" class="btn-sig">
                    <i class="fa-solid fa-pen-to-square"></i> 새 문의 작성하기
                </a>
            </div>

            <c:choose>
                <%-- 서비스에서 model.addAttribute("MyInquiryList", list)로 보낸 데이터 확인 --%>
                <c:when test="${not empty MyInquiryList}">
                    <div class="inquiry-card-wrap">
                        <table class="inquiry-table">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">번호</th>
                                    <th>문의 제목</th>
                                    <th style="width: 150px;">상태</th>
                                    <th style="width: 150px;">작성일</th>
                                    <th style="width: 150px;">답변일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="inquiry" items="${MyInquiryList}" varStatus="vs">
                                    <%-- 상세페이지 이동 시 inquiry_id(DTO 변수명) 전달 --%>
                                    <tr onclick="location.href='${path}/inquiryDetail.do?inquiryId=${inquiry.inquiry_id}'">
                                        <td>${vs.count}</td>
                                        <td class="td-title">
                                            <a href="${path}/inquiryDetail.do?inquiryId=${inquiry.inquiry_id}">${inquiry.title}</a>
                                        </td>
                                        <td>
                                            <%-- 상태값에 따른 뱃지 분기처리 --%>
                                            <span class="badge-status ${inquiry.status eq 'ANSWERED' ? 'badge-done' : 'badge-waiting'}">
                                                ${inquiry.status eq 'ANSWERED' ? '답변 완료' : '답변 대기'}
                                            </span>
                                        </td>
                                        <%-- 날짜 포맷팅 (yyyy-MM-dd 형식) --%>
                                        <td><fmt:formatDate value="${inquiry.inquiryDate}" pattern="yyyy-MM-dd"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty inquiry.answerDate}">
                                                    <fmt:formatDate value="${inquiry.answerDate}" pattern="yyyy-MM-dd"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="opacity: 0.3;">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <%-- 페이징 컨트롤러: Paging 객체(${paging}) 활용 --%>
                    <div class="pagination-wrap">
                        <%-- 이전 버튼: 10페이지 단위 이전으로 이동 --%>
                        <c:if test="${paging.startPage > 10}">
                            <button class="page-btn" onclick="movePage(${paging.prev})">
                                <i class="fa-solid fa-chevron-left"></i>
                            </button>
                        </c:if>

                        <%-- 페이지 번호 반복 출력 --%>
                        <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="p">
                            <button class="page-btn ${p == paging.currentPage ? 'active' : ''}" onclick="movePage(${p})">
                                ${p}
                            </button>
                        </c:forEach>

                        <%-- 다음 버튼: 10페이지 단위 다음으로 이동 --%>
                        <c:if test="${paging.endPage < paging.pageCount}">
                            <button class="page-btn" onclick="movePage(${paging.next})">
                                <i class="fa-solid fa-chevron-right"></i>
                            </button>
                        </c:if>
                    </div>
                </c:when>

                <%-- 데이터가 없을 경우 출력 --%>
                <c:otherwise>
                    <div class="no-data">
                        <i class="fa-solid fa-clipboard-question"></i>
                        <p>아직 작성한 문의 내역이 없네요.<br>궁금한 점이 있으시면 언제든지 문의해 주세요!</p>
                        <a href="${path}/inquiryWrite.sp" class="btn-sig">문의하러 가기</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <%@ include file="../../common/footer.jsp"%>
    </div>

    <script>
        // 페이지 번호 클릭 시 호출
        function movePage(page) {
            // 서비스에서 pageNum으로 받으므로 이름을 맞춤
            location.href = '${path}/viewInquiries.do?pageNum=' + page + '&status=${status}';
        }

        // 필터 탭 클릭 시 호출
        function filterInquiry(type) {
            // 필터 변경 시 무조건 1페이지부터 보여줌
            location.href = '${path}/viewInquiries.do?status=' + type + '&pageNum=1';
        }
    </script>
</body>
</html>