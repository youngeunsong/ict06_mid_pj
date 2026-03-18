<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>숙소 정보 등록</title>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bc41a35c5a5b0162c873953a6d550c47&libraries=services"></script>
<link rel="stylesheet"
	href="${path}/resources/css/admin/ad_accommodationInsert.css">
<c:choose>
    <c:when test="${insertCnt == 1}">
        <script type="text/javascript">
            setTimeout(function(){
                alert("맛집등록 성공!!");
                <%-- 키워드 유무에 따라 서블릿 주소 결정 --%>
                <c:if test="${not empty keyword}">
                    window.location="${path}/accommodationSearch.acc?pageNum=${pageNum}&areaCode=${areaCode}&category=${category}&keyword=${keyword}";
                </c:if>
                <c:if test="${empty keyword}">
                    window.location="${path}/accommodation.acc?pageNum=${pageNum}&areaCode=${areaCode}&category=${category}";
                </c:if>
            }, 1000);
        </script>
    </c:when>
    
    <c:otherwise>
        <script type="text/javascript">
            setTimeout(function(){
                alert("맛집등록 실패!!");
                <%-- 실패 시 다시 등록 폼으로 돌아갈 때도 검색어 유지 --%>
                window.location="${path}/accommodationInsert.acc?pageNum=${pageNum}&areaCode=${areaCode}&category=${category}&keyword=${keyword}";
            }, 1000);
        </script>
    </c:otherwise>
</c:choose>
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
                                <span style="border-left:5px solid #01D281; padding-left:15px;">새로운 숙소 등록</span>
                            </h4>
                        </div>
                        
                        <form action="${path}/accommodationInsertAction.acc" method="post" enctype="multipart/form-data" name="insertForm">
                            <input type="hidden" name="areaCode1" id="areaCodeHidden" value="${param.areaCode}">
                            <input type="hidden" name="pageNum" value="${param.pageNum}">
                            <input type="hidden" name="category1" value="${param.category}">
                            <input type="hidden" name="keyword" value="${param.keyword}">
                            
                            <div class="card-body px-5 pb-5">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <label class="form-label">숙소 이름 *</label>
                                        <input type="text" name="pdName" class="form-control" placeholder="숙소명을 입력하세요" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">지역 선택 *</label>
                                        <select id="areaCodeSelect" class="form-select"name="areaCode" required>
                                        	<option value="">지역을 선택해주세요</option>
                                            <option value="1">서울</option>
									        <option value="31">경기</option>
									        <option value="2">인천</option>
									        <option value="6">부산</option>
									        <option value="4">대구</option>
									        <option value="3">대전</option>
									        <option value="5">광주</option>
									        <option value="7">울산</option>
									        <option value="39">제주</option>
                                        </select>
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label">주소 *</label>
                                        <div class="input-group mb-2">
                                            <input type="text" id="address" name="address" class="form-control bg-light" placeholder="주소 검색을 이용해주세요" readonly required>
                                            <button type="button" class="btn btn-dark px-4" onclick="execPostcode()">주소 검색</button>
                                        </div>
                                        <input type="text" id="address_detail" name="address_detail" class="form-control" placeholder="상세 주소를 입력하세요~~~" required>
                                    </div>
                                    <input type="hidden" id="latitude" name="latitude" required>
                                    <input type="hidden" id="longitude" name="longitude" required>
                                    <div class="col-md-6">
                                        <label class="form-label">전화번호</label>
                                        <input type="text" name="phone" class="form-control" placeholder="ex) 02-1234-5678">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">카테고리 *</label>
                                        <select name="category" class="form-select" required>
                                            <option value="">-- 카테고리 선택 --</option>
                                            <option value="B02010100">일반호텔</option>
                                            <option value="B02011100">호스텔</option>
                                            <option value="B02010700">펜션</option>
                                            <option value="B02011200">서비스드레지던스</option>
                                            <option value="B02011600">한옥스테이</option>
                                            <option value="B02010900">홈스테이</option>
                                            <option value="B02011400">휴양펜션</option>
                                            <option value="B02011000">유스호스텔</option>
                                            <option value="B02010600">가족호텔</option>
                                            <option value="B02010500">한국전통호텔</option>
                                            <option value="B02010300">수상관광호텔</option>
                                        </select>
                                    </div>
                                    
                                    <div class="col-md-12">
                                        <label class="form-label">상세 소개</label>
                                        <textarea name="pdContent" class="form-control" rows="4" placeholder="숙소를 상세히 소개해주세요"></textarea>
                                    </div>
                                    
                                    <div class="col-md-6">
									    <label class="form-label">가격</label>
									    <input type="text" name="price" class="form-control" placeholder="ex) 50000원~~~~">
									</div>

                                    <div class="col-md-12">
                                        <label class="form-label">대표 이미지 *</label>
                                        <input type="file" name="pdImg" class="form-control bg-light" accept="image/*" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-footer bg-white border-top-0 py-5 text-center">
                                <button type="submit" class="btn-submit me-3">등록하기</button>
                                <button type="button" class="btn-cancel" onclick="history.back()">돌아가기</button>
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