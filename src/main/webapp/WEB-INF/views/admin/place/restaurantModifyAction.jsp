<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<html>
<head>
<meta charset="UTF-8">
<title>맛집 정보 수정</title>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bc41a35c5a5b0162c873953a6d550c47&libraries=services"></script>
	<c:if test="${updateCnt == 1}">
		<script type="text/javascript">
			setTimeout(function(){
				alert("맛집수정 성공!!");
				window.location="${path}/restaurant.ad";
			},1000);
		</script>
	</c:if>
	
	<c:if test="${updateCnt != 1}">
		<script type="text/javascript">
			setTimeout(function(){
				alert("맛집수정 실패!!");
				window.location="${path}/restaurantModify.ad";
			},1000);
		</script>
	</c:if>
<style>
    /* 1. 전체 배경: 리스트 페이지와 동일한 연회색 */
    body { background-color: #F6F6F6 !important; }
    
    .card { border: none; box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); border-radius: 12px; }
    .form-label { font-weight: 600; color: #495057; font-size: 0.9rem; }

    /* 2. 번호, 유형, 주소창 설정 (글자색을 검은색으로 수정) */
    .form-control:read-only { 
        background-color: #ffffff !important; /* 배경은 영업시간창처럼 흰색 */
        cursor: not-allowed; 
        color: #333333 !important;    /* ★글자색을 검은색으로 변경해서 이제 잘 보입니다! */
    }

    /* 3. 수정완료 버튼: 리스트 페이지의 초록색 적용 */
    .btn-submit { 
        background-color: #01D281 !important; 
        color: white !important; 
        border-radius: 8px; 
        padding: 10px 30px; 
        border: none; 
        font-weight: 600; 
    }
    
    .btn-cancel { background-color: #adb5bd !important; color: white !important; border-radius: 8px; padding: 10px 30px; border: none; }
    .img-preview { max-width: 200px; border-radius: 8px; margin-top: 10px; border: 1px solid #ddd; }
</style>
</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
    <div class="app-wrapper">
        <%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
        
        <main class="app-main p-4">
            <div class="container-fluid">
                <div class="card shadow-sm">
                    <div class="card-header py-3">
                        <h3 class="card-title fw-bold m-0" style="color:#333;">
                            <span style="border-left:5px solid #01D281; padding-left:10px;">맛집 정보 수정</span>
                        </h3>
                    </div>
                    
                    <form action="${path}/restaurantModifyAction.ad" method="post" enctype="multipart/form-data" name="updateForm">
                        <input type="hidden" name="oldImg" value="${pdto.image_url}">
                        <input type="hidden" name="pageNum" value="${pageNum}">
                        
                        <div class="card-body p-4">
                            <div class="row g-4">
                                <div class="col-md-4">
                                    <label class="form-label">장소 번호 </label>
                                    <input type="text" name="place_id" class="form-control" value="${pdto.place_id}" readonly>
                                </div>

                                <div class="col-md-8">
                                    <label class="form-label">맛집 이름</label>
                                    <input type="text" name="pdName" class="form-control" value="${pdto.name}" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">장소 유형</label>
                                    <input type="text" class="form-control" value="맛집" readonly>
                                    <input type="hidden" name="place_type" value="REST">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">지역 선택</label>
                                    <select name="areaCode" class="form-select" required>
                                        <option value="1" ${rdto.areaCode == '1' ? 'selected' : ''}>서울</option>
                                        <option value="2" ${rdto.areaCode == '2' ? 'selected' : ''}>인천</option>
                                        <option value="31" ${rdto.areaCode == '31' ? 'selected' : ''}>경기</option>
                                        <option value="4" ${rdto.areaCode == '4' ? 'selected' : ''}>대구</option>
                                        <option value="6" ${rdto.areaCode == '6' ? 'selected' : ''}>부산</option>
                                    </select>
                                </div>

                                <div class="col-md-12">
								    <label class="form-label">주소</label>
								    <div class="input-group mb-2">
								        <input type="text" id="address" name="address" class="form-control" value="${pdto.address}">
								        <button type="button" class="btn btn-dark" onclick="execPostcode()">주소 재검색</button>
								    </div>
								    
								    <div class="mb-2">
								        <input type="text" id="address_detail" name="address_detail" class="form-control" placeholder="상세 주소 (예: 건물 명, 층, 호수)"> 
								                
								    </div>
								
								    <input type="hidden" id="latitude" name="latitude" value="${pdto.latitude}">
								    <input type="hidden" id="longitude" name="longitude" value="${pdto.longitude}">
								</div>

                                <div class="col-md-4">
                                    <label class="form-label">전화번호</label>
                                    <input type="text" name="phone" class="form-control" value="${rdto.phone}" placeholder="번호를 수정해주세요">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">음식점 카테고리</label>
                                    <select name="category" class="form-select" required>
                                        <option value="A05020100" ${rdto.category == 'A05020100' ? 'selected' : ''}>한식</option>
                                        <option value="A05020400" ${rdto.category == 'A05020400' ? 'selected' : ''}>양식</option>
                                        <option value="A05020300" ${rdto.category == 'A05020300' ? 'selected' : ''}>일식</option>
                                        <option value="A05020200" ${rdto.category == 'A05020200' ? 'selected' : ''}>중식</option>
                                        <option value="A05020600" ${rdto.category == 'A05020600' ? 'selected' : ''}>카페/찻집</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">주차 가능 여부</label>
                                    <input type="text" name="parking" class="form-control" value="${rdto.parking}">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">영업시간</label>
                                    <input type="text" name="opentime" class="form-control" value="${rdto.opentime}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">휴무일</label>
                                    <input type="text" name="restdate" class="form-control" value="${rdto.restdate}">
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label">상세 소개</label>
                                    <textarea name="pdContent" class="form-control" rows="4">${rdto.description}</textarea>
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label">대표 이미지 수정</label>
                                    <div class="mb-2">
                                        <p class="text-muted small mb-1">현재 등록된 이미지:</p>
                                        <img src="${pdto.image_url}" class="img-preview" id="currentImg">
                                    </div>
                                    <input type="file" name="pdImg" class="form-control bg-light" accept="image/*" onchange="previewImage">
                                    <p class="text-danger small mt-1">* 이미지를 변경할 경우에만 파일을 선택해 주세요.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card-footer bg-white border-0 py-4 text-center">
                            <button type="submit" class="btn-submit shadow-sm me-2">수정완료</button>
                            <button type="button" class="btn-cancel shadow-sm" onclick="history.back()">취소</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

<script>
var geocoder;

// 카카오 지도 API 로드 후 geocoder 생성
kakao.maps.load(function () {
    geocoder = new kakao.maps.services.Geocoder();
});

function execPostcode() {
    new daum.Postcode({
        oncomplete: function (data) {
            // 주소 선택
            const addr = data.userSelectedType === 'R'
                ? data.roadAddress
                : data.jibunAddress;
            // 주소 input에 넣기
            document.getElementById("address").value = addr;

            // 좌표 변환
            if (geocoder) {
                geocoder.addressSearch(addr, function (results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        const result = results[0];
                        document.getElementById("latitude").value = result.y;
                        document.getElementById("longitude").value = result.x;
                        console.log("좌표 추출 성공");
                        console.log("위도:", result.y);
                        console.log("경도:", result.x);
                    }
                });
            }
        }
    }).open();
}
</script>
<%@ include file="/WEB-INF/views/common/footer_script.jsp" %>
</body>
</html>