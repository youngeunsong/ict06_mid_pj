/**
 * 관리자 > 예약 전체목록 > 상세조회
 */
 
//리스트 or 캘린더로 보기 클릭 시
window.addEventListener('load', function() {
	//캘린더 객체 담을 변수
	let calendar = null;
	
	//버튼 클릭 시 이벤트 로직
	const listBtn = document.getElementById('viewListBtn');
	const calBtn = document.getElementById('viewCalBtn');
	const listView = document.getElementById('reservationListView');
	const calView = document.getElementById('reservationCalendarView');
	const listFilters = document.getElementById('listFilters');
	const searchTool = document.getElementById('searchTool');
	
	function showListView() {
		listView.style.display = 'block';
		calView.style.display = 'none';
		listFilters.style.display = 'block';
		searchTool.style.display = 'block';
		listBtn.classList.remove('btn-outline-success');
		listBtn.classList.add('btn-success');
		calBtn.classList.remove('btn-success');
		calBtn.classList.add('btn-outline-success');
		localStorage.setItem('reservationView', 'list');
	}
	
	function showCalView() {
		listView.style.display = 'none';
		calView.style.display = 'block';
		listFilters.style.display = 'block';
		searchTool.style.display = 'block';
		calBtn.classList.remove('btn-outline-success');
		calBtn.classList.add('btn-success');
		listBtn.classList.remove('btn-success');
		listBtn.classList.add('btn-outline-success');
		localStorage.setItem('reservationView', 'cal');
		
		setTimeout(function() {
			if(!calendar) {
				initCalendar();
			} else {
				calendar.updateSize();
			}
		}, 50);
	}
	
	//2. 캘린더 초기화 함수 정의
	function initCalendar() {
		const calendarEl = document.getElementById('calendar');
		if(!calendarEl) return;
		
		calendar = new FullCalendar.Calendar(calendarEl, {
			initialView: 'dayGridMonth',
			locale: 'ko',
			height: 650,
			events: reservationData.map(function(e) {
				const start = new Date(e.start);
				start.setDate(start.getDate() - 1);
				return Object.assign({}, e, {
					start: start.toISOString().slice(0,10)
				});
			}),
			eventClick: function(info) {
				//상세정보 모달 호출
				viewDetail(info.event.id);
			}
		});
		calendar.render();
	}
	
	//저장된 보기 방식 복원(리스트, 캘린더)
	const currentView = localStorage.getItem('reservationView') || 'cal';
	
	if(currentView === 'cal') {
		showCalView();
	} else {
		showListView();
	}

	document.getElementById('viewCalBtn').addEventListener('click',showCalView);
	document.getElementById('viewListBtn').addEventListener('click',showListView);
});

//==============================
//검색 필터 적용
//예약상태 필터 클릭 시
function statusFilterChange(val) {
	const placeType = document.getElementById('placeTypeFilter').value;
	location.href = path + "/getReservationList.ad?status=" + val + "&placeType=" + placeType;
}

//장소분류 필터 클릭 시
function placeTypeFilterChange(val) {
	const status = document.getElementById('statusFilter').value;
	location.href = path + "/getReservationList.ad?status=" + status + "&placeType=" + val;
}
 
//상세보기 버튼 클릭 시
function viewDetail(resId) {
	$.ajax({
		url: path + '/getReservationDetail.ad',
		type: 'get',
		data: 'resId=' + resId,
		dataType: 'json',
		success: function(data) {
			console.log(data)
			
			const statusMap = {'RESERVED':'확정', 'PENDING':'결제대기', 'CANCELLED':'취소', 'COMPLETED':'이용완료'};

			$('#modal_res_id').text(data.reservation_id);
			$('#modal_user_id').text(data.user_id);
			$('#modal_name').text(data.placeDTO.name);
			$('#modal_check_in').text(data.check_in);
			$('#modal_check_out').text(data.check_out);
			$('#modal_visit_time').text(data.visit_time);
			$('#modal_guest_count').text(data.guest_count + "명");
			$('#modal_status').html(statusMap[data.status]||data.status);
			
			$('#resDetailModal').modal('show');
		},
		error: function(error) {
			console.log("Detail Error:",error);
			alert("예약 상세 정보를 가져올 수 없습니다.");
		}
	});
}

// 수정 버튼 클릭 시
function editReservation(resId) {
	console.log("수정 버튼 클릭 - ID: " + resId);
	
	$.ajax({
		url: path + '/getReservationDetail.ad',
		type: 'get',
		data: 'resId=' + resId,
		dataType: 'json',
		success: function(data) {
			//수정 불가 필드(예약번호, 사용자ID)
			$('#update_res_id').val(data.reservation_id);
			$('#update_user_id').val(data.user_id);
			$('#update_check_in').val(data.check_in);
			$('#update_check_out').val(data.check_out);
			$('#update_guest_count').val(data.guest_count + "명");
			
			if(data.placeDTO && data.placeDTO.name) {
				$('#update_name').val(data.placeDTO.name);
			} else {
				$('#update_name').val('');
			}
			
			//수정 가능 필드(예약상태)
			$('#update_status').val(data.status);
			
			//수정 modal 띄우기
			$('#resUpdateModal').modal('show');
		},
		error: function() {
			alert("데이터 로드 실패");
		}
	});
 }
 
 //예약상태 변경
 function updateReservationStatus() {
 	//input 박스의 value 가져오기
 	const resId = $('#update_res_id').val();
 	const status = $('#update_status').val();
 	
 	if(!confirm("예약 상태를 변경하시겠습니까?"))
 	return;
 	
 	$.ajax({
 		url: path + '/updateReservationStatus.ad',
 		type: 'post',
 		data: {
 			"resId": resId,
 			"status": status
 		},
 		success: function(result){
 			if(result === "success") {
 				alert("상태가 변경되었습니다.");
 				$('#resUpdateModal').modal('hide');
 				location.reload();
 			} else {
 				alert("상태 변경에 실패하였습니다.");
 			}
 		},
 		error: function() {
 			alert("오류 발생");
 		}
 	});
 }