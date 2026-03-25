/**
 * 관리자 > 예약 전체목록 > 상세조회
 */

window.addEventListener('load', function() {
	window.calendar = null;
	
	const listBtn    = document.getElementById('viewListBtn');
	const calBtn     = document.getElementById('viewCalBtn');
	const listView   = document.getElementById('reservationListView');
	const calView    = document.getElementById('reservationCalendarView');
	
	/* 보기 전환 */
	function showListView() {
		document.getElementById('sortType').disabled = false;
		listView.style.display  = 'block';
		calView.style.display   = 'none';
		listBtn.classList.replace('btn-outline-edit','btn-edit');
		calBtn.classList.replace('btn-edit','btn-outline-edit');
		localStorage.setItem('reservationView', 'list');
	}
	
	function showCalView() {
		document.getElementById('sortType').disabled = true;
		listView.style.display  = 'none';
		calView.style.display   = 'block';
		calBtn.classList.replace('btn-outline-edit','btn-edit');
		listBtn.classList.replace('btn-edit','btn-outline-edit');
		localStorage.setItem('reservationView', 'cal');
		
		setTimeout(function() {
			if (!calendar) {
				initCalendar();
			}
			else {
				console.log("기존 캘린더 업데이트");
				calendar.updateSize();
				if(typeof calendar.getEvents === 'function') {
					console.log("이벤트 개수:", calendar.getEvents().length);
				}
				calendar.render();
			}
		}, 100);
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
			dayMaxEvents: 3,
			
			moreLinkClick: function(info) {
				const date = info.date;
				const dateStr = date.getFullYear() + '-' +
								String(date.getMonth() + 1).padStart(2, '0') + '-' +
								String(date.getDate()).padStart(2, '0');
				showMoreEventsModal(info.jsEvent, dateStr);
				return 'none';
			},
			
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
				el.style.borderRadius = '6px';
				el.style.fontSize    = '0.78rem';
				el.style.fontWeight  = '500';
				el.style.boxShadow   = '0 2px 4px rgba(0,0,0,0.08)';
				
				//PENDING(노란색) 이벤트는 텍스트 어둡게 처리
				const bg = arg.event.backgroundColor || '';
				const titleEl = el.querySelector('.fc-event-title');
				const timeEl  = el.querySelector('.fc-event-time');
				if (bg.toLowerCase().includes('fefbda')) {
					if (titleEl) titleEl.style.color = '#333';
					if (timeEl)  timeEl.style.color  = '#333';
				} else {
					if (titleEl) titleEl.style.color = '#fff';
					if (timeEl)  timeEl.style.color  = '#fff';
				}
			},
			
			events: reservationData.map(function(e) {
				const formatStr = (dateStr) => dateStr ? dateStr.replaceAll('.', '-').split(' ')[0] : '';
				
				let startStr = formatStr(e.start);
				let endStr = formatStr(e.end || e.start);
				
				const endDate = new Date(endStr);
				endDate.setDate(endDate.getDate() +1);

				const finalEndStr = endDate.getFullYear() + '-' +
									String(endDate.getMonth() + 1).padStart(2, '0') + '-' +
									String(endDate.getDate()).padStart(2, '0');

				//예약상태별 색 지정
				//console.log(e);
				//let status = (e.status || '').toUpperCase();
				
				//let colorMap = {
				//	'RESERVED' : '#01D281',
				//	'PENDING' : '#FEFBDA',
				//	'CANCELLED' : '#dc3545',
				//	'COMPLETED' : '#6c757d'
				//};
				
				//let color = colorMap[status] || '#01D281';
				
				return {
					id: e.id,
					title: e.title,
					start: startStr,
					end: finalEndStr,
					backgroundColor: e.backgroundColor,
					borderColor: 'transparent',
					textColor: (e.backgroundColor || '').trim().toLowerCase() === '#fefbda' ? '#333' : '#fff',
					extendedProps: {
						status: e.status
					}
				};
			}),
			eventClick: function(info) {
				if($(info.el).closest('.fc-more-link').length)
					return;
				viewDetail(info.event.id);
			}
		});
		calendar.render();
	}
	
	/* 초기 뷰 복원, 이벤트 바인딩 */
	const currentView = localStorage.getItem('reservationView') || 'list';
	if (currentView === 'cal') showCalView();
	else showListView();

	document.getElementById('viewCalBtn').addEventListener('click', showCalView);
	document.getElementById('viewListBtn').addEventListener('click', showListView);
});

