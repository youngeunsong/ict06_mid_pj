/**
 * 관리자 > 예약 전체목록 > 상세조회
 */

window.addEventListener('load', function() {
	let calendar = null;
	
	const listBtn    = document.getElementById('viewListBtn');
	const calBtn     = document.getElementById('viewCalBtn');
	const listView   = document.getElementById('reservationListView');
	const calView    = document.getElementById('reservationCalendarView');
	
	/* 보기 전환 */
	function showListView() {
		listView.style.display  = 'block';
		calView.style.display   = 'none';
		listBtn.classList.replace('btn-outline-success','btn-success');
		calBtn.classList.replace('btn-success','btn-outline-success');
		localStorage.setItem('reservationView', 'list');
	}
	
	function showCalView() {
		listView.style.display  = 'none';
		calView.style.display   = 'block';
		calBtn.classList.replace('btn-outline-success','btn-success');
		listBtn.classList.replace('btn-success','btn-outline-success');
		localStorage.setItem('reservationView', 'cal');
		
		setTimeout(function() {
			if (!calendar) initCalendar();
			else calendar.updateSize();
		}, 50);
	}
	
	/* 캘린더 초기화 */
	function initCalendar() {
		const calendarEl = document.getElementById('calendar');
		if (!calendarEl) return;
		
		calendar = new FullCalendar.Calendar(calendarEl, {
			initialView: 'dayGridMonth',
			locale: 'ko',
			contentHeight: 'auto',
			eventBorderColor: 'transparent',
			
			//달력 색상 지정
			dayCellDidMount: function(arg) {
				const day = arg.date.getDay();
				const numEl = arg.el.querySelector('.fc-daygrid-day-number');
				if (!numEl) return;
				if (day === 0)      numEl.style.color = '#e53935';
				else if (day === 6) numEl.style.color = '#1565c0';
				else                numEl.style.color = '#222';
			},
			
			//요일 헤더 색상
			dayHeaderDidMount: function(arg) {
				const day = arg.date.getDay();
				const color = day === 0 ? '#e53935' : day === 6 ? '#1565c0' : '#222';
				arg.el.style.color = color;
				arg.el.querySelectorAll('a, span').forEach(function(el) {
					el.style.color = color;
				});
			},
			
			//이벤트 스타일: 테두리 제거 + 텍스트 색상 보정 + 그림자
			eventDidMount: function(arg) {
				const el = arg.el;
				el.style.border      = 'none';
				el.style.borderRadius = '4px';
				el.style.fontSize    = '0.78rem';
				el.style.fontWeight  = '500';
				el.style.boxShadow   = '0 1px 3px rgba(0,0,0,0.18)';
				
				//PENDING(노란색) 이벤트는 텍스트 어둡게 처리
				const bg = arg.event.backgroundColor || '';
				const titleEl = el.querySelector('.fc-event-title');
				const timeEl  = el.querySelector('.fc-event-time');
				if (bg.toLowerCase().includes('ffc107')) {
					if (titleEl) titleEl.style.color = '#333';
					if (timeEl)  timeEl.style.color  = '#333';
				} else {
					if (titleEl) titleEl.style.color = '#fff';
					if (timeEl)  timeEl.style.color  = '#fff';
				}
			},
			
			events: reservationData.map(function(e) {
				const start = new Date(e.start);
				start.setDate(start.getDate() - 1);
				return Object.assign({}, e, {
					start: start.toISOString().slice(0, 10),
					borderColor: 'transparent'
				});
			}),
			
			eventClick: function(info) {
				viewDetail(info.event.id);
			}
		});
		calendar.render();
	}
	
	/* 초기 뷰 복원 */
	const currentView = localStorage.getItem('reservationView') || 'cal';
	if (currentView === 'cal') showCalView();
	else showListView();

	document.getElementById('viewCalBtn').addEventListener('click', showCalView);
	document.getElementById('viewListBtn').addEventListener('click', showListView);
});

//==============================
//태그 토글
function toggleTag(el) {
	el.classList.toggle('active');
}

//검색 필터(체크박스)
function filterData() {
	const statusList = [];
	document.querySelectorAll('.tag-success.active, .tag-warning.active, .tag-danger.active, .tag-secondary.active')
		.forEach(function(el) {
			if(el.dataset.value) statusList.push(el.dataset.value);	
		});
		
	const typeList = [];
	document.querySelectorAll('.tag-primary.active')
		.forEach(function(el) {
			if(el.dataset.value) typeList.push(el.dataset.value);
		});
		
	const params = [];
	const sortType = document.getElementById('sortType').value;
	if(statusList.length > 0) params.push('status=' + statusList.join(','));
	if(typeList.length > 0) params.push('placeType=' + typeList.join(','));
	if(sortType) params.push('sortType=' + sortType);
	
	location.href = path + '/getReservationList.ad' +
	(params.length > 0 ? '?' + params.join('&') : '');
}

