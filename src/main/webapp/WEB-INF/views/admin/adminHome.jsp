<!-- 
 * @author 김다솜 / 송혜진 / 송영은
 * 최초작성일: 2026-03-23
 * 최종수정일: 2026-03-25
 * 수정 내용
 v260325: 조회 기간 내 사용자 만족도 조사 결과 표 추가 (송영은)
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp"%> <!-- 관리자용 setting 별도로 함. 주의! -->
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>관리자 Home</title>

<link rel="stylesheet" href="${path}/resources/css/admin/ad_home.css">

<script src="https://cdn.jsdelivr.net/npm/echarts@5/dist/echarts.min.js"></script> <!-- E차트 라이브러리 선언 -->
<script src="${path}/resources/js/admin/adHome.js" defer></script>
<script>const path = "${path}";</script>
</head>
<!--begin::Body-->
<!-- <body class="hold-transition sidebar-mini layout-fixed"> -->
<body class="hold-transition sidebar-mini">
<!--begin::div wrapper-->
<!-- <div class="wrapper"> -->
<div class="wrapper d-flex flex-column min-vh-100">
	<!-- Preloader -->
	<div
		class="preloader flex-column justify-content-center align-items-center">
		<img src="${path}/resources/admin/dist/img/AdminLTELogo.png"
			height="60" width="60" alt="AdminLTE Logo">
	</div>

	<!-- ================= HEADER ================= -->
	<%@ include file="/WEB-INF/views/common/adminHeader.jsp"%>

	<!-- ================= SIDEBAR ================= -->
	<%@ include file="/WEB-INF/views/common/adminSidebar.jsp"%>

	<!-- ================= CONTENT ================= -->
	<!-- <div class="content-wrapper"> -->
	<div class="content-wrapper flex-grow-1">
		<section class="content pt-3">
			<div class="container-fluid">
				<!-- ===== 기간 조회 필터S ===== -->
				<div class="card dashboard-card filter-card mb-4">
					<div class="card-body">
						<div class="period-shortcuts mb-3">
							<button type="button" class="btn btn-outline-primary range-btn"
								data-range="7">7일</button>
							<button type="button" class="btn btn-outline-primary range-btn"
								data-range="30">30일</button>
							<button type="button" class="btn btn-outline-primary range-btn"
								data-range="90">90일</button>
							<button type="button" class="btn btn-outline-primary range-btn"
								data-range="180">6개월</button>
							<button type="button" class="btn btn-outline-primary range-btn"
								data-range="365">1년</button>
						</div>

						<form action="${path}/adminHome.ad" method="get"
							class="row g-3 align-items-end">
							<div class="col-lg-4 col-md-6">
								<label for="startDate" class="form-label">시작일</label>
								<input
									type="date" id="startDate" name="startDate"
									value="${startDate}" class="form-control">
							</div>

							<div class="col-lg-4 col-md-6">
								<label for="endDate" class="form-label">종료일</label>
								<input
									type="date" id="endDate" name="endDate"
									value="${endDate}" class="form-control">
							</div>

							<div class="col-lg-4 col-md-12">
								<button type="submit" class="btn btn-primary w-100">조회</button>
							</div>
						</form>
					</div>
				</div>
				<!-- ===== 기간 조회 필터E ===== -->

				<!-- ===== 기간별 트래픽 분석S ===== -->
				<!-- 기간 별 트레픽 추이(adHome.js) -->
				<div class="row g-4 mb-4">
					<div class="col-lg-8 col-md-12">
						<div class="card dashboard-card h-100">
							<div
								class="card-header d-flex justify-content-between align-items-center">
								<h5 class="mb-0">기간별 트래픽 추이</h5>
								<small class="text-muted">${startDate} ~ ${endDate}</small>
							</div>
							
							<div class="card-body">
								<div id="trafficTrendChart"></div>
							</div>
						</div>
					</div>

					<div class="col-lg-4 col-md-12">
						<div class="card dashboard-card h-100">
							<div class="card-header">
								<h5 class="mb-0">기간 요약</h5>
							</div>
							<div class="card-body p-0">
								<ul class="summary-list mb-0">
									<li><span>기간 방문자 수</span> <strong>${empty periodKpi.visitorCount ? 0 : periodKpi.visitorCount}명</strong>
									</li>
									<li><span>기간 페이지뷰</span> <strong>${empty periodKpi.viewCount ? 0 : periodKpi.viewCount}회</strong>
									</li>
									<li><span>기간 신규 회원</span> <strong>${empty periodKpi.newMemberCount ? 0 : periodKpi.newMemberCount}명</strong>
									</li>
									<li><span>기간 맛집 등록</span> <strong>${empty periodKpi.newRestaurantCount ? 0 : periodKpi.newRestaurantCount}건</strong>
									</li>
									<li><span>기간 예약</span> <strong>${empty periodKpi.reservationCount ? 0 : periodKpi.reservationCount}건</strong>
									</li>
									<li><span>기간 댓글</span> <strong>${empty periodKpi.commentCount ? 0 : periodKpi.commentCount}건</strong>
									</li>
									<li><span>기간 결제</span> <strong>${empty periodKpi.paymentCount ? 0 : periodKpi.paymentCount}건</strong>
									</li>
									<li><span>기간 만족도조사 참여자</span> <strong>${empty periodKpi.surveyParticipantCount ? 0 : periodKpi.surveyParticipantCount}명</strong>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
				<!-- ===== 기간별 트래픽 분석E ===== -->

				<!-- ===== 금일 KPI S ===== -->
				<div class="row g-3 mb-4">
					<div class="col-lg-3 col-md-4 col-sm-6">
						<div class="card kpi-card accent-blue">
							<div class="card-body">
								<h6>금일 신규 가입</h6>
								<h3>${empty todayKpi.newMemberCount ? 0 : todayKpi.newMemberCount}명</h3>
							</div>
						</div>
					</div>

					<div class="col-lg-3 col-md-4 col-sm-6">
						<div class="card kpi-card accent-green">
							<div class="card-body">
								<h6>금일 신규 맛집 등록</h6>
								<h3>${empty todayKpi.newRestaurantCount ? 0 : todayKpi.newRestaurantCount}건</h3>
							</div>
						</div>
					</div>

					<div class="col-lg-3 col-md-4 col-sm-6">
						<div class="card kpi-card accent-yellow">
							<div class="card-body">
								<h6>금일 신규 예약</h6>
								<h3>${empty todayKpi.reservationCount ? 0 : todayKpi.reservationCount}건</h3>
							</div>
						</div>
					</div>

					<div class="col-lg-3 col-md-4 col-sm-6">
						<div class="card kpi-card accent-purple">
							<div class="card-body">
								<h6>금일 신규 댓글</h6>
								<h3>${empty todayKpi.commentCount ? 0 : todayKpi.commentCount}건</h3>
							</div>
						</div>
					</div>

					<div class="col-lg-3 col-md-4 col-sm-6">
						<div class="card kpi-card accent-pink">
							<div class="card-body">
								<h6>금일 신규 결제</h6>
								<h3>${empty todayKpi.paymentCount ? 0 : todayKpi.paymentCount}건</h3>
							</div>
						</div>
					</div>

					<div class="col-lg-3 col-md-4 col-sm-6">
						<div class="card kpi-card accent-orange">
							<div class="card-body">
								<h6>금일 만족도조사 참여자 수</h6>
								<h3>${empty todayKpi.surveyParticipantCount ? 0 : todayKpi.surveyParticipantCount}명</h3>
							</div>
						</div>
					</div>

					<div class="col-lg-3 col-md-4 col-sm-6">
						<div class="card kpi-card accent-teal">
							<div class="card-body">
								<h6>금일 방문자 수</h6>
								<h3>${empty todayKpi.visitorCount ? 0 : todayKpi.visitorCount}명</h3>
							</div>
						</div>
					</div>

					<div class="col-lg-3 col-md-4 col-sm-6">
						<div class="card kpi-card accent-cyan">
							<div class="card-body">
								<h6>금일 페이지뷰</h6>
								<h3>${empty todayKpi.viewCount ? 0 : todayKpi.viewCount}회</h3>
							</div>
						</div>
					</div>
				</div>
				<!-- ===== 금일 KPI E ===== -->

				<!-- ===== 만족도 분석S ===== -->
				<div class="row g-4 mb-4">
					<div class="col-lg-8 col-md-12">
						<div class="card dashboard-card h-100">
							<div class="card-header">
								<h5 class="mb-0">최근 만족도</h5>
							</div>
							
							<!-- 최근만족도(adHome.js) -->
							<div class="card-body">
								<div id="trendChart"></div>
							</div>
						</div>
					</div>

					<div class="col-lg-4 col-md-12">
						<div class="card dashboard-card h-100">
							<div class="card-header">
								<h5 class="mb-0">NPS 평점 분포</h5>
							</div>
							
							<!-- NPS 평점 분포(adHome.js) -->
							<div class="card-body">
								<div id="npsChart"></div>
							</div>
						</div>
					</div>
				</div>
				<!-- ===== 만족도 분석E ===== -->

				<!-- ===== 만족도 핵심 통계 표S ===== -->
				<div class="row mb-4">
					<div class="col-12">
						<div class="card dashboard-card">
							<div class="card-header">
								<h5 class="mb-0">맛집만족도 / 정보신뢰도 / NPS 핵심 통계</h5>
							</div>
							<div class="card-body">
								<div class="table-responsive">
									<table class="table dashboard-table mb-0">
										<thead>
											<tr>
												<th>지표</th>
												<th>평균</th>
												<th>표준편차</th>
												<th>최솟값</th>
												<th>최댓값</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="row" items="${statsList}">
												<tr>
													<td>${row.metricName}</td>
													<td>${row.avgValue}</td>
													<td>${row.stddevValue}</td>
													<td>${row.minValue}</td>
													<td>${row.maxValue}</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- ===== 만족도 핵심 통계 표E ===== -->
				
				<!-- ===== 만족도 조사 결과 표S ===== -->
				<div class="row mb-4">
					<div class="col-12">
						<div class="card dashboard-card">
							<div class="card-header">
								<h5 class="mb-0">기간 내 맛집만족도 / 정보신뢰도 / NPS 조사 결과 표</h5>
							</div>
							<div class="card-body">
								<div class="table-responsive">
									<table class="table dashboard-table mb-0">
										<thead>
											<tr>
												<th>번호</th>
												<th>만족도</th>
												<th>정보신뢰도</th>
												<th>NPS 점수</th>
												<th>예약번호</th>
												<th>제출일</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="dto" items="${satisfactionList}">
												<tr>
													<td>${dto.survey_id}</td>
													<td>${dto.satisfaction_score}</td>
													<td>${dto.info_reliability_score}</td>
													<td>${dto.nps_score}</td>
													<td>${dto.reservation_id}</td>
													<td>${dto.surveyDate}</td>
												</tr>
											</c:forEach>
										</tbody> 
									</table>
								</div>
								
								<!-- 페이징 처리 : 설문 전용 페이징 -->
								<div class="py-3 border-top">
									<%@ include file="/WEB-INF/views/admin/surveyPagination.jsp"%>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- ===== 만족도 조사 결과 표E ===== -->

				<!-- ===== 문의S ===== -->
				<div class="row g-4 mb-4">
					<div class="col-lg-6 col-md-12">
						<div class="card dashboard-card h-100">
							<div class="card-header d-flex align-items-center">
								<h5 class="mb-0 me-auto">1:1 문의 미처리</h5>
								<div class="card-tools">
									<a href="${path}/adInquiryList.adsp"
										class="btn btn-sm btn-outline-primary">전체보기</a>
								</div>
							</div>

							<div class="card-body table-responsive">
								<table
									class="table table-hover text-center align-middle dashboard-table mb-0">
									<thead>
										<tr>
											<th>문의번호</th>
											<th>작성자</th>
											<th>제목</th>
											<th>작성일</th>
											<th>상태</th>
											<th>답변하기</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="inquiry" items="${pendingInquiryList}">
											<tr>
												<td>${inquiry.inquiry_id}</td>
												<td>${inquiry.user_id}</td>
												<td class="text-start">${inquiry.title}</td>
												<td>
													<c:choose>
														<c:when test="${not empty inquiry.inquiryDate}">
															<fmt:formatDate value="${inquiry.inquiryDate}"
																pattern="yyyy-MM-dd" />
														</c:when>
														<c:otherwise>
					                                        ${inquiry.regDate}
					                                    </c:otherwise>
													</c:choose></td>
												<td>${inquiry.status}</td>
												<td><a
													href="${path}/adInquiryDetail.adsp?inquiry_id=${inquiry.inquiry_id}"
													class="btn btn-sm btn-primary"> 답변하기 </a></td>
											</tr>
										</c:forEach>

										<c:if test="${empty pendingInquiryList}">
											<tr>
												<td colspan="6" class="text-center text-muted">미처리
													문의가 없습니다.</td>
											</tr>
										</c:if>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<!-- ===== 문의E ===== -->

					<!-- ===== 사용자 만족도 워드클라우드S ===== -->
					<div class="col-lg-6 col-md-12">
						<div class="card dashboard-card h-100">
							<div class="card-header">
								<h5 class="mb-0">사용자 만족도 워드클라우드</h5>
							</div>
							
							<div class="card-body">
								<!-- 워드클라우드 출력 영역 -->
								<div id="wordcloudBox" class="wordcloud-box"></div>
					
								<!-- 주관식 응답을 숨겨둠 -->
								<c:forEach var="word" items="${subjectiveAnswers}">
								    <input type="hidden" class="subjective-word-source" value="<c:out value='${word}' />" />
								</c:forEach>
							</div>
						</div>
					</div>
					<!-- ===== 사용자 만족도 워드클라우드E ===== -->
				</div>
			</div>
		</section>
	</div>

	<!-- ================= FOOTER ================= -->
	<!-- <footer class="main-footer"> -->
	<footer class="main-footer text-center">
		<strong>Copyright &copy; 2026</strong>
	</footer>
