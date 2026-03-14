<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛집 정보 수정</title>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bc41a35c5a5b0162c873953a6d550c47&libraries=services"></script>

<style>
    .content-wrapper { 
        background-color: #F6F6F6 !important; 
        min-height: calc(100vh - 150px) !important; 
        padding-bottom: 20px !important;
    }
    
    .card { 
        border: none; 
        box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); 
        border-radius: 12px;
        margin-bottom: 0 !important;
    }

    .form-label { font-weight: 600; color: #495057; font-size: 0.9rem; }

    .form-control:read-only { 
        background-color: #f8f9fa !important;
        cursor: not-allowed; 
        color: #333333 !important;
    }

    .card-footer {
        background-color: white !important;
        border-top: none !important;
        padding-top: 10px !important;
        padding-bottom: 30px !important;
    }

    .btn-submit { 
        background-color: #01D281 !important; 
        color: white !important; 
        border-radius: 8px; 
        padding: 10px 30px; 
        border: none; 
        font-weight: 600; 
    }
    .btn-submit:hover { background-color: #01b06c !important; }
    
    .btn-cancel { 
        background-color: #adb5bd !important; 
        color: white !important; 
        border-radius: 8px; 
        padding: 10px 30px; 
        border: none; 
    }
    
    .main-footer {
        margin-top: 0 !important;
        padding: 30px 0 !important; 
        border-top: 1px solid #dee2e6 !important;
        background-color: #fff !important;
        display: block !important;
        text-align: center !important;
        font-size: 1rem; 
        color: #333; 
        letter-spacing: 1px;
    }
    .img-preview { max-width: 200px; border-radius: 8px; margin-top: 10px; border: 1px solid #ddd; }
</style>
</head>

<body class="hold-transition sidebar-mini layout-fixed">
    <div class="wrapper">
        <%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>
        <%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

        <div class="content-wrapper">
            <section class="app-content-header">
                <div class="container-fluid">
                    <div class="row mb-2 p-3">
                        <div class="col-sm-6">
                            <h1 class="m-0 fw-bold">맛집 관리</h1>
                        </div>
                        <div class="col-sm-6">
                            <ol class="breadcrumb float-sm-right">
                                <li class="breadcrumb-item"><a href="${path}/admin/home">Home</a></li>
                                <li class="breadcrumb-item"><a href="${path}/restaurant.ad">맛집 목록</a></li>
                                <li class="breadcrumb-item active">정보 수정</li>
                            </ol>
                        </div>
                    </div>
                </div>
            </section>

            <section class="content">
                <div class="container-fluid">
                    <div class="card shadow-sm mx-2">
                        <div class="card-header py-3 bg-white border-bottom-0">
                            <h3 class="card-title fw-bold m-0" style="color:#333;">
                                <span style="border-left:5px solid #01D281; padding-left:10px;">맛집 정보 수정</span>
                            </h3>
                        </div>
                        
                        <form action="${path}/restaurantModifyAction.ad" method="post" enctype="multipart/form-data" name="updateForm">
                            <input type="hidden" name="oldImg" value="${pDto.image_url}">
                            <input type="hidden" name="pageNum" value="${pageNum}">
                            
                            <div class="card-body p-4">
                                <div class="row g-4">
                                    <div class="col-md-4">
                                        <label class="form-label">장소 번호</label>
                                        <input type="text" name="place_id" class="form-control" value="${pDto.place_id}" readonly>
                                    </div>

                                    <div class="col-md-8">
                                        <label class="form-label">맛집 이름</label>
                                        <input type="text" name="pdName" class="form-control" value="${pDto.name}" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">장소 유형</label>
                                        <input type="text" class="form-control" value="맛집" readonly>
                                        <input type="hidden" name="place_type" value="REST">
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">지역 선택</label>
                                        <select name="areaCode" id="areaCodeSelect" class="form-select" required onchange="updateAddressGuide()">
									        <option value="" ${empty (dto.areaCode or param.areaCode) ? 'selected' : ''}>지역을 선택하세요</option>
									        <option value="1" ${(dto.areaCode == '1' or param.areaCode == '1') ? 'selected' : ''}>서울</option>
									        <option value="31" ${(dto.areaCode == '31' or param.areaCode == '31') ? 'selected' : ''}>경기</option>
									        <option value="2" ${(dto.areaCode == '2' or param.areaCode == '2') ? 'selected' : ''}>인천</option>
									        <option value="6" ${(dto.areaCode == '6' or param.areaCode == '6') ? 'selected' : ''}>부산</option>
									        <option value="4" ${(dto.areaCode == '4' or param.areaCode == '4') ? 'selected' : ''}>대구</option>
									        <option value="3" ${(dto.areaCode == '3' or param.areaCode == '3') ? 'selected' : ''}>대전</option>
									        <option value="5" ${(dto.areaCode == '5' or param.areaCode == '5') ? 'selected' : ''}>광주</option>
									        <option value="7" ${(dto.areaCode == '7' or param.areaCode == '7') ? 'selected' : ''}>울산</option>
									        <option value="39" ${(dto.areaCode == '39' or param.areaCode == '39') ? 'selected' : ''}>제주</option>
									    </select>
                                    </div>

                                    <div class="col-md-12">
                                        <label class="form-label">주소</label>
                                        <div class="input-group mb-2">
                                            <input type="text" id="address" name="address" class="form-control" value="${pDto.address}">
                                            <button type="button" class="btn btn-dark" onclick="execPostcode()">주소 검색</button>
                                        </div>
                                        <input type="text" id="address_detail" name="address_detail" class="form-control" placeholder="상세 주소">
                                        <input type="hidden" id="latitude" name="latitude" value="${pDto.latitude}">
                                        <input type="hidden" id="longitude" name="longitude" value="${pDto.longitude}">
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label">전화번호</label>
                                        <input type="text" name="phone" class="form-control" value="${rDto.phone}" placeholder="번호를 수정해주세요">
                                    </div>
                                    
                                    <div class="col-md-4">
                                        <label class="form-label">음식점 카테고리</label>
                                        <select name="category" class="form-select" required>
                                            <option value="A05020100" ${rDto.category == 'A05020100' ? 'selected' : ''}>한식</option>
                                            <option value="A05020400" ${rDto.category == 'A05020400' ? 'selected' : ''}>양식</option>
                                            <option value="A05020300" ${rDto.category == 'A05020300' ? 'selected' : ''}>일식</option>
                                            <option value="A05020200" ${rDto.category == 'A05020200' ? 'selected' : ''}>중식</option>
                                            <option value="A05020600" ${rDto.category == 'A05020600' ? 'selected' : ''}>카페/찻집</option>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label">휴무일</label>
                                        <input type="text" name="restdate" class="form-control" value="${rDto.restdate}">
                                    </div>

                                    <div class="col-md-12">
                                        <label class="form-label">상세 소개</label>
                                        <textarea name="pdContent" class="form-control" rows="4">${rDto.description}</textarea>
                                    </div>

                                    <div class="col-md-12">
                                        <label class="form-label">대표 이미지 수정</label>
                                        <div class="mb-2">
                                            <p class="text-muted small mb-1">현재 등록된 이미지:</p>
                                            <img src="${pDto.image_url}" class="img-preview" id="currentImg">
                                        </div>
                                        <input type="file" name="pdImg" class="form-control bg-light" accept="image/*">
                                        <p class="text-danger small mt-1">* 이미지를 변경할 경우에만 파일을 선택해 주세요.</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-footer bg-white border-top-0 py-4 text-center">
                                <button type="submit" class="btn-submit shadow-sm me-2">수정완료</button>
                                <button type="button" class="btn-cancel shadow-sm" onclick="history.back()">취소</button>
                            </div>
                        </form>
                    </div>
                </div>
            </section>
        </div>
        <footer class="main-footer">
            <strong>Copyright &copy; 2026</strong>
        </footer>
    </div>



<script>
var geocoder;

// 1. 카카오 지도 API 초기화 (SDK 로드 대기)
if (window.kakao && kakao.maps) {
    kakao.maps.load(function () {
        geocoder = new kakao.maps.services.Geocoder();
    });
}

// 2. 주소 검색 함수 (다음 우편번호 서비스)
function execPostcode() {
    new daum.Postcode({
        oncomplete: function (data) {
            // 도로명 주소와 지번 주소 중 선택한 값 가져오기
            let addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
            document.getElementById("address").value = addr;
            
            // 상세주소 입력칸 초기화 및 포커스
            const detailField = document.getElementById("address_detail");
            detailField.value = "";
            detailField.focus();

            // 주소로부터 좌표(위도, 경도) 추출
            if (geocoder) {
                geocoder.addressSearch(addr, function (results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        document.getElementById("latitude").value = results[0].y; // 위도
                        document.getElementById("longitude").value = results[0].x; // 경도
                    } else {
                        console.error("좌표를 불러오는 데 실패했습니다.");
                    }
                });
            }
        }
    }).open();
}

// 3. 폼 제출 시 유효성 검사
window.onload = function() {
    var form = document.updateForm;
    
    if (form) {
        form.onsubmit = function() {
            const areaSelect = document.getElementById("areaCodeSelect");
            const addr = document.getElementById("address").value;
            const lat = document.getElementById("latitude").value;
            
            // [검증 1] 지역 선택 여부
            if(!areaSelect.value) {
                alert("지역을 선택해주세요.");
                areaSelect.focus();
                return false;
            }

            // [검증 2] 지역 일치 여부 확인 (핵심)
            // <option>의 텍스트(서울, 경기 등)가 주소 문자열에 포함되어 있는지 체크
            const cityName = areaSelect.options[areaSelect.selectedIndex].text;
            if (addr.indexOf(cityName) === -1) {
                alert("선택하신 지역 [" + cityName + "]과 입력된 주소가 일치하지 않습니다.\n지역에 맞는 주소를 다시 검색해주세요.");
                return false;
            }

            // [검증 3] 좌표 데이터 확인
            if(!lat || lat === "" || lat === "0") {
                alert("좌표 정보가 생성되지 않았습니다. 주소 재검색을 진행해주세요.");
                return false;
            }
            
            return true; // 모든 검사 통과 시 제출
        };
    }
};

// 지역 변경 시 안내 (필요 시 로직 추가 가능)
function updateAddressGuide() {
    console.log("지역 코드가 변경되었습니다.");
}
</script>
</body>
</html>