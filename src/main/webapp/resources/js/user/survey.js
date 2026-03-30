/*
 * @author 김다솜
 * 최초작성일: 2026-03-25
 * 최종수정일: 2026-03-26
 * 참고 코드: none
*/

// =========================
// 전역변수
// =========================
let surveyQueue = [];
let currentSurvey = null;
let totalSurveyCount = 0;
let shouldOpenSurvey = false;
let isFirstSurvey = true;

console.log("survey.js 로드됨");

// =========================
// 설문 진행률 업데이트
// =========================
function updateProgress() {
	if(totalSurveyCount === 0) return;
	
	const current = totalSurveyCount - surveyQueue.length;
	const percent = Math.round((current/totalSurveyCount)*100);
	
	$('#surveyProgressBar').css('width', percent + '%');
	$('#progressText').text(`${current}/${totalSurveyCount}`);
}

// =========================
// 문서 준비 완료
// =========================
$(document).ready(function() {

    // 설문/리뷰 페이지형 JSP에서는 모달용 survey.js 실행 중지
    if ($("#surveyForm").length > 0) {
        console.log("surveyReview.jsp에서는 survey.js 실행 중지");
        return;
    }
	
	console.log("📄 문서 준비 완료");
	
	// ✅ 여기서 URL 파라미터 처리
	const urlParams = new URLSearchParams(window.location.search);
	shouldOpenSurvey = urlParams.get('openSurvey') === 'true';
	
	console.log("🔍 URL:", window.location.href);
	console.log("🔍 openSurvey 파라미터:", urlParams.get('openSurvey'));
	console.log("✅ shouldOpenSurvey:", shouldOpenSurvey);
	
	//설문 대상 조회
	$.ajax({
		url: path + "/surveyList.sv",
		type: "get",
		dataType: "json",
		success: function(list) {
			console.log("✅ 서버 응답 데이터:", list);
			
			if(!list || list.length === 0) {
				console.log("⚠️ 설문 목록 비어있음");
				return;
			}
			
			//skip하지 않은 설문만 필터
			surveyQueue = list.filter(item => {
        		const key = "survey_skip_" + item.reservation_id;
				return !sessionStorage.getItem(key);
			});
			
			totalSurveyCount = surveyQueue.length;
			console.log("✅ 필터된 설문 개수:", totalSurveyCount);
			
			if(surveyQueue.length === 0) {
				console.log("⚠️ 필터 후 설문 없음");
				return;
			}
			
			isFirstSurvey = true;
			console.log("✅ isFirstSurvey = true");
			showNextSurvey();
		},
		error: function(error) {
			console.error("❌ 설문 목록 조회 실패:", error);
		}
	});
					
	//NPS 슬라이더
	$(document).on('input', '#nps_score', function() {
		$('#nps_value').text($(this).val());
	});
});

// =========================
// 설문 값 초기화
// =========================
function resetSurveyForm() {

	if ($("#surveyForm").length > 0) {
        return;
    }
    
	$('#satisfaction_score').val('');
	$('#nps_score').val('');
	$('#info_reliability_score').val('');
	$('#inconvenience').val('');
	$('#improvements').val('');
	
	$('.score-item').removeClass('active');
	$('.selected-value').remove();

	$('#review_rating').val('');
	$('#review_content').val('');
	$('.star-item').removeClass('active');
}

// =========================
// 다음 설문 표시
// =========================
function showNextSurvey() {
	console.log("🔄 showNextSurvey 호출됨");
	console.log("   shouldOpenSurvey:", shouldOpenSurvey);
	console.log("   isFirstSurvey:", isFirstSurvey);
	console.log("   남은 설문:", surveyQueue.length);
	
	if(!surveyQueue || surveyQueue.length === 0) {
		console.log("⚠️ 모든 설문 완료");
		currentSurvey = null;
		
		$('#surveyGuide').addClass('d-none');
		showToast("모든 설문 완료! 감사합니다🎉");
		
		return;
	}
	
	resetSurveyForm();
	
	currentSurvey = surveyQueue.shift();
	updateProgress();
	
	const placeId = currentSurvey.place_id || "";
	const placeName = (currentSurvey.placeDTO && currentSurvey.placeDTO.name) || "알 수 없는 장소";
	
	console.log("✅ 현재 설문:", currentSurvey);
	
	$('#surveyGuide').removeClass('d-none');
	$('#surveyGuideText').text(placeName);
	
	$('#survey_reservation_id').val(currentSurvey.reservation_id);
	$('#survey_place_name').text(placeName);
	
	$('#review_place_id').val(placeId);
	$('#review_place_name').text(placeName);
	
	console.log("🔍 조건 체크 - shouldOpenSurvey:", shouldOpenSurvey, "isFirstSurvey:", isFirstSurvey);
	
	if(shouldOpenSurvey && isFirstSurvey) {
		console.log("✅ 모달 오픈!");
		isFirstSurvey = false;
		
		setTimeout(() => {
			console.log("🎬 modal show 호출");
			$('#surveyModal').modal('show');
		}, 300);
	} else {
		console.log("⚠️ 모달 오픈 조건 불만족");
		isFirstSurvey = false;
	}
}