</div>

<!-- 서버 데이터를 JS로 넘기기 위해 jsp에 유지 -->
<!-- adminHomeData : 기간별 트래픽 추이 데이터/ 최근 만족도 차트용 데이터/ NPS 평점 분포 차트용 데이터 -->
<script>
   window.adminHomeData = {
	   /* 만족도 차트 */
       trendList: [
           <c:forEach var="trend" items="${trendList}" varStatus="st">
               {
                   statDate: '${trend.statDate}',
                   satisfactionAvg: ${empty trend.satisfactionAvg ? 0 : trend.satisfactionAvg},
                   infoReliabilityAvg: ${empty trend.infoReliabilityAvg ? 0 : trend.infoReliabilityAvg},
                   npsAvg: ${empty trend.npsAvg ? 0 : trend.npsAvg}
               }<c:if test="${!st.last}">,</c:if>
           </c:forEach>
       ],
       /* NPS 분포 */
       npsDistribution: [
           <c:forEach var="nps" items="${npsDistribution}" varStatus="st">
               {
                   scoreCount: ${empty nps.scoreCount ? 0 : nps.scoreCount},
                   bucketName: '${nps.bucketName}'
               }<c:if test="${!st.last}">,</c:if>
           </c:forEach>
       ],
       /* GA 기간별 트래픽 추이 */
       trafficTrendList: [
    	    <c:forEach var="row" items="${trafficTrendList}" varStatus="st">
    	    {
    	        date: "${row.date}",
    	        visitorCount: ${empty row.visitorCount ? 0 : row.visitorCount},
    	        viewCount: ${empty row.viewCount ? 0 : row.viewCount}
    	    }<c:if test="${!st.last}">,</c:if>
    	    </c:forEach>
    	],
    	/* 오늘 날짜 */
       today: '${today}'
   };
</script>

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
                   clickScroll: true
               }
           });
       }
   });
</script>




</body>
</html>