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
    /* 1. 본문 영역 */
    .content-wrapper { 
        background-color: #F6F6F6 !important; 
        min-height: calc(100vh - 120px) !important; /* 푸터 높이 고려 */
        padding-bottom: 20px !important;
    }
    
    /* 2. 카드 스타일 */
    .card { 
        border: none; 
        box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); 
        border-radius: 12px; 
    }
    
    .form-label { font-weight: 600; color: #444; font-size: 0.9rem; }
    .form-control, .form-select { border-radius: 8px !important; border: 1px solid #dee2e6; padding: 0.65rem; }
    .form-control:focus, .form-select:focus { border-color: #01D281; box-shadow: 0 0 0 0.2rem rgba(1, 210, 129, 0.1); }
    
    /* 버튼 스타일 */
    .btn-submit { 
        background-color: #01D281 !important; color: white; border-radius: 8px; 
        padding: 12px 40px; border: none; font-weight: 600; transition: 0.3s;
    }
    .btn-submit:hover { background-color: #01b06c !important; transform: translateY(-1px); }
    .btn-cancel { 
        background-color: #6c757d !important; color: white; border-radius: 8px; 
        padding: 12px 40px; border: none; transition: 0.3s;
    }
    .btn-cancel:hover { background-color: #5a6268 !important; }

    /* 3. 푸터 스타일 (목록 페이지와 동일하게) */
    .main-footer {
        margin-top: 0 !important;
        padding: 25px 0 !important;
        border-top: 1px solid #dee2e6 !important;
        background-color: #fff !important;
        text-align: center !important;
        font-size: 0.95rem;
    }
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
                        <div class="col-sm-6 text-end">
                            <ol class="breadcrumb float-sm-right d-inline-flex bg-transparent p-0 m-0">
                                <li class="breadcrumb-item"><a href="${path}/admin/home">Home</a></li>
                                <li class="breadcrumb-item"><a href="${path}/restaurant.ad">맛집 목록</a></li>
                                <li class="breadcrumb-item active text-dark">신규 등록</li>
                            </ol>
                        </div>
                    </div>
                </div>
            </section>

            <section class="content">
                <div class="container-fluid">
                    <div class="card shadow-sm mx-2">
                        <div class="card-header py-4 bg-white border-bottom-0">
                            <h4 class="card-title fw-bold m-0">
                                <span style="border-left:5px solid #01D281; padding-left:15px;">새로운 맛집 등록</span>
                            </h4>
                        </div>
                        
                        <form action="${path}/restaurantInsertAction.ad" method="post" enctype="multipart/form-data" name="insertForm">
                            <input type="hidden" name="areaCode" value="${param.areaCode}">
                            <input type="hidden" name="pageNum" value="${param.pageNum}">
                            
                            <div class="card-body px-5 pb-5">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <label class="form-label">맛집 이름</label>
                                        <input type="text" name="pdName" class="form-control" placeholder="가게명을 입력하세요" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">지역 선택</label>
                                        <select name="areaCodeSelect" class="form-select" onchange="document.getElementsByName('areaCode')[0].value=this.value">
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
                                        <label class="form-label">주소</label>
                                        <div class="input-group mb-2">
                                            <input type="text" id="address" name="address" class="form-control bg-light" placeholder="주소 검색 버튼을 이용해 주세요" readonly required>
                                            <button type="button" class="btn btn-dark px-4" onclick="execPostcode()">주소 검색</button>
                                        </div>
                                        <input type="text" id="address_detail" name="address_detail" class="form-control" placeholder="상세 주소를 입력하세요">
                                    </div>
                                    
                                    <input type="hidden" id="latitude" name="latitude">
                                    <input type="hidden" id="longitude" name="longitude">

                                    <div class="col-md-6">
                                        <label class="form-label">전화번호</label>
                                        <input type="text" name="phone" class="form-control" placeholder="02-1234-5678">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">카테고리</label>
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
                                        <label class="form-label">영업시간</label>
                                        <input type="text" name="opentime" class="form-control" placeholder="09:00 ~ 22:00">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">휴무일</label>
                                        <input type="text" name="restdate" class="form-control" placeholder="매주 일요일 휴무">
                                    </div>

                                    <div class="col-md-12">
                                        <label class="form-label">대표 이미지</label>
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
        
        <footer class="main-footer">
            <strong>Copyright &copy; 2026 </strong> All rights reserved.
        </footer>
    </div>

<script>
    const geocoder = new kakao.maps.services.Geocoder();

    function execPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                const addr = data.address;
                document.getElementById("address").value = addr;
                geocoder.addressSearch(addr, function(results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        const result = results[0];
                        document.getElementById("latitude").value = result.y;
                        document.getElementById("longitude").value = result.x;
                    }
                });
            }
        }).open();
    }
</script>
</body>
</html>