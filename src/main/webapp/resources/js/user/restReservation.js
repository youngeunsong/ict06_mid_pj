/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: accReservation.js
 * 변경 사항
 * ----------------------------------------
 * v260327
 * 예약시간 30분 단위 생성 및 오늘 날짜의 과거 시간 차단 로직 추가
 * ----------------------------------------	
*/

// =========================
// 예약 날짜/시간 설정, flatpickr 캘린더 설정
// =========================
$(document).ready(function() {
	//flatpickr 인라인 캘린더 설정
	flatpickr('#visit_date', {
		locale: 'ko',
		dateFormat: 'Y-m-d',
		minDate: 'today',
		//inline: 별도 클릭 없이 바로 화면에 렌더링
		inline: true,
		//날짜 선택 시 동작
		onChange: function(selectedDates, dateStr) {
			console.log("선택된 날짜:", dateStr);
			$('#visit_date').val(dateStr);
			generateTimeOptions(dateStr);
			checkForm();
		}
	});
	
	//이벤트 바인딩
	$('#guest_count').on('input', checkForm);
	checkForm();
});

// =========================
// 시간 슬롯
// =========================
function generateTimeOptions(selectedDate) {
	console.log("선택 날짜:", selectedDate);
	
	const wrap = $('#timeSlotWrap');
	wrap.empty();
	$('#visit_time').val('');
	
	const now = new Date();
	const today = now.toISOString().split('T')[0];
	const isToday = selectedDate === today;
	
	//오늘 선택 시 현재 +1시간 이후부터
	const minTime = new Date(now.getTime() + 60*60*1000);
	
	let amGroup = $('<div class="time-group"><div class="time-title">🌞 오전</div></div>');
	let pmGroup = $('<div class="time-group"><div class="time-title">🌙 오후</div></div>');
	
	let hasSlot = false;
	
	for(let h=9; h<=21; h++) {
		for(let m=0; m<60; m+=30) {
			if(h === 21 && m > 0)
				break;
			
			//오늘이면 과거 시간 제거
			if(isToday) {
				const slotTime = new Date();
				slotTime.setHours(h, m, 0, 0);
				
				if(slotTime <= minTime)
					continue;
			}
			
			const hh = String(h).padStart(2, '0');
			const mm = String(m).padStart(2, '0');
			const timeStr = `${hh}:${mm}`;
			
			const btn = $(`<button type="button" class="time-slot-btn">${timeStr}</button>`);
			btn.data('time', timeStr);
			
			//시간대 분기
			if(h < 13) {
				amGroup.append(btn);
			}
			else {
				pmGroup.append(btn);
			}
			
			hasSlot = true; 
		}
	}
	
	if(amGroup.children().length > 1) {
		wrap.append(amGroup);
	}
	if(pmGroup.children().length > 1) {
		wrap.append(pmGroup);
	}
}

// =========================
// 시간 클릭 이벤트
// =========================
$(document).on('click', '.time-slot-btn', function() {
	$('.time-slot-btn').removeClass('active');
	$(this).addClass('active');
	
	const time = $(this).data('time');
	$('#visit_time').val(time);
	
	//예약 버튼 활성화
	checkForm();
});

// =========================
// 버튼 활성화 체크
// =========================
function checkForm() {
	const isDateSelected = $('#visit_date').val() !== '';
	const isTimeSelected = $('#visit_time').val() !== '';
	$('#btnSubmitReservation').prop('disabled', !isDateSelected || !isTimeSelected);
}

// =========================
// 예약 처리
// =========================
function submitReservation() {
	const data = {
		place_id: PLACE_ID,
		place_type: PLACE_TYPE,
		visit_date: $('#visit_date').val(),
		visit_time: $('#visit_time').val(),
		guest_count: $('#guest_count').val(),
		request_note: $('#request_note').val()
	};
	
	//유효성 검사
	if(!data.visit_date) {
		alert("방문일을 선택하세요.");
		return;
	}
	
	if(!data.visit_time) {
		alert("방문 시간을 선택하세요.");
		return;
	}
	
	if(!data.guest_count || data.guest_count <= 0) {
		alert("인원 수를 확인하세요.");
		return;
	}
	
	//버튼 중복 클릭 방지
	const btn = $('#btnSubmitReservation');
	btn.prop('disabled', true).text('예약 처리 중');
	
	$.ajax({
		url: CTX + "/reservationAction.rv",
		type: "post",
		data: data,
		success: function(res) {
			location.href = CTX + "/reservationConfirm.rv?reservation_id=" + res.reservation_id;
		},
		error: function() {
			alert("예약 실패. 다시 시도해주세요.");
		},
		complete: function() {
			btn.prop('disabled', false).text('예약하기');
		}
	});
}