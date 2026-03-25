<!-- 
 * @author 송혜진
 * 최초작성일: 2026-03-18
 * 최종수정일: 2026-03-20
 * 적용 라이브러리 : summernote
 * 참고 코드: community_insert.jsp
 게시글 작성 페이지에서 기존 정보 끌고와 뿌림. 
 
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 > 자유게시판 > 게시글 > 수정</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/community/community-common.css">
<link rel="stylesheet" href="${path}/resources/css/user/community/community.css">
<link rel="stylesheet" href="${path}/resources/css/user/community/community_insert.css">

<!-- Summernote -->
<link rel="stylesheet" href="${path}/resources/admin/plugins/summernote/summernote-lite.css">

<script>
    window.__oldDefine = window.define;
    window.__oldModule = window.module;
    window.__oldExports = window.exports;

    window.define = undefined;
    window.module = undefined;
    window.exports = undefined;
</script>

<script src="${path}/resources/admin/plugins/summernote/summernote-lite.js"></script>
<script src="${path}/resources/admin/plugins/summernote/lang/summernote-ko-KR.js"></script>

<script>
    window.define = window.__oldDefine;
    window.module = window.__oldModule;
    window.exports = window.__oldExports;

    delete window.__oldDefine;
    delete window.__oldModule;
    delete window.__oldExports;

    const CTX = "${path}";
</script>

<script src="${path}/resources/js/community/community_modify.js" defer></script>
</head>

<body>
<div class="wrap">

    <%@ include file="../../common/header.jsp" %>

    <div class="page-body">
        <div class="container">
       
            <div class="breadcrumb-area">
                <a href="${path}/community_free.co">커뮤니티</a>
                <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
                <a href="${path}/community_free.co">자유게시판</a>
                <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
                <span class="cur">게시글 수정</span>
            </div>

            <div class="write-card">
                <div class="write-card-header">
                    <i class="bi bi-pencil-square" style="color:var(--primary); font-size:1.1rem;"></i>
                    <h2>게시글 수정</h2>
                </div>

                <form action="${path}/community_modifyAction.co"
                      method="post"
                      enctype="multipart/form-data"
                      onsubmit="return validateModifyForm();">

                    <input type="hidden" name="post_id" value="${dto.post_id}">

                    <div class="write-form">

                        <div>
                            <div class="field-label">
                                카테고리 <span class="required">*</span>
                            </div>
                            <div class="cat-select-wrap">
                                <input type="radio" name="category" id="cat1" class="cat-radio" value="맛집수다" ${dto.category eq '맛집수다' ? 'checked' : ''}>
                                <label for="cat1" class="cat-label">맛집수다</label>

                                <input type="radio" name="category" id="cat2" class="cat-radio" value="숙소수다" ${dto.category eq '숙소수다' ? 'checked' : ''}>
                                <label for="cat2" class="cat-label">숙소수다</label>

                                <input type="radio" name="category" id="cat3" class="cat-radio" value="축제수다" ${dto.category eq '축제수다' ? 'checked' : ''}>
                                <label for="cat3" class="cat-label">축제수다</label>

                                <input type="radio" name="category" id="cat4" class="cat-radio" value="정보공유" ${dto.category eq '정보공유' ? 'checked' : ''}>
                                <label for="cat4" class="cat-label">정보공유</label>

                                <input type="radio" name="category" id="cat5" class="cat-radio" value="동행구해요" ${dto.category eq '동행구해요' ? 'checked' : ''}>
                                <label for="cat5" class="cat-label">동행구해요</label>
                            </div>
                        </div>

                        <div>
                            <div class="field-label">
                                제목 <span class="required">*</span>
                            </div>
                            <input type="text"
                                   name="title"
                                   id="titleInput"
                                   class="input-title"
                                   value="<c:out value='${dto.title}'/>"
                                   placeholder="제목을 입력하세요 (최대 200자)"
                                   maxlength="200">
                            <div class="char-counter" id="titleCounter">0 / 200</div>
                            <div class="err-msg" id="titleErr" style="display:none;">제목을 입력해주세요.</div>
                        </div>

                        <div>
                            <div class="field-label">
                                내용 <span class="required">*</span>
                            </div>
                            <textarea name="content"
                                      id="contentInput"
                                      class="textarea-content">${dto.content}</textarea>
                            <div class="char-counter" id="contentCounter">0자</div>
                            <div class="err-msg" id="contentErr" style="display:none;">내용을 입력해주세요.</div>
                        </div>

                        <c:if test="${not empty dto.repImage and not empty dto.repImage.image_url}">
                            <div>
                                <div class="field-label">
                                    현재 대표 이미지
                                </div>
                                <div class="existing-image-box">
                                    <img src="${dto.repImage.image_url}" alt="현재 대표 이미지" class="existing-image-thumb">
                                </div>
                            </div>
                        </c:if>

                        <div>
                            <div class="field-label">
                                <i class="bi bi-images" style="color:#adb5bd; margin-right:5px;"></i>
                                새 대표 이미지 첨부
                                <span style="font-size:.7rem; color:#adb5bd; font-weight:400; margin-left:8px;">
                                    (최대 5장 · JPG, PNG · 장당 10MB 이하)
                                </span>
                            </div>

                            <div class="upload-area" id="uploadArea" onclick="document.getElementById('fileInput').click()">
                                <i class="bi bi-cloud-upload upload-icon"></i>
                                <div class="upload-text">
                                    이미지를 <strong>드래그&드롭</strong>하거나 클릭해서 업로드하세요
                                </div>
                                <div class="upload-hint">새 이미지를 올리지 않으면 기존 대표 이미지를 유지합니다</div>
                            </div>

                            <input type="file"
                                   id="fileInput"
                                   name="files"
                                   accept="image/jpeg, image/png"
                                   multiple
                                   style="display:none;">

                            <div class="preview-grid" id="previewGrid"></div>
                        </div>

                        <div class="notice-box">
                            <strong>⚠️ 수정 전 꼭 확인해주세요</strong>
                            <ul>
                                <li>욕설·비방·홍보성 게시물은 예고 없이 삭제될 수 있습니다.</li>
                                <li>개인정보(전화번호, 계좌번호 등)는 게시글에 포함하지 마세요.</li>
                                <li>타인의 저작물을 무단 사용하지 마세요.</li>
                            </ul>
                        </div>
                    </div>

                    <div class="write-footer">
                        <a href="${path}/community_detail.co?post_id=${dto.post_id}"
                           class="btn-cancel"
                           onclick="return confirm('수정을 취소하시겠습니까? 변경사항은 저장되지 않습니다.');">
                            <i class="bi bi-x"></i> 취소
                        </a>
                        <button type="submit" class="btn-submit">
                            <i class="bi bi-check2-circle"></i> 수정하기
                        </button>
                    </div>

                </form>
            </div>
        </div>
    </div>

    <%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>