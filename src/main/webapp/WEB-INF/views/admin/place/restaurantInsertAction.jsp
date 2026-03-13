<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %> <%-- 목록 페이지와 동일하게 adminSetting 적용 --%>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛집 정보 등록</title>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bc41a35c5a5b0162c873953a6d550c47&libraries=services"></script>

<style>
    /* 1. 본문 영역: 배경색 유지 및 푸터 밀착 조절 */
    .content-wrapper { 
        background-color: #F6F6F6 !important; 
        /* 화면 전체를 채우되 푸터 높이만큼 제외하여 공백 방지 */
        min-height: calc(100vh - 60px) !important; 
        padding-bottom: 0 !important;
    }
    
    /* 2. 카드 스타일: 하단 마진 제거하여 푸터와 연결 */
    .card { 
        border: none; 
        box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); 
        border-radius: 12px; 
        margin-bottom: 0 !important; 
    }
    
    .form-label { font-weight: 600; color: #495057; font-size: 0.9rem; }
    .form-control, .form-select { border-radius: 8px !important; border: 1px solid #dee2e6; padding: 0.6rem; }
    
    /* 버튼 스타일 */
    .btn-submit { 
        background-color: #01D281 !important; 
        color: white; 
        border-radius: 8px; 
        padding: 10px 30px; 
        border: none; 
        font-weight: 600; 
    }
    .btn-submit:hover { background-color: #01b06c !important; }
    .btn-cancel { 
        background-color: #adb5bd !important; 
        color: white; 
        border-radius: 8px; 
        padding: 10px 30px; 
        border: none; 
    }

    /* 3. 푸터 강제 밀착 */
    .main-footer {
        margin-top: 0 !important;
        padding: 15px 20px !important;
        border-top: 1px solid #dee2e6 !important;
        background-color: #fff !important;
    }

    /* 카드 하단 버튼 영역 패딩 조정 */
    .card-footer {
        padding-top: 10px !important;
        padding-bottom: 30px !important;
        background-color: #fff !important;
    }
</style>
<c:if test="${insertCnt == 1}">
	<script type="text/javascript">
		setTimeout(function(){
			alert("맛집등록 성공!!");
			window.location="${path}/restaurant.ad?pageNum=${pageNum}&areaCode=${areaCode}";
		},1000);
	</script>
</c:if>
<c:if test="${insertCnt != 1}">
	<script type="text/javascript">
		setTimeout(function(){
			alert("맛집등록 실패!!");
			window.location="${path}/restaurantInsert.ad?pageNum=${pageNum}&areaCode=${areaCode}";
		},1000);
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
                                <li class="breadcrumb-item active">신규 등록</li>
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
                                <span style="border-left:5px solid #01D281; padding-left:10px;">새로운 맛집 등록</span>
                            </h3>
                        </div>
                        
                        <form action="${path}/restaurantInsertAction.ad" method="post" enctype="multipart/form-data" name="insertForm">
                        	<input type="hidden" name="areaCode" value="${param.areaCode}">
    						<input type="hidden" name="pageNum" value="${param.pageNum}">
                            <div class="card-body p-4">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <label class="form-label">맛집 이름</label>
                                        <input type="text" name="pdName" class="form-control" placeholder="가게명을 입력하세요" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">지역 선택</label>
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

                                    <div class="col-md-6">
                                        <label class="form-label">전화번호</label>
                                        <input type="text" name="phone" class="form-control" placeholder="02-000-0000">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">음식점 카테고리</label>
                                        <select name="category" id="category_code" class="form-select" required>
                                            <option value="">-- 카테고리를 선택하세요 --</option>
                                            <option value="한식">한식</option>
                                            <option value="양식">양식</option>
                                            <option value="일식">일식</option>
                                            <option value="중식">중식</option>
                                            <option value="카페">카페/찻집</option>
                                        </select>
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
                                        <label class="form-label">대표 이미지</label>
                                        <input type="file" name="pdImg" class="form-control bg-light shadow-none" accept="image/*" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-footer bg-white border-top-0 py-4 text-center">
                                <button type="submit" class="btn-submit shadow-sm me-2">등록하기</button>
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
    // 주소 검색 및 좌표 변환 (기존 로직 유지)
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