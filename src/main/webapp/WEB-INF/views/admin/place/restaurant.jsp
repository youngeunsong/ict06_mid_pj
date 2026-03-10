<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<style>
	body {
		background-color: #F6F6F6 !important;
	}
	.card {
		border: none;
		box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
	}
	.card-header {
		background-color: #ffffff;
		border-bottom: 1px solid #eeeeee;
	}
	.table td, .table th {
		padding: 1rem 0.5rem;
	}
	.table thead th {
		background-color: #ffffff;
		color: #333;
		font-weight: 600;
		border-bottom: 2px solid #dee2e6;
	}
	.table tbody td {
		font-size: 0.9rem;
		vertical-align: middle;
	}
	.table-hover tbody tr:hover {
		background-color: #fcfcfc !important;
	}
	
	/* 버튼설정 시작 */
	.btn-detail-custom {
		background-color: #495057 !important;
		color: #ffffff !important;
		border: none;
		transition: 0.3s;
	}
	.btn-detail-custom:hover {
		background-color: #01D281;
	}
	/* 버튼설정 끝 */
	
	.form-select, .form-control {
		border-radius: 8px !important;
	}
	.form-switch .form-check-input {
		width: 2.5em;
		height: 1.25em;
		cursor: pointer;
	}
	.form-switch .form-check-input:checked {
		background-color: #01D281 !important;
		border-color: #01D281 !important;
	}
	.input-group-sm .form-control {
		border-radius: 20px 0 0 20px;
		padding-left: 15px;
	}
	.input-group-sm .btn {
		border-radius: 0 20px 20px 0;
		padding-right: 15px;
	}
	
	/* 액션icon 시작 */
	.action-icon {
		color: #adb5bd;
		transition: 0.2s;
		font-size: 1.1rem;
		cursor: pointer;
		text-decoration: none !important;
	}
	.action-icon:hover {
		color: #01D281;
		transform: scale(1.15);
	}
	/* 액션icon 끝 */
	
	/* 배지 커스텀 시작 */
	.badge {
		padding: 5px 10px;
		font-weight: 600;
		border-radius: 4px;
	}
	.bg-res-success {
		background-color: #01D281 !important;
		color: white;
	}
	.bg-res-pending {
		background-color: #FEFBDA !important;
		color: #856404;
	}
	.bg-res-cancel {
		background-color: #FF6B6B !important;
		color: white !important;
	}
	.bg-res-secondary {
		background-color: #E9ECEF !important;
		color: #495057 !important;
	}
	/* 배지 커스텀 끝 */
	
	/* 페이징 시작 */
	.page-link {
		border-radius: 6px !important;
		margin: 0 3px;
		color: #666;
	}
	/* 페이징 끝 */

    /* 1. 감싸고 있는 footer 영역 제어 */
    .card-footer {
        display: block !important;
        text-align: center !important;
    }

    /* 2. pagination.jsp 내부의 d-flex justify-content-between 강제 무력화 */
    .card-footer .d-flex {
        display: flex !important;
        justify-content: center !important; /* 왼쪽/오른쪽 찢어지는 걸 중앙으로 강제 고정 */
        flex-direction: column !important;  /* 위아래 정렬로 변경 */
        align-items: center !important;
    }

    /* 3. Total entries 문구 숨기기 */
    .card-footer small.text-muted {
        display: none !important; /* 글자만 쏙 제거 */
    }

    /* 4. pagination 간격 조정 */
    .card-footer .pagination {
        margin: 0 auto !important;
        display: flex !important;
    }
</style>

<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="${path}/resources/js/admin/request.js"></script>