//URL 파라미터 -> 태그 복원
$(document).ready(function() {
	const urlParams = new URLSearchParams(window.location.search);
	const statusParam = urlParams.get('status');
	const typeParam = urlParams.get('placeType');
	const sortParam = urlParams.get('sortType');
	
	if(statusParam) {
		statusParam.split(',').forEach(function(val) {
			document.querySelectorAll('.tag[data-value="' + val + '"]')
				.forEach(function(el) {
					el.classList.add('active');
				});
		});
	}
	if(typeParam) {
		typeParam.split(',').forEach(function(val) {
			document.querySelectorAll('.tag[data-value="' + val + '"]')
				.forEach(function(el) {
					el.classList.add('active');
				});
		});
	}
	if(sortParam) {
		document.getElementById('sortType').value = sortParam;
	}
});

/* 키워드(ID/예약번호) 검색 */
function keywordSearch() {
	const keyword = $('#keyword').val().trim();
	const sortType = document.getElementById('sortType').value;
	
	if(!keyword) {
		alert('ID 또는 예약번호를 입력하세요.');
		return;
	}
	location.href = path + '/getReservationList.ad?keyword=' + encodeURIComponent(keyword)
					+ (sortType ? '&sortType=' + sortType : '');
}

//상세보기 Modal
function viewDetail(resId) {
	$.ajax({
		url: path + '/getReservationDetail.ad',
		type: 'get',
		data: 'resId=' + resId,
		dataType: 'json',
		success: function(data) {
			console.log(data);
			const statusMap = { 'RESERVED': '확정', 'PENDING': '결제대기', 'CANCELLED': '취소', 'COMPLETED': '이용완료' };
			$('#modal_res_id').text(data.reservation_id);
			$('#modal_user_id').text(data.user_id);
			$('#modal_name').text(data.placeDTO.name);
			$('#modal_check_in').text(data.check_in);
			$('#modal_check_out').text(data.check_out);
			$('#modal_visit_time').text(data.visit_time);
			$('#modal_guest_count').text(data.guest_count + "명");
			$('#modal_status').html(statusMap[data.status] || data.status);
			$('#resDetailModal').modal('show');
		},
		error: function(error) {
			console.log("Detail Error:", error);
			alert("예약 상세 정보를 가져올 수 없습니다.");
		}
	});
}

//예약 수정 Modal
function editReservation(resId) {
	$.ajax({
		url: path + '/getReservationDetail.ad',
		type: 'get',
		data: 'resId=' + resId,
		dataType: 'json',
		success: function(data) {
			//readonly 필드
			$('#update_res_id').text(data.reservation_id);
			$('#update_user_id').text(data.user_id);
			$('#update_name').text(data.placeDTO && data.placeDTO.name ? data.placeDTO.name : '');
			
			//수정가능 필드
			$('#update_status').val(data.status);
			$('#update_check_in').val(data.check_in);
			$('#update_check_out').val(data.check_out);
			$('#update_visit_time').val(data.visit_time || '');
			$('#update_guest_count').val(data.guest_count + "명");
			$('#update_request_note').val(data.request_note || '');
			$('#resUpdateModal').modal('show');
		},
		error: function() {
			alert("데이터 로드 실패");
		}
	});
}

//예약 수정 처리
function updateReservation() {
	const checkIn = $('#update_check_in').val();
	const checkOut = $('#update_check_out').val();
	
	//날짜 유효성 체크
	if(checkIn && checkOut && checkIn > checkOut) {
		alert('퇴실일은 방문일 이후로만 설정할 수 있음');
		return;
	}
	if(!confirm("예약 정보를 수정하시겠습니까?"))
		return;
	
	$.ajax({
		url: path + '/updateReservation.ad',
		type: 'post',
		data: {
			resId: $('#update_res_id').text(),
			status: $('#update_status').val(),
			check_in: checkIn,
			check_out: checkOut,
			visit_time: $('#update_visit_time').val(),
			guest_count: $('#update_guest_count').val().replace('명',''),
			request_note: $('#update_request_note').val(),
		},
		success: function(result) {
			if (result === "success") {
				alert("수정 완료");
				$('#resUpdateModal').modal('hide');
				location.reload();
			} else {
				alert("수정 실패");
			}
		},
		error: function() {
			alert("오류 발생");
		}
	});
}
