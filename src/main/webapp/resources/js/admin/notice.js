/* ========================================
   notice.js - 관리자 > 공지/이벤트 관리 최종 통합본
   ========================================*/

/* 전역 변수 설정 */
const selectedFiles = []; // 썸네일용 파일 객체 저장 배열
const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
const ALLOWED_TYPES = ["image/jpeg", "image/png"];

$(document).ready(function() {

    // 0. 초기화 및 이벤트 바인딩
    bindTitleCounter();    // 제목 글자수 제한
    bindUploadEvents();    // 썸네일 드래그 앤 드롭
    initSummernote();      // 에디터 초기화
    initSidebarScroll();   // 사이드바 스크롤 (OverlayScrollbars)
    
    // 초기 상태 렌더링
    countTitle();
});

//----------------------------------------
// 1. 제목 입력 필드 로직
//----------------------------------------
function bindTitleCounter() {
    const titleInput = document.getElementById("titleInput");
    if (!titleInput) return;

    titleInput.addEventListener("input", function () {
        countTitle();
        if (this.value.trim().length > 0) {
            hideError("titleErr");
        }
    });
}

function countTitle() {
    const titleInput = document.getElementById("titleInput");
    const titleCounter = document.getElementById("titleCounter");
    if (!titleInput || !titleCounter) return;

    titleCounter.textContent = titleInput.value.length + " / 200";
}

//----------------------------------------
// 2. Summernote 에디터 초기화 및 이미지 업로드
//----------------------------------------
function initSummernote() {
	const $editor = $('#content');
    if($editor.length) {
        $('#content').summernote({
            lang: 'ko-KR',
            height: 400,
            minHeight: 300,
            maxHeight: 600,
            focus: false,
            disableResizeEditor: true,
            placeholder: '내용을 입력하세요.',
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['ul','ol','paragraph']],
                ['table', ['table']],
                ['insert', ['link', 'picture']],
                ['view', ['fullscreen','codeview']]
            ],
            callbacks: {
                onImageUpload: function(files) {
                    for (let i = 0; i < files.length; i++) {
                        uploadSummernoteImage(files[i], this);
                    }
                },
                onChange: function(contents, $editable) {
                    countContent();
                }
            }
        });
        
        countContent();
        
    }
}

// 화면의 본문 글자수 카운터 업데이트
function countContent() {
    const contentCounter = document.getElementById("contentCounter");
    if (!contentCounter) return;

    const textLength = getPlainTextLengthWithoutSpace();
    contentCounter.textContent = textLength + "자";
}

// 공백을 제외한 본문의 글자수 계산
function getPlainTextLengthWithoutSpace() {
    return getSummernotePlainText().replace(/\s+/g, "").length;
}

// 에디터의 순수 텍스트 반환
function getSummernotePlainText() {
    return extractPlainText(getSummernoteHtml()); //6-3에서 반환한 순수 텍스트 받기
}

// 에디터에 작성된 현재 HTML 코드를 가져옴
function getSummernoteHtml() {
    const contentInput = document.getElementById("content");
    if (!content || !window.jQuery || !$(content).next(".note-editor").length) {
        return "";
    }
    return $(contentInput).summernote("code");
}

// HTML 문자열에서 태그를 제거
function extractPlainText(html) {
    const tempDiv = document.createElement("div");
    tempDiv.innerHTML = html || "";
    return (tempDiv.textContent || tempDiv.innerText || "").trim();
}

// 본문 내 이미지 서버 업로드 처리
function uploadSummernoteImage(file, editor) {
    if (!file) return;
    
    if (!ALLOWED_TYPES.includes(file.type)) {
        alert('본문 이미지는 JPG, PNG 파일만 업로드할 수 있습니다.');
        return;
    }
    
    if (file.size > MAX_FILE_SIZE) {
        alert(file.name + ' : 파일 용량은 10MB 이하만 가능합니다.');
        return;
    }

    var formData = new FormData();
    formData.append('file', file);
    
    $.ajax({
        url: CTX + '/noticeImageUpload.adnt',
        type: 'POST',
        data: formData,
        contentType: false,
        processData: false,
        success: function(url) {
            $(editor).summernote('insertImage', url);
        },
        error: function() {
            alert('이미지 업로드 실패');
        }
    });
}

