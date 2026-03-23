<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %> <%-- 관리자용 세팅으로 통일 --%>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛집 정보 수정</title>
<link rel="stylesheet"
	href="${path}/resources/css/admin/ad_restaurantModify.css">
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bc41a35c5a5b0162c873953a6d550c47&libraries=services"></script>

<c:if test="${updateCnt == 1}">
    <script type="text/javascript">
        setTimeout(function(){
            alert("맛집 수정 성공!!");
            
            <%-- 키워드가 있을 때는 restaurantSearch.ad로, 없을 때는 restaurant.ad로 분기 --%>
            <c:choose>
                <c:when test="${not empty keyword}">
                    window.location="${path}/restaurantSearch.ad?pageNum=${hiddenPageNum}&areaCode=${areaCode1}&category=${category1}&keyword=${keyword}";
                </c:when>
                <c:otherwise>
                    window.location="${path}/restaurant.ad?pageNum=${hiddenPageNum}&areaCode=${areaCode1}&category=${category1}";
                </c:otherwise>
            </c:choose>
        }, 1000);
    </script>
</c:if>

<c:if test="${updateCnt != 1}">
    <script type="text/javascript">
        setTimeout(function(){
            alert("맛집수정 실패!!");
            <%-- 실패 시 다시 수정 폼으로 돌아갈 때도 파라미터 유지 --%>
            window.location="${path}/restaurantModify.ad?place_id=${pDto.place_id}&pageNum=${hiddenPageNum}&areaCode=${areaCode1}&category=${category1}&keyword=${keyword}";
        }, 1000);
    </script>
</c:if>

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
                            <input type="hidden" name="areaCode" value="${areaCode}">
                            
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
                                        <label class="form-label">맛집 유형</label>
                                        <input type="text" class="form-control" value="맛집" readonly>
                                        <input type="hidden" name="place_type" value="REST">
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">지역 선택</label>
                                        <select name="areaCode" id="areaCodeSelect" class="form-select" required onchange="updateAddressGuide()">
									        <option value="" ${empty (dto.areaCode or param.areaCode) ? 'selected' : ''}>지역을 선택하세요</option>
									        <option value="1" ${(areaCode == '1' or param.areaCode == '1') ? 'selected' : ''}>서울</option>
									        <option value="31" ${(areaCode == '31' or param.areaCode == '31') ? 'selected' : ''}>경기</option>
									        <option value="2" ${(areaCode == '2' or param.areaCode == '2') ? 'selected' : ''}>인천</option>
									        <option value="6" ${(areaCode == '6' or param.areaCode == '6') ? 'selected' : ''}>부산</option>
									        <option value="4" ${(areaCode == '4' or param.areaCode == '4') ? 'selected' : ''}>대구</option>
									        <option value="3" ${(areaCode == '3' or param.areaCode == '3') ? 'selected' : ''}>대전</option>
									        <option value="5" ${(areaCode == '5' or param.areaCode == '5') ? 'selected' : ''}>광주</option>
									        <option value="7" ${(areaCode == '7' or param.areaCode == '7') ? 'selected' : ''}>울산</option>
									        <option value="39" ${(areaCode == '39' or param.areaCode == '39') ? 'selected' : ''}>제주</option>
									    </select>
                                    </div>

                                    <div class="col-md-12">
                                        <label class="form-label">주소</label>
                                        <div class="input-group mb-2">
                                            <input type="text" id="address" name="address" class="form-control" value="${pDto.address}">
                                            <button type="button" class="btn btn-dark" onclick="execPostcode()">주소 재검색</button>
                                        </div>
                                        <input type="text" id="address_detail" name="address_detail" class="form-control" placeholder="상세 주소 (예: 건물 명, 층, 호수)"> 
                                        
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
                                            <option value="A05020100" ${rdto.category == 'A05020100' ? 'selected' : ''}>한식</option>
                                            <option value="A05020400" ${rdto.category == 'A05020400' ? 'selected' : ''}>양식</option>
                                            <option value="A05020300" ${rdto.category == 'A05020300' ? 'selected' : ''}>일식</option>
                                            <option value="A05020200" ${rdto.category == 'A05020200' ? 'selected' : ''}>중식</option>
                                            <option value="A05020600" ${rdto.category == 'A05020600' ? 'selected' : ''}>카페/찻집</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
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
var geocoder;
kakao.maps.load(function () {
    geocoder = new kakao.maps.services.Geocoder();
});

function execPostcode() {
    new daum.Postcode({
        oncomplete: function (data) {
            const addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
            document.getElementById("address").value = addr;

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