// =========================
// 설문 열기
// =========================
$(document).on('click', '#openSurveyBtn', function() {
	location.href = path + '/viewReservations.do?openSurvey=true';
});

// =========================
// '나중에' 버튼 클릭
// =========================
$(document).on('click', '#laterBtn', function() {
	console.log("⏭️ '나중에' 버튼 클릭");
	
	//모달 닫기
	$('#surveyModal').modal('hide');
	$('#reviewModal').modal('hide');
	
	//설문카드 숨기고 '나중에' 메시지 출력
	$('#surveyGuide').addClass('d-none');
	$('#surveyLater').removeClass('d-none');
	
	console.log("✅ 설문을 건너뜀. 나중에 다시 들어오면 표시됩니다.");
});

// =========================
// '지금 작성하기' 버튼 클릭
// =========================
$(document).on('click', '#retryBtn', function() {
	console.log("🔄 지금 작성하기 클릭");
	
	//마이페이지로 이동
	location.href = path + '/viewReservations.do?openSurvey=true';
})

// =========================
// 점수 선택
// =========================
$(document).on('click', '.score-item', function() {
	const group = $(this).closest('.score-group');
	const type = group.data('type');
	const value = $(this).data('value');
	
	group.find('.score-item').removeClass('active');
	$(this).addClass('active');
	
	group.find('.selected-value').remove();
	group.append(`<div class="selected-value">선택한 점수: ${value}점</div>`);
	
	if(type === 'satisfaction') {
		$('#satisfaction_score').val(value);
	}
	else if(type === 'reliability') {
		$('#info_reliability_score').val(value);
	}
	else if(type === 'nps') {
		$('#nps_score').val(value);
	}
});

// =========================
// 설문 제출
// =========================
function submitSurvey() {
	const data = {
		reservation_id: $('#survey_reservation_id').val(),
		satisfaction_score: $('#satisfaction_score').val(),
		nps_score: $('#nps_score').val(),
		info_reliability_score: $('#info_reliability_score').val(),
		inconvenience: $('#inconvenience').val(),
		improvements: $('#improvements').val()
	};
	
	if(!data.reservation_id) {
		alert("예약 정보 누락");
		return;
	}
	
	if(!data.satisfaction_score || !data.nps_score || !data.info_reliability_score) {
		alert("필수 항목을 선택하세요.");
		return;
	}
	
	$.ajax({
		url: path + "/surveyInsert.sv",
		type: "post",
		data: data,
		success: function(res) {
			console.log("설문 응답:", res);
		
			if(res.success) {

				alert("설문이 제출되었습니다. 응답해 주셔서 감사합니다😊");
				
				// ===============================
				// 추가: 김재원 2026-03-26
				// 설문 참여 시 포인트 지급 알림
				
                alert("🎉 설문 참여로 1000 포인트가 적립되었습니다!");
                
	            // ================================

				$('#surveyModal').modal('hide');
				
				setTimeout(() => {
					$('#reviewModal').modal('show');
				}, 300);
			} else {
				alert(res.msg || "설문 제출 실패");
			}
		},
	});
}

// =========================
// 별점 클릭
// =========================
$(document).on('click', '.star-item', function() {
	const value = $(this).data('value');
	$('#review_rating').val(value);
	
	$('.star-item').each(function() {
		$(this).toggleClass('active', $(this).data('value') <= value);
	});
});

// =========================
// 리뷰 제출
// =========================
function submitReview() {
	const placeId = $('#review_place_id').val();
	const reservationId = $('#survey_reservation_id').val();
	
	console.log("제출 시점 placeId 확인:", placeId);
	console.log("제출 시점 reservationId 확인:", reservationId);
	
	if(!placeId) {
		alert("장소 정보 누락");
		return;
	}
	if(!reservationId) {
		alert("예약 정보 누락");
		return;
	}	
	
	const data = {
		place_id: placeId,
		reservation_id: reservationId,
		rating: $('#review_rating').val(),
		content: $('#review_content').val()
	};
	
	if(!data.rating) {
		alert('별점을 선택해주세요.');
		return;
	}
	
	if(!data.content.trim()) {
		alert('리뷰 내용을 입력해주세요.');
		return;
	}
	
	$.ajax({
		url: path + '/reviewInsert.sv',
		type: 'post',
		data: data,
		success: function(res) {
			console.log("리뷰 응답:", res);

			if(res.success) {

				alert('리뷰가 등록되었습니다. 감사합니다😊');
				
				// ===============================
				// 추가: 김재원 2026-03-26
				// 리뷰 참여 시 포인트 지급 알림
	            
	            alert("🎉 리뷰 작성으로 500 포인트가 적립되었습니다!");
	            
	            // ================================

				$('#reviewModal').modal('hide');
				showNextSurvey();
			} else {
				alert(res.msg || '리뷰 등록 실패');
			}
		},
		error: function(xhr, status, error) {
			console.error("리뷰 등록 에러:", xhr.responseText, status, error);
			alert('리뷰 등록 실패. 다시 시도해주세요.');
		}
	});
}

// =========================
// 알림 toast UI
// =========================
function showToast(msg) {
	const toast = $('#toast');
	toast.text(msg).fadeIn();
	
	setTimeout(() => {
		toast.fadeOut();
	}, 2000);
}