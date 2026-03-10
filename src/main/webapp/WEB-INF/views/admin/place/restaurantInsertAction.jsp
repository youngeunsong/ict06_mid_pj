<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<html>
<head>
<meta charset="UTF-8">
<title>신규 맛집 등록</title>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bc41a35c5a5b0162c873953a6d550c47&libraries=services"></script>
<c:if test="${insertCnt == 1}">
	<script type="text/javascript">
		setTimeout(function(){
			alert("맛집등록 성공!!");
			window.location="${path}/restaurant.ad";
		},1000);
	</script>
</c:if>
<c:if test="${insertCnt != 1}">
	<script type="text/javascript">
		setTimeout(function(){
			alert("맛집등록 실패!!");
			window.location="${path}/restaurantInsert.ad";
		},1000);
	</script>
</c:if>
<style>
    /* 보내주신 스타일 시트 적용 */
    body { background-color: #F6F6F6 !important; }
    .card { border: none; box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); border-radius: 12px; }
    .form-label { font-weight: 600; color: #495057; font-size: 0.9rem; }
    .form-control, .form-select { border-radius: 8px !important; border: 1px solid #dee2e6; padding: 0.6rem; }
    .btn-submit { background-color: #01D281 !important; color: white; border-radius: 8px; padding: 10px 30px; border: none; font-weight: 600; }
    .btn-cancel { background-color: #adb5bd !important; color: white; border-radius: 8px; padding: 10px 30px; border: none; }
</style>
</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
    <div class="app-wrapper">
        <%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>
        
        <main class="app-main p-4">
            <div class="container-fluid">
                <div class="card shadow-sm">
                    <div class="card-header py-3">
                        <h3 class="card-title fw-bold m-0" style="color:#333;">
                            <span style="border-left:5px solid #01D281; padding-left:10px;">새로운 맛집 등록</span>
                        </h3>
                    </div>
                    
                    <form action="${path}/restaurantInsertAction.ad" method="post" enctype="multipart/form-data" name="insertForm">
                        <div class="card-body p-4">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label">맛집 이름 (pdName)</label>
                                    <input type="text" name="pdName" class="form-control" placeholder="가게명을 입력하세요" required>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">지역 선택 (areaCode)</label>
                                    <select name="areaCode" class="form-select" required>
                                        <option value="1">서울</option>
                                        <option value="2">인천</option>
                                        <option value="31">경기</option>
                                        <option value="4">대구</option>
                                        <option value="6">부산</option>
                                    </select>
                                </div>

                                <div class="col-md-12">
								    <label class="form-label">주소 (Address)</label>
								    <div class="input-group mb-2">
								        <input type="text" id="address" name="address" class="form-control" placeholder="주소 검색 버튼을 눌러주세요" readonly required>
								        <button type="button" class="btn btn-dark" onclick="execPostcode()">주소 검색</button>
								    </div>
								    
								    <input type="text" id="address_detail" name="address_detail" class="form-control" placeholder="상세 주소(건물명, 동/호수 등)를 입력하세요">
								</div>
								
								<input type="hidden" id="latitude" name="latitude">
								<input type="hidden" id="longitude" name="longitude">

                                <input type="hidden" id="latitude" name="latitude">
                                <input type="hidden" id="longitude" name="longitude">

                                <div class="col-md-4">
                                    <label class="form-label">전화번호</label>
                                    <input type="text" name="phone" class="form-control" placeholder="02-000-0000">
                                </div>
                                <div class="form-group">
								    <label for="category_code" class="fw-bold mb-2">음식점 카테고리</label>
								    <select name="category" id="category_code" class="form-control" required 
								            style="border-radius: 8px; border: 1px solid #ddd;">
								        <option value="">-- 카테고리를 선택하세요 --</option>
								        <option value="한식">한식</option>
								        <option value="양식">양식</option>
								        <option value="일식">일식</option>
								        <option value="중식">중식</option>
								        <option value="이색음식">이색음식</option>
								        <option value="카페">카페/찻집</option>
								        <option value="패스트푸드">패스트푸드</option>
								    </select>
								</div>
								
                                <div class="col-md-4">
                                    <label class="form-label">주차 가능 여부</label>
                                    <input type="text" name="parking" class="form-control" placeholder="예: 가능, 불가">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">영업시간</label>
                                    <input type="text" name="opentime" class="form-control" placeholder="예: 09:00 ~ 22:00">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">휴무일</label>
                                    <input type="text" name="restdate" class="form-control" placeholder="예: 매주 일요일">
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label">상세 소개</label>
                                    <textarea name="pdContent" class="form-control" rows="4" placeholder="맛집에 대한 상세 설명을 입력하세요"></textarea>
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label">대표 이미지</label>
                                    <input type="file" name="pdImg" class="form-control bg-light shadow-none" accept="image/*" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card-footer bg-white border-0 py-4 text-center">
                            <button type="submit" class="btn-submit shadow-sm me-2">등록하기</button>
                            <button type="button" class="btn-cancel shadow-sm" onclick="history.back()">취소</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

<script>
    // 1. 주소 검색 및 좌표 변환 로직
    const geocoder = new kakao.maps.services.Geocoder();

    function execPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                const addr = data.address; // 최종 주소 변수
                document.getElementById("address").value = addr;

                // 주소로 상세 좌표(위도, 경도) 찾기
                geocoder.addressSearch(addr, function(results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        const result = results[0];
                        document.getElementById("latitude").value = result.y;  // 위도
                        document.getElementById("longitude").value = result.x; // 경도
                        console.log("좌표 추출 성공:", result.y, result.x);
                    }
                });
            }
        }).open();
    }
</script>

<!-- <script>
    // 페이지 로드 시 실행
    window.onload = function() {
        // 컨트롤러에서 model.addAttribute("insertResult", result)로 보낸 값 확인
        var result = "${insertCnt}"; 
        
        if (result !== "") { // 결과값이 있을 때만 실행
            if (result == "1") {
                alert("✨ 맛집이 성공적으로 등록되었습니다!");
                // 등록 성공 후 맛집 목록 페이지로 이동 (실제 경로에 맞춰 수정하세요)
                location.href = "${path}/restaurant.ad"; 
            } else {
                alert("❌ 등록에 실패하였습니다. 입력 정보를 다시 확인해주세요.");
                // 실패 시에는 현재 페이지(입력 폼)에 유지됩니다.
            }
        }
    };

    // 폼 제출 전 최종 유효성 검사 (좌표 추출 확인)
    document.insertForm.onsubmit = function() {
    
    // [추가된 부분] 맛집 이름 입력 체크
    var pdNameInput = document.getElementsByName("pdName")[0]; // 맛집 이름 입력창 가져오기
    if (pdNameInput.value.trim() == "") {
        
        pdNameInput.focus(); // 안 적었으면 커서를 여기로 자동 이동(autofocus)
        return false;        // 서버로 전송 안 하고 중단!
    }

    // 2. 좌표 추출 확인 (기존 코드)
    var lat = document.getElementById("latitude").value;
    var lng = document.getElementById("longitude").value;
    
    if (!lat || !lng) {
        
        return false;
    }
    
    // 3. 이미지 첨부 확인 (기존 코드)
    var file = document.getElementsByName("pdImg")[0].value;
    if (!file) {
        
        return false;
    }
    
    return true; // 다 통과하면 그때서야 서버(Controller)로 출발!
};
</script> -->

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>