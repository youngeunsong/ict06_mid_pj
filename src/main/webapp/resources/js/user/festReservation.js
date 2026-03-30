/*
 * @author 김다솜
 * 최초작성일: 2026-03-22
 * 최종수정일: 2026-03-27
 * 참고 코드: festivalDetail.js
 * 변경 사항
 * ----------------------------------------
 * v260327
 * 종료 축제의 예약하기 클릭 시 '종료된 축제입니다' 메시지 이후 상세페이지로 돌아가도록 수정, 예약날짜 선택 flatpickr 캘린더 적용
 * ----------------------------------------	
*/

// =========================
// 로컬 날짜 문자열 반환
// =========================
function getLocalDateStr(date = new Date()) {
	const year = date.getFullYear();
	const month = String(date.getMonth() + 1).padStart(2, '0');
	const day = String(date.getDate()).padStart(2, '0');
	return `${year}-${month}-${day}`;
}

// =========================
// 예약 날짜/시간 설정, flatpickr 캘린더 설정
// =========================
$(document).ready(function() {
	const festStart = $('#festStartDate').val();
	const festEnd = $('#festEndDate').val();
	
	const todayStr = getLocalDateStr();
	
	if(!festStart || !festEnd) {
		console.error("축제 날짜 없음");
		return;
	}
	
	//축제 종료 여부 체크
	if(new Date(todayStr) > new Date(festEnd)) {
		alert("이미 종료된 축제입니다. 상세 페이지로 이동합니다.");
		location.href = CTX + "/festivalDetail.fe?place_id=" + PLACE_ID;
		return;
	}
	
	//flatpickr 인라인 캘린더 설정
	flatpickr('#flatpickr-container', {
		locale: 'ko',
		dateFormat: 'Y-m-d',
		//오늘과 시작일 중 늦은 날짜 적용
		minDate: todayStr > festStart ? todayStr : festStart,
		maxDate: festEnd,
		//inline: 별도 클릭 없이 바로 화면에 렌더링
		inline: true,
		//날짜 선택 시 동작
		onChange: function(selectedDates, dateStr) {
			console.log("선택된 날짜:", dateStr);
			$('#visit_date').val(dateStr);
			$('#selected_date_display').text("선택일: " + dateStr);
			updateTotalPrice();
		}
	});
	
	//이벤트 바인딩
	$('input[name="ticket_id"]').on('change', function() {
		validateGuestCount();
		updateTotalPrice();
	});
	
	$('#guest_count').on('input',function() {
		validateGuestCount();
		updateTotalPrice();
	});
	
	updateTotalPrice();
});

// =========================
// 인원 유효성 검사(재고 체크)
// =========================
function validateGuestCount() {
	const selected = $('input[name="ticket_id"]:checked');
	if(selected.length > 0) {
		const stock = Number(selected.data('stock'));
		let count = Number($('#guest_count').val());
		
		if(count > stock) {
			alert("해당 티켓의 잔여 수량(" + stock + "매)을 초과할 수 없습니다.");
			$('#guest_count').val(stock);
		}
	}
}

// =========================
// 총 금액 계산
// =========================
function updateTotalPrice() {
	const selected = $('input[name="ticket_id"]:checked');
	const dateVal = $('#visit_date').val();
	const btn = $('#btnSubmitReservation');
	const hasTicketList = $('input[name="ticket_id"]').length > 0;
	
	//티켓 목록 있는데 선택하지 않은 경우
	if(hasTicketList && selected.length === 0) {
		$('#total_price').text('0원');
		btn.prop('disabled', true);
		return;
	}
	
	const price = selected.length > 0 ? Number(selected.data('price')) : 0;
	const count = Number($('#guest_count').val()) || 1;
	const total = price * count;
	
	//금액 표시
	if(total === 0) {
		$('#total_price').text('무료');
	}
	else {
		$('#total_price').text(total.toLocaleString() + '원');
	}
	
	//조건 충족 시 버튼 활성화(티켓 있으면 날짜+티켓 둘 다, 없으면 날짜만 있는 경우 날짜만 선택)
	if(hasTicketList) {
		btn.prop('disabled', !(dateVal && selected.length > 0));
	}
	else {
		btn.prop('disabled', !dateVal);
	}
}

// =========================
// 예약 제출
// =========================
function submitReservation() {
	const data = {
		place_id: PLACE_ID,
		place_type: PLACE_TYPE,
		ticket_id: $('input[name="ticket_id"]:checked').val(),
		visit_date: $('#visit_date').val(),
		guest_count: $('#guest_count').val(),
		request_note: $('#request_note').val()
	};
	
	//유효성 검사
	if(!data.visit_date) {
		alert("방문일을 선택하세요.");
		return;
	}
	
	if($('input[name="ticket_id"]').length > 0 && !data.ticket_id) {
		alert("티켓 종류를 선택하세요.");
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
		dataType: "json",
		success: function(res) {
			location.href = CTX + "/reservationConfirm.rv?reservation_id=" + res.reservation_id;
		},
		error: function() {
			alert("예약 중 오류가 발생했습니다. 다시 시도해주세요.");
		},
		complete: function() {
			btn.prop('disabled', false).text('결제 및 예약하기');
		}
	});
}