/*
 * @author 김다솜
 * 최초작성일: 2026-03-24
 * 최종수정일: 2026-03-30
 * 참고 코드: festReservation.js
 * 변경 사항
 * ----------------------------------------
 * v260330
 * flatpickr range 인라인 캘린더 적용 (체크인/체크아웃 통합)
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
// 총 금액 계산 + 버튼 활성화
// =========================
function updateTotalPrice() {
	const checkIn = $('#check_in').val();
	const checkOut = $('#check_out').val();
	const guestCount = Number($('#guest_count').val());
	const btn = $('#btnSubmitReservation');

	if (!checkIn || !checkOut) {
		$('#total_price').text('');
		$('#nights_label').text('-박');
		btn.prop('disabled', true);
		return;
	}

	const nights = Math.round((new Date(checkOut) - new Date(checkIn)) / (1000 * 60 * 60 * 24));

	if (nights <= 0) {
		alert('체크아웃은 체크인 이후 날짜여야 합니다.');
		$('#check_in').val('');
		$('#check_out').val('');
		fp.clear();
		$('#total_price').text('');
		$('#nights_label').text('-박');
		$('#selected_date_display').text('');
		btn.prop('disabled', true);
		return;
	}

	const total = PRICE_PER_NIGHT * nights;
	$('#nights_label').text(nights + '박');
	$('#total_price').text(total.toLocaleString() + '원');
	$('#selected_date_display').text(`체크인: ${checkIn} / 체크아웃: ${checkOut} (${nights}박)`);
	btn.prop('disabled', guestCount <= 0);
}

// =========================
// flatpickr range 캘린더
// =========================
let fp;

$(document).ready(function () {
	fp = flatpickr('#flatpickr-container', {
		locale: 'ko',
		dateFormat: 'Y-m-d',
		minDate: 'today',
		mode: 'range',
		inline: true,
		onChange: function (selectedDates) {
			if (selectedDates.length === 2) {
				$('#check_in').val(getLocalDateStr(selectedDates[0]));
				$('#check_out').val(getLocalDateStr(selectedDates[1]));
				updateTotalPrice();
			} else if (selectedDates.length === 1) {
				$('#check_in').val(getLocalDateStr(selectedDates[0]));
				$('#check_out').val('');
				$('#total_price').text('');
				$('#nights_label').text('-박');
				$('#selected_date_display').text('체크아웃 날짜를 선택해주세요.');
				$('#btnSubmitReservation').prop('disabled', true);
			} else {
				$('#check_in').val('');
				$('#check_out').val('');
				updateTotalPrice();
			}
		}
	});

	$('#guest_count').on('input', function () {
		let count = Number($(this).val());
		if (count < 1 || isNaN(count)) $(this).val(1);
		updateTotalPrice();
	});

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

	if (!data.check_in) { alert("체크인 날짜를 선택하세요."); return; }
	if (!data.check_out) { alert("체크아웃 날짜를 선택하세요."); return; }
	if (!data.guest_count || data.guest_count <= 0) { alert("인원 수를 확인하세요."); return; }

	const nights = Math.round((new Date(data.check_out) - new Date(data.check_in)) / (1000 * 60 * 60 * 24));
	if (nights <= 0) { alert("최소 1박부터 예약할 수 있습니다."); return; }

	const btn = $('#btnSubmitReservation');
	btn.prop('disabled', true).text('예약 처리 중');

	$.ajax({
		url: CTX + "/reservationAction.rv",
		type: "post",
		data: data,
		dataType: "json",
		success: function (res) {
			location.href = CTX + "/reservationConfirm.rv?reservation_id=" + res.reservation_id;
		},
		error: function () {
			alert("예약 실패. 다시 시도해주세요.");
		},
		complete: function () {
			btn.prop('disabled', false).text('결제 및 예약하기');
		}
	});
}