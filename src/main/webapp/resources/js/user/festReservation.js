/*
 * @author 김다솜
 * 최초작성일: 2026-03-22
 * 최종수정일: 2026-03-27
 * 참고 코드: festivalDetail.js
 * 변경 사항
 * ----------------------------------------
 * v260327
 * 종료 축제의 예약하기 클릭 시 '종료된 축제입니다' 메시지 이후 상세페이지로 돌아가도록 수정
 * ----------------------------------------	
*/

// =========================
// 예약페이지로 이동
// =========================
document.addEventListener("DOMContentLoaded", function() {
	console.log("DOM 로딩 완료");
	
	const btn = document.getElementById("btnReserve");

	console.log("btn:",btn);	
	
	if(btn) {
		btn.addEventListener("click", function() {
			location.href = CTX + "/festReservation.rv?place_id=" + PLACE_ID;
		});
	}
});

// =========================
// 총 금액 계산
// =========================
function updateTotalPrice() {
	const selected = $('input[name="ticket_id"]:checked');
	
	//1. 선택된 티켓 없는 경우 초기화 후 종료
	if(selected.length === 0) {
		$('#total_price').text('0원');
		$('#btnSubmitReservation').prop('disabled', true);
		return;
	}
	
	const price = Number(selected.data('price')) || 0;
	const stock = Number(selected.data('stock')) || 0;
	let count = Number($('#guest_count').val()) || 0;
	
	//2. 재고 검사
	if(count > stock) {
		alert("잔여 수량을 초과했습니다.");
		$('#guest_count').val(stock);
		count = stock;
	}
	
	if(stock === 0) {
		alert("선택한 티켓은 매진되었습니다.");
		$('input[name="ticket_id"]:checked').prop('checked', false);
		$('#total_price').text('');
		$('#btnSubmitReservation').prop('disabled', true);
		return;
	}
	
	//3. 금액 계산 및 버튼 활성화
	const total = price * count;

	if(price === 0) {
		$('#total_price').text('무료');
	} else {
		$('#total_price').text(total.toLocaleString() + '원');
	}
	
	//날짜가 선택되어 있을 때만 결제+예약 버튼 활성화
	const isDateSelected = $('#visit_date').val() !== "";
	$('#btnSubmitReservation').prop('disabled', !isDateSelected || total < 0);
}

$(document).ready(function() {
	const today = new Date().toISOString().split('T')[0];
	const festStart = $('#visit_date').attr('min');
	const festEnd = $('#visit_date').attr('max');
	
	//축제시작일과 오늘 중 늦은 날짜 선택
	const minDate = (today > festStart) ? today : festStart;

	$('#visit_date').attr('min', minDate);
	
	if(today > festEnd) {
		alert("종료된 축제입니다.");
		location.href = CTX + "/festReservation.rv?place_id=" + PLACE_ID;
		$('#btnSubmitReservation').prop('disabled', true);
	}
	
	updateTotalPrice();
	$('#btnSubmitReservation').prop('disabled', true);
	$('input[name="ticket_id"]').on('change', updateTotalPrice);
	$('#guest_count').on('input', updateTotalPrice);
});

// =========================
// 예약 처리
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
	
	//날짜 범위 검사
	const minDate = $('#visit_date').attr('min');
	const maxDate = $('#visit_date').attr('max');
	
	if(data.visit_date < minDate || data.visit_date > maxDate) {
		alert("축제 기간 내 날짜만 선택 가능합니다.");
		return;
	}
	
	//유효성 검사
	if(!data.ticket_id) {
		alert("티켓을 선택하세요.");
		return;
	}
	
	if(!data.visit_date) {
		alert("방문일을 선택하세요.");
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
			alert("확인 페이지 이동");
			location.href = CTX + "/reservationConfirm.rv?reservation_id=" + res.reservation_id;
		},
		error: function() {
			alert("예약 실패. 다시 시도해주세요.");
		},
		complete: function() {
			btn.prop('disabled', false).text('결제 및 예약하기');
		}
	});
}