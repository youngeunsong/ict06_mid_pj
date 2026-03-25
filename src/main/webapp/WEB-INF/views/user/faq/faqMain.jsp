<!--  * 주요 기능:
 * 1. 카테고리별 필터링 (Ajax)
 * 2. 실시간 검색 및 엔터키 지원
 * 3. 아코디언 토글 (꿀렁임 방지 및 단일 개방 로직)
 * * @author 조민수
 * @since 2026-03-23 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<fmt:setTimeZone value="Asia/Seoul"/>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>고객센터 - FAQ</title>

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    var contextPath = "${pageContext.request.contextPath}";
    var sessionUserId = "${sessionScope.user_id}";
</script>
<script src="${pageContext.request.contextPath}/resources/js/support/faqMain.js" defer></script>

<style>
    /* [1] 전체적인 배경색과 가독성 좋은 폰트 */
    body {
        background-color: #fafafa; /* 완전 흰색보다 눈이 편안한 밝은 회색 */
        color: #333; /* 글자색은 너무 검지 않은 짙은 회색 */
        font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif; /* 트렌디한 Pretendard 폰트 사용 추천 (공통 설정에 없다면 추가) */
        overflow-x: hidden;
    }
    
    .input-group #keyword:focus {
        border-color: #3CB371; /* 포커스 시 '맛침내 그린' 색상 */
        box-shadow: 0 0 0 0.2rem rgba(60, 179, 113, 0.25); /* 은은함 */
    }
    
    .input-group .btn-primary:hover,
    .input-group .btn-primary:focus {
        background-color: #2e8b57; /* 호버 시 약간 짙은 초록 */
        border-color: #2e8b57;
    }

    /* [5] 카테고리 태그 스타일 */
    .tag {
        display: inline-block;
        padding: 9px 18px;
        border-radius: 50px;
        background-color: #fff;
        color: #666;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        border: 1px solid #e1e1e1;
        transition: all 0.3s ease;
    }
    .tag:hover {
        background-color: #f1f1f1;
        color: #333;
    }
    .tag.active {
        background-color: #3CB371; /* 활성화된 카테고리는 '맛침내 그린' */
        color: #fff;
        border-color: #3CB371;
        box-shadow: 0 4px 10px rgba(60, 179, 113, 0.3);
    }
    #selected-category-name {
        color: #3CB371; /* 선택된 카테고리 이름 색상 */
    }
    
    /* [6] FAQ 아코디언 스타일 */
    #faqListArea {
        background-color: #fff;
        border-radius: 12px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.05); /* 카드 전체에 은은한 그림자 */
        overflow: hidden; /* 테두리 둥글게 유지 */
    }
    .faq-item {
        border-bottom: 1px solid #f1f1f1;
    }
    .faq-question { 
        cursor: pointer; 
        transition: all 0.3s; 
        padding: 22px 25px !important; /* 여백 확대 */
    }
    .faq-question:hover { 
        background-color: #f9fbf9; /* 호버 시 아주 옅은 초록빛 회색 */
    }
    .faq-question div span:last-child {
        color: #2c3e50; /* 질문 텍스트 색상 차분하게 */
        font-size: 1.05rem;
    }
    .transition-icon {
        color: #bbb;
        font-size: 1.1rem;
    }

    /* [7] 인기 질문 Top 10 카드 스타일 */
    .card {
        border-radius: 12px;
        overflow: hidden;
    }
    .card-header {
        background-color: #f8fbf8; /* 아주 옅은 초록빛 배경 */
        padding: 18px 20px !important;
    }
    .card-header .card-title {
        color: #2e8b57; /* 짙은 초록색 */
    }
    .list-group-item-action {
        padding: 12px 20px !important;
    }
    .list-group-item-action:hover {
        background-color: #f9fbf9;
        color: #3CB371; /* 호버 시 초록색 포인트 */
    }
    .badge-view { 
        font-size: 0.75rem; 
        vertical-align: middle; 
    }
    .view-all-link:hover {
        color: #3CB371 !important; /* '맛침내 그린'으로 호버 색상 통일 */
    }
    
    /* [8] 심플한 스타일의 세로 리스트 */
    .quick-link-box {
        background-color: #fff;
        border: 1px solid #e1e1e1; /* 테두리는 아주 연하게 */
        border-radius: 8px; /* 살짝만 둥글게 */
        overflow: hidden;
        max-width: 350px; /* 너무 넓지 않게 고정 */
    }
    .quick-link-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 20px;
        color: #333;
        text-decoration: none;
        border-bottom: 1px solid #f1f1f1;
        font-size: 0.95rem;
        transition: background 0.2s;
    }
    .quick-link-item:last-child { border-bottom: none; }
    .quick-link-item:hover {
        background-color: #f9f9f9;
        color: #3CB371; /* 호버 시에만 포인트 컬러 */
    }
    .quick-link-item i { color: #ccc; font-size: 0.8rem; }
</style>
</head>
<body>
    <%@ include file="../../common/header.jsp" %>
    <c:set var="isMainPage" value="true" scope="request" />
	<jsp:include page="../faq/faqSearchHeader.jsp" />
    
    <div class="container my-5">
        <div class="row g-x-5"> 
            <div class="col-lg-9"> 
                <div class="faq-category-container mb-3"> 
                    <div class="d-flex flex-wrap gap-2 justify-content-between align-items-center mb-2">
                        <div class="d-flex flex-wrap gap-2">
                            <a href="javascript:void(0);" onclick="changeCategory('', this)" class="tag active">전체</a>
                            <a href="javascript:void(0);" onclick="changeCategory('장소/정보', this)" class="tag">장소/정보</a>
                            <a href="javascript:void(0);" onclick="changeCategory('예약/결제', this)" class="tag">예약/결제</a>
                            <a href="javascript:void(0);" onclick="changeCategory('회원/포인트', this)" class="tag">회원/포인트</a>
                            <a href="javascript:void(0);" onclick="changeCategory('리뷰/커뮤니티', this)" class="tag">리뷰/커뮤니티</a>
                            <a href="javascript:void(0);" onclick="changeCategory('이벤트/공지', this)" class="tag">이벤트/공지</a>
                            <a href="javascript:void(0);" onclick="changeCategory('기타', this)" class="tag">기타</a>
                        </div>
                        <div class="ms-auto">
                            <a href="${pageContext.request.contextPath}/faqAllList.sp" class="text-secondary text-decoration-none small view-all-link">
                                질문 전체보기 <i class="fa-solid fa-circle-chevron-right ms-1"></i>
                            </a>
                        </div>
                    </div>
                    
                    <div id="category-notice-area" class="pt-2 pb-2"> 
                        <h6 class="fw-bold mb-0" style="color: #444; font-size: 0.95rem;">
                            '<span id="selected-category-name" class="text-primary">전체</span>' 관련 가장 자주 묻는 질문입니다.
                        </h6>
                    </div>
                </div>
                
                <div id="faqListArea">
                    <c:forEach var="faq" items="${faqList}">
                        <div class="faq-item border-bottom">
                            <div class="faq-question p-3 d-flex justify-content-between align-items-center" 
                                 onclick="toggleAnswer(this)" style="cursor:pointer;">
                                <div>
                                    <span class="text-primary fw-bold me-2">Q.</span>
                                    <span class="fw-medium">${faq.question}</span>
                                </div>
                                <i class="fa-solid fa-chevron-down text-secondary transition-icon"></i>
                            </div>
                            
                            <div class="faq-answer bg-light" style="display: none; overflow: hidden; padding: 0;">
                                <div class="p-4 d-flex">
                                    <span class="text-danger fw-bold me-2">A.</span>
                                    <div class="text-muted small">${faq.answer}</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="mt-5">
				    <div class="row g-4">
				        <div class="col-md-6">
				            <h6 class="fw-bold mb-3" style="color: #222;">간편하게 해결하세요</h6>
				            <div class="quick-link-box" style="max-width: 100%;"> <a href="${pageContext.request.contextPath}/viewInquiries.do" class="quick-link-item">
				                    <span>나의 문의내역</span>
				                    <i class="fa-solid fa-chevron-right"></i>
				                </a>
				                <a href="${pageContext.request.contextPath}/modifyUser.do" class="quick-link-item">
				                    <span>내 회원정보수정</span>
				                    <i class="fa-solid fa-chevron-right"></i>
				                </a>
				                <a href="${pageContext.request.contextPath}/myPageHome.do" class="quick-link-item">
				                    <span>나의 포인트 조회</span>
				                    <i class="fa-solid fa-chevron-right"></i>
				                </a>
				            </div>
				        </div>
				
				        <div class="col-md-6">
				            <h6 class="fw-bold mb-3" style="color: #222;">맛침내 고객센터 안내</h6>
				            <div class="quick-link-box p-4" style="max-width: 100%; min-height: 163px; background-color: #fcfcfc;">
				                <div class="d-flex align-items-start mb-2">
				                    <i class="fa-solid fa-headset text-success me-3 mt-1" style="font-size: 1.2rem;"></i>
				                    <div>
				                        <strong style="font-size: 1.1rem;">1544-2222</strong>
				                        <p class="text-muted small mb-0">평일 09:00 ~ 18:00 (토/일/공휴일 휴무)</p>
				                    </div>
				                </div>
				                <hr class="my-3" style="opacity: 0.1;">
				                <div class="d-flex align-items-center">
				                    <i class="fa-solid fa-envelope text-secondary me-3" style="font-size: 1.1rem;"></i>
				                    <span class="text-muted small">help@matchimnae.co.kr (상시 접수)</span>
				                </div>
				            </div>
				        </div>
				    </div>
				</div>
            </div> 
            <div class="col-lg-3">
                <div class="card shadow-sm border-0 mb-3">
                    <div class="card-header bg-white py-3 border-bottom-0">
                        <h6 class="card-title mb-0 fw-bold">
                            <i class="fa-solid fa-fire text-danger me-1"></i> 인기 질문 Top 10
                        </h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush">
                            <c:forEach var="top" items="${top10Global}" varStatus="status">
                                <a href="faqDetail.sp?faq_id=${top.faq_id}" 
                                   class="list-group-item list-group-item-action border-0 py-2 px-3">
                                    <div class="d-flex w-100 align-items-center">
                                        <span class="me-2 text-primary fw-bold" style="font-size: 0.85rem;">${status.count}.</span> 
                                        <span class="text-truncate text-dark" style="font-size: 0.85rem; flex: 1;">
                                            ${top.question}
                                        </span>
                                    </div>
                                </a>
                            </c:forEach>
                            <c:if test="${empty top10Global}">
                                <div class="p-4 text-center text-muted small">인기 질문이 없습니다.</div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm border-0 mb-3" style="background-color: #f8fbf8;">
                    <div class="card-body p-4 text-center">
                        <div class="mb-3">
                            <img src="${pageContext.request.contextPath}/resources/images/user/faq/logo_icon.png" 
                                 alt="맛침내 로고" 
                                 style="width: 40px; height: auto; opacity: 0.8;">
                        </div>
                        <h6 class="fw-bold mb-2" style="color: #2e8b57; font-size: 1rem;">1:1 문의를 남겨주세요</h6>
                        <p class="text-muted small mb-3">원하시는 답을 찾지 못하셨나요?<br>상세한 내용을 남겨주시면 빠르게 답변 드릴게요.</p>
                        <a href="${pageContext.request.contextPath}/inquiryWrite.sp" 
                           class="btn btn-primary btn-sm rounded-pill px-4 shadow-sm"
                           style="background-color: #3CB371; border-color: #3CB371; font-weight: 600;">
                            <i class="fa-solid fa-pen-to-square me-1"></i> 문의글 작성
                        </a>
                    </div>
                </div>

                <div class="card shadow-sm border-0 mb-4" style="background-color: #f9f9f9;">
                    <div class="card-body p-4 text-center">
                        <div class="mb-3 text-secondary">
                            <i class="fa-solid fa-triangle-exclamation" style="font-size: 2.5rem; opacity: 0.6;"></i>
                        </div>
                        <h6 class="fw-bold mb-2 text-dark" style="font-size: 1rem;">불편사항을 알려주세요</h6>
                        <p class="text-muted small mb-3">웹페이지 내 서비스 이용에 심각한<br>불편함이 있으셨다면 신고해 주세요.</p>
                        <a href="javascript:void(0);" 
						   data-bs-toggle="modal" data-bs-target="#reportModal"
						   class="btn btn-outline-secondary btn-sm rounded-pill px-4"
						   style="font-size: 0.85rem; border-color: #ddd; color: #666;">
						   <i class="fa-solid fa-bullhorn me-1"></i> 불편 신고
						</a>
                    </div>	
                </div>
            </div>
        </div> 
    </div> 
    <div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
	    <div class="modal-dialog modal-dialog-centered">
	        <div class="modal-content">
	            <div class="modal-header border-0">
	                <h5 class="modal-title fw-bold" id="reportModalLabel">불편사항 신고센터</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body px-4">
	                <p class="small text-muted mb-4">사이트 이용 중 느끼신 불편한 점을 남겨주시면 서비스 개선에 큰 힘이 됩니다.</p>
	                
	                <form id="reportForm">
	                    <input type="hidden" name="user_id" value="${sessionScope.sessionID}">
	                    <input type="hidden" name="category" value="불편사항">
	                    
	                    <div class="mb-3">
	                        <label class="form-label small fw-bold">신고제목</label>
	                        <input type="text" name="title" class="form-control form-control-sm" placeholder="간략한 제목을 입력해주세요" required>
	                    </div>
	                    
	                    <div class="mb-3">
	                        <label class="form-label small fw-bold">신고내용</label>
	                        <textarea name="content" class="form-control form-control-sm" rows="5" placeholder="불편하신 내용을 상세히 적어주세요" required></textarea>
	                    </div>
	                </form>
	            </div>
	            <div class="modal-footer border-0 pb-4">
	                <button type="button" class="btn btn-light btn-sm px-4" data-bs-dismiss="modal">취소하기</button>
	                <button type="button" id="btnSendReport" class="btn btn-primary btn-sm px-4" style="background-color: #007bff;">신고하기</button>
	            </div>
	        </div>
	    </div>
	</div>
    <%@ include file="../../common/footer.jsp" %>
</body>
</html>