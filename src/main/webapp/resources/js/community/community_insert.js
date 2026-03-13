/* community_insert.js */

document.addEventListener("DOMContentLoaded", function () {
    const titleInput = document.getElementById("titleInput");
    const contentInput = document.getElementById("contentInput");

    if (titleInput) {
        countTitle();
    }

    if (contentInput) {
        countContent();
    }
});

/* =========================
   제목 글자 수
========================= */
function countTitle() {
    const titleInput = document.getElementById("titleInput");
    const titleCounter = document.getElementById("titleCounter");
    const titleErr = document.getElementById("titleErr");

    if (!titleInput || !titleCounter || !titleErr) return;

    const len = titleInput.value.length;
    titleCounter.textContent = `${len} / 200`;

    if (len > 0) {
        titleErr.style.display = "none";
    }
}

/* =========================
   내용 글자 수
========================= */
function countContent() {
    const contentInput = document.getElementById("contentInput");
    const contentCounter = document.getElementById("contentCounter");
    const contentErr = document.getElementById("contentErr");

    if (!contentInput || !contentCounter || !contentErr) return;

    let textLength = 0;

    if (window.jQuery && typeof window.jQuery.fn.summernote === "function" && window.jQuery(contentInput).next(".note-editor").length) {
        const html = window.jQuery(contentInput).summernote("code");
        const tempDiv = document.createElement("div");
        tempDiv.innerHTML = html;
        textLength = tempDiv.textContent.trim().length;
    } else {
        textLength = contentInput.value.length;
    }

    contentCounter.textContent = `${textLength}자`;

    if (textLength > 0) {
        contentErr.style.display = "none";
    }
}

/* =========================
   등록 전 검사
========================= */
function validateInsertForm() {
    const titleInput = document.getElementById("titleInput");
    const contentInput = document.getElementById("contentInput");
    const titleErr = document.getElementById("titleErr");
    const contentErr = document.getElementById("contentErr");

    let isValid = true;

    if (!titleInput || !contentInput || !titleErr || !contentErr) {
        return true;
    }

    const title = titleInput.value.trim();
    let contentText = "";

    if (window.jQuery && typeof window.jQuery.fn.summernote === "function" && window.jQuery(contentInput).next(".note-editor").length) {
        const html = window.jQuery(contentInput).summernote("code");
        const tempDiv = document.createElement("div");
        tempDiv.innerHTML = html;
        contentText = tempDiv.textContent.trim();
    } else {
        contentText = contentInput.value.trim();
    }

    if (title === "") {
        titleErr.style.display = "block";
        titleInput.focus();
        isValid = false;
    } else {
        titleErr.style.display = "none";
    }

    if (contentText === "") {
        contentErr.style.display = "block";

        if (isValid) {
            if (window.jQuery && typeof window.jQuery.fn.summernote === "function" && window.jQuery(contentInput).next(".note-editor").length) {
                window.jQuery(contentInput).summernote("focus");
            } else {
                contentInput.focus();
            }
        }

        isValid = false;
    } else {
        contentErr.style.display = "none";
    }

    return isValid;
}

/* =========================
   파일 업로드 미리보기
========================= */
const selectedFiles = [];
const MAX_FILES = 5;
const MAX_FILE_SIZE = 10 * 1024 * 1024;
const ALLOWED_TYPES = ["image/jpeg", "image/png"];

function handleFiles(files) {
    if (!files || files.length === 0) return;

    const previewGrid = document.getElementById("previewGrid");
    if (!previewGrid) return;

    const incomingFiles = Array.from(files);

    for (const file of incomingFiles) {
        if (selectedFiles.length >= MAX_FILES) {
            alert("이미지는 최대 5장까지 업로드할 수 있습니다.");
            break;
        }

        if (!ALLOWED_TYPES.includes(file.type)) {
            alert(`${file.name} : JPG, PNG 파일만 업로드할 수 있습니다.`);
            continue;
        }

        if (file.size > MAX_FILE_SIZE) {
            alert(`${file.name} : 파일 용량은 10MB 이하만 가능합니다.`);
            continue;
        }

        selectedFiles.push(file);
    }

    renderPreview();
    syncFileInput();
}

function renderPreview() {
    const previewGrid = document.getElementById("previewGrid");
    if (!previewGrid) return;

    previewGrid.innerHTML = "";

    selectedFiles.forEach((file, index) => {
        const reader = new FileReader();

        reader.onload = function (e) {
            const item = document.createElement("div");
            item.className = "preview-item";

            item.innerHTML = `
                <div class="preview-thumb-wrap">
                    <img src="${e.target.result}" alt="preview" class="preview-thumb">
                    ${index === 0 ? '<span class="preview-badge">대표</span>' : ""}
                    <button type="button" class="preview-del-btn" data-index="${index}">&times;</button>
                </div>
                <div class="preview-name">${escapeHtml(file.name)}</div>
            `;

            previewGrid.appendChild(item);

            const delBtn = item.querySelector(".preview-del-btn");
            delBtn.addEventListener("click", function () {
                removeFile(index);
            });
        };

        reader.readAsDataURL(file);
    });
}

function removeFile(index) {
    selectedFiles.splice(index, 1);
    renderPreview();
    syncFileInput();
}

function syncFileInput() {
    const fileInput = document.getElementById("fileInput");
    if (!fileInput) return;

    const dataTransfer = new DataTransfer();

    selectedFiles.forEach(file => dataTransfer.items.add(file));

    fileInput.files = dataTransfer.files;
}

/* =========================
   드래그 앤 드롭
========================= */
function onDragOver(event) {
    event.preventDefault();

    const uploadArea = document.getElementById("uploadArea");
    if (uploadArea) {
        uploadArea.classList.add("dragover");
    }
}

function onDragLeave(event) {
    event.preventDefault();

    const uploadArea = document.getElementById("uploadArea");
    if (uploadArea) {
        uploadArea.classList.remove("dragover");
    }
}

function onDrop(event) {
    event.preventDefault();

    const uploadArea = document.getElementById("uploadArea");
    if (uploadArea) {
        uploadArea.classList.remove("dragover");
    }

    const files = event.dataTransfer.files;
    handleFiles(files);
}

/* =========================
   HTML escape
========================= */
function escapeHtml(str) {
    return String(str)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#39;");
}