/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-24
 * 참고 코드: festReservation.js
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
			location.href = CTX + "/accReservation.rv?place_id=" + PLACE_ID;
		});
	}
});

// =========================
// 총 금액 계산
// =========================
function updateTotalPrice() {
	const checkIn = $('#check_in').val();
	const checkOut = $('#check_out').val();
	
	if(!checkIn || !checkOut) {
		$('#total_price').text('');
		$('#nights_label').text('-박');
		$('#btnSubmitReservation').prop('disabled', true);
		return;
	}
	
	const inDate = new Date(checkIn);
	const outDate = new Date(checkOut);
	//박수 계산
	const nights = Math.round((outDate - inDate) / (1000*60*60*24));
	
	if(nights <= 0) {
		alert('체크아웃은 체크인 이후 날짜여야 합니다.');
		$('#check_out').val('');
		$('#total_price').text('');
		$('#nights_label').text('');
		$('#btnSubmitReservation').prop('disabled', true);
		return;
	}
	
	const total = PRICE_PER_NIGHT * nights;
	$('#nights_label').text(nights + '박');
	$('#total_price').text(total.toLocaleString() + '원');
	$('#btnSubmitReservation').prop('disabled', false);
}

$(document).ready(function() {
	const today = new Date().toISOString().split('T')[0];
	$('#check_in').attr('min', today);
	$('#check_out').attr('min', today);
	
	$('#check_in').on('change', function() {
		//체크인 변경 시 체크아웃 최소값 조정
		const checkIn = $(this).val();
		const nextDay = new Date(checkIn);
		nextDay.setDate(nextDay.getDate() + 1);
		const nextDayStr = nextDay.toISOString().split('T')[0];
		$('#check_out').attr('min', nextDayStr);
		
		//체크아웃이 체크인보다 이전이면 초기화
		if($('#check_out').val() <= checkIn) {
			$('#check_out').val('');
		}
		updateTotalPrice();
	});
	$('#check_out').on('change', updateTotalPrice);
	$('#guest_count').on('input', updateTotalPrice);
	
	updateTotalPrice();
});

// =========================
// 예약 처리
// =========================
function submitReservation() {
	const data = {
		place_id: PLACE_ID,
		place_type: PLACE_TYPE,
		check_in: $('#check_in').val(),
		check_out: $('#check_out').val(),
		guest_count: $('#guest_count').val(),
		request_note: $('#request_note').val()
	};
	
	//유효성 검사
	if(!data.check_in) {
		alert("체크인 날짜를 선택하세요.");
		return;
	}
	if(!data.check_out) {
		alert("체크아웃 날짜를 선택하세요.");
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