//----------------------------------------
// 3. 썸네일 파일 업로드 (Drag & Drop + DataTransfer)
//----------------------------------------
function bindUploadEvents() {
    const uploadArea = document.getElementById("uploadArea");
    const fileInput = document.querySelector('input[name="uploadFile"]');

    if (!uploadArea || !fileInput) return;

    // 영역 클릭 시 파일 창 열기
    uploadArea.addEventListener("click", () => fileInput.click());

    // 드래그 시각 효과
    uploadArea.addEventListener("dragover", (e) => {
        e.preventDefault();
        uploadArea.classList.add("dragover");
    });
    uploadArea.addEventListener("dragleave", () => {
        uploadArea.classList.remove("dragover");
    });
    uploadArea.addEventListener("drop", (e) => {
        e.preventDefault();
        uploadArea.classList.remove("dragover");
        handleThumbnailFiles(e.dataTransfer.files);
    });

    // 파일 선택 완료 시
    fileInput.addEventListener("change", function() {
        handleThumbnailFiles(this.files);
    });
}

function handleThumbnailFiles(files) {
    if (!files || files.length === 0) return;
    const file = files[0]; // 썸네일은 1개만 허용

    if (!ALLOWED_TYPES.includes(file.type)) {
        alert("JPG, PNG 파일만 업로드 가능합니다.");
        return;
    }
    
    if (file.size > MAX_FILE_SIZE) {
        alert("파일 용량은 10MB 이하만 가능합니다.");
        return;
    }

    selectedFiles[0] = file; // 배열에 저장
    renderPreview();         // 미리보기 출력
    syncFileInput();        // 실제 input에 DataTransfer 주입
}

function syncFileInput() {
    const fileInput = document.querySelector('input[name="uploadFile"]');
    const dt = new DataTransfer();
    selectedFiles.forEach(file => dt.items.add(file));
    fileInput.files = dt.files;
}

function renderPreview() {
    const previewGrid = document.getElementById("previewGrid");
    if (!previewGrid) return;

    previewGrid.innerHTML = "";
    selectedFiles.forEach((file, index) => {
        const reader = new FileReader();
        reader.onload = function(e) {
            const html = `
                <div class="preview-item mt-2">
                    <div class="position-relative d-inline-block">
                        <img src="${e.target.result}" class="img-thumbnail" style="width:150px; height:150px; object-fit:cover;">
                        <button type="button" onclick="removeThumbnail(${index})" 
                                class="btn btn-danger btn-sm position-absolute" style="top:5px; right:5px;">&times;</button>
                    </div>
                    <div class="small text-muted mt-1 text-truncate" style="max-width:150px;">${escapeHtml(file.name)}</div>
                </div>`;
            previewGrid.innerHTML = html;
        };
        reader.readAsDataURL(file);
    });
}

function removeThumbnail(index) {
    selectedFiles.splice(index, 1);
    renderPreview();
    syncFileInput();
}

//----------------------------------------
// 4. 유효성 검사 및 전송
//----------------------------------------
$(document).on('submit', '#noticeWriteForm, #noticeModifyForm', function(e) {
    var category = $('select[name=category]').val();
    var title = $('#titleInput').val().trim();
    var content = $('#content').summernote('isEmpty') ? '' : $('#content').summernote('code');
    
    if(!category) {
        alert('분류를 선택하세요.');
        e.preventDefault();
        return;
    }
    if(!title) {
        showError("titleErr");
        alert('제목을 입력하세요.');
        e.preventDefault();
        return;
    }
    if(!content || content === '<p><br></p>') {
        alert('내용을 입력하세요.');
        e.preventDefault();
        return;
    }
});

//----------------------------------------
// 5. 삭제 및 공통 함수
//----------------------------------------
function deleteNotice(noticeId) {
    if(!confirm('정말 삭제하시겠습니까?')) return;
    
    $.ajax({
        url: CTX + '/noticeDelete.adnt',
        type: 'post',
        data: {noticeId: noticeId},
        success: function(result) {
            if(result === 'success') {
                location.href = CTX + '/noticeList.adnt?deleted=true';
            } else {
                alert('삭제 실패');
            }
        },
        error: function() { alert('오류 발생'); }
    });
}

function initSidebarScroll() {
    const SELECTOR_SIDEBAR_WRAPPER = '.sidebar-wrapper';
    const sidebarWrapper = document.querySelector(SELECTOR_SIDEBAR_WRAPPER);
    if (sidebarWrapper && typeof OverlayScrollbarsGlobal !== 'undefined') {
        OverlayScrollbarsGlobal.OverlayScrollbars(sidebarWrapper, {
            scrollbars: { theme: 'os-theme-light', autoHide: 'leave', clickScroll: true },
        });
    }
}

function showError(id) {
    const el = document.getElementById(id);
    if (el) el.style.display = "block";
}

function hideError(id) {
    const el = document.getElementById(id);
    if (el) el.style.display = "none";
}

function escapeHtml(str) {
    return String(str).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll('"', "&quot;").replaceAll("'", "&#39;");
}