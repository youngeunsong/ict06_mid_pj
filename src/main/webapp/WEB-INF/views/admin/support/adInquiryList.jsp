<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<fmt:setTimeZone value="Asia/Seoul"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">
<meta charset="UTF-8">
<title>1:1 문의 관리</title>
<style>  
    .tag.active { background-color: #01D281; color: white; border-color: #01D281; }
    .table-hover tbody tr:hover { background-color: #f1fff9; }
    .text-truncate-custom { max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
	.badge-info { background-color: #007bff; color: white; } /* 답변중 파란색 */
	.badge-success, .badge-outline-secondary { background-color: #01D281; color: white; } /* 답변완료 초록색 */
	.badge-warning { background-color: #ffc107; color: #212529; } /* 대기중 노란색 */
    
    /* 화살표 뒤집기 (공통 pagination.jsp) */
    .pagination .page-item:first-child .bi-chevron-right {
        display: inline-block;
        transform: rotate(180deg);
    }

    /* 페이징 영역 정렬 스타일 */
    .pagination {
        justify-content: flex-end; /* 버튼들을 오른쪽으로 밀기 */
    }
    
   	/* 불편사항 강조 스타일 추가 */
	.urgent-row {
	    background-color: #fff5f5 !important; /* 아주 연한 빨간 배경 */
	}
	.urgent-row:hover {
	    background-color: #ffebeb !important; /* 호버 시 약간 더 진하게 */
	}
	.text-danger-strong {
	    color: #dc3545 !important; /* 진한 빨간색 */
	    font-weight: 800 !important;
	}
	.badge-danger-custom {
	    background-color: #dc3545;
	    color: white;
	    padding: 3px 8px;
	    border-radius: 4px;
	    font-size: 0.75rem;
	}
</style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">
	<!-- Preloader -->
    <div class="preloader flex-column justify-content-center align-items-center">
       <img src="${path}/resources/admin/dist/img/AdminLTELogo.png" height="60" width="60">
    </div>
	<!-- ================= HEADER ================= -->
    <%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>
    <!-- ================= SIDEBAR ================= -->
    <%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

	<!-- ================= CONTENT ================= -->
	<!--begin::content 헤더-->
    <div class="content-wrapper">
        <div class="app-content-header py-3">
            <div class="container-fluid">
                <h3 class="mb-0 font-weight-bold">1:1 문의 관리</h3>
            </div>
        </div>
        
        <section class="app-content">
            <div class="container-fluid">
				<%-- 필터 박스 시작 --%>
				<div class="filter-box mb-3 p-3 bg-white shadow-sm rounded border">
				    <div class="d-flex justify-content-between align-items-start w-100">
				        
				        <div class="search-area" style="align-self: flex-start; padding-top: 5px;">
				            <div class="input-group input-group-sm" style="width:280px;">
				                <input type="text" id="keyword" name="keyword" class="form-control" 
				                       placeholder="아이디 또는 제목 검색" value="${keyword}"
				                       onkeyup="if(window.event.keyCode==13){goSearch()}">
				                <div class="input-group-append">
				                    <button class="btn btn-outline-secondary" type="button" onclick="goSearch()">
				                        <i class="bi bi-search"></i>
				                    </button>
				                </div>
				            </div>
				        </div>
				
				        <div class="filter-controls-wrapper" style="border: 1px solid #eee; padding: 15px; border-radius: 8px; background-color: #fcfcfc;">
				            <div class="d-flex flex-column align-items-end" style="gap:12px;">
				                <div class="filter-row d-flex align-items-center">
				                    <span class="mr-3" style="font-weight:bold; font-size: 0.9rem; min-width: 60px;">카테고리</span>
				                    <div class="d-flex flex-wrap justify-content-end" style="gap:6px;">
				                        <a href="?category=&status=${status}&keyword=${keyword}" class="tag ${empty category ? 'active' : ''}">전체</a>
				                        <a href="?category=장소/정보&status=${status}&keyword=${keyword}" class="tag ${category == '장소/정보' ? 'active' : ''}">장소/정보</a>
				                        <a href="?category=예약/결제&status=${status}&keyword=${keyword}" class="tag ${category == '예약/결제' ? 'active' : ''}">예약/결제</a>
				                        <a href="?category=회원/포인트&status=${status}&keyword=${keyword}" class="tag ${category == '회원/포인트' ? 'active' : ''}">회원/포인트</a>
				                        <a href="?category=리뷰/커뮤니티&status=${status}&keyword=${keyword}" class="tag ${category == '리뷰/커뮤니티' ? 'active' : ''}">리뷰/커뮤니티</a>
				                        <a href="?category=이벤트/공지&status=${status}&keyword=${keyword}" class="tag ${category == '이벤트/공지' ? 'active' : ''}">이벤트/공지</a>
				                        <a href="?category=기타&status=${status}&keyword=${keyword}" class="tag ${category == '기타' ? 'active' : ''}">기타</a>
				                    </div>
				                </div>
				
				                <div class="filter-row d-flex align-items-center">
				                    <span class="mr-3" style="font-weight:bold; font-size: 0.9rem; min-width: 60px;">답변상태</span>
				                    <div class="d-flex justify-content-end" style="gap:6px;">
				                        <a href="?status=&category=${category}&keyword=${keyword}" class="tag ${empty status ? 'active' : ''}">전체</a>
				                        <a href="?status=PENDING&category=${category}&keyword=${keyword}" class="tag ${status == 'PENDING' ? 'active' : ''}">대기중</a>
				                        <a href="?status=PROGRESS&category=${category}&keyword=${keyword}" class="tag ${status == 'PROGRESS' ? 'active' : ''}" 
				                           style="${status == 'PROGRESS' ? 'background-color:#007bff; border-color:#007bff; color:white;' : ''}">답변중</a>
				                        <a href="?status=ANSWERED&category=${category}&keyword=${keyword}" class="tag ${status == 'ANSWERED' ? 'active' : ''}">답변완료</a>
				                    </div>
				                </div>
				            </div>
				        </div>
				    </div>
				</div>
				<%-- 필터 박스 끝 --%>
                <%-- 테이블 카드 --%>
                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle m-0">
                            <thead class="thead-light">
                                <tr>
                                    <th style="width:80px;">번호</th>
                                    <th style="width:100px;">카테고리</th>
                                    <th>제목</th>
                                    <th style="width:120px;">작성자</th>
                                    <th style="width:150px;">문의일</th>
                                    <th style="width:100px;">상태</th>
                                    <th style="width:80px;">관리</th>
                                </tr>
                            </thead>
                            <%-- 페이징부분 --%>
							<tbody>
						    <c:forEach var="dto" items="${list}">
						        <%-- 카테고리가 '불편사항'이면 urgent-row 클래스(빨간 배경)를 추가합니다 --%>
						        <tr onclick="location.href='${path}/adInquiryDetail.adsp?inquiry_id=${dto.inquiry_id}'" 
						            class="align-middle ${dto.category == '불편사항' ? 'urgent-row' : ''}" 
						            style="cursor:pointer;">
						            
						            <%-- 번호도 빨간색으로 강조 --%>
						            <td class="text-center ${dto.category == '불편사항' ? 'text-danger-strong' : ''}">${dto.inquiry_id}</td>
						            
						            <td class="text-center">
						                <c:choose>
						                    <c:when test="${dto.category == '불편사항'}">
						                        <span class="badge badge-danger-custom">🚨 불편사항</span>
						                    </c:when>
						                    <c:otherwise>
						                        <span class="badge badge-outline-secondary">${dto.category}</span>
						                    </c:otherwise>
						                </c:choose>
						            </td>
						            
						            <%-- 제목을 빨간색+굵게 강조 --%>
						            <td class="text-truncate-custom font-weight-bold ${dto.category == '불편사항' ? 'text-danger-strong' : ''}">
						                ${dto.title}
						            </td>
						            
						            <td class="text-center">${dto.user_id}</td>
						            <td class="text-center"><fmt:formatDate value="${dto.inquiryDate}" pattern="yyyy-MM-dd HH:mm"/></td>
						            
						            <td class="text-center">
						                <c:choose>
						                    <c:when test="${dto.status == 'ANSWERED'}">
						                        <span class="badge badge-success" style="background-color: #01D281;">답변완료</span>
						                    </c:when>
						                    <c:when test="${dto.status == 'PROGRESS'}">
						                        <span class="badge badge-info">답변중</span>
						                    </c:when>
						                    <c:otherwise>
						                        <span class="badge badge-warning">대기중</span>
						                    </c:otherwise>
						                </c:choose>
						            </td>
						            
						            <td class="text-center">
						                <%-- 불편사항이면 버튼도 빨간색으로 채워진 버튼 사용 --%>
						                <button class="btn btn-sm ${dto.category == '불편사항' ? 'btn-danger' : 'btn-outline-success'}">
						                    <i class="bi bi-chat-dots"></i>
						                </button>
						            </td>
						        </tr>
						    </c:forEach>    
						</tbody>
                        </table>
						<div class="card-footer bg-white border-0 py-3">
					        <div class="d-flex justify-content-between align-items-center">
					            <div>
					                <small class="text-muted">총 <strong style="color:#01D281;">${totalCount}</strong>건</small>
					            </div>
					
					            <nav aria-label="Page navigation">
					                <ul class="pagination pagination-sm m-0">
					                    <%@ include file="/WEB-INF/views/common/pagination.jsp" %>
					                </ul>
					            </nav>
					        </div>
					    </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <!-- ================= FOOTER ================= -->
    <footer class="main-footer">
    <strong>Copyright &copy; 2026</strong></footer>
</div>
<script type="text/javascript">

function goSearch() {
    // 1. 입력창에서 검색어 가져오기
    var keyword = document.getElementById("keyword").value;
    
    // 2. 현재 선택되어 있는 카테고리와 상태값 가져오기 (JSP 변수 활용)
    // 만약 필터가 선택되지 않았다면 빈 문자열이 들어갑니다.
    var category = "${category}"; 
    var status = "${status}";
    
    // 3. 주소 생성 (한글 검색어를 위해 encodeURIComponent 사용)
    var url = "adInquiryList.adsp?keyword=" + encodeURIComponent(keyword) 
              + "&category=" + encodeURIComponent(category) 
              + "&status=" + encodeURIComponent(status);
    
    // 4. 페이지 이동
    location.href = url;
}
    
    // 1. document(문서 전체)에 이벤트 리스너를 추가
    // 'DOMContentLoaded'는 HTML 문서가 브라우저에 의해 완전히 로드되고 해석되었을 때 발생
    // 엔터키를 눌렀을 때도 검색이 실행되게 하는 보너스 코드
    document.addEventListener('DOMContentLoaded', function() {
        
        // 2. id가 "keyword"인 요소(검색창 input 태그)를 찾아서 input 변수에 담는다
        var input = document.getElementById("keyword");
        
        // 3. 만약 화면에 keyword라는 id를 가진 입력창이 존재한다면
        if(input) {
            
            // 4. 그 입력창에 'keyup' 이벤트를 등록
            // keyup은 사용자가 키보드를 눌렀다가 뗄 떄 발생하는 이벤트
            input.addEventListener("keyup", function(event) {
                
                // 5. 방금 사용자가 누른 키의 번호(keyCode)가 13번인지 확인
                // 키보드의 'Enter' 키는 고유 번호가 13번
                if (event.keyCode === 13) {
                    
                    // 6. 브라우저의 기본 동작(폼 제출 등)이 혹시나 방해하지 않도록 막는다
                    event.preventDefault();
                    
                    // 7. 위에 검색 함수인 goSearch()를 실행
                    // 결과적으로 엔터를 치면 마우스로 돋보기를 누른 것과 똑같은 효과
                    goSearch();
                }
            });
        }
    });
</script>
</body>
</html>