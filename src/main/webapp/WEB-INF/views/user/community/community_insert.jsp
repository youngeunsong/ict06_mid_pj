<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>커뮤니티 글쓰기</title>

<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<!-- Summernote만 개별 페이지에서 추가 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/lang/summernote-ko-KR.min.js"></script>

<link rel="stylesheet" href="${path}/resources/css/user/community/community_insert.css">
<script src="${path}/resources/js/community/community_insert.js" defer></script>

<script>
    const contextPath = "${path}";
</script>

<script>
window.addEventListener("load", function () {
    console.log("[inline test] jQuery =", window.jQuery);
    console.log("[inline test] summernote =", window.jQuery ? window.jQuery.fn.summernote : "없음");

    if (window.jQuery && typeof window.jQuery.fn.summernote === "function") {
        $('#contentInput').summernote({
            height: 350,
            lang: 'ko-KR',
            placeholder: '여행 이야기를 자유롭게 작성해보세요 :)'
        });
        console.log("[inline test] Summernote 초기화 성공");
    } else {
        console.log("[inline test] Summernote 초기화 실패");
    }
});
</script>

</head>
<body>
<div class="wrap">

    <%@ include file="../../common/header.jsp" %>

    <div class="page-body">
        <div class="container" style="max-width:860px;">

            <div class="breadcrumb-area">
                <a href="${path}/community_free.co">커뮤니티</a>
                <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
                <a href="${path}/community_free.co">자유게시판</a>
                <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
                <span class="cur">글쓰기</span>
            </div>

            <div class="write-card">
                <div class="write-card-header">
                    <i class="bi bi-pencil-square" style="color:var(--primary); font-size:1.1rem;"></i>
                    <h2>게시글 작성</h2>
                </div>

                <form action="${path}/community_insert.co"
                      method="post"
                      onsubmit="return validateInsertForm();">

                    <div class="write-form">

                        <div>
                            <div class="field-label">
                                카테고리 <span class="required">*</span>
                            </div>
                            <div class="cat-select-wrap">
                                <input type="radio" name="category" id="cat1" class="cat-radio" value="맛집수다" checked>
                                <label for="cat1" class="cat-label">맛집수다</label>

                                <input type="radio" name="category" id="cat2" class="cat-radio" value="숙소수다">
                                <label for="cat2" class="cat-label">숙소수다</label>

                                <input type="radio" name="category" id="cat3" class="cat-radio" value="축제수다">
                                <label for="cat3" class="cat-label">축제수다</label>

                                <input type="radio" name="category" id="cat4" class="cat-radio" value="정보공유">
                                <label for="cat4" class="cat-label">정보공유</label>

                                <input type="radio" name="category" id="cat5" class="cat-radio" value="동행구해요">
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
                                   placeholder="제목을 입력하세요 (최대 200자)"
                                   maxlength="200">
                            <div class="char-counter" id="titleCounter">0 / 200</div>
                            <div class="err-msg" id="titleErr">제목을 입력해주세요.</div>
                        </div>

                        <div>
                            <div class="field-label">
                                내용 <span class="required">*</span>
                            </div>
                            <textarea name="content"
                                      id="contentInput"
                                      class="textarea-content"></textarea>
                            <div class="char-counter" id="contentCounter">0자</div>
                            <div class="err-msg" id="contentErr">내용을 입력해주세요.</div>
                        </div>

                        <div>
                            <div class="field-label">
                                <i class="bi bi-images" style="color:#adb5bd; margin-right:5px;"></i>
                                대표 이미지 첨부
                                <span style="font-size:.7rem; color:#adb5bd; font-weight:400; margin-left:8px;">
                                    (최대 5장 · JPG, PNG · 장당 10MB 이하)
                                </span>
                            </div>

                            <div class="upload-area" id="uploadArea" onclick="document.getElementById('fileInput').click()">
                                <i class="bi bi-cloud-upload upload-icon"></i>
                                <div class="upload-text">
                                    이미지를 <strong>드래그&드롭</strong>하거나 클릭해서 업로드하세요
                                </div>
                                <div class="upload-hint">첫 번째 이미지가 대표 이미지(썸네일)로 사용됩니다</div>
                            </div>

                            <input type="file"
                                   id="fileInput"
                                   name="files"
                                   accept="image/jpeg, image/png"
                                   multiple
                                   onchange="handleFiles(this.files)">

                            <div class="preview-grid" id="previewGrid"></div>
                        </div>

                        <div class="notice-box">
                            <strong>⚠️ 작성 전 꼭 확인해주세요</strong>
                            <ul>
                                <li>욕설·비방·홍보성 게시물은 예고 없이 삭제될 수 있습니다.</li>
                                <li>개인정보(전화번호, 계좌번호 등)는 게시글에 포함하지 마세요.</li>
                                <li>타인의 저작물을 무단 사용하지 마세요.</li>
                            </ul>
                        </div>
                    </div>

                    <div class="write-footer">
                        <a href="${path}/community_free.co"
                           class="btn-cancel"
                           onclick="return confirm('작성 중인 내용은 저장되지 않습니다. 취소하시겠습니까?');">
                            <i class="bi bi-x"></i> 취소
                        </a>
                        <button type="submit" class="btn-submit">
                            <i class="bi bi-send-fill"></i> 등록하기
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