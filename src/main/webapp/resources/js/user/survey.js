/*
 * @author 김다솜
 * 최초작성일: 2026-03-25
 * 최종수정일: 2026-03-25
 * 참고 코드: none
*/

// =========================
// 설문 모달 띄우기
// =========================
// 로그인 후 설문 대상 체크
$(document).ready(function() {
	console.log("설문 체크 시작");
	
	//설문 대상 조회
	$.ajax({
		url: CTX + "/surveyList.sv",
		type: "get",
		success: function(list) {
			console.log("서버 응답 데이터:",list);
			
			if(list && list.length > 0) {
				const target = list[0];
				
				//데이터 체크(placeDTO null여부 확인)
				const hasPlace = target.placeDTO && target.placeDTO.name;
				const placeId = target.place_id || "";
				const placeName = (target.placeDTO && target.placeDTO.name) || "알 수 없는 장소";
				
        		console.log("장소 ID:", placeId);
        
				const skipUntil = localStorage.getItem("survey_skip_until");
				if(!skipUntil || new Date().getTime() > parseInt(skipUntil)) {
					$('#surveyGuide').removeClass('d-none');
				}
				
				//설문용 데이터
				$('#survey_reservation_id').val(target.reservation_id);
				$('#survey_place_name').text(placeName);
				
				//리뷰용 데이터
				$('#review_place_id').val(placeId);
				$('#review_place_name').text(placeName);
			}
		}
	});
	
	//NPS 슬라이더
	$('#nps_score').on('input', function() {
		$('#nps_value').text($('#nps_score').val());
	});
});

//작성하기 클릭 > 모달 오픈
$(document).on('click', '#openSurveyBtn', function() {
	$('#surveyModal').modal('show');
});

//나중에 클릭
$(document).on('click', '#laterBtn', function() {
	const now = new Date().getTime();
	const tomorrow = now + (24*60*60*1000);
	
	localStorage.setItem("survey_skip_until", tomorrow);
	
	$('#surveyGuide').hide();
});

//신뢰도 버튼 클릭
$(document).on('click', '.score-item', function() {
	const group = $(this).closest('.score-group');
	const type = group.data('type');
	const value = $(this).data('value');
	
	//버튼 active 처리
	group.find('.score-item').removeClass('active');
	$(this).addClass('active');
	
	//값 표시
	group.find('.selected-value').remove();
	group.append(`<div class="selected-value">선택한 점수: ${value}점</div>`);
	
	//hidden값 세팅
	if(type === 'satisfaction') {
		$('#satisfaction_score').val(value);
	}
	else if(type === 'reliability') {
		$('#info_reliability_score').val(value);
	}
	if(type === 'nps') {
		$('#nps_score').val(value);
	}
});

//설문 등록
function submitSurvey() {
	const data = {
		reservation_id: $('#survey_reservation_id').val(),
		satisfaction_score: $('#satisfaction_score').val(),
		nps_score: $('#nps_score').val(),
		info_reliability_score: $('#info_reliability_score').val(),
		inconvenience: $('#inconvenience').val(),
		improvements: $('#improvements').val()
	};
	
	//유효성 검사(만족도, nps, reliability)
	if(!data.satisfaction_score || !data.nps_score || !data.info_reliability_score) {
		alert("필수 항목을 선택하세요.");
		return;
	}
	
	$.ajax({
		url: CTX + "/surveyInsert.sv",
		type: "post",
		data: data,
		success: function(res) {
			if(res.success) {
				alert("설문이 제출되었습니다. 응답해 주셔서 감사합니다😊");
				$('#surveyModal').modal('hide');
				
				setTimeout(() => {
					$('#reviewModal').modal('show');
				}, 500);
			}
		},
		error: function() {
			alert("설문 제출 실패. 다시 시도해주세요.");
		}
	});
}

// =========================
// 설문 제출 후 리뷰 모달 띄우기
// =========================
//별점 클릭
$(document).on('click', '.star-item', function() {
	const value = $(this).data('value');
	$('#review_rating').val(value);
	
	$('.star-item').each(function() {
		if($(this).data('value') <= value) {
			$(this).addClass('active');
		}
		else {
			$(this).removeClass('active');
		}
	});
});

//리뷰 등록
function submitReview() {
	const placeId = $('#review_place_id').val();
	console.log("제출 시점 placeId 확인:",placeId);
	
	if(!placeId) {
		alert("장소 정보 누락");
		return;
	}
	
	const data = {
		place_id: $('#review_place_id').val(),
		reservation_id: $('#survey_reservation_id').val(),
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
		url: CTX + '/reviewInsert.sv',
		type: 'post',
		data: data,
		success: function(res) {
			if(res.success) {
				alert('리뷰가 등록되었습니다. 감사합니다😊');
				$('#reviewModal').modal('hide');
			}
		},
		error: function() {
			alert('리뷰 등록 실패. 다시 시도해주세요.');
		}
	});
}