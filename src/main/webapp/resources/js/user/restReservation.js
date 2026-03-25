/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: accReservation.js
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
			location.href = CTX + "/restReservation.rv?place_id=" + PLACE_ID;
		});
	}
});

// =========================
// 버튼 활성화 체크
// =========================
function checkForm() {
	const isDateSelected = $('#visit_date').val() !== '';
	const isTimeSelected = $('#visit_time').val() !== '';
	$('#btnSubmitReservation').prop('disabled', !isDateSelected || !isTimeSelected);
}

$(document).ready(function() {
	const today = new Date().toISOString().split('T')[0];
	$('#visit_date').attr('min', today);
	
	$('#visit_date').on('change', checkForm);
	$('#visit_time').on('change', checkForm);
	$('#guest_count').on('input', checkForm);
	
	checkForm();
});

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