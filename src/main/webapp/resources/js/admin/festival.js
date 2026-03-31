/*
 * @author 송영은
 * 최초작성일: 26.03.10
 * 최종수정일: 26.03.30
 * 한 메서드 안에서 여러 개의 sql 쿼리가 반드시 순차적으로 일어나야 할 경우 @Transaction 추가 
 * 
 * 코드 변경사항
 * v260318: 
 *    	오픈 API로 받아온 정보를 DB에 추가하는 기능 구현 완료. 
 * 		기존 신규 축제 등록 방법 변경. 축제 이름, 주소, 시작일이 일치 시 중복 등록 안 되게 설정.  
 * v260330: 
 * 		다양한 티켓 유형 대응할 수 있게 수정. 
 * 		축제 수정 시 기존 티켓 유형 삭제 및 추가 가능하게 수정
 */

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
	        ticketHtml += '<td>' + (ticket.ticket_type === null ? '' : ticket.ticket_type) + '</td>';
	        ticketHtml += '<td>' + (ticket.price === null ? '' : ticket.price) + '</td>';
	        ticketHtml += '<td>' + (ticket.stock === null ? '' : ticket.stock) + '</td>';
	        ticketHtml += '<td>' + (ticket.description === null ? '' : ticket.description) + '</td>';
	        ticketHtml += '</tr>';

	    });

	    ticketHtml += '</tbody>';
	    ticketHtml += '</table>';

	    $('#ticketTableArea').html(ticketHtml);
	}

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
	    ticketHtml += '<th>삭제</th>';
	    ticketHtml += '</tr>';
	    ticketHtml += '</thead>';
	    ticketHtml += '<tbody>';

	    data.ticketList.forEach(function(ticket){

	        ticketHtml += '<tr class="ticketRow" data-id="' + ticket.ticket_id + '">';
	        ticketHtml += '<td><input type="text" class="ticket_type" value="' + ticket.ticket_type + '"></td>';
	        ticketHtml += '<td><input type="number" class="ticket_price" value="' + ticket.price + '"></td>';
	        ticketHtml += '<td><input type="number" class="ticket_stock" value="' + ticket.stock + '"></td>';
	        ticketHtml += '<td><textarea class="ticket_desc" cols="24" rows="2">' + (ticket.description || '') + '</textarea></td>';
	        
	        ticketHtml += '<td>';
			ticketHtml += '<button type="button" class="btn btn-danger btn-sm" onclick="removeTicketRow(this)">-</button>';
			ticketHtml += '</td>';

	        ticketHtml += '</tr>';

	    });

	    ticketHtml += '</tbody>';
	    ticketHtml += '</table>';

	    $('#ticketTable_edit').html(ticketHtml);
	}

   $('#modal_festival_modify').modal("show");
  }
 });
}

// 축제 수정 처리를 위한 티켓 데이터 받기 
function getTicketData(){

    var ticketList = [];

    $('#ticketTable_edit .ticketRow').each(function(){

        var ticket = {
        	ticket_id : $(this).data('id'), 
            ticket_type : $(this).find('.ticket_type').val(),
            price       : $(this).find('.ticket_price').val(),
            stock       : $(this).find('.ticket_stock').val(),
            description : $(this).find('.ticket_desc').val()
        };

        ticketList.push(ticket);
    });

    console.log(ticketList);

    return ticketList;
}

/* 축제 수정 : 행 추가 함수 */
function addTicketRow(){

    // =========================
    // 1. table이 없으면 생성
    // =========================
    if($('#ticketTable_edit table').length === 0){

        var tableHtml = '';

        tableHtml += '<table class="table">';
        tableHtml += '<thead>';
        tableHtml += '<tr>';
        tableHtml += '<th>티켓 종류</th>';
        tableHtml += '<th>가격</th>';
        tableHtml += '<th>재고</th>';
        tableHtml += '<th>설명</th>';
        tableHtml += '<th>';
        tableHtml += '<button type="button" class="btn btn-primary btn-sm" onclick="addTicketRow()">+</button>';
        tableHtml += '</th>';
        tableHtml += '</tr>';
        tableHtml += '</thead>';

        tableHtml += '<tbody></tbody>';
        tableHtml += '</table>';

        $('#ticketTable_edit').html(tableHtml);
    }


    // =========================
    // 2. 중복 ticket_type 체크
    // =========================
    var ticketTypes = [];

    $('#ticketTable_edit .ticket_type').each(function(){

        var type = $(this).val().trim();

        if(type !== ''){
            ticketTypes.push(type);
        }
    });


    // =========================
    // 3. ticket_type 입력
    // =========================
    var newType = prompt("추가할 티켓 종류를 입력하세요");

    if(newType == null || newType.trim() === ''){
        return;
    }

    newType = newType.trim();

    if(ticketTypes.includes(newType)){
        alert("이미 존재하는 티켓 종류입니다.");
        return;
    }


    // =========================
    // 4. row 생성
    // =========================
    var row = '';

    row += '<tr class="ticketRow">';

    row += '<td>';
    row += '<input type="text" class="ticket_type" value="'+ newType +'">';
    row += '<input type="hidden" class="ticket_id" value="0">';
    row += '</td>';

    row += '<td>';
    row += '<input type="number" class="ticket_price" value="0">';
    row += '</td>';

    row += '<td>';
    row += '<input type="number" class="ticket_stock" value="0">';
    row += '</td>';

    row += '<td>';
    row += '<textarea class="ticket_desc" rows="2"></textarea>';
    row += '</td>';

    row += '<td>';
    row += '<button type="button" class="btn btn-danger btn-sm" onclick="removeTicketRow(this)">-</button>';
    row += '</td>';

    row += '</tr>';


    // =========================
    // 5. tbody에 추가
    // =========================
    $('#ticketTable_edit tbody').append(row);
}

/* 행 추가 시 중복되는 티켓 유형 방지 */
function isDuplicateTicketType(){

    var ticketTypes = [];
    var duplicate = false;

    $('#ticketTable_edit .ticketRow').each(function(){

        var type = $(this).find('.ticket_type').val().trim();

        if(type === '') return;

        if(ticketTypes.includes(type)){

            alert("같은 티켓 종류가 존재합니다: " + type);
            duplicate = true;
            return false;
        }

        ticketTypes.push(type);
    });

    return duplicate;
}

/* 축제 수정 : 행 삭제 함수 */
function removeTicketRow(btn){

    var row = $(btn).closest('tr');

    if(confirm("이 티켓을 삭제하시겠습니까?")){
        row.remove();
    }
}

/* 축제 수정 처리 */ 
function updateFestival(id){

 if(isDuplicateTicketType()){
        return;
    }	

 var ticketList = getTicketData(); 	

 var festivalData = {
	    festival_id : id,

	    placeDTO : {
	    	name : $('#inputName').val(),
		    address : $('#inputAddress').val(),
		    latitude : $('#inputLatitude').val(),
		    longitude : $('#inputLongitude').val(),
		    image_url : $('#inputImgAddress').val(),
	    }, 
	    
	    description : $('#inputDescription').val(),
	    start_date : $('#inputStartDate').val(),
	    end_date : $('#inputEndDate').val(),

	    ticketList : ticketList
	};

 $.ajax({

  url : path + "/updateFestival.adfe",
  type : "post",
  contentType : "application/json", // JSON 타입으로 변경
  data : JSON.stringify(festivalData),	

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
