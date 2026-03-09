<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!doctype html>
<html lang="en">

<!--begin::Head-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>ADMIN Dashboard</title>
<!--begin::Accessibility Meta Tags-->
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes" />
<meta name="color-scheme" content="light dark" />
<meta name="theme-color" content="#007bff"
	media="(prefers-color-scheme: light)" />
<meta name="theme-color" content="#1a1a1a"
	media="(prefers-color-scheme: dark)" />
<!--end::Accessibility Meta Tags-->
<!--begin::Primary Meta Tags-->
<meta name="title" content="AdminLTE v4 | Dashboard" />
<meta name="author" content="ColorlibHQ" />
<meta name="description"
	content="AdminLTE is a Free Bootstrap 5 Admin Dashboard, 30 example pages using Vanilla JS. Fully accessible with WCAG 2.1 AA compliance." />
<meta name="keywords"
	content="bootstrap 5, bootstrap, bootstrap 5 admin dashboard, bootstrap 5 dashboard, bootstrap 5 charts, bootstrap 5 calendar, bootstrap 5 datepicker, bootstrap 5 tables, bootstrap 5 datatable, vanilla js datatable, colorlibhq, colorlibhq dashboard, colorlibhq admin dashboard, accessible admin panel, WCAG compliant" />
<!--end::Primary Meta Tags-->
<!--begin::Accessibility Features-->
<!-- Skip links will be dynamically added by accessibility.js -->
<meta name="supported-color-schemes" content="light dark" />
<link rel="preload" href="${path}/resources/css/adminlte.css" as="style" />
<link rel="stylesheet" href="${path}/resources/css/adminlte.css">
<!--end::Accessibility Features-->
<!--begin::Third Party Plugin(OverlayScrollbars)-->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/overlayscrollbars@2.11.0/styles/overlayscrollbars.min.css"
	crossorigin="anonymous" />
<!--end::Third Party Plugin(OverlayScrollbars)-->
<!-- apexcharts -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/apexcharts@3.37.1/dist/apexcharts.css"
	integrity="sha256-4MX+61mt9NVvvuPjUWdUdyfZfxSB1/Rf9WtqRHgG5S0="
	crossorigin="anonymous" />
<!-- jsvectormap -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/jsvectormap@1.5.3/dist/css/jsvectormap.min.css"
	integrity="sha256-+uGLJmmTKOqBr+2E6KDYs/NRsHxSkONXFHUL0fy2O/4="
	crossorigin="anonymous" />
</head>
<!--end::Head-->

