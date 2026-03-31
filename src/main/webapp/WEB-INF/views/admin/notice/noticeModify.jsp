<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">

<!-- Summernote 선언 및 충돌 방지 -->
<link rel="stylesheet" href="${path}/resources/admin/plugins/summernote/summernote-lite.css">

<!-- 1) 기존 설정 대피 (Backup) -->
<script>
    window.__oldDefine = window.define;
    window.__oldModule = window.module;
    window.__oldExports = window.exports;
    window.define = undefined;
    window.module = undefined;
    window.exports = undefined;
</script>

<!-- 2) 라이브러리 로드 -->
<script src="${path}/resources/admin/plugins/summernote/summernote-lite.js"></script>
<script src="${path}/resources/admin/plugins/summernote/lang/summernote-ko-KR.js"></script>

<!-- 3) 기존 설정 복구 (Restore) -->
<script>
    window.define = window.__oldDefine;
    window.module = window.__oldModule;
    window.exports = window.__oldExports;
    
    /* 임시 변수 삭제 */
    delete window.__oldDefine;
    delete window.__oldModule;
    delete window.__oldExports;
    
    const CTX = "${path}";
</script>

<title>공지/이벤트 수정</title>
</head>

<body class="hold-transition sidebar-mini layout-fixed">
<!--begin::div wrapper-->
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
        <div class="app content-header">
            <div class="container-fluid">
                <h3 class="mb-0 font-weight-bold">공지/이벤트 수정</h3>
            </div>
        </div>
        
        <div class="app-content">
            <div class="container-fluid">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <form id="noticeModifyForm" method="post" action="${path}/noticeUpdate.adnt" enctype="multipart/form-data">
                        
                            <input type="hidden" name="noticeId" value="${dto.notice_id}">
                            
                            <%-- 분류 --%>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label font-weight-bold">분류 <span class="text-danger">*</span></label>
                                <div class="col-sm-4">
                                    <select name="category" class="form-control" required>
                                        <option value="">선택</option>
                                        <option value="NOTICE" ${dto.category == 'NOTICE' ? 'selected' : ''}>공지사항</option>
                                        <option value="EVENT" ${dto.category == 'EVENT' ? 'selected' : ''}>이벤트</option>
                                    </select>
                                </div>
                            </div>
                            
                            <%-- 제목 --%>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label font-weight-bold">제목 <span class="text-danger">*</span></label>
                                <div class="col-sm-10">
                                    <input type="text" name="title" id="titleInput" class="form-control" 
                                           value="${dto.title}" maxlength="200" required>
                                    <div class="char-counter text-muted text-right" id="titleCounter" style="font-size: 0.8rem;">0 / 200</div>
                                    <div class="err-msg text-danger" id="titleErr" style="display:none; font-size: 0.8rem;">제목을 입력해주세요.</div>
                                </div>
                            </div>
                            
                            <%-- 내용 --%>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label font-weight-bold">내용 <span class="text-danger">*</span></label>
                                <div class="col-sm-10">
                                    <textarea id="content" name="content" class="form-control" rows="15" required>${dto.content}</textarea>
                                    <div class="char-counter text-muted text-right" id="contentCounter" style="font-size: 0.8rem;">0자</div>
                                    <div class="err-msg text-danger" id="contentErr" style="display:none; font-size: 0.8rem;">내용을 입력해주세요.</div>
                                </div>
                            </div>
                            
                            <%-- 썸네일 이미지 (수정 모드) --%>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label font-weight-bold">썸네일 이미지</label>
                                <div class="col-sm-10">
                                    <div id="uploadArea"
                                    	 class="border rounded p-4 text-center mb-2" 
                                         style="border: 2px dashed #dee2e6 !important;
                                         cursor: pointer;
                                         background: #f8f9fa;">
                                        <i class="fas fa-cloud-upload-alt fa-2x text-muted mb-2"></i>
                                        <p class="mb-0 text-muted small">새 이미지를 끌어오거나 클릭하여 변경하세요.</p>
                                        <input type="file" name="uploadFile" class="d-none" accept="image/*">
                                    </div>
                                    
                                    <div id="previewGrid" class="d-flex flex-wrap gap-3">
                                        <%-- 기존 이미지가 있는 경우 JS에서 처리하거나 아래와 같이 초기 렌더링 가능 --%>
                                        <c:if test="${not empty dto.image_url}">
                                            <div class="preview-item mt-2" id="existThumb">
                                                <div class="position-relative d-inline-block">
                                                    <img src="${dto.image_url}" class="img-thumbnail" style="width:150px; height:150px; object-fit:cover;">
                                                    <span class="badge badge-info position-absolute" style="top:5px; left:5px;">기존</span>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            
                            <%-- 상단 고정 --%>
                            <div class="form-group row">
                                <label class="col-sm-2 col-form-label font-weight-bold">상단 고정</label>
                                <div class="col-sm-10 d-flex align-items-center">
                                    <div class="icheck-primary">
                                        <input type="checkbox" id="isTop" name="isTop" value="Y" ${dto.is_top == 'Y' ? 'checked' : ''}>
                                        <label for="isTop">상단 고정</label>
                                    </div>
                                </div>
                            </div>
                            
                            <%-- 버튼 --%>
                            <div class="form-group d-flex justify-content-between mt-4">
                                <a href="${path}/noticeList.adnt" class="btn btn-secondary">목록</a>
                                <div>
                                    <button type="button" class="btn btn-danger mr-2" onclick="deleteNotice('${dto.notice_id}')">삭제</button>
                                    <button type="submit" class="btn btn-primary px-4">수정 완료</button>
                                </div>
                            </div>
                            
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--end::content-wrapper--%>
    
  	<!-- ================= FOOTER ================= -->
	<footer class="main-footer">
		<strong>Copyright &copy; 2026</strong>
	</footer>
</div>
<%--end::wrapper--%>

<script>const path = "${path}";</script>
<script src="${path}/resources/admin/plugins/summernote/lang/summernote-ko-KR.min.js"></script>
<script src="${path}/resources/js/admin/notice.js"></script>
</body>
</html>