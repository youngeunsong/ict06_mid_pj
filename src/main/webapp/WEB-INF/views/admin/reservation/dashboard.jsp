<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- TODO : 이 페이지의 작동 제대로 하는 지 체크 필요 -->
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>  <!-- 관리자용 setting 별도로 함. 주의! -->   
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<!-- apexcharts -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/apexcharts@3.37.1/dist/apexcharts.css"
	integrity="sha256-4MX+61mt9NVvvuPjUWdUdyfZfxSB1/Rf9WtqRHgG5S0="
	crossorigin="anonymous" />

<!--begin::Body-->
<body class="hold-transition sidebar-mini layout-fixed">
	<!--begin::div wrapper-->
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
		<div class="content-wrapper">	
			<!--begin::App Main-->
			<main class="app-main">
				<!--begin::App Content Header-->
				<div class="app-content-header py-4 bg-white border-bottom mb-4">
					<div class="container-fluid">
						<h3 class="fw-bold text-dark"><i class="bi bi-bar-chart-fill me-2"></i>Reservation Dashboard</h3>
					</div>
				</div>
				<!--end::App Content Header-->
			
				<!--begin::App Content-->
				<div class="app-content">
					<!--begin::Container-->
					<div class="container-fluid">
			
						<!--begin::통계치-->
						<div class="row g-3 mb-4 text-white">
							<div class="col-md-3">
								<div class="card bg-primary border-0 shadow-sm p-3 h-100">
									<div class="d-flex justify-content-between align-items-start">
										<div><p class="mb-0 opacity-75">총 예약</p><h2 class="fw-bold">1,240</h2></div>
										<div class="fs-1 opacity-50"><i class="bi bi-calendar-check"></i></div>
									</div>
									<div class="mt-3 small fw-light"><i class="bi bi-arrow-up"></i> 12% 증가</div>
								</div>
							</div>
							<div class="col-md-3">
								<div class="card bg-danger border-0 shadow-sm p-3 h-100">
									<div class="d-flex justify-content-between align-items-start">
										<div><p class="mb-0 opacity-75">취소 건수</p><h2 class="fw-bold">48</h2></div>
										<div class="fs-1 opacity-50"><i class="bi bi-x-circle"></i></div>
									</div>
									<div class="mt-3 small fw-light">전월 대비 2% 감소</div>
								</div>
							</div>
							<div class="col-md-3">
								<div class="card bg-warning border-0 shadow-sm p-3 h-100 text-dark">
									<div class="d-flex justify-content-between align-items-start text-dark">
										<div><p class="mb-0 opacity-75">노쇼(No-show)</p><h2 class="fw-bold text-dark">12</h2></div>
										<div class="fs-1 opacity-50"><i class="bi bi-person-x"></i></div>
									</div>
									<div class="mt-3 small fw-bold">주의 필요</div>
								</div>
							</div>
							<div class="col-md-3">
								<div class="card bg-success border-0 shadow-sm p-3 h-100">
									<div class="d-flex justify-content-between align-items-start">
										<div><p class="mb-0 opacity-75">정상 이행률</p><h2 class="fw-bold">96%</h2></div>
										<div class="fs-1 opacity-50"><i class="bi bi-pie-chart-fill"></i></div>
									</div>
									<div class="mt-3 small fw-light">최고치 달성 중</div>
								</div>
							</div>
						</div>
						<!--end::통계치-->
						
						<!--begin::주간 예약 추이-->
						<div class="row g-4">
							<div class="col-lg-8">
								<div class="card border-0 shadow-sm h-100">
									<div class="card-header bg-white border-bottom-0 pt-4 px-4">
										<h5 class="fw-bold">주간 예약 추이 분석</h5>
									</div>
									<div class="card-body p-4"><div id="reservation-trend-chart"></div></div>
								</div>
							</div>
							<div class="col-lg-4">
								<div class="card border-0 shadow-sm h-100">
									<div class="card-header bg-white border-bottom-0 pt-4 px-4">
										<h5 class="fw-bold">상태별 점유율</h5>
									</div>
									<div class="card-body p-4"><div id="reservation-status-pie"></div></div>
								</div>
							</div>
						</div>
						<!--end::주간 예약 추이-->
					</div>
					<!--end::Container-->
				</div>
				<!--end::App Content-->
			</main>
			<!--end::App Main-->
		</div>
		<!--end::content Wrapper-->
	</div>
	<!-- end::div Wrapper -->
	
	<!-- JS -->
	<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>	<!-- apex charts 라이브러리 추가 -->
	<script>
		document.addEventListener('DOMContentLoaded',function() {
			//==============================
			//[1] 기간별 예약 추이 차트(Line/Area Chart) 시작
			//begin::Reservation Trend Chart
			//==============================
			const trend_options = {
					series: [{
						name: '예약 건수',
						data: [31,40,28,51,42,109,100]	//실제 DB data 바인딩 영역
					}, {
						name: '취소 건수',
						data: [11,17,4,26,35,57,31]
					}],
					chart: {
						height: 350,
						type: 'area',
						toolbar: {show: false}
					},
					colors: ['#0d6efd', '#dc3545'],	//blue(예약), red(취소)
					dataLabels: {enabled: false},
					stroke: {curve: 'smooth'},
					xaxis: {
						categories: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
					},
					tooltip: {x: {format: 'yyyy/MM/dd HH:mm'}},
				};
			
			const trend_chart = new ApexCharts(
				document.querySelector("#reservation-trend-chart"),
				trend_options
			);
			trend_chart.render();
			//end::Reservation Trend Chart
	
			//==============================
			//[2] 상태별 점유율 차트(Donut/Pie Chart) 시작
			//begin::Reservation Status Pie Chart
			//==============================
			const status_options = {
				series: [40, 15, 10, 35],	//[확정, 대기, 취소, 완료] 데이터 비중
				chart: {
					height: 350,
					type: 'donut',	//도넛형 차트
				},
				labels: ['예약확정', '결제대기', '취소', '이용완료'],
				colors: ['#0d6efd', '#ffc107', '#dc3545', '#198754'],
				legend: {
					position: 'bottom'
				},
				responsive: [{
					breakpoint: 480,
					options: {
						chart: {width: 200},
						legend: {position: 'bottom'}
					}
				}]
			};
		
			/* const status_chart = new ApexCharts(
				document.querySelector("#reservation-status-pie"),
				status_options
			);
			status_chart.render();
			//end::Reservation Status Pie Chart */
			new ApexCharts(document.querySelector("#reservation-status-pie"), status_options).render();
		});
	</script>
</body>
<!--end::Body-->
