/* community_insert.js */

/* 전역 변수 설정 */
const selectedFiles = []; // 사용자가 선택한 파일 객체들을 저장하는 배열
const MAX_FILES = 5;      // 최대 업로드 가능 파일 수
const MAX_FILE_SIZE = 10 * 1024 * 1024; // 개별 파일 최대 용량 (10MB)
const ALLOWED_TYPES = ["image/jpeg", "image/png"]; // 허용하는 이미지 타입

/* 페이지 로드 시 가장 먼저 시작 : 이벤트 바인딩 및 초기화 ===================================================== */
document.addEventListener("DOMContentLoaded", function () {
    bindTitleCounter();         // 1) 제목 글자수 카운트 이벤트 연결
    bindCategoryPlaceholder();  // 2) 카운터/카테고리 변경 시 플레이스홀더 변경 이벤트 연결
    bindUploadEvents();         // 3) 파일 드래그 앤 드롭 이벤트 연결
    initSummernote();           // 4) Summernote 초기화
    countTitle();               // 5) 초기 제목 글자수 계산
    countContent();             // 6) 초기 본문 글자수 계산
});

/* 1) 제목 입력 필드 글자수 제한 및 에러 핸들링 */
function bindTitleCounter() {
    const titleInput = document.getElementById("titleInput");
    if (!titleInput) return;

    titleInput.addEventListener("input", function () {
        countTitle();
        if (titleInput.value.trim().length > 0) { // 입력값이 있으면 에러 메시지 숨김
            hideError("titleErr");
        }
    });
}

/* 2) 카테고리(라디오 버튼) 변경 시 에디터 안내 문구 변경 ---------------------------------------------------- */
function bindCategoryPlaceholder() {
    const radios = document.querySelectorAll('input[name="category"]');
    radios.forEach(function (radio) {
        radio.addEventListener("change", function () {
            updateSummernotePlaceholder();
        });
    });
}

/* 2-1) Summernote 에디터의 플레이스홀더 강제 업데이트 */
function updateSummernotePlaceholder() {
	// Summernote가 올바르게 붙었는지 체크
    const contentInput = document.getElementById("contentInput");
    if (!contentInput || !window.jQuery || !$(contentInput).next(".note-editor").length) return;

    const placeholder = getCategoryPlaceholder();
    const editor = $(contentInput).next(".note-editor");

	// 에디터 내부 placeholder 속성 및 텍스트 변경
    editor.find(".note-editable").attr("data-placeholder", placeholder);
    editor.find(".note-placeholder").text(placeholder);
}

/* 2-2) 선택된 카테고리에 맞는 안내 문구(Placeholder) 반환 */
function getCategoryPlaceholder() {
    const checked = document.querySelector('input[name="category"]:checked');
    const category = checked ? checked.value : "";

    switch (category) {
        case "맛집수다":
            return "방문 후기, 추천 메뉴, 분위기 등을 자유롭게 작성해보세요.";
        case "숙소수다":
            return "숙소 후기, 위치, 가격, 청결도 등을 공유해보세요.";
        case "축제수다":
            return "축제 후기, 일정, 팁 등을 작성해보세요.";
        case "정보공유":
            return "유용한 여행 정보나 꿀팁을 자세히 공유해보세요.";
        case "동행구해요":
            return "일정, 장소, 인원, 연락 방법 등을 명확히 적어주세요.";
        default:
            return "여행 이야기를 자유롭게 작성해보세요.";
    }
}

/* 3) 파일 업로드 영역 이벤트 바인딩 (클릭 및 드래그 앤 드롭) -------------------------------------------*/
function bindUploadEvents() {
    const uploadArea = document.getElementById("uploadArea");
    const fileInput = document.getElementById("fileInput");

    if (!uploadArea || !fileInput) return;

    uploadArea.addEventListener("dragover", onDragOver);   // 드래그
    uploadArea.addEventListener("dragleave", onDragLeave); // 드래그
    uploadArea.addEventListener("drop", onDrop);           // 드롭

	// 클릭해서 파일 선택 시 처리
    fileInput.addEventListener("change", function () {
        handleFiles(fileInput.files);
    });
}

/* 3-1) 드래그(on) 이벤트 핸들러 */
function onDragOver(event) {
    event.preventDefault(); // 브라우저 기본동작 강제 중지
    const uploadArea = document.getElementById("uploadArea");
    if (uploadArea) uploadArea.classList.add("dragover"); // class에 dragover 추가
}

/* 3-2) 드래그(Leave) 이벤트 핸들러 */
function onDragLeave(event) {
    event.preventDefault(); // 브라우저 기본 동작 방지
    const uploadArea = document.getElementById("uploadArea");
    if (uploadArea) uploadArea.classList.remove("dragover");
}

