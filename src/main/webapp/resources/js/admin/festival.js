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
   $('#modal_festival_detail_id').val(data.festival_id);	

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

   $('#modal_start_date').text(data.start_date_str);
   $('#modal_end_date').text(data.end_date_str);

   $('#modal_description').text(data.description);

   $('#modal_image').attr("src",data.placeDTO.image_url);

   // 티켓 표시
   if(data.ticketList && data.ticketList.length > 0){
	    var ticketHtml = '';

	    ticketHtml += '<table class="table">';
	    ticketHtml += '<thead>';
	    ticketHtml += '<tr>';
	    ticketHtml += '<th>티켓 종류</th>';
	    ticketHtml += '<th>가격</th>';
	    ticketHtml += '<th>재고</th>';
	    ticketHtml += '<th>설명</th>';
	    ticketHtml += '</tr>';
	    ticketHtml += '</thead>';
	    ticketHtml += '<tbody>';

	    data.ticketList.forEach(function(ticket){

	        ticketHtml += '<tr>';
	        ticketHtml += '<td>' + ticket.ticket_type + '</td>';
	        ticketHtml += '<td>' + ticket.price + '</td>';
	        ticketHtml += '<td>' + ticket.stock + '</td>';
	        ticketHtml += '<td>' + ticket.description + '</td>';
	        ticketHtml += '</tr>';

	    });

	    ticketHtml += '</tbody>';
	    ticketHtml += '</table>';

	    $('#ticketTableArea').html(ticketHtml);
	}
   // if(data.ticketList){
   //  data.ticketList.forEach(function(ticket){

// 	 	if(ticket.ticket_type == "Free"){
// 			 $('#detail_priceFree').text(ticket.price + "원");
// 			 $('#detail_stockFree').text(ticket.stock);
// 			 $('#detail_ticketDescFreeDay').text(ticket.description);
// 			}
		
// 		if(ticket.ticket_type == "OneDay"){
// 			 $('#detail_priceOneDay').text(ticket.price + "원");
// 			 $('#detail_stockOneDay').text(ticket.stock);
// 			 $('#detail_ticketDescOneDay').text(ticket.description);
// 		}
		
// 		if(ticket.ticket_type == "TwoDay"){
// 			 $('#detail_priceTwoDay').text(ticket.price + "원");
// 			 $('#detail_stockTwoDay').text(ticket.stock);
// 			 $('#detail_ticketDescTwoDay').text(ticket.description);
// 		}
		
// 		if(ticket.ticket_type == "AllDay"){
// 			 $('#detail_priceAllDay').text(ticket.price + "원");
// 			 $('#detail_stockAllDay').text(ticket.stock);
// 			 $('#detail_ticketDescAllDay').text(ticket.description);
// 		}
   //  });
   // }

   $('#modal_festival_detail').modal("show");
  }
 });
}

/* 축제 상세 조회 modal 닫고 수정 modal 열기*/ 
function openEditFromDetail(){

 const id = $('#modal_festival_detail_id').val();

 $('#modal_festival_detail').on('hidden.bs.modal', function(){
     editFestival(id);
 });

 $('#modal_festival_detail').modal('hide');
}

