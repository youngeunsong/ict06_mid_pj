<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<fmt:setTimeZone value="Asia/Seoul"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">
<!-- 글 등록시 알럿 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.10.5/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.10.5/dist/sweetalert2.all.min.js"></script>
<meta charset="UTF-8">
<title>FAQ 마스터 등록</title>

<style>
    /* 입력 폼 컨테이너 */
    .write-container { background: white; padding: 35px; border-radius: 15px; border: 1px solid #eef2f5; }
    .form-section-title { font-size: 1.1rem; font-weight: 700; color: #333; margin-bottom: 20px; border-left: 4px solid #01D281; padding-left: 10px; }
    
    /* 알약 모양 시그니처 버튼 */
    .btn-pill { border-radius: 50px !important; padding: 10px 35px; font-weight: 600; transition: 0.3s; }
    .btn-signature { background-color: #01D281 !important; border: none; color: white !important; }
    .btn-signature:hover { background-color: #00b36d !important; transform: translateY(-1px); }
</style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">
	<!-- Preloader -->
    <div class="preloader flex-column justify-content-center align-items-center">
       <img src="${path}/resources/admin/dist/img/AdminLTELogo.png" height="60" width="60">
    </div>
    <%-- 1. HEADER 영역 --%>
    <%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>
    
    <%-- 2. SIDEBAR 영역 --%>
    <%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

    <div class="content-wrapper">
        <div class="app-content-header py-3">
            <div class="container-fluid">
                <h3 class="mb-0 font-weight-bold">FAQ 컨텐츠 등록</h3>
            </div>
        </div>
        
        <section class="app-content">
            <div class="container-fluid">
                <div class="write-container shadow-sm">
                    <%-- onsubmit에서 return을 받아야 전송을 멈추거나 보낼 수 있습니다 --%>
                    <form action="${path}/adFaqWriteAction.adsp" method="post" id="faqForm" onsubmit="return handleFaqSubmit(event);">
                        <div class="form-section-title">기본 정보 설정</div>
                        <div class="row">
                            <div class="col-md-4 mb-4">
                                <label class="font-weight-bold">문의 유형</label>
                                <select name="category" class="form-control" required>
                                    <option value="장소/정보">장소/정보</option>
                                    <option value="예약/결제">예약/결제</option>
                                    <option value="회원/포인트">회원/포인트</option>
                                    <option value="리뷰/커뮤니티">리뷰/커뮤니티</option>
                                    <option value="이벤트/공지">이벤트/공지</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>
                            <div class="col-md-2 mb-4">
                                <label class="font-weight-bold">정렬 순서</label>
                                <input type="number" name="order_no" class="form-control" value="1" min="1">
                            </div>
                            <div class="col-md-6 mb-4">
                                <label class="font-weight-bold">노출 상태</label>
                                <div class="d-flex align-items-center" style="height: 38px;">
                                    <div class="custom-control custom-radio mr-4">
                                        <input type="radio" id="visY" name="visible" class="custom-control-input" value="Y" checked>
                                        <label class="custom-control-label" for="visY">즉시 노출</label>
                                    </div>
                                    <div class="custom-control custom-radio">
                                        <input type="radio" id="visN" name="visible" class="custom-control-input" value="N">
                                        <label class="custom-control-label" for="visN">숨김(임시저장)</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section-title">질의응답 내용 작성</div>
                        <%-- 질문 입력 --%>
                        <div class="form-group mb-4">
                            <label class="font-weight-bold">질문 내용</label>
                            <input type="text" name="question" class="form-control form-control-lg" placeholder="사용자가 리스트에서 클릭할 질문을 입력하세요." required>
                        </div>

                        <%-- 답변 입력 --%>
                        <div class="form-group mb-5">
                            <label class="font-weight-bold">답변 및 상세 설명</label>
                            <textarea name="answer" class="form-control" rows="12" placeholder="사용자에게 보여줄 상세 설명을 입력하세요." required></textarea>
                            <div class="text-right mt-1"><small id="charCount" class="text-muted">0 / 2000자</small></div>
                        </div>

                        <%-- 하단 컨트롤 버튼 --%>
                        <div class="d-flex justify-content-center gap-3" style="gap:15px;">
                            <button type="button" class="btn btn-pill btn-light border" onclick="history.back();">취소하기</button>
                            <button type="button" class="btn btn-pill btn-info" onclick="saveTemp();">임시저장</button>
                            <button type="submit" class="btn btn-pill btn-signature">FAQ 등록하기</button>
                        </div>
                    </form>
                </div>
            </div>
        </section>
        
        <footer class="main-footer mt-5">
            <strong>Copyright &copy; 2026</strong>
        </footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.10.5/dist/sweetalert2.all.min.js"></script>

<script src="${path}/resources/js/admin/adFaqWrite.js"></script>
</body>
</html>