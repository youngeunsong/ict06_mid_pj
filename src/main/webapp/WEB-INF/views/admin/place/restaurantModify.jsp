<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %> <%-- 관리자용 세팅으로 통일 --%>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛집 정보 수정</title>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bc41a35c5a5b0162c873953a6d550c47&libraries=services"></script>

<style>
    /* AdminLTE 3 표준 배경색 및 레이아웃 유지 */
    .content-wrapper { 
        background-color: #F6F6F6 !important; 
        /* 화면 전체를 강제로 채우지 않고 콘텐츠 양에 맞게 조절 */
        min-height: calc(100vh - 150px) !important; 
        padding-bottom: 20px !important;
    }
    
    .card { 
        border: none; 
        box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); 
        border-radius: 12px;
        margin-bottom: 0 !important; /* 카드 아래 여백 제거 */
    }

    .form-label { font-weight: 600; color: #495057; font-size: 0.9rem; }

    /* 읽기 전용 필드 스타일 */
    .form-control:read-only { 
        background-color: #f8f9fa !important;
        cursor: not-allowed; 
        color: #333333 !important;
    }

    /* 버튼 및 하단 푸터 간격 조정 */
    .card-footer {
        background-color: white !important;
        border-top: none !important;
        padding-top: 10px !important;
        padding-bottom: 30px !important; /* 버튼 아래 적당한 여백 */
    }

    /* 버튼 스타일 */
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
    
    /* 관리자 푸터 스타일 미세 조정 */
    .main-footer {
        margin-top: 0 !important;
        /* 위아래 패딩을 30px로 늘려 푸터의 폭을 크게 확보합니다 */
        padding: 30px 0 !important; 
        border-top: 1px solid #dee2e6 !important;
        background-color: #fff !important;
        display: block !important;
        text-align: center !important;
        /* 폰트 크기를 키워 존재감을 줍니다 */
        font-size: 1rem; 
        color: #333; /* 글자색을 조금 더 진하게 조정 */
        letter-spacing: 1px; /* 글자 간격을 넓혀 고급스럽게 설정 */
    }
    .img-preview { max-width: 200px; border-radius: 8px; margin-top: 10px; border: 1px solid #ddd; }
</style>

<script>
window.addEventListener('DOMContentLoaded', function() {
    var fullAddr = document.getElementById("address").value; // "서울특별시 ... - 305동..."
    
    if (fullAddr.indexOf(" - ") !== -1) {
        // 정확히 " - "라는 문자열을 기준으로 딱 두 덩어리로만 나눕니다.
        var parts = fullAddr.split(" - ");
        
        var mainAddr = parts[0]; // 서울특별시 노원구 화랑로 608 (공릉동)
        var detailAddr = parts[1]; // 305동101호
        
        // 각각의 칸에 다시 배분
        document.getElementById("address").value = mainAddr;
        document.getElementById("address_detail").value = detailAddr;
    }
});
</script>

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
                            <input type="hidden" name="oldImg" value="${pdto.image_url}">
                            <input type="hidden" name="pageNum" value="${pageNum}">
                            
                            <div class="card-body p-4">
                                <div class="row g-4">
                                    <div class="col-md-4">
                                        <label class="form-label">장소 번호</label>
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
                                        <select name="areaCode" id="areaCodeSelect" class="form-select" required>
                                            <option value="1" ${rdto.areaCode == '1' ? 'selected' : ''}>서울</option>
                                            <option value="2" ${rdto.areaCode == '2' ? 'selected' : ''}>인천</option>
                                            <option value="31" ${rdto.areaCode == '31' ? 'selected' : ''}>경기</option>
                                            <option value="4" ${rdto.areaCode == '4' ? 'selected' : ''}>대구</option>
                                            <option value="6" ${rdto.areaCode == '6' ? 'selected' : ''}>부산</option>
                                        </select>
                                    </div>

                                    <div class="col-md-12">
                                        <label class="form-label"></label>
                                        
                                        <%-- 주소를 " - " 기준으로 쪼개서 변수에 담기 --%>
									    <c:set var="fullAddr" value="${pdto.address}" />
									    <c:set var="addrArray" value="${fn:split(fullAddr, ' - ')}" />
									    
                                       <div class="col-md-12">
										    <label class="form-label">주소</label>
										    <div class="input-group mb-2">
										        <%-- 우선 전체 주소를 넣어둡니다 --%>
										        <input type="text" id="address" name="address" class="form-control" value="${pdto.address}">
										        <button type="button" class="btn btn-dark" onclick="execPostcode()">주소 재검색</button>
										    </div>
										    <%-- 상세 주소 칸 --%>
										    <input type="text" id="address_detail" name="address_detail" class="form-control" placeholder="상세 주소">
										    <%-- ★ 아래 hidden 필드들이 반드시 form 안에, 그리고 name 속성이 정확해야 합니다 ★ --%>
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
									    
									    <%-- 1. 데이터를 변수에 담기 --%>
									    <c:set var="opentimeValue" value="${rdto.opentime}" />
									    
									    <%-- 2. <br> 태그를 줄바꿈(\n)으로 치환 (개행 문자는 스크립트릿이나 별도 변수로 정의) --%>
									    <% pageContext.setAttribute("newline", "\n"); %>
									    <c:set var="convertedOpentime" value="${fn:replace(opentimeValue, '<br>', newline)}" />
									    <c:set var="convertedOpentime" value="${fn:replace(convertedOpentime, '<br/>', newline)}" />
									    <c:set var="convertedOpentime" value="${fn:replace(convertedOpentime, '<br />', newline)}" />
									
									    <%-- 3. 치환된 값을 textarea에 출력 --%>
									    <textarea name="opentime" class="form-control" rows="3">${convertedOpentime}</textarea>
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
// 1. 카카오 주소/좌표 서비스 로드 (전역)
var geocoder;
if (window.kakao && kakao.maps) {
    kakao.maps.load(function () {
        geocoder = new kakao.maps.services.Geocoder();
    });
}

// 2. 페이지 로드 완료 후 실행
window.addEventListener('DOMContentLoaded', function() {
    
    // [A] 기존 주소 데이터 분리 (메인 주소와 상세 주소 나누기)
    var addrInput = document.getElementById("address");
    var detailInput = document.getElementById("address_detail");
    
    if (addrInput && addrInput.value.indexOf(" - ") !== -1) {
        var parts = addrInput.value.split(" - ");
        addrInput.value = parts[0];  // 메인 주소
        if(detailInput) detailInput.value = parts[1]; // 상세 주소
    }

    // [B] 폼 전송 전 최종 유효성 검사
    var form = document.updateForm; 
    if (form) {
        form.onsubmit = function() {
            const addr = document.getElementById("address").value;
            const areaSelect = document.getElementById("areaCodeSelect");
            
            if (!areaSelect) return true; // 셀렉트 박스가 없으면 통과
            
            const selectedText = areaSelect.options[areaSelect.selectedIndex].text;

            // 주소에 선택한 지역명(서울, 인천 등)이 포함되어 있는지 확인
            if (!addr.includes(selectedText)) {
                alert("지역 선택과 입력된 주소가 일치하지 않습니다.\n현재 선택: [" + selectedText + "]\n입력된 주소: [" + addr + "]");
                return false; // 전송 중단
            }
            return true; // 일치하면 정상 전송
        };
    }
});

// 3. 주소 재검색 함수 (버튼 클릭 시 실행)
function execPostcode() {
    new daum.Postcode({
        oncomplete: function (data) {
            // 도로명 주소 또는 지번 주소 선택
            const addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
            document.getElementById("address").value = addr;
            
            // 주소 선택 후 상세주소 칸으로 포커스 이동
            document.getElementById("address_detail").focus();

            // 좌표 변환
            if (geocoder) {
                geocoder.addressSearch(addr, function (results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        const result = results[0];
                        document.getElementById("latitude").value = result.y;
                        document.getElementById("longitude").value = result.x;
                    }
                });
            }
        }
    }).open();
}
</script>
</body>
</html>