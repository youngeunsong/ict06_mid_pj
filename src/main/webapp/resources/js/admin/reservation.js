/**
 * 관리자 > 예약 전체목록 > 상세조회
 */
 
 //status 필터 클릭 시
 function handleFilterChange(val) {
 	const status = val;
 	location.href = path + "/admin/reservation/list?status=" + status;
 }
 
 //상세보기 버튼 클릭 시
 function viewDetail(resId) {
 	$.ajax({
 		url: path + '/admin/reservation/detail',
 		type: 'get',
 		data: 'resId=' + resId,
 		dataType: 'json',
 		success: function(data) {
 			console.log(data)
 			
 			$('#modal_res_id').text(data.reservation_id);
 			$('#modal_user_id').text(data.user_id);
 			$('#modal_check_in').text(data.check_in);
 			$('#modal_check_out').text(data.check_out);
 			$('#modal_visit_time').text(data.visit_time);
 			$('#modal_guest_count').text(data.guest_count + "명");
 			$('#modal_status').text(data.status);
 		
 			if(data.placeDTO) {
	 			$('#modal_name').text(data.placeDTO.name);
 			} else {
 				$('#modal_name').text('');
 			}

 			$('#resDetailModal').modal('show');
 		},
 		error: function(error) {
 			console.log(error);
 			alert("예약 상세 정보를 가져올 수 없습니다.");
 		}
 	});
 }

 // 수정 버튼 클릭 시
 function editReservation(resId) {
	console.log("수정 버튼 클릭 - ID: " + resId);
	
	$.ajax({
		url: path + '/admin/reservation/detail',
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
 		url: path + '/admin/reservation/updateStatus',
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