/* 3-3) 드롭 이벤트 핸들러 */
function onDrop(event) {
    event.preventDefault(); // 브라우저 기본 동작 방지

    const uploadArea = document.getElementById("uploadArea");
    if (uploadArea) uploadArea.classList.remove("dragover");

	// dataTransfer = event 속성 = 드래그 중인 데이터(이미지 파일, 선택한 텍스트, URL 등)를 임시로 저장하고 관리
    handleFiles(event.dataTransfer.files);
}

/* 3-4) 다중 파일(첨부파일) 선택 시 유효성 검사 및 배열 저장 */
function handleFiles(files) {
    if (!files || files.length === 0) return;

    const incomingFiles = Array.from(files);

    for (let i = 0; i < incomingFiles.length; i++) {
        const file = incomingFiles[i];

        if (selectedFiles.length >= MAX_FILES) {
            alert("이미지는 최대 5장까지 업로드할 수 있습니다.");
            break;
        }

        if (!ALLOWED_TYPES.includes(file.type)) {
            alert(file.name + " : JPG, PNG 파일만 업로드할 수 있습니다.");
            continue;
        }

        if (file.size > MAX_FILE_SIZE) {
            alert(file.name + " : 파일 용량은 10MB 이하만 가능합니다.");
            continue;
        }

        selectedFiles.push(file);
    }

    renderPreview(); // 미리보기 갱신
    syncFileInput(); // 실제 input 필드와 동기화
}

/* 4) Summernote 초기화 ---------------------------------------------------------------- */
function initSummernote() {
    const contentInput = document.getElementById("contentInput");

    if (!contentInput) return;

	// jQuery 및 Summernote 로드 여부 확인
    if (!window.jQuery || !window.jQuery.fn || typeof window.jQuery.fn.summernote !== "function") {
        console.warn("[community_insert] Summernote 로드 실패");
        return;
    }

	// summernote 설정 지정
    $("#contentInput").summernote({
        lang: "ko-KR",              // 언어 설정 (한국어)
        height: 350,                // 기본 높이
        minHeight: 300,             // 최소 높이
        maxHeight: 600,             // 최대 높이
        focus: false,               // 시작 시 자동 포커스 해제
        disableResizeEditor: true,  // 에디터 크기 조절 비활성화
        placeholder: getCategoryPlaceholder(), // 카테고리별 초기 안내 문구
        toolbar: [
            ["style", ["style"]],
            ["font", ["bold", "underline", "italic", "clear"]],
            ["color", ["color"]],
            ["para", ["ul", "ol", "paragraph"]],
            ["insert", ["link", "picture"]],
            ["view", ["codeview"]]
        ],
        callbacks: {
        	// 내용이 변경될 때마다 호출
            onChange: function (contents) {
                countContent(); // 본문 글자수 업데이트
                const plainText = extractPlainText(contents);
                if (plainText.length > 0) {
                    hideError("contentErr"); // 내용이 있으면 에러 메시지 숨김
                }
                updateSummernotePlaceholder(); // 플레이스홀더 상태 업데이트
            },
            // 이미지를 에디터에 올렸을 때 서버 업로드 처리
            onImageUpload: function (files) {
                for (let i = 0; i < files.length; i++) {
                    uploadSummernoteImage(files[i], this);
                }
            }
        }
    });

    updateSummernotePlaceholder();
    countContent();
}

/* 4-1) 본문 내 이미지 서버 업로드 (Fetch API 사용) */
function uploadSummernoteImage(file, editor) {
    if (!file) return;

    if (!ALLOWED_TYPES.includes(file.type)) {
        alert("본문 이미지는 JPG, PNG 파일만 업로드할 수 있습니다.");
        return;
    }

    if (file.size > MAX_FILE_SIZE) {
        alert("본문 이미지는 10MB 이하만 업로드할 수 있습니다.");
        return;
    }

    const formData = new FormData();
    formData.append("file", file);

	// 서버의 이미지 업로드 경로로 전송 (CTX는 ContextPath 전역변수)
    fetch(CTX + "/uploadImage.co", {
        method: "POST",
        body: formData
    })
        .then(function (response) {
            return response.text();
        })
        .then(function (imageUrl) {
            if (imageUrl && imageUrl.trim() !== "") {
                $(editor).summernote("insertImage", imageUrl.trim());
            } else {
                alert("이미지 업로드에 실패했습니다.");
            }
        })
        .catch(function (error) {
            console.error(error);
            alert("이미지 업로드 중 오류가 발생했습니다.");
        });
}