<script type="text/javascript">

		function handleFilterChange(areaCode) {
		    handleAreaChange(areaCode, "1"); // 필터 변경 시 무조건 1페이지부터 조회
		}
        /**
         * 2. 지역 선택 시 실행되는 메인 함수
         */
        function handleAreaChange(areaCode, pageNum) {
            // 서버 컨텍스트 경로에 맞춰 매핑 주소 설정
            var url = "${path}/restaurantArea.ad";
            var params = "areacode=" + areaCode + "&pageNum=" + pageNum;
            
            // request.js의 sendRequest(콜백함수, URL, 방식, 파라미터) 호출
            sendRequest(areaListCallback, url, "GET", params);
        }

        /**
         * 3. 서버로부터 응답이 왔을 때 실행될 콜백 함수
         */
        function areaListCallback() {
            // httpRequest는 request.js에 정의된 전역 객체입니다.
            if (httpRequest.readyState == 4) { // 전송 완료 상태
                if (httpRequest.status == 200) { // 정상 응답(OK)
                    // 서버가 보낸 JSON 문자열을 객체 배열로 변환
                    var response = JSON.parse(httpRequest.responseText);
                    updateTable(response.list, response.paging); // 테이블 갱신 함수 호출
                    updatePagination(response.paging, response.areacode);
                } else {
                    console.error("Ajax 오류 발생: " + httpRequest.status);
                }
            }
        }
        
        /** 5. 페이징 UI를 동적으로 생성하는 함수 (CSS 유지) */
        function updatePagination(paging, areacode) {
            // pagination.jsp가 포함된 영역을 찾습니다.
            var paginationArea = document.querySelector(".card-header.bg-white.py-3");
            if (!paginationArea || !paging) return;

            // 기존 UI 스타일을 유지하기 위한 HTML 생성
            var html = '<ul class="pagination justify-content-center m-0">';

            // [이전] 버튼
            if (paging.startPage > paging.pageBlock) {
                html += `<li class="page-item">
                            <a class="page-link" href="javascript:handleAreaChange('\${areacode}', \${paging.startPage - paging.pageBlock})">이전</a>
                         </li>`;
            }
            
         // 숫자 버튼
            for (var i = paging.startPage; i <= paging.endPage; i++) {
                var activeClass = (i == paging.currentPage) ? "active" : "";
                // active일 경우 부트스트랩 스타일이 적용되도록 합니다.
                var style = (i == paging.currentPage) ? 'style="background-color:#01D281; border-color:#01D281; color:white;"' : '';
                
                html += `<li class="page-item \${activeClass}">
                            <a class="page-link" \${style} href="javascript:handleAreaChange('\${areacode}', \${i})">\${i}</a>
                         </li>`;
            }

            // [다음] 버튼
            if (paging.endPage < paging.pageCount) {
                html += `<li class="page-item">
                            <a class="page-link" href="javascript:handleAreaChange('\${areacode}', \${paging.startPage + paging.pageBlock})">다음</a>
                         </li>`;
            }

            html += '</ul>';
            
            paginationArea.innerHTML = html;
        }

        /** 6. 페이지 번호 클릭 시 호출될 함수 (기존 handleAreaChange 확장) */
       /*  function handleAreaChange(areaCode, pageNum) {
            if (!pageNum) pageNum = "1"; // 기본값 1
            
            var url = "${path}/restaurantArea.ad";
            // 파라미터에 pageNum도 추가해서 보냅니다.
            var params = "areacode=" + areaCode + "&pageNum=" + pageNum;
            
            sendRequest(areaListCallback, url, "GET", params);
        } */

        /**
         * 4. 받은 데이터를 바탕으로 테이블 tbody만 갈아끼우는 함수
         */
         function updateTable(list, paging) {
        	    var tbody = document.getElementById("restaurant_list_body");
        	    if (!tbody) return;

        	    tbody.innerHTML = ""; 

        	    if (list.length === 0) {
        	        tbody.innerHTML = '<tr><td colspan="9" class="text-center">조회된 맛집 정보가 없습니다.</td></tr>';
        	        return;
        	    }

        	    list.forEach(function(dto) {
        	        var row = document.createElement("tr");
        	        
        	        // \${ } 문법을 사용하여 JSP가 아닌 브라우저에서 해석하도록 설정
        	        row.innerHTML = `
        	            <td class="text-center text-muted">\${dto.place_id}</td>
        	            <td class="text-center">맛집</td>
        	            <td class="text-center">\${dto.name}</td>
        	            <td class="text-center">\${dto.address}</td>
        	            <td class="text-center">\${dto.view_count}</td>
        	            <td class="text-center">
        	                <img src="\${dto.image_url}" alt="관광지 이미지" style="width: 100px; height: auto;">
        	            </td>
        	            <td class="text-center">\${dto.placeRegDate}</td>
        	            <td class="text-center">
        	                <button type="button" class="btn btn-sm btn-outline-secondary" 
        	                    onclick="location.href='${path}/restaurantModify.ad?place_id=\${dto.place_id}&pageNum=\${paging ? paging.currentPage : 1}'">수정</button>
        	            </td>
        	            <td class="text-center">
        	                <button type="button" class="btn btn-sm btn-outline-danger" onclick="if(confirm('삭제하시겠습니까?')) { location.href='#'; }">삭제</button>
        	            </td>
        	        `;
        	        tbody.appendChild(row);
        	    });
        	}