//캘린더 더보기 모달
function showMoreEventsModal(jsEvent, dateStr) {
	const listEl = document.getElementById('moreEventList');
	let allEvents = [];
	
	//해당 날짜 이벤트 필터링
	allEvents = window.calendar.getEvents().filter(function(ev) {
		const start = ev.startStr.substring(0, 10);
		const end = ev.endStr.substring(0, 10);
		return dateStr >= start && dateStr < end;
	});
	
	//상태별 건수 계산
	const statusMap = {
		'RESERVED':0,
		'PENDING':0,
		'CANCELLED':0,
		'COMPLETED':0,
	};
	allEvents.forEach(function(ev) {
		const status = ev.extendedProps.status || '';
		if(statusMap[status] !== undefined) statusMap[status]++;
	});
	
	//탭 건수 업데이트
	document.getElementById('tab-count-ALL').textContent = allEvents.length;
	Object.keys(statusMap).forEach(function(s) {
		document.getElementById('tab-count-' + s).textContent = statusMap[s];
	});
	
	//탭 클릭 이벤트
	document.querySelectorAll('#moreEventTabs .nav-link').forEach(function(tab) {
		tab.onclick = function(e) {
			e.preventDefault();
			document.querySelectorAll('#moreEventTabs .nav-link').forEach(function(t) {
				t.classList.remove('active');			
			});
			tab.classList.add('active');
			window._moreEvents = allEvents;
			renderEventList(tab.dataset.status, allEvents, 1);
		};
	});
	
	//초기 전체 탭 활성화
	document.querySelectorAll('#moreEventTabs .nav-link').forEach(function(t) {
		t.classList.remove('active');
	});
	document.querySelector('#moreEventTabs .nav-link[data-status="ALL"]').classList.add('active');
	
	window._moreEvents = allEvents;
	renderEventList('ALL', allEvents, 1);
	
	$('#moreEventsModal').modal('show');
}
	
function renderEventList(status, allEvents, page) {
	page = page || 1;
	const pageSize = 10;
	const listEl = document.getElementById('moreEventList');
	listEl.innerHTML = '';
	
	const statusLabelMap = {
		'RESERVED': '확정', 'PENDING': '결제대기',
		'CANCELLED': '취소', 'COMPLETED': '이용완료'
	};
	
	 const filtered = status === 'ALL' ? allEvents : allEvents.filter(function(ev) {
	 	return ev.extendedProps.status === status;
	 });
	 
	 if(filtered.length === 0) {
	 	listEl.innerHTML = '<li class="list-group-item text-center text-muted">해당 상태의 예약이 없습니다.</li>';
	 	return;
	 }
	 
	 //페이징 계산
	 const totalPages = Math.ceil(filtered.length / pageSize);
	 const start = (page - 1) * pageSize;
	 const paged = filtered.slice(start, start + pageSize);
	 
	 //리스트 생성
	 paged.forEach(function(ev) {
	 	const li = document.createElement('li');
	 	li.className = 'list-group-item d-flex justify-content-between align-items-center';
	 	li.style.cursor = 'pointer';
	 	li.innerHTML = `
	 		<span>
	 			<span style="display:inline-block; width:10px; height:10px; border-radius:50%;
	 			background:${ev.backgroundColor}; margin-right:6px;"></span>
	 			${ev.title}
	 		</span>
	 		<span class="badge badge-secondary">상세보기</span>
	 	`;
	 	
	 	li.onclick = function() {
	 		$('#moreEventsModal').modal('hide');
	 		viewDetail(ev.id);
	 	};
	 	listEl.appendChild(li);
	});
	
	if(totalPages > 1) {
		const pagingEl = document.createElement('div');
		pagingEl.className = 'd-flex justify-content-center align-items-center mt-2';
		let pagingHtml = '';
		
		//이전 버튼
		pagingHtml += `<button class="btn btn-sm btn-outline-secondary mr-1"
					${page === 1 ? 'disabled' : ''}
					onclick="renderEventList('${status}', window._moreEvents, ${page - 1})">&lt;</button>`;
					
		//페이지 번호(현재 페이지 기준 앞뒤 2개씩 최대 5개)
		const startPage = Math.max(1, page - 2);
		const endPage = Math.min(totalPages, startPage + 4);
		
		for(let i = startPage; i <= endPage; i++) {
			pagingHtml += `<button class="btn btn-sm ${i === page ? 'btn-dark' : 'btn-outline-secondary'} mr-1"
					onclick="renderEventList('${status}', window._moreEvents, ${i})">${i}</button>`;
		}
			
		//다음 버튼
		pagingHtml += `<button class="btn btn-sm btn-outline-secondary mr-1"
					${page === totalPages ? 'disabled' : ''}
					onclick="renderEventList('${status}', window._moreEvents, ${page + 1})">&gt;</button>`;
		pagingEl.innerHTML = pagingHtml;
		listEl.appendChild(pagingEl);
	}
}

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
	const view = localStorage.getItem('reservationView');
	const sortType = document.getElementById('sortType').value;
	if(view !== 'cal' && sortType) {
		params.push('sortType=' + sortType);
	}
	if(statusList.length > 0) params.push('status=' + statusList.join(','));
	if(typeList.length > 0) params.push('placeType=' + typeList.join(','));
	
	location.href = path + '/reservationList.ad' +
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
	
	//OverlayScrollbars 추가
	const sidebarWrapper = document.querySelector('.sidebar-wrapper');
	if(sidebarWrapper && typeof OverlayScrollbarsGlobal !== 'undefined'
			&& OverlayScrollbarsGlobal.OverlayScrollbars !== undefined) {
		OverlayScrollbarsGlobal.OverlayScrollbars(sidebarWrapper, {
			scrollbars: {theme: 'os-theme-light', autoHide: 'leave', clickScroll: true},
		});
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
	location.href = path + '/reservationList.ad?keyword=' + encodeURIComponent(keyword)
					+ (sortType ? '&sortType=' + sortType : '');
}

