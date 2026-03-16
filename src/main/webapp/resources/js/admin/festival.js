/**
 * 관리자 > 축제 전체목록 > 상세조회
 */

//태그 토글
function toggleTag(el) {
	el.classList.toggle('active');
}

//검색 필터(체크박스)
function filterData() {
	const statusList = [];
	document.querySelectorAll('.tag-success.active, .tag-warning.active, .tag-secondary.active')
		.forEach(function(el) {
			if(el.dataset.value) statusList.push(el.dataset.value);	
		});
		
	const params = [];
	const sortType = document.getElementById('sortType').value;
	if(statusList.length > 0) params.push('status=' + statusList.join(','));
	if(sortType) params.push('sortType=' + sortType);
	
	location.href = path + '/festivalList.adfe' +
	(params.length > 0 ? '?' + params.join('&') : '');
}

//URL 파라미터 -> 태그 복원
$(document).ready(function() {
	const urlParams = new URLSearchParams(window.location.search);
	const statusParam = urlParams.get('status');
	const sortParam = urlParams.get('sortType');
	
	if(statusParam) {
		statusParam.split(',').forEach(function(val) {
			document.querySelectorAll('.tag[data-value="' + val + '"]')
				.forEach(function(el) {
					el.classList.add('active');
				});
		});
	}
	
	if(sortParam) {
		document.getElementById('sortType').value = sortParam;
	}
});

/* 키워드 검색 */
function keywordSearch() {
	const keyword = $('#keyword').val().trim();
	const sortType = document.getElementById('sortType').value;
	
	if(!keyword) {
		alert('축제명 혹은 설명에 해당하는 키워드를 입력해주세요!'); // TODO: 어떤 키워드를 넣을 수 있을 지 체크 
		return;
	}
	location.href = path + '/festivalList.adfe?keyword=' + encodeURIComponent(keyword)
					+ (sortType ? '&sortType=' + sortType : '');
}

/* 축제 상세 조회 modal */
function viewFestivalDetail(id){

 $.ajax({

  url : path + "/getFestivalDetail.adfe",
  type : "get",
  data : {festival_id : id},

  success : function(data){

   $('#modal_name').text(data.placeDTO.name);
   if(data.status == "UPCOMING"){
		$('#modal_status').text("시작 전"); 
	}
	else if(data.status =="ONGOING"){
		$('#modal_status').text("진행 중"); 
	}
	else if(data.status =="ENDED"){
		$('#modal_status').text("종료"); 
	}
   		
   $('#modal_address').text(data.placeDTO.address);
   $('#modal_latitude').text(data.placeDTO.latitude);
   $('#modal_longitude').text(data.placeDTO.longitude);

   $('#modal_start_date').text(data.start_date);
   $('#modal_end_date').text(data.end_date);

   $('#modal_description').text(data.description);

   $('#modal_image').attr("src",data.placeDTO.image_url);

   // 티켓 표시
   if(data.ticketList){
    data.ticketList.forEach(function(ticket){

     if(ticket.ticket_type == "Free"){
     	$('#priceFree').text(ticket.price + "원");
		$('#stockFree').text(ticket.stock);
		$('#ticketDescFreeDay').text(ticket.description);
     }

     if(ticket.ticket_type == "OneDay"){
      	$('#priceOneDay').text(ticket.price + "원");
		$('#stockOneDay').text(ticket.stock);
		$('#ticketDescOneDay').text(ticket.description);
     }

     if(ticket.ticket_type == "TwoDay"){
     	$('#priceTwoDay').text(ticket.price + "원");
		$('#stockTwoDay').text(ticket.stock);
		$('#ticketDescOneDay').text(ticket.description);
     }

     if(ticket.ticket_type == "AllDay"){
      	$('#priceAllDay').text(ticket.price + "원");
		$('#stockAllDay').text(ticket.stock);
		$('#ticketDescAllDay').text(ticket.description);
     }
    });
   }

   $('#festivalDetailModal').modal("show");
  }
 });
}

/* 축제 수정 modal */
function editFestival(id){
 $.ajax({

  url : path + "/getFestivalDetail.adfe",
  type : "get",
  data : {festival_id : id},
  dataType : "json",

  success : function(data){

   // 축제 정보	
   $('#inputName').val(data.placeDTO.name);
   $('#inputAddress').val(data.placeDTO.address); 
   $('#inputLatitude').val(data.placeDTO.latitude);
   $('#inputLongitude').val(data.placeDTO.longitude); 
   $('#inputImgAddress').val(data.placeDTO.image_url);
   $('#inputDescription').val(data.description);
   $('#inputStartDate').val(data.start_date);
   $('#inputEndDate').val(data.end_date);
   
   // 티켓 정보
   data.ticketList.forEach(function(ticket){
	 if(ticket.ticket_type == "Free"){
	   $('#priceFree').val(ticket.price);
	   $('#stockFree').val(ticket.stock);
	   $('#ticketDescFreeDay').val(ticket.description);
	 }
	
	 if(ticket.ticket_type == "OneDay"){
	   $('#priceOneDay').val(ticket.price);
	   $('#stockOneDay').val(ticket.stock);
	   $('#ticketDescOneDay').val(ticket.description);
	 }
	
	 if(ticket.ticket_type == "TwoDay"){
	   $('#priceTwoDay').val(ticket.price);
	   $('#stockTwoDay').val(ticket.stock);
	   $('#ticketDescTwoDay').val(ticket.description);
	 }
	
	 if(ticket.ticket_type == "AllDay"){
	   $('#priceAllDay').val(ticket.price);
	   $('#stockAllDay').val(ticket.stock);
	   $('#ticketDescAllDay').val(ticket.description);
	 }
	});

   $('#festivalUpdateModal').modal("show");
  }
 });
}

/* 축제 수정 처리 */ 
function updateFestival(){
 $.ajax({

  url : path + "/updateFestival.adfe",
  type : "post",

  data : {

   name : $('#update_name').val(),
   start_date : $('#update_start_date').val(),
   end_date : $('#update_end_date').val(),
   description : $('#update_description').val()

  },

  success : function(res){

   if(res=="success"){

    alert("수정 완료");
    $('#festivalUpdateModal').modal('hide');
    location.reload();

   }
  }
 });
}

/* 축제 삭제 처리 */
function deleteFestival(festival_id){

    if(!confirm("정말 삭제하시겠습니까?")){
        return;
    }

    $.ajax({

        url : path + "/deleteActionFestival.adfe",
        type : "POST",
        data : { festival_id : festival_id },

        success : function(result){

            if(result == 1){
                alert("삭제되었습니다");
                location.reload();
            }else{
                alert("삭제 실패");
            }
        },

        error : function(){
            alert("서버 오류");
        }

    });
}
