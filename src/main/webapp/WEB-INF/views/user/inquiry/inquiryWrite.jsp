<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<fmt:setTimeZone value="Asia/Seoul"/>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>문의글 작성</title>
<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>
<script>
    var contextPath = "${pageContext.request.contextPath}";
    var sessionUserId = "${sessionScope.user_id}";
</script>
<script src="${pageContext.request.contextPath}/resources/js/support/faqMain.js" defer></script>
<style>
    /* [1] 기본 설정 */
    body {
        background-color: #f8f9fa; /* 혹은 메인처럼 #fafafa */
        color: #333;
        font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
    }

    /* [2] 전체 레이아웃 */
    .inquiry-outer-container {
        max-width: 1100px;
        margin: 50px auto;
        padding: 0 20px;
    }

    /* 좌측 타이틀 영역 */
    .inquiry-side-title {
        width: 200px;
        border-right: 1px solid #ddd; /* 세로선 추가 */
        padding-right: 30px;
        margin-right: 30px;
        display: flex;
        flex-direction: column;
    }
    .inquiry-side-title h2 {
        font-size: 1.5rem;
        font-weight: 800;
        border-bottom: 2px solid #333;
        padding-bottom: 15px;
        margin-bottom: 0;
    }

    /* 우측 폼 카드 */
    .inquiry-form-card {
        background: #fff;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }

    /* [3] 폼 요소 상세 스타일 (G마켓 스타일 가로 배치) */
    .form-row {
        margin-bottom: 25px;
        border-bottom: 1px solid #f0f0f0;
        padding-bottom: 20px;
        align-items: flex-start; /* Bootstrap Grid와 함께 사용 */
    }
    .form-row:last-child { border-bottom: none; margin-bottom: 0; }

    .form-label-side {
        font-weight: 700;
        font-size: 0.95rem;
        padding-top: 10px; /* 입력창과 높이 맞춤 */
        color: #555;
    }

    /* Bootstrap 5 표준 클래스 강화 */
    .form-control, .form-select {
        border: 1px solid #ddd !important;
        padding: 12px !important;
        border-radius: 6px !important;
        width: 100% !important; /* 무조건 가득 채우게 */
    }
    .form-control:focus {
        border-color: #3CB371 !important;
        box-shadow: 0 0 0 0.2rem rgba(60, 179, 113, 0.15) !important;
    }

    textarea.form-control {
        height: 250px !important;
        resize: none !important;
    }

    /* [4] 버튼 스타일 */
    .btn-submit {
        background-color: #3CB371 !important;
        color: white !important;
        border: none !important;
        padding: 15px 50px !important;
        font-weight: 600 !important;
        border-radius: 8px !important;
        width: auto !important; /* 부트스트랩 너비 무시 */
    }
    .btn-submit:hover { background-color: #2e8b57 !important; color: #fff !important; }

    .btn-cancel {
        background-color: #6c757d !important;
        color: white !important;
        padding: 15px 50px !important;
        border-radius: 8px !important;
        text-decoration: none !important;
        width: auto !important;
    }

</style>

<body>
	
	<c:set var="isMainPage" value="false" scope="request" />
	<jsp:include page="../faq/faqSearchHeader.jsp" />
    <div class="inquiry-outer-container">
        <div class="row g-0">
            
            <div class="col-md-auto inquiry-side-title">
                <h2>문의글 작성</h2>
            </div>

            <div class="col-md inquiry-form-card">
                <form action="${pageContext.request.contextPath}/inquiryInsert.sp" method="post">
                    <input type="hidden" name="user_id" value="${sessionScope.sessionID}">

                    <div class="row form-row">
                        <label class="col-sm-2 form-label-side">문의 유형</label>
                        <div class="col-sm-10">
                            <select name="category" id="category" class="form-select" required>
                                <option value="">유형을 선택하세요</option>
                                <option value="장소/정보">장소/정보</option>
                                <option value="예약/결제">예약/결제</option>
                                <option value="회원/포인트">회원/포인트</option>
                                <option value="리뷰/커뮤니티">리뷰/커뮤니티</option>
                                <option value="이벤트/공지">이벤트/공지</option>
                                <option value="기타">기타</option>
                            </select>
                        </div>
                    </div>

                    <div class="row form-row">
                        <label class="col-sm-2 form-label-side">제목</label>
                        <div class="col-sm-10">
                            <input type="text" name="title" id="title" class="form-control" placeholder="제목을 입력해주세요" required>
                        </div>
                    </div>

                    <div class="row form-row">
                        <label class="col-sm-2 form-label-side">문의 내용</label>
                        <div class="col-sm-10">
                            <textarea name="content" id="content" class="form-control" placeholder="문의하실 내용을 상세히 입력해주세요." required></textarea>
                            <small class="text-muted mt-2 d-block">부적절한 내용은 상담이 제한되거나 삭제될 수 있습니다.</small>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mt-4 pt-4 border-top">
                        <button type="submit" class="btn btn-submit">등록하기</button>
                        <a href="javascript:history.back();" class="btn btn-cancel">취소</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="../../common/footer.jsp" %>
</body>
</html>