/* 축제 수정 modal */
function editFestival(id){
 $.ajax({

  url : path + "/getFestivalDetail.adfe",
  type : "get",
  data : {festival_id : id},
  dataType : "json",

  success : function(data){
   // festival_id 저장
   $('#modal_festival_modify_id').val(data.festival_id);	

   // 축제 정보	
   $('#inputName').val(data.placeDTO.name);
   $('#inputAddress').val(data.placeDTO.address); 
   $('#inputLatitude').val(data.placeDTO.latitude);
   $('#inputLongitude').val(data.placeDTO.longitude); 
   $('#inputImgAddress').val(data.placeDTO.image_url);
   $('#inputDescription').val(data.description);
   $('#inputStartDate').val(data.start_date_str);
   $('#inputEndDate').val(data.end_date_str);
   
   // 티켓 정보 표시
   if(data.ticketList && data.ticketList.length > 0){
	    var ticketHtml = '';

	    ticketHtml += '<table class="table">';
	    ticketHtml += '<thead>';
	    ticketHtml += '<tr>';
	    ticketHtml += '<th>티켓 종류</th>';
	    ticketHtml += '<th>가격</th>';
	    ticketHtml += '<th>재고</th>';
	    ticketHtml += '<th>설명</th>';
	    ticketHtml += '</tr>';
	    ticketHtml += '</thead>';
	    ticketHtml += '<tbody>';

	    data.ticketList.forEach(function(ticket){

	        ticketHtml += '<tr>';
	        ticketHtml += '<td><input type="text" value="' + ticket.ticket_type + '"></td>';
	        ticketHtml += '<td><input type="number" value="' + ticket.price + '"></td>';
	        ticketHtml += '<td><input type="number" value="' + ticket.stock + '"></td>';
	        ticketHtml += '<td><textarea cols="24" rows="2" placeholder="티켓 설명문을 입력해주세요." value="' + ticket.description + '"></textarea></td>';
	        ticketHtml += '</tr>';

	    });

	    ticketHtml += '</tbody>';
	    ticketHtml += '</table>';

	    $('#ticketTable_edit').html(ticketHtml);
	}
   // data.ticketList.forEach(function(ticket){

	 // if(ticket.ticket_type == "Free"){
	 //   $('#priceFree').val(ticket.price);
	 //   $('#stockFree').val(ticket.stock);
	 //   $('#ticketDescFreeDay').val(ticket.description);
	 // }
	
	 // if(ticket.ticket_type == "OneDay"){
	 //   $('#priceOneDay').val(ticket.price);
	 //   $('#stockOneDay').val(ticket.stock);
	 //   $('#ticketDescOneDay').val(ticket.description);
	 // }
	
	 // if(ticket.ticket_type == "TwoDay"){
	 //   $('#priceTwoDay').val(ticket.price);
	 //   $('#stockTwoDay').val(ticket.stock);
	 //   $('#ticketDescTwoDay').val(ticket.description);
	 // }
	
	 // if(ticket.ticket_type == "AllDay"){
	 //   $('#priceAllDay').val(ticket.price);
	 //   $('#stockAllDay').val(ticket.stock);
	 //   $('#ticketDescAllDay').val(ticket.description);
	 // }
	// });

   $('#modal_festival_modify').modal("show");
  }
 });
}

/* 축제 수정 처리 */ 
function updateFestival(id){
 $.ajax({

  url : path + "/updateFestival.adfe",
  type : "post",

  data : {
   festival_id : id,
    
   name : $('#inputName').val(),
   address : $('#inputAddress').val(),
   latitude : $('#inputLatitude').val(),
   longitude : $('#inputLongitude').val(),
   image_url : $('#inputImgAddress').val(),
   description : $('#inputDescription').val(),
   start_date : $('#inputStartDate').val(),
   end_date : $('#inputEndDate').val(),
   
   priceFree : $('#priceFree').val(),
   stockFree : $('#stockFree').val(),
   ticketDescFreeDay : $('#ticketDescFreeDay').val(),
   
   priceOneDay : $('#priceOneDay').val(),
   stockOneDay : $('#stockOneDay').val(),
   ticketDescOneDay : $('#ticketDescOneDay').val(),
   
   priceTwoDay : $('#priceTwoDay').val(),
   stockTwoDay : $('#stockTwoDay').val(),
   ticketDescTwoDay : $('#ticketDescTwoDay').val(),
   
   priceAllDay : $('#priceAllDay').val(),
   stockAllDay : $('#stockAllDay').val(),
   ticketDescAllDay : $('#ticketDescAllDay').val()
  },

  success : function(res){
  	console.log("response:", res);
    alert("수정 완료");
    $('#modal_festival_modify').modal('hide');
    location.reload();
   	},

   error : function(){
    alert("수정 실패");
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