/* 5) 화면의 제목 글자수 카운터 업데이트 (0 / 200) -------------------------------------------- */
function countTitle() {
    const titleInput = document.getElementById("titleInput");
    const titleCounter = document.get ElementById("titleCounter");
    if (!titleInput || !titleCounter) return;

    titleCounter.textContent = titleInput.value.length + " / 200";
}

/* 6) 화면의 본문 글자수 카운터 업데이트 ------------------------------------------------------ */
function countContent() {
    const contentCounter = document.getElementById("contentCounter");
    if (!contentCounter) return;

    const textLength = getPlainTextLengthWithoutSpace();
    contentCounter.textContent = textLength + "자";
}

/* 6-1) 공백을 제외한 본문의 글자수 계산 */
function getPlainTextLengthWithoutSpace() {
    return getSummernotePlainText().replace(/\s+/g, "").length;
}

/* 6-2) 에디터의 순수 텍스트 반환 */
function getSummernotePlainText() {
    return extractPlainText(getSummernoteHtml()); //6-3에서 반환한 순수 텍스트 받기
}

/* 6-3) 에디터에 작성된 현재 HTML 코드를 가져옴 */
function getSummernoteHtml() {
    const contentInput = document.getElementById("contentInput");
    if (!contentInput || !window.jQuery || !$(contentInput).next(".note-editor").length) {
        return "";
    }
    return $(contentInput).summernote("code");
}

/* 6-3) HTML 문자열에서 태그를 제거 */
function extractPlainText(html) {
    const tempDiv = document.createElement("div");
    tempDiv.innerHTML = html || "";
    return (tempDiv.textContent || tempDiv.innerText || "").trim();
}

/* -------------------------------------------------------------------------- */


/* 폼 제출 전 유효성 검사 (제목 및 본문 입력 여부 확인) */
function validateInsertForm() {
    const titleInput = document.getElementById("titleInput");
    const title = titleInput ? titleInput.value.trim() : "";
    const contentText = getSummernotePlainText();

    let isValid = true;

    hideError("titleErr");
    hideError("contentErr");

    if (!title) {
        showError("titleErr");
        if (titleInput) {
            titleInput.focus();
        }
        isValid = false;
    }

    if (!contentText) {
        showError("contentErr");
        if (isValid && window.jQuery && typeof $("#contentInput").summernote === "function") {
            $("#contentInput").summernote("focus");
        }
        isValid = false;
    }

    return isValid;
}

function showError(id) {
    const el = document.getElementById(id);
    if (el) el.style.display = "block";
}

function hideError(id) {
    const el = document.getElementById(id);
    if (el) el.style.display = "none";
}




/* 선택된 파일들에 대한 미리보기 UI 생성 ------------------------------------------------------------------------- */
function renderPreview() {
    const previewGrid = document.getElementById("previewGrid");
    if (!previewGrid) return;

    previewGrid.innerHTML = ""; // 기존 미리보기 초기화

    selectedFiles.forEach(function (file, index) {
        const reader = new FileReader();

        reader.onload = function (e) {
            const item = document.createElement("div");
            item.className = "preview-item";

			// 첫 번째 사진을 대표 사진으로 표시
            const badgeHtml = index === 0
                ? '<span class="preview-badge">대표</span>'
                : '';

            item.innerHTML =
                '<div class="preview-thumb-wrap">' +
                    '<img src="' + e.target.result + '" alt="preview" class="preview-thumb">' +
                    badgeHtml +
                    '<button type="button" class="preview-del-btn" data-index="' + index + '">&times;</button>' +
                '</div>' +
                '<div class="preview-name">' + escapeHtml(file.name) + '</div>';

            previewGrid.appendChild(item);

			// 삭제 버튼 이벤트 연결
            const delBtn = item.querySelector(".preview-del-btn");
            if (delBtn) {
                delBtn.addEventListener("click", function (event) {
                    event.stopPropagation();
                    removeFile(index);
                });
            }
        };

        reader.readAsDataURL(file); // 이미지를 base64로 읽어와 미리보기 표시
    });
}

/* 미리보기 목록에서 파일 제거 */
function removeFile(index) {
    selectedFiles.splice(index, 1);
    renderPreview(); // 
    syncFileInput(); //
}

/*
   selectedFiles 배열의 내용을 실제 HTML input file 태그에 동기화
   (DataTransfer를 사용하여 수동으로 파일 목록을 구성)
*/
function syncFileInput() {
    const fileInput = document.getElementById("fileInput");
    if (!fileInput) return;

    const dataTransfer = new DataTransfer();
    selectedFiles.forEach(function (file) {
        dataTransfer.items.add(file);
    });
    fileInput.files = dataTransfer.files;
}

/* XSS 방지를 위한 HTML 특수문자 이스케이프 함수 */
function escapeHtml(str) {
    return String(str)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#39;");
}