<!--begin::Body-->
<body
	class="layout-fixed sidebar-expand-lg sidebar-open bg-body-tertiary">
	<!--begin::App Wrapper-->
	<div class="app-wrapper">

		<!--begin::Header-->
		<%@ include file="/WEB-INF/views/admin/common/header.jsp"%>
		<!--end::Header-->

		<!--begin::Sidebar-->
		<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp"%>
		<!--end::Sidebar-->

		<!--begin::App Main-->
		<main class="app-main">
			<!--begin::App Content Header-->
			<div class="app-content-header">
				<!--begin::Container-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-sm-6">
							<h3 class="mb-0">관리자 HOME</h3>
						</div>
					</div>
				</div>
			</div>
			
			<!--begin::app-content-->
			<div class="app-content">
				<div class="container-fluid">
				
					<div class="row mb-4">
						<div class="col-12">
							<div class="card card-outline card-primary shadow-sm">
								<div class="card-header">
									<h3 class="card-title fw-bold">기간별 KPI 요약</h3>
								</div>
								<div class="card-body text-center">
									<div class="row">
										<div class="col-3 border-end"><h6>전체 방문자</h6></div>
										<div class="col-3 border-end"><h6>예약 전환율</h6></div>
										<div class="col-3 border-end"><h6>평균 평점</h6></div>
										<div class="col-3"><h6>신규 회원</h6></div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row mb-4">
						<div class="col-md-6">
							<div class="card h-100 shadow-sm">
								<div class="card-header">
									<h3 class="card-title fw-bold">만족도 설문 wordcloud</h3>
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
									<h3 class="card-title fw-bold text-danger">1:1문의 미처리</h3>
								</div>
								<div class="card-body p-0">
									<table class="table table-hover align-middle m-0">
										<thead class="table-light text-center">
											<tr>
												<th>작성자</th>
												<th>제목</th>
												<th>날짜</th>
											</tr>
										</thead>
										<tbody class="text-center">
											<tr>
												<td colspan="3" class="py-5 text-muted">미처리 내역이 없습니다.</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							</div>
						<div class="row">
							<div class="col-12">
								<div class="card shadow-sm border-0">
									<div class="card-header bg-white">
										<h3 class="card-title fw-bold">사용자 만족도 설문 결과</h3>
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
					</div>
					</div>
				</main>
				<!--end::Container-->
			</div>

	<%@ include file="/WEB-INF/views/admin/common/footer.jsp"%>

	<!--begin::Script-->
	<!--begin::OverlayScrollbars Configure-->
	<script>
      const SELECTOR_SIDEBAR_WRAPPER = '.sidebar-wrapper';
      const Default = {
        scrollbarTheme: 'os-theme-light',
        scrollbarAutoHide: 'leave',
        scrollbarClickScroll: true,
      };
      document.addEventListener('DOMContentLoaded', function () {
        const sidebarWrapper = document.querySelector(SELECTOR_SIDEBAR_WRAPPER);
        if (sidebarWrapper && OverlayScrollbarsGlobal?.OverlayScrollbars !== undefined) {
          OverlayScrollbarsGlobal.OverlayScrollbars(sidebarWrapper, {
            scrollbars: {
              theme: Default.scrollbarTheme,
              autoHide: Default.scrollbarAutoHide,
              clickScroll: Default.scrollbarClickScroll,
            },
          });
        }
      });
    </script>
	<!--end::OverlayScrollbars Configure-->
	<!-- OPTIONAL SCRIPTS -->
	<!-- sortablejs -->
	<script
		src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"
		crossorigin="anonymous"></script>
	<!-- sortablejs -->
	<script>
      new Sortable(document.querySelector('.connectedSortable'), {
        group: 'shared',
        handle: '.card-header',
      });

      const cardHeaders = document.querySelectorAll('.connectedSortable .card-header');
      cardHeaders.forEach((cardHeader) => {
        cardHeader.style.cursor = 'move';
      });
    </script>

	<!-- ChartJS -->
	<script>
      // NOTICE!! DO NOT USE ANY OF THIS JAVASCRIPT
      // IT'S ALL JUST JUNK FOR DEMO
      // ++++++++++++++++++++++++++++++++++++++++++

      const sales_chart_options = {
        series: [
          {
            name: 'Digital Goods',
            data: [28, 48, 40, 19, 86, 27, 90],
          },
          {
            name: 'Electronics',
            data: [65, 59, 80, 81, 56, 55, 40],
          },
        ],
        chart: {
          height: 300,
          type: 'area',
          toolbar: {
            show: false,
          },
        },
        legend: {
          show: false,
        },
        colors: ['#0d6efd', '#20c997'],
        dataLabels: {
          enabled: false,
        },
        stroke: {
          curve: 'smooth',
        },
        xaxis: {
          type: 'datetime',
          categories: [
            '2023-01-01',
            '2023-02-01',
            '2023-03-01',
            '2023-04-01',
            '2023-05-01',
            '2023-06-01',
            '2023-07-01',
          ],
        },
        tooltip: {
          x: {
            format: 'MMMM yyyy',
          },
        },
      };

      const sales_chart = new ApexCharts(
        document.querySelector('#revenue-chart'),
        sales_chart_options,
      );
      sales_chart.render();
    </script>
	<!-- jsvectormap -->
	<script
		src="https://cdn.jsdelivr.net/npm/jsvectormap@1.5.3/dist/js/jsvectormap.min.js"
		integrity="sha256-/t1nN2956BT869E6H4V1dnt0X5pAQHPytli+1nTZm2Y="
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/jsvectormap@1.5.3/dist/maps/world.js"
		integrity="sha256-XPpPaZlU8S/HWf7FZLAncLg2SAkP8ScUTII89x9D3lY="
		crossorigin="anonymous"></script>
	<!-- jsvectormap -->

	<script>
      // World map by jsVectorMap
      new jsVectorMap({
        selector: '#world-map',
        map: 'world',
      });

      // Sparkline charts
      const option_sparkline1 = {
        series: [
          {
            data: [1000, 1200, 920, 927, 931, 1027, 819, 930, 1021],
          },
        ],
        chart: {
          type: 'area',
          height: 50,
          sparkline: {
            enabled: true,
          },
        },
        stroke: {
          curve: 'straight',
        },
        fill: {
          opacity: 0.3,
        },
        yaxis: {
          min: 0,
        },
        colors: ['#DCE6EC'],
      };

      const sparkline1 = new ApexCharts(document.querySelector('#sparkline-1'), option_sparkline1);
      sparkline1.render();

      const option_sparkline2 = {
        series: [
          {
            data: [515, 519, 520, 522, 652, 810, 370, 627, 319, 630, 921],
          },
        ],
        chart: {
          type: 'area',
          height: 50,
          sparkline: {
            enabled: true,
          },
        },
        stroke: {
          curve: 'straight',
        },
        fill: {
          opacity: 0.3,
        },
        yaxis: {
          min: 0,
        },
        colors: ['#DCE6EC'],
      };

      const sparkline2 = new ApexCharts(document.querySelector('#sparkline-2'), option_sparkline2);
      sparkline2.render();

      const option_sparkline3 = {
        series: [
          {
            data: [15, 19, 20, 22, 33, 27, 31, 27, 19, 30, 21],
          },
        ],
        chart: {
          type: 'area',
          height: 50,
          sparkline: {
            enabled: true,
          },
        },
        stroke: {
          curve: 'straight',
        },
        fill: {
          opacity: 0.3,
        },
        yaxis: {
          min: 0,
        },
        colors: ['#DCE6EC'],
      };

      const sparkline3 = new ApexCharts(document.querySelector('#sparkline-3'), option_sparkline3);
      sparkline3.render();
    </script>
	<!--end::Script-->
</body>
<!--end::Body-->
</html>