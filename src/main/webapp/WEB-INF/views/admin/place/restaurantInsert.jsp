<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛집 정보 등록</title>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bc41a35c5a5b0162c873953a6d550c47&libraries=services"></script>
<style>
    .content-wrapper { background-color: #F6F6F6 !important; min-height: calc(100vh - 120px) !important; padding-bottom: 20px !important; }
    .card { border: none; box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); border-radius: 12px; }
    .form-label { font-weight: 600; color: #444; font-size: 0.9rem; }
    .btn-submit { background-color: #01D281 !important; color: white; border-radius: 8px; padding: 12px 40px; border: none; font-weight: 600; transition: 0.3s; }
    .btn-cancel { background-color: #6c757d !important; color: white; border-radius: 8px; padding: 12px 40px; border: none; transition: 0.3s; }
</style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
    <div class="wrapper">
        <%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>
        <%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

        <div class="content-wrapper">
            <section class="content">
                <div class="container-fluid">
                    <div class="card shadow-sm mx-2 mt-4">
                        <div class="card-header py-4 bg-white border-bottom-0">
                            <h4 class="card-title fw-bold m-0">
                                <span style="border-left:5px solid #01D281; padding-left:15px;">새로운 맛집 등록</span>
                            </h4>
                        </div>
                        
                        <form action="${path}/restaurantInsertAction.ad" method="post" enctype="multipart/form-data" name="insertForm">
                            <input type="hidden" name="areaCode" id="areaCodeHidden" value="${param.areaCode}">
                            <input type="hidden" name="pageNum" value="${param.pageNum}">
                            
                            <div class="card-body px-5 pb-5">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <label class="form-label">맛집 이름 *</label>
                                        <input type="text" name="pdName" class="form-control" placeholder="가게명을 입력하세요" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">지역 선택 *</label>
                                        <select id="areaCodeSelect" class="form-select" required onchange="document.getElementById('areaCodeHidden').value=this.value">
                                            <option value="">-- 지역 선택 --</option>
                                            <option value="1" ${param.areaCode == '1' ? 'selected' : ''}>서울</option>
                                            <option value="2" ${param.areaCode == '2' ? 'selected' : ''}>인천</option>
                                            <option value="31" ${param.areaCode == '31' ? 'selected' : ''}>경기</option>
                                            <option value="32" ${param.areaCode == '32' ? 'selected' : ''}>강원</option>
                                            <option value="3" ${param.areaCode == '3' ? 'selected' : ''}>대전</option>
                                            <option value="4" ${param.areaCode == '4' ? 'selected' : ''}>대구</option>
                                            <option value="5" ${param.areaCode == '5' ? 'selected' : ''}>광주</option>
                                            <option value="6" ${param.areaCode == '6' ? 'selected' : ''}>부산</option>
                                        </select>
                                    </div>

                                    <div class="col-md-12">
                                        <label class="form-label">주소 *</label>
                                        <div class="input-group mb-2">
                                            <input type="text" id="address" name="address" class="form-control bg-light" placeholder="주소 검색을 이용해주세요" readonly required>
                                            <button type="button" class="btn btn-dark px-4" onclick="execPostcode()">주소 검색</button>
                                        </div>
                                        <input type="text" id="address_detail" name="address_detail" class="form-control" placeholder="상세 주소를 입력하세요 (동, 호수, 층 등)" required>
                                    </div>
                                    
                                    <input type="hidden" id="latitude" name="latitude" required>
                                    <input type="hidden" id="longitude" name="longitude" required>

                                    <div class="col-md-6">
                                        <label class="form-label">전화번호</label>
                                        <input type="text" name="phone" class="form-control" placeholder="02-1234-5678">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">카테고리 *</label>
                                        <select name="category" class="form-select" required>
                                            <option value="">-- 카테고리 선택 --</option>
                                            <option value="A05020100">한식</option>
                                            <option value="A05020200">양식</option>
                                            <option value="A05020300">일식</option>
                                            <option value="A05020400">중식</option>
                                            <option value="A05020600">카페/찻집</option>
                                        </select>
                                    </div>
                                    
                                    <div class="col-md-6">
									    <label class="form-label">휴무일</label>
									    <input type="text" name="off_day" class="form-control" placeholder="예: 매주 월요일, 연중무휴">
									</div>

                                    <div class="col-md-12">
                                        <label class="form-label">대표 이미지 *</label>
                                        <input type="file" name="pdImg" class="form-control bg-light" accept="image/*" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-footer bg-white border-top-0 py-5 text-center">
                                <button type="submit" class="btn-submit me-3">등록하기</button>
                                <button type="button" class="btn-cancel" onclick="location.href='${path}/restaurant.ad?areaCode=${param.areaCode}&pageNum=${param.pageNum}'">취소하기</button>
                            </div>
                        </form>
                    </div>
                </div>
            </section>
        </div>
    </div>

<script>
var geocoder;
if (window.kakao && kakao.maps) {
    kakao.maps.load(function () {
        geocoder = new kakao.maps.services.Geocoder();
    });
}

window.addEventListener('DOMContentLoaded', function() {
    var form = document.insertForm;
    if (form) {
        form.onsubmit = function() {
            const areaSelect = document.getElementById("areaCodeSelect");
            const addr = document.getElementById("address").value;
            const addrDetail = document.getElementById("address_detail").value.trim();
            const lat = document.getElementById("latitude").value;
            
            // 1. 기본 required 외 상세주소 빈칸(공백) 검사
            if(!addrDetail) {
                alert("상세 주소를 입력해주세요.");
                document.getElementById("address_detail").focus();
                return false;
            }

            // 2. 지역 일치 여부 정밀 검사
            const cityName = areaSelect.options[areaSelect.selectedIndex].text;
            if (!addr.includes(cityName)) {
                alert("선택하신 지역 [" + cityName + "]과 주소가 일치하지 않습니다.\n지역에 맞는 주소를 다시 검색해주세요.");
                return false;
            }

            // 3. 위도/경도 값 존재 여부 (지도 API 정상 작동 확인)
            if(!lat) {
                alert("좌표 정보가 없습니다. 주소를 다시 검색해주세요.");
                return false;
            }
            
            return true; 
        };
    }
});

function execPostcode() {
    const areaSelect = document.getElementById("areaCodeSelect");
    if(!areaSelect.value) {
        alert("지역을 먼저 선택한 후 주소 검색을 해주세요.");
        areaSelect.focus();
        return;
    }

    new daum.Postcode({
        oncomplete: function (data) {
            let addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
            document.getElementById("address").value = addr;
            
            // 주소 입력 시 상세주소로 포커스 이동
            document.getElementById("address_detail").focus();

            if (geocoder) {
                geocoder.addressSearch(addr, function (results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        document.getElementById("latitude").value = results[0].y;
                        document.getElementById("longitude").value = results[0].x;
                    }
                });
            }
        }
    }).open();
}
</script>
</body>
</html>