//상세보기 Modal
function viewDetail(res_id) {
	$.ajax({
		url: path + '/getReservationDetail.ad',
		type: 'get',
		data: 'res_id=' + res_id,
		dataType: 'json',
		success: function(data) {
			console.log(data);
			const statusMap = { 'RESERVED': '확정', 'PENDING': '결제대기', 'CANCELLED': '취소', 'COMPLETED': '이용완료' };
			$('#modal_res_id').text(data.reservation_id);
			$('#modal_user_id').text(data.user_id);
			$('#modal_name').text(data.placeDTO.name);
			$('#modal_check_in').text(data.check_in);
			$('#modal_check_out').text(data.check_out);
			$('#modal_visit_time').text(data.visit_time || '-');
			$('#modal_request_note').text(data.request_note || '-');
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
function editReservation(res_id) {
	$.ajax({
		url: path + '/getReservationDetail.ad',
		type: 'get',
		data: 'res_id=' + res_id,
		dataType: 'json',
		success: function(data) {
			//날짜 형식 변환(2026.01.01 -> 2026-01-01)
			function formatDate(dateStr) {
				if(!dateStr) return '';
				return dateStr.toString().substring(0,10).replaceAll('.', '-');
			}
			
			function formatTime(timeStr) {
				if(!timeStr) return '';
				return timeStr.toString().substring(0,5);
			}
			
			//readonly 필드
			$('#update_res_id').text(data.reservation_id);
			$('#update_reservation_id').val(data.reservation_id);
			$('#update_user_id').text(data.user_id);
			$('#update_name').text(data.placeDTO && data.placeDTO.name ? data.placeDTO.name : '');
			
			//수정가능 필드
			$('#update_status').val(data.status);
			$('#update_check_in').val(formatDate(data.check_in));
			$('#update_check_out').val(formatDate(data.check_out));
			$('#update_visit_time').val(formatTime(data.visit_time));
			$('#update_guest_count').val(data.guest_count);
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
	const reservationId = $('#update_reservation_id').val().trim();
	const checkIn = $('#update_check_in').val();
	const checkOut = $('#update_check_out').val();
	const visitTime = $('#update_visit_time').val();
	const guestCount = $('#update_guest_count').val();
	
	//필수값 체크
	if(!reservationId) {
		alert('예약번호가 없습니다.');
		return;
	}
	if(!checkIn) {
		alert('방문일을 입력하세요.');
		$('#update_check_in').focus();
		return;
	}
	if(!guestCount || Number(guestCount) < 1) {
		alert('인원수를 1명 이상 입력하세요.');
		$('#update_guest_count').focus();
		return;
	}

	
	//필수값 체크
	if(!checkIn) {
		alert('방문일을 입력해주세요.');
		return;
	}

	//날짜 유효성 체크
	if(checkIn && checkOut && checkIn > checkOut) {
		alert('퇴실일은 방문일 이후로만 설정할 수 있습니다.');
		return;
	}
	if(!confirm("예약 정보를 수정하시겠습니까?"))
		return;
	
	$.ajax({
		url: path + '/updateReservation.ad',
		type: 'post',
		data: {
			reservation_id: reservationId,
			status: $('#update_status').val(),
			check_in: checkIn,
			check_out: checkOut,
			visit_time: visitTime,
			guest_count: guestCount,
			request_note: $('#update_request_note').val(),
			res_id: $('#update_res_id').text(),
			status: $('#update_status').val(),
			check_in: checkIn,
			check_out: checkOut || null,
			visit_time: $('#update_visit_time').val() || null,
			guest_count: $('#update_guest_count').val().replace('명',''),
			request_note: $('#update_request_note').val() || null,
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
