<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>맛집 관리</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">
<link rel="stylesheet"
	href="${path}/resources/css/admin/ad_restaurant.css">
</head>
<body class="hold-transition sidebar-mini layout-fixed">
    <div class="wrapper">
        <%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>
        <%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

        <div class="content-wrapper">
            <div class="app-content-header py-3">
                <div class="container-fluid">
                    <h3 class="mb-0 font-weight-bold">맛집 관리</h3>
                </div>
            </div>
            
            <section class="app-content">
                <div class="container-fluid">
                    <%-- 필터 영역 --%>
                    <div class="filter-box shadow-sm d-flex justify-content-between">
                        <div class="filter-left">
                            <div class="input-group input-group-sm" style="width:220px;">
                                <input type="text" id="keyword" name="keyword" class="form-control"
                                    placeholder="맛집명 또는 번호 입력"value="${keyword}">
                                <div class="input-group-append">
                                    <button class="btn btn-outline-secondary" type="button" onclick="searchRestaurant()">
                                     <i>검색</i>
                                     </button>
                                </div>
                            </div>
                        </div>

                        <div class="filter-right">
                            <div class="filter-row">
                                <span class="filter-row-label">지역</span>
                                <select id="areaCode" name="areaCode" class="filter-select">
							       
							        <!-- 검색어가 있고, 지역 선택이 없는 경우에만 표시 -->
						            <c:if test="${not empty keyword}">
						                <option value="" selected>검색중</option>
						            </c:if>
						             <option value="" ${empty param.areaCode and empty keyword ? 'selected' : ''}>전체 지역</option>
							        <option value="1" ${areaCode == '1' ? 'selected' : ''}>서울</option>
							        <option value="31" ${areaCode == '31' ? 'selected' : ''}>경기</option>
							        <option value="2" ${areaCode == '2' ? 'selected' : ''}>인천</option>
							        <option value="6" ${areaCode == '6' ? 'selected' : ''}>부산</option>
							        <option value="4" ${areaCode == '4' ? 'selected' : ''}>대구</option>
							        <option value="3" ${areaCode == '3' ? 'selected' : ''}>대전</option>
							        <option value="5" ${areaCode == '5' ? 'selected' : ''}>광주</option>
							        <option value="7" ${areaCode == '7' ? 'selected' : ''}>울산</option>
							        <option value="39" ${areaCode == '39' ? 'selected' : ''}>제주</option>
							    </select>
                            </div>
                            <div class="filter-row mt-1">
						        <span class="filter-row-label">맛집 유형</span>
						        <select id="category" name="category" class="filter-select">
						            
						            <c:if test="${not empty keyword}">
						                <option value="" selected>검색중</option>
						            </c:if>
						            <option value="" ${empty param.category and empty keyword ? 'selected' : ''}>전체 유형</option>
						            <option value="A05020100" ${category == 'A05020100' ? 'selected' : ''}>한식</option>
						            <option value="A05020200" ${category == 'A05020200' ? 'selected' : ''}>양식</option>
						            <option value="A05020300" ${category == 'A05020300' ? 'selected' : ''}>일식</option>
						            <option value="A05020400" ${category == 'A05020400' ? 'selected' : ''}>중식</option>
						            <option value="A05020500" ${category == 'A05020500' ? 'selected' : ''}>기타</option>
						            <option value="A05020600" ${category == 'A05020600' ? 'selected' : ''}>카페</option>
						            <option value="A05020700" ${category == 'A05020700' ? 'selected' : ''}>이색음식</option>
						            <option value="A05020900" ${category == 'A05020900' ? 'selected' : ''}>식음료</option>
								        
						        </select>
						    </div>
                            <div class="filter-row mt-1">
                                <button type="button" class="btn btn-search-dark" onclick="handleCombinedSearch()">
                                    <i class="bi bi-search mr-1"></i>검색
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <%-- 테이블 영역 --%>
                    <div class="card shadow-sm border-0">
                        <div class="card-body p-0">
                            <table class="table table-hover align-middle m-0">
                                <thead class="thead-light">
                                    <tr>
                                        <th class="col-num">번호</th>
                                        <th class="col-cat">맛집 유형</th>
                                        <th class="col-name">맛집명</th>
                                        <th class="col-addr">주소</th>
                                        <th style="width:70px;" class="text-center">조회수</th>
                                        <th style="width:110px;" class="text-center">이미지</th>
                                        <th style="width:110px;" class="text-center">등록일</th>
                                        <th style="width:130px;" class="text-center">관리</th>
                                    </tr>
                                </thead>
                                <tbody>
							    <c:choose>
							        <%-- 1. 결과가 있는 경우 --%>
							        <c:when test="${not empty list}">
							            <c:forEach var="dto" items="${list}">
							                <tr>
							                    <td class="text-muted col-num">${dto.place_id}</td>
							                    <td class="col-cat">
							                        <c:choose>
							                            <c:when test="${dto.category == 'A05020100'}"><span class="badge border text-success">한식</span></c:when>
							                            <c:when test="${dto.category == 'A05020200'}"><span class="badge border text-danger">양식</span></c:when>
							                            <c:when test="${dto.category == 'A05020300'}"><span class="badge border text-primary">일식</span></c:when>
							                            <c:when test="${dto.category == 'A05020400'}"><span class="badge border text-warning">중식</span></c:when>
							                            <c:when test="${dto.category == 'A05020500'}"><span class="badge border text-info">기타</span></c:when>
							                            <c:when test="${dto.category == 'A05020600'}"><span class="badge border text-dark">카페</span></c:when>
							                            <c:when test="${dto.category == 'A05020700'}"><span class="badge border text-secondary">이색음식</span></c:when>
							                            <c:when test="${dto.category == 'A05020900'}"><span class="badge border" style="color: #0077b6;">식음료</span></c:when>
							                        </c:choose>
							                    </td>
							                    <td class="fw-bold col-name">${dto.name}</td>
							                    <td class="col-addr text-truncate">${dto.address}</td>
							                    <td class="text-center">${dto.view_count}</td>
							                    <td class="text-center">
							                        <img src="${dto.image_url}" style="width:80px; height:50px; object-fit:cover; border-radius:4px;" onerror="this.src='${path}/resources/images/no-image.png'">
							                    </td>
							                    <td class="text-muted small text-center">${fn:substring(dto.placeUpdateDate, 0, 10)}</td>
							                    <td class="text-center">
							                        <button class="btn btn-xs btn-outline-secondary" onclick="location.href='${path}/restaurantModify.ad?place_id=${dto.place_id}&pageNum=${paging.pageNum}&areaCode=${areaCode}&category=${category}&keyword=${keyword}'">수정</button>
							                        <button class="btn btn-xs btn-outline-danger" onclick="if(confirm('삭제하시겠습니까?')) { location.href='${path}/restaurantDeleteAction.ad?place_id=${dto.place_id}&pageNum=${paging.pageNum}&areaCode=${param.areaCode}&category=${param.category}&keyword=${keyword}';}">삭제</button>
							                    </td>
							                </tr>
							            </c:forEach>
							        </c:when>
							
							        <%-- 2. 결과가 없는 경우 --%>
							        <c:otherwise>
							            <tr>
							                <td colspan="8" class="text-center py-5 text-muted">
							                    <i class="bi bi-exclamation-circle d-block mb-2" style="font-size: 2rem;"></i>
							                    조회된 결과가 없습니다.
							                </td>
							            </tr>
							        </c:otherwise>
							    </c:choose>
							</tbody>
                            </table>
                            
                            <div class="pagination-right-wrapper border-top">
                                <%@ include file="/WEB-INF/views/common/restaurant_pagination.jsp"%>
                            </div>
                            
                            <div class="add-btn-area">
                                <button type="button" class="btn btn-res-primary px-4 py-2"
                                        onclick="location.href='${path}/restaurantInsert.ad?areaCode=${areaCode}&pageNum=${paging.pageNum}&category=${category}&keyword=${keyword}'">
                                    새 맛집 추가
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <footer class="main-footer text-center py-3">
            <strong>Copyright &copy; 2026</strong>
        </footer>
    </div>
