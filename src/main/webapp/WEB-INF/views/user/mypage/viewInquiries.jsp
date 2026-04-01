<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - 1:1 문의</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<link rel="stylesheet" href="${path}/resources/css/user/mypage/viewInquiries.css">
</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<section class="my-inquiry-section">
			<div class="page-header">
				<h2>
					<img src="${path}/resources/images/common/locationMarker.png" class="title-marker"> 1:1 문의 내역
				</h2>
			</div>

			<div class="d-flex justify-content-between align-items-center mb-4">
				<div class="filter-tabs">
					<button class="filter-tab ${status eq 'all' ? 'active' : ''}"
						onclick="filterInquiry('all')">전체</button>
					<button class="filter-tab ${status eq 'PENDING' ? 'active' : ''}"
						onclick="filterInquiry('PENDING')">답변 대기</button>
					<button class="filter-tab ${status eq 'ANSWERED' ? 'active' : ''}"
						onclick="filterInquiry('ANSWERED')">답변 완료</button>
				</div>

				<a href="${path}/inquiryWrite.sp" class="btn-sig">
					<i class="bi bi-pencil-square"></i> 새 문의 작성하기
				</a>
			</div>

			<c:choose>
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
									<tr onclick="location.href='${path}/inquiryDetail.do?inquiryId=${inquiry.inquiry_id}'">

										<td>${(paging.currentPage - 1) * 10 + vs.count}</td>

										<td class="td-title">
											<a href="${path}/inquiryDetail.do?inquiryId=${inquiry.inquiry_id}">
												${inquiry.title}
											</a>
										</td>

										<td>
											<span class="badge-status ${inquiry.status eq 'ANSWERED' ? 'badge-done' : 'badge-waiting'}">
												${inquiry.status eq 'ANSWERED' ? '답변 완료' : '답변 대기'}
											</span>
										</td>

										<td>
											<fmt:formatDate value="${inquiry.inquiryDate}" pattern="yyyy-MM-dd" />
										</td>

										<td>
											<c:choose>
												<c:when test="${not empty inquiry.answerDate}">
													<fmt:formatDate value="${inquiry.answerDate}" pattern="yyyy-MM-dd" />
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

					<div class="pagination-wrap">

						<c:if test="${paging.startPage > 10}">
							<button class="page-btn" onclick="movePage(${paging.prev})">
								<i class="bi bi-chevron-left"></i>
							</button>
						</c:if>

						<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="p">
							<button class="page-btn ${p == paging.currentPage ? 'active' : ''}"
								onclick="movePage(${p})">${p}</button>
						</c:forEach>

						<c:if test="${paging.endPage < paging.pageCount}">
							<button class="page-btn" onclick="movePage(${paging.next})">
								<i class="bi bi-chevron-right"></i>
							</button>
						</c:if>

					</div>
				</c:when>

				<c:otherwise>
					<div class="no-data">
						<i class="bi bi-question-circle"></i>
						<p>
							아직 작성한 문의 내역이 없네요.<br>
							궁금한 점이 있으시면 언제든지 문의해 주세요!
						</p>
						<a href="${path}/inquiryWrite.sp" class="btn-sig">문의하러 가기</a>
					</div>
				</c:otherwise>
			</c:choose>
		</section>

		<%@ include file="../../common/footer.jsp"%>
	</div>

	<script>
	    const contextPath = '${path}';
	    const inquiryStatus = '${status}';
	</script>
	<script src="${path}/resources/js/user/mypage/viewInquiries.js"></script>
</body>
</html>