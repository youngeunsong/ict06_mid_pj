/**
 * 관리자 > 예약 전체목록 > 상세조회
 */
 
 //상세보기 버튼 클릭 시
 function viewDetail(resId) {
 	$.ajax({
 		url: path + '/resdetail.ad',
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
 		
 			if(data.place) {
	 			$('#modal_name').text(data.place.name);
 			}

 			$('#resDetailModal').modal('show');
 		},
 		error: function(error) {
 			console.log(error);
 			alert("예약 상세 정보를 가져올 수 없습니다.");
 		}
 	});
 }