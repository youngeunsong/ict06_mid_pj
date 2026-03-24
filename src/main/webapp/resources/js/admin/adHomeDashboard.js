/* ========================================
   adHomeDashboard.js - 관리자 > 홈 대시보드 공통 JS
   ========================================*/
   
//[GA4 이벤트]
//대시보드 요약 및 KPI 클릭 이벤트 추적
function trackDashboardKPI(kpiName) {
	gtag('event', 'admin_dashboard_click', {
		'card_name': kpiName,		//총방문자수, 예약취소율 등
		'menu_location': 'main_dashboard'
	});
}

//1:1 문의 답변 버튼 클릭 추적
function trackInquiryAction(category, id) {
	gtag('event', 'admin_inquiry_process', {
		'inquiry_category': category,
		'inquiry_id': id
	});
}

//차트 필터 변경 시
$(document).on('change', '.chart-filter', function() {
	gtag('event', 'admin_chart_filter', {
		'filter_range': $(this).val()		//daily, weekly, monthly 등
	});
});