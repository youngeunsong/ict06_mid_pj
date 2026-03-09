//예약 통계 대시보드
//HTML 전부 로딩 후 실행되도록 addEventListener 적용
document.addEventListener('DOMContentLoaded', function() {
	const GREEN = '#01D281';
	const YELLOW = '#FEFBDA';
	const LIGHT_GRAY = '#F6F6F6';
	
	//예약상태별 색상 매핑(객체 리터럴 정의)
	const statusColorMap = {
		'RESERVED': '#01D281',
		'PENDING': '#ffc107',
		'CANCELLED': '#dc3545',
		'COMPLETED': '#6c757d'
	};
	
	//장소분류별 색상 매핑(객체 리터럴 정의)
	const placeColorMap = {
		'REST': '#01d281',
		'ACC': '#4fc3f7',
		'FEST': '#FEFBDA',
	};
	
	//=====월별 고정 라벨 생성(과거3+현재+미래3개월=총 7개월)
	function generateMonthLabels() {
		const labels = [];
		const now = new Date();
		for(let i=-3; i<=3; i++) {
			const d = new Date(now.getFullYear(), now.getMonth()+i, 1);
			const yyyy = d.getFullYear();
			const mm = String(d.getMonth() + 1).padStart(2,'0');
			labels.push(yyyy + '-' + mm);
		}
		return labels;
	}
	const monthLabels = generateMonthLabels();
	const monthDataMap = {};
	dashBoardData.monthly.labels.forEach(function(label, i) {
		monthDataMap[label] = dashBoardData.monthly.data[i];
	});
	const monthData = monthLabels.map(function(label) {
		return monthDataMap[label] || 0;
	})
	
	//=====요일별 고정 라벨
	const DAY_ORDER = ['일', '월', '화', '수', '목', '금', '토'];
	const dayDataMap = {};
	dashBoardData.dayOfWeek.labels.forEach(function(label, i) {
		dayDataMap[label] = dashBoardData.dayOfWeek.data[i];
	});
	const dayData = DAY_ORDER.map(function(day) {
		return dayDataMap[day] || 0;
	});
	
	//=====차트 생성 기본 패턴=====
	/* new Chart(canvas, {
		type: 차트 종류
		data: labels(x축/범례) + datasets(실제 데이터+색상)
		options: 범례위치, 축 설정 등
	}) */
	
	//===1. 월별 예약 추이(line chart)===
	new Chart(document.getElementById('monthlyChart').getContext('2d'), {
		type: 'line',
		data: {
			labels: monthLabels,			//['2026-01', '2026-02' ...]
			datasets: [{
				label: '예약 수',
				data: monthData,			//[5, 12, 8 ...(월단위로 보여줌)]
				borderColor: GREEN,
				backgroundColor: 'rgba(1,210,129,0.1)',
				borderWidth: 2,
				pointBackgroundColor: GREEN,
				pointRadius: 4,
				fill: true,
				tension: 0.3
			}]
		},
		options: {
			responsive: true,
			maintainAspectRatio: false,
			legend: {display: false},
			scales: {
				yAxes: [{
					//y축 0부터 시작, 눈금 1 단위
					ticks: {
							beginAtZero: true,
							stepSize: 1,
							callback: function(value) {
								if(Number.isInteger(value)) return value;
							}
					}
				}]
			}
		}
	});

	//===2. 예약상태별 비율(doughnut chart)===
	new Chart(document.getElementById('statusChart').getContext('2d'), {
		type: 'doughnut',
		data: {
			labels: dashBoardData.status.labels,		//['RESERVED','PENDING' ...]
			datasets: [{
				data: dashBoardData.status.data,		//[10, 3, 2, 5]
				
				//labels 배열 돌며 각 항목에 맞는 색상 배열 생성. 매핑 없으면 회색('#ccc')
				//결과: ['#01D281', '#ffc107', '#dc3545', '#6c757d']
				backgroundColor: dashBoardData.status.labels.map(function(l) {
					return statusColorMap[l] || '#ccc';
				}),
				borderWidth: 1
			}]
		},
		options: {
			responsive: true,
			legend: {position: 'right'}
		}
	});

	//===3. 장소분류별 비율(doughnut chart)===
	new Chart(document.getElementById('placeTypeChart').getContext('2d'), {
		type: 'doughnut',
		data: {
			labels: dashBoardData.placeType.labels,
			datasets: [{
				data: dashBoardData.placeType.data,
				backgroundColor: dashBoardData.placeType.labels.map(function(l) {
					return placeColorMap[l] || '#ccc';
				})
			}]
		},
		options: {
			responsive: true,
			legend: {position: 'right'}
		}
	});
	
	//===4. 요일별 예약 분포(bar chart)===
	new Chart(document.getElementById('dayOfWeekChart').getContext('2d'), {
		type: 'bar',
		data: {
			labels: DAY_ORDER,		//['일', '월', '화' ...]
			datasets: [{
				label: '예약 수',
				data: dayData,
				backgroundColor: DAY_ORDER.map(function(l) {
					//요일별 색상 지정: 일(빨강), 토(파랑), 평일(초록)
					if(l === '일') return '#dc3545';
					if(l === '토') return '#4fc3f7';
					return GREEN;
				}),
				borderRadius: 4
			}]
		},
		options: {
			responsive: true,
			maintainAspectRatio: false,
			legend: {display: false},
			scales: {
				yAxes: [{
					ticks: {
							beginAtZero: true,
							stepSize: 1,
							callback: function(value) {
								if(Number.isInteger(value))	return value;
							}
					}
				}]
			}
		}
	});
});