<script>
function handleCombinedSearch() {
    // 1. 엘리먼트가 있는지 확인하며 값을 가져옵니다.
    const areaCodeEl = document.getElementById("areaCode");
    const categoryEl = document.getElementById("category");
    const keywordEl = document.getElementById("keyword");
    
    // 2. 값이 있으면 가져오고, 없으면 빈 문자열 처리
    const areaCode = areaCodeEl ? areaCodeEl.value : "";
    const category = categoryEl ? categoryEl.value : "";
    const keyword = keywordEl ? keywordEl.value : "";
    
    // 3. 카테고리는 화면에서 뺐으므로 파라미터에서 제외하거나 빈 값 처리
    location.href = "${path}/restaurant.ad?areaCode=" + areaCode + 
    				"&category=" + category +
                    "&keyword=" + encodeURIComponent(keyword) + 
                    "&pageNum=1";
}

function searchRestaurant() {
    // 1. 입력창(input)의 ID가 'keyword'인 요소에서 값을 가져옵니다.
    const keywordElement = document.getElementById("keyword");
    const keyword = keywordElement ? keywordElement.value : "";
    
    const categoryElement = document.getElementById("category");
    const category = categoryElement ? categoryElement.value : "";
    // 2. 검색어가 비어있을 경우 유효성 검사 (선택 사항)
    if (!keyword.trim()) {
        alert("검색어를 입력해주세요.");
        keywordElement.focus();
        return;
    }

    // 3. 지역 코드는 현재 '0'으로 고정하여 이동
    // [수정] 세미콜론 위치를 조정하고 category를 끝에 붙인다.
    location.href = `${path}/restaurantSearch.ad?areaCode=0&keyword=` 
                    + encodeURIComponent(keyword) 
                    + `&pageNum=1`
                    + `&category=` + category; // 이제 URL에 category가 포함됩니다.
}
</script>
</body>
</html>