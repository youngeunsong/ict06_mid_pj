<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<fmt:setTimeZone value="Asia/Seoul"/>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>고객지원 FAQ상세</title>
<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>
<script>
    var contextPath = "${pageContext.request.contextPath}";
    var sessionUserId = "${sessionScope.sessionID}"; 
</script>
<script src="${pageContext.request.contextPath}/resources/js/support/faqMain.js" defer></script>
<style>
    body { background-color: #fafafa; color: #333; }
    /* [수정안] 모든 요소에 적용하되, 아이콘 전용 태그는 제외 */
	.container.my-5 *:not(i), 
	.inquiry-outer-container *:not(i),
	.sticky-search-wrap *:not(i),
	.content-card *:not(i) {
	    font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif !important;
	}
	
	/* Font Awesome 아이콘 폰트 강제 유지 */
	.fa, .fas, .far, .fab, .transition-icon {
	    font-family: "Font Awesome 5 Free" !important; /* 사용하시는 폰트어썸 버전에 맞춰 확인 */
	    font-weight: 900;
	}
    .category-sidebar { background: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .category-item { padding: 15px 20px; border-bottom: 1px solid #f1f1f1; cursor: pointer; transition: 0.2s; color: #555; text-decoration: none; display: block; }
    .category-item:last-child { border-bottom: none; }
    .category-item:hover { background-color: #f9fbf9; color: #3CB371; }
    .category-item.active { font-weight: bold; color: #3CB371; border-left: 4px solid #3CB371; }
    
    .content-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); min-height: 500px; }
    .faq-q-section { background-color: #f8fbf8; border-radius: 8px; padding: 25px; margin-bottom: 20px; }
    .faq-a-section { padding: 10px 25px; line-height: 1.8; color: #666; }
    
    /* 목록 스타일 */
    .faq-list-item { padding: 18px 25px; border-bottom: 1px solid #f1f1f1; transition: 0.2s; }
    .faq-list-item:hover { background-color: #fcfcfc; }
    .faq-list-item a { text-decoration: none; color: #333; display: flex; justify-content: space-between; }
    .faq-list-item:hover a { color: #3CB371; }
    
    /* 상세페이지 내 버튼들도 '맛침내 그린'으로 통일 */
.btn-success {
    background-color: #3CB371 !important;
    border-color: #3CB371 !important;
}
.btn-outline-success {
    color: #3CB371 !important;
    border-color: #3CB371 !important;
}
.btn-outline-success:hover {
    background-color: #3CB371 !important;
    color: #fff !important;
}
</style>
</head>
<body>
    <%@ include file="../../common/header.jsp" %>
    <c:set var="isMainPage" value="false" scope="request" />
	<jsp:include page="../faq/faqSearchHeader.jsp" />

    <div class="container my-5">
        <div class="row">
            <div class="col-lg-3 mb-4">
                <div class="category-sidebar">
                    <div class="p-4 border-bottom">
                        <h5 class="fw-bold mb-0">자주 묻는 질문</h5>
                    </div>
                    <a href="faqDetail.sp" class="category-item ${empty param.category ? 'active' : ''}">전체</a>
                    <a href="faqDetail.sp?category=장소/정보" class="category-item ${param.category == '장소/정보' ? 'active' : ''}">장소/정보</a>
                    <a href="faqDetail.sp?category=예약/결제" class="category-item ${param.category == '예약/결제' ? 'active' : ''}">예약/결제</a>
                    <a href="faqDetail.sp?category=회원/포인트" class="category-item ${param.category == '회원/포인트' ? 'active' : ''}">회원/포인트</a>
                    <a href="faqDetail.sp?category=리뷰/커뮤니티" class="category-item ${param.category == '리뷰/커뮤니티' ? 'active' : ''}">리뷰/커뮤니티</a>
                    <a href="faqDetail.sp?category=이벤트/공지" class="category-item ${param.category == '이벤트/공지' ? 'active' : ''}">이벤트/공지</a>
                    <a href="faqDetail.sp?category=기타" class="category-item ${param.category == '기타' ? 'active' : ''}">기타</a>
                </div>
                
                <div class="mt-4 p-4 bg-light rounded-3 text-center border">
				    <p class="small text-muted mb-2">도움이 필요하신가요?</p>
				    <h5 class="fw-bold text-success mb-2">1544-2222</h5>
				    <div class="mb-3">
				        <p class="text-muted mb-0" style="font-size: 0.75rem; letter-spacing: -0.5px;">
				            평일 09:00 ~ 18:00
				        </p>
				        <p class="text-secondary" style="font-size: 0.7rem;">
				            (토/일/공휴일 휴무)
				        </p>
				    </div>
				    <a href="${pageContext.request.contextPath}/inquiryWrite.sp" 
				       class="btn btn-outline-success btn-sm w-100 rounded-pill fw-bold py-2 shadow-sm"
				       onclick="return confirmExit();">
				        1:1 문의하기
				    </a>
				</div>
            </div>

           <div class="col-lg-9">
			    <div class="content-card p-4">
			        <div id="faqListArea" style="display: none;"></div> 
			        
			        <c:choose>
			            <%-- 상세보기 모드 (viewMode == 'DETAIL') --%>
			            <c:when test="${viewMode == 'DETAIL'}">
			                <div id="detailViewSection">
			                    <nav aria-label="breadcrumb" class="mb-4">
			                        <ol class="breadcrumb small">
			                            <li class="breadcrumb-item text-muted">홈</li>
			                            <li class="breadcrumb-item text-muted">자주 묻는 질문</li>
			                            <li class="breadcrumb-item active text-success" aria-current="page">상세보기</li>
			                        </ol>
			                    </nav>
			
			                    <div class="faq-q-section">
			                        <div class="d-flex align-items-start">
			                            <span class="badge bg-success me-3 mt-1">Q</span>
			                            <h4 class="fw-bold mb-0">${faqDetail.question}</h4>
			                        </div>
			                        <div class="mt-3 text-muted small">
			                            <i class="fa-regular fa-eye me-1"></i> 조회수 ${faqDetail.view_count} 
			                            <span class="mx-2">|</span> 
			                            카테고리: ${faqDetail.category}
			                        </div>
			                    </div>
			
			                    <div class="faq-a-section">
			                        <div class="d-flex">
			                            <strong class="text-danger me-3">A.</strong>
			                            <div>${faqDetail.answer}</div>
			                        </div>
			                    </div>
			
			                    <div class="text-center mt-5 border-top pt-4">
			                        <a href="javascript:history.back();" class="btn btn-light px-4 me-2">이전으로</a>
			                        <a href="${pageContext.request.contextPath}/faqMain.sp" class="btn btn-success px-4">목록으로 돌아가기</a>
			                    </div>
			                </div> </c:when>
			
			            <%-- 목록 보기 모드 (그 외 모든 경우) --%>
			            <c:otherwise>
			                <div class="faq-list-container">
			                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
			                        <h4 class="fw-bold mb-0">
			                            <c:out value="${empty param.category ? '전체 질문' : param.category}" />
			                        </h4>
			                        <span class="text-muted small">총 ${faqList.size()}건</span>
			                    </div>
			
			                    <c:if test="${empty faqList}">
			                        <div class="text-center py-5 text-muted">등록된 자주 묻는 질문이 없습니다.</div>
			                    </c:if>
			                    
			                    <c:forEach var="faq" items="${faqList}">
			                        <div class="faq-list-item">
			                            <a href="faqDetail.sp?faq_id=${faq.faq_id}&category=${faq.category}">
			                                <span>
			                                    <span class="text-success fw-bold me-2">Q.</span>
			                                    ${faq.question}
			                                </span>
			                                <i class="fa-solid fa-chevron-right text-muted"></i>
			                            </a>
			                        </div>
			                    </c:forEach>
			                </div>
			            </c:otherwise>
			        </c:choose>
			    </div>
			</div>
        </div>
    </div>

    <%@ include file="../../common/footer.jsp" %>
</body>
</html>