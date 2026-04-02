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
<title>FAQ 마스터 관리</title>

<style>
    /* 버튼 및 태그 스타일 */
    .tag {
        display: inline-block;
        padding: 6px 14px;
        border: 1px solid #dee2e6 !important;
        border-radius: 4px !important;
        background-color: #ffffff;
        color: #007bff !important;
        text-decoration: none !important;
        font-size: 0.85rem;
        transition: all 0.2s;
        cursor: pointer;
    }
    .tag.active {
        background-color: #01D281 !important;
        color: #ffffff !important;
        border-color: #01D281 !important;
    }

    /* 답변 로우: 보이지 않도록 설정 */
    .answer-row { display: none !important; }
    /* open 클래스가 붙었을 때만 테이블 로우로 표시 */
    .answer-row.open { display: table-row !important; }
    
    .answer-box {
        background-color: #f9f9f9;
        padding: 20px;
        border-radius: 8px;
        margin: 10px;
        border: 1px inset #eee;
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
		    <div class="container-fluid d-flex justify-content-between align-items-center">
		        <h3 class="mb-0 font-weight-bold">FAQ 마스터 관리</h3>
		        
		        <button class="btn btn-success rounded-pill px-4 shadow-sm" 
		                style="background-color: #01D281; border-color: #01D281; font-weight: 500;"
		                onclick="location.href='adFaqWrite.adsp'">
		            <i class="bi bi-plus-lg mr-1"></i> 신규 FAQ 등록
		        </button>
		    </div>
		</div>
        
        <section class="app-content">
            <div class="container-fluid">
                
                <%-- 필터/검색 영역 (좌측 검색, 우측 필터) --%>
                <div class="filter-box mb-4 p-4 bg-white shadow-sm rounded border">
                    <div class="d-flex justify-content-between align-items-start w-100">
                        
                        <%-- 검색 영역 (왼쪽 상단 배치) --%>
                        <div class="search-area">
                            <div class="input-group" style="width: 320px;">
                                <input type="text" id="faqSearch" class="form-control" 
                                       value="${keyword}" placeholder="질문 또는 키워드 검색"
                                       onkeydown="if(event.keyCode==13) { goSearch(); }">
                                <div class="input-group-append">
                                    <button class="btn btn-outline-secondary" type="button" onclick="goSearch()">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
						<%-- 필터 컨트롤 박스 (오른쪽 상단 배치) --%>
                        <div class="filter-controls-wrapper shadow-none" 
                             style="border: 1px solid #e9ecef; padding: 20px; border-radius: 10px; background-color: #fcfcfc; min-width: 600px;">
                            <div class="d-flex flex-column" style="gap:15px;">
                                <%-- 카테고리 필터 라인 --%>
                                <div class="filter-row d-flex align-items-center justify-content-end">
                                    <span style="margin-right: 20px; font-weight:bold; font-size: 0.95rem; color: #333;">카테고리</span>
                                    <div class="d-flex flex-wrap gap-2">
                                        <a href="adFaqList.adsp?category=&visible=${visible}&keyword=${keyword}" class="tag ${empty category ? 'active' : ''}">전체</a>
                                        <a href="adFaqList.adsp?category=장소/정보&visible=${visible}&keyword=${keyword}" class="tag ${category == '장소/정보' ? 'active' : ''}">장소/정보</a>
                                        <a href="adFaqList.adsp?category=예약/결제&visible=${visible}&keyword=${keyword}" class="tag ${category == '예약/결제' ? 'active' : ''}">예약/결제</a>
                                        <a href="adFaqList.adsp?category=회원/포인트&visible=${visible}&keyword=${keyword}" class="tag ${category == '회원/포인트' ? 'active' : ''}">회원/포인트</a>
                                        <a href="adFaqList.adsp?category=리뷰/커뮤니티&visible=${visible}&keyword=${keyword}" class="tag ${category == '리뷰/커뮤니티' ? 'active' : ''}">리뷰/커뮤니티</a>
                                        <a href="adFaqList.adsp?category=이벤트/공지&visible=${visible}&keyword=${keyword}" class="tag ${category == '이벤트/공지' ? 'active' : ''}">이벤트/공지</a>
                                        <a href="adFaqList.adsp?category=기타&visible=${visible}&keyword=${keyword}" class="tag ${category == '기타' ? 'active' : ''}">기타</a>
                                    </div>
                                </div>
                                <%-- 노출상태 필터 라인 --%>
                                <div class="filter-row d-flex align-items-center justify-content-end">
                                    <span style="margin-right: 20px; font-weight:bold; font-size: 0.95rem; color: #333;">노출상태</span>
                                    <div class="d-flex gap-2">
                                        <a href="adFaqList.adsp?visible=&category=${category}&keyword=${keyword}" class="tag ${empty visible ? 'active' : ''}">전체</a>
                                        <a href="adFaqList.adsp?visible=Y&category=${category}&keyword=${keyword}" class="tag ${visible == 'Y' ? 'active' : ''}">노출중</a>
                                        <a href="adFaqList.adsp?visible=N&category=${category}&keyword=${keyword}" class="tag ${visible == 'N' ? 'active' : ''}">숨김</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- FAQ 리스트 테이블 --%>
                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle m-0" id="faqTable">
                            <thead class="thead-light">
                                <tr class="text-center">
                                    <th style="width:70px;">번호</th>
                                    <th style="width:120px;">카테고리</th>
                                    <th>질문 (클릭 시 답변 확인)</th>
                                    <th style="width:80px;">순서</th>
                                    <th style="width:100px;">노출</th>
                                    <th style="width:120px;">관리</th>
                                </tr>
                            </thead>
                            <tbody id="faqBody">
                                <c:forEach var="dto" items="${list}">
                                    <tr class="faq-row" style="cursor:pointer;" onclick="toggleAnswer(this)">
                                        <td class="text-center text-muted">${dto.faq_id}</td>
                                        <td class="text-center"><span class="badge badge-outline-secondary">${dto.category}</span></td>
                                        <td class="faq-question font-weight-bold"><i class="bi bi-question-circle mr-2 text-success"></i>${dto.question}</td>
                                        <td class="text-center">${dto.order_no}</td>
                                        <td class="text-center">
                                            <span class="badge-status" style="background-color: ${dto.visible == 'Y' ? '#01D281' : '#adb5bd'}; color:white; padding: 4px 8px; border-radius: 4px; font-size: 0.8rem;">
                                                ${dto.visible == 'Y' ? '노출중' : '숨김'}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" onclick="event.stopPropagation();">
                                                <button class="btn btn-sm btn-outline-primary" onclick="location.href='adFaqUpdate.adsp?faq_id=${dto.faq_id}'"><i class="bi bi-pencil-square"></i></button>
                                                <button class="btn btn-sm btn-outline-danger" onclick="deleteFaq(${dto.faq_id})"><i class="bi bi-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                    <%-- [중요] open 클래스 없이 렌더링하여 기본 숨김 처리 --%>
                                    <tr class="answer-row">
                                        <td colspan="6">
                                            <div class="answer-box">
                                                <div class="mb-2"><strong style="color: #01D281;"><i class="bi bi-check-circle-fill mr-1"></i> 답변 내용</strong></div>
                                                <div class="text-dark" style="line-height: 1.6;">${dto.answer}</div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
        <!-- ================= FOOTER ================= -->
        <footer class="main-footer"><strong>Copyright &copy; 2026</strong></footer>
        <!-- 관련 SQL 시작 -->
		<div align="center">SQL 쿼리 : 1:1 문의 상세 조회</div>
		
			<!-- 작성 요령 : 몇몇 특수문자를 화면에 제대로 출력하기 위해 아래와 같이 사용 필요-->
			<!-- #${'{'} : #과 { 표시 -->
			<!-- &lt; : < 표시 -->
			<!-- &gt; : > 표시 -->
			<div>
				<pre><code>
				SELECT * FROM FAQ 
				&lt;where&gt;
				    &lt;if test="category != null and category != ''"&gt;
				        AND category = #${'{'}category}
				    &lt;/if&gt;
				    &lt;if test="keyword != null and keyword != ''"&gt;
				        AND (question LIKE '%' || #${'{'}keyword} || '%' 
				        OR answer LIKE '%' || #${'{'}keyword} || '%')
				    &lt;/if&gt;
				&lt;/where&gt;
				ORDER BY order_no ASC					
				</code></pre>
			</div>
		<!-- 관련 SQL 끝 -->
    </div>
</div>

<script type="text/javascript">
	// JS 파일에서 사용할 수 있게 전역 변수로 선언
	const currCat = "${category}"; 
	const currVis = "${visible}";
	const currPath = "${path}";
</script>
<script src="${path}/resources/js/admin/adFaqList.js"></script>
</body>
</html>