</script>
<title>맛집 관리 목록</title>
</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
	<div class="app-wrapper">
		<!--begin::Sidebar-->
		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>
		<!--end::Sidebar-->
		
		<main class="app-main">
			<div class="app-content-header">
				<div class="container-fluid">
					<div class="row">
						<div class="col-sm-6">
							<nav aria-label="breadcrumb">
								<ol class="breadcrumb m-0">
									<li class="breadcrumb-item"><a href="${path}/admin/home" class="text-decoration-none text-muted">Home</a></li>
									<li class="breadcrumb-item active" aria-current="page">맛집 목록</li>
								</ol>
							</nav>
						</div>
					</div>
				</div>
			</div>
	
		<div class="app-content">
			<div class="container-fluid">
				<div class="card shadow-sm border-0 mb-4">
				
						<div class="d-flex justify-content-between align-items-center">
							<div class="d-flex align-items-center gap-3">
								<h3 class="card-title fw-bold m-0" style="color:#333; min-width:150px;">
									<span style="border-left:5px solid #01D281; padding-left:10px;">맛집 목록</span>
								</h3>
								
								<button type="button" class="btn btn-sm fw-bold text-white" 
							            onclick="location.href='${path}/restaurantInsert.ad'"
							            style="background-color: #01D281; border-radius: 8px; padding: 5px 15px; border: none; font-size: 0.8rem;">
							        <i class="fas fa-plus-circle me-1"></i> 등록하기
							    </button>
								
								<select id="statusFilter" class="form-select form-select-sm border-light bg-light shadow-none" onchange="handleFilterChange(this.value)" style="width:130px;">
									<option value="">전체 목록</option>
								    <option value="1">서울</option>
								    <option value="2">인천</option>
								    <option value="31">경기</option>
								    <option value="32">강원</option>
								    <option value="3">대전</option>
								    <option value="4">대구</option>
								    <option value="5">광주</option>
								    <option value="6">부산</option>
								</select>
							</div>
							
							<div class="card-tools">
								<form action="${path}/restaurantArea.ad" method="get" class="input-group input-group-sm" style="width: 250px;">
									<input type="text" name="keyword" class="form-control border-0 bg-light shadow-none"
										style="border-radius: 8px 0 0 8px;"
										value="${param.keyword}" placeholder="맛집 이름">
									<button type="submit" class="btn text-white" style="background-color:#01D281; border-radius:0 8px 8px 0;">
										<i class="fas fa-search"></i>
									</button>
								</form>
							</div>
					</div>
					
						<table class="table table-hover align-middle m-0">
							<thead class="table-light">
								<tr>
									<th class="text-center" style="width:130px;">장소 번호</th>
									<th class="text-center">장소 유형</th>
									<th class="text-center">이름</th>
									<th class="text-center">주소</th>
									<th class="text-center">조회수</th>
									<th class="text-center">이미지</th>
									<th class="text-center" style="width: 120px;">등록날짜</th>
									<th class="text-center">수정</th>
									<th class="text-center">삭제</th>
								</tr>
							</thead>
							<tbody id="restaurant_list_body">
								<c:forEach var="dto" items="${list}">
									<tr>
										<td class="text-center text-muted">${dto.place_id}</td>
										<td class="text-center">맛집</td>
										<td class="text-center">${dto.name}</td>
										<td class="text-center">${dto.address}</td>
										<td class="text-center">${dto.view_count}</td>
										<td class="text-center">
										<img src="${dto.image_url}" style="width: 100px; height: auto;">	
										</td>
										<td class="text-center">${dto.placeRegDate}</td>
										<td class="text-center">
								            <button type="button" onclick="location.href='${path}/restaurantModify.ad?place_id=${dto.place_id}&pageNum=${paging.pageNum}'">수정</button>
								        </td>
								        <td class="text-center">
								            <button type="button" onclick="if(confirm('삭제하시겠습니까?')) { location.href='#'; }">삭제</button>
								        </td>
									</tr>
								</c:forEach>
								
								<c:if test="${empty list}">
									<tr>
										<td colspan="9">조회된 맛집 정보가 없습니다.</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
						<div class="card-header bg-white py-3">
						
						<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
						
						</div>
				</div>
			</div>
		</div>
	</main>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- 등록성공여부 확인 알림창 -->
<c:if test="${insertCnt == 1}">
	<script>
		alert("맛집이 등록되었습니다.")
	</script>
</c:if>
</body>
</html>