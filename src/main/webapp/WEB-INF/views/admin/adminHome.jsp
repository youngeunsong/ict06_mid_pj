<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>관리자 Home</title>

</head>
<!--end::Head-->
<!--begin::Body-->
<body class="hold-transition sidebar-mini layout-fixed">
	<div class="wrapper">

		<!-- Preloader -->
		<div
			class="preloader flex-column justify-content-center align-items-center">
			<img src="${path}/resources/admin/dist/img/AdminLTELogo.png"
				height="60" width="60">
		</div>

		<!-- ================= HEADER ================= -->
		<%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>

		<!-- ================= SIDEBAR ================= -->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

		<!-- ================= CONTENT ================= -->
		<!--begin::content-wrapper-->
		<div class="content-wrapper">
			<!--begin::content-header-->
			<div class="content-header">
				<!--begin::container-fluid-->
				<div class="container-fluid">
					<h1 class="m-0">Dashboard</h1>
				</div>
			</div>
			<!--end::content-header-->
		
			<!--begin::content-->
			<section class="content">
				<!--begin::container-fluid-->
				<div class="container-fluid">
					
					<!-- KPI 요약 -->
					<div class="row mb-4">
						<div class="col-12">
							<div class="card card-primary shadow-sm">
								<div class="card-header">
									<h3 class="card-title font-weight-bold">기간별 KPI 요약</h3>
								</div>
								<div class="card-body text-center">
									<div class="row">
										<div class="col-3 border-right" style="cursor:pointer"
											onclick="trackDashboardKPI('total_visitor')"><h6>전체 방문자</h6></div>
										<div class="col-3 border-right" style="cursor:pointer"
											onclick="trackDashboardKPI('reservation_rate')"><h6>예약 전환율</h6></div>
										<div class="col-3 border-right" style="cursor:pointer"
											onclick="trackDashboardKPI('average_rating')"><h6>평균 평점</h6></div>
										<div class="col-3" style="cursor:pointer"
											onclick="trackDashboardKPI('new_member')"><h6>신규 회원</h6></div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- Wordcloud + 1:1 문의 미처리 -->
					<div class="row mb-4">
						<div class="col-md-6">
							<div class="card h-100 shadow-sm">
								<div class="card-header">
									<h3 class="card-title font-weight-bold">만족도 설문 wordcloud</h3>
								</div>
								<div class="card-body d-flex align-items-center justify-content-center" style="min-height:300px;">
									<div id="wordcloud-canvas">
										<p class="text-muted">서술형 데이터 분석 영역</p>
									</div>
								</div>
							</div>
						</div>
						
						<div class="col-md-6">
							<div class="card h-100 shadow-sm">
								<div class="card-header">
									<h3 class="card-title font-weight-bold text-danger">
									<i class="bi bi-exclamation-circle mr-1"></i>1:1문의 미처리
									</h3>
								</div>
								<div class="card-body" style="max-height:350px; overflow-y:auto;">
									<c:choose>
										<c:when test="${empty pendingInquiryList}">
											<div class="text-center py-4 text-muted">미처리 내역이 없습니다.</div>
										</c:when>
										<c:otherwise>
											<c:forEach var="inquiry" items="${pendingInquiryList}">
												<div class="inquiry-item py-2 border-bottom">
													<div class="inquiry-info">
														<span class="badge badge-warning mr-1">${inquiry.category}</span>
														<span class="font-weight-bold inquiry-title">${inquiry.title}</span>
														<div class="inquiry-meta text-muted">
															${inquiry.user_id} · <fmt:formatDate value="${inquiry.inquiryDate}" pattern="yyyy-MM-dd HH:mm" />
														</div>
													</div>
													<a href="${path}/adInquiryDetail.adsp?inquiry_id=${inquiry.inquiry_id}"
														class="btn btn-sm btn-edit flex-shrink-0"
														onclick="trackInquiryAction('${inquiry.category}', '${inquiry.inquiry_id}')">답변하기</a>
												</div>
											</c:forEach>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</div>
					</div>
						
						<!--사용자 만족도 설문 결과-->
						<div class="row mb-4">
							<div class="col-12">
								<div class="card shadow-sm border-0">
									<div class="card-header bg-white">
										<h3 class="card-title font-weight-bold">사용자 만족도 설문 결과</h3>
									</div>
									<div class="card-body p-0">
										<div id="survey-result-table" style="min-height:350px;" class="bg-light d-flex align-items-center justify-content-center">
											<p class="text-muted">데이터 테이블 로딩 영역</p>
										</div>
									</div>
								</div>
							</div>
						</div>
						
					</div>
					<!--end::container-fluid-->
				</section>
				<!--end::content-->
			</div>
			<!--end::content-wrapper-->
				
			<!-- ================= FOOTER ================= -->
			<footer class="main-footer">
				<strong>Copyright &copy; 2026</strong>
			</footer>
		</div>
		<!--end::wrapper-->

	<!-- ================= JS ================= -->
	<!-- OverlayScrollbars 사이드바 설정 -->
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

<script>const path = "${path}";</script>
<script src="${path}/resources/js/admin/adHomeDashboard.js"></script>

</body>
</html>
