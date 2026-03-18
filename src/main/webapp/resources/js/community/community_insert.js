/* community_insert.js */

document.addEventListener("DOMContentLoaded", function () {
    console.log("[community_insert.js] DOMContentLoaded");

    const titleInput = document.getElementById("titleInput");
    const contentInput = document.getElementById("contentInput");

    console.log("titleInput:", titleInput);
    console.log("contentInput:", contentInput);
    console.log("window.jQuery:", window.jQuery);
    console.log("summernote fn:", window.jQuery ? window.jQuery.fn.summernote : "jQuery 없음");

    // Summernote 초기화
    if (contentInput && window.jQuery && typeof window.jQuery.fn.summernote === "function") {
        console.log("[Summernote] 초기화 시작");

        $(contentInput).summernote({
            height: 350,
            lang: "ko-KR",
            placeholder: "여행 이야기를 자유롭게 작성해보세요 :)",
            toolbar: [
                ["style", ["style"]],
                ["font", ["bold", "underline", "italic", "clear"]],
                ["para", ["ul", "ol", "paragraph"]],
                ["insert", ["link", "picture"]],
                ["view", ["fullscreen", "codeview"]]
            ],
            callbacks: {
                onImageUpload: function(files) {
                    for (let i = 0; i < files.length; i++) {
                        uploadSummernoteImage(files[i], this);
                    }
                },
                onChange: function() {
                    countContent();
                }
            }
        });

        console.log("[Summernote] 초기화 완료");
    } else {
        console.warn("[Summernote] 초기화 실패 - jQuery 또는 summernote 미로드");
    }

    if (titleInput) {
        titleInput.addEventListener("input", countTitle);
        countTitle();
    }

    countContent();
});

function uploadSummernoteImage(file, editor) {
    let data = new FormData();
    data.append("file", file);

    $.ajax({
        url: contextPath + "/uploadImage.co",
        type: "POST",
        data: data,
        processData: false,
        contentType: false,
        success: function(imageUrl) {
            $(editor).summernote("insertImage", imageUrl);
        },
        error: function() {
            alert("이미지 업로드 중 오류가 발생했습니다.");
        }
    });
}

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

function countContent() {
    const contentInput = document.getElementById("contentInput");
    const contentCounter = document.getElementById("contentCounter");
    const contentErr = document.getElementById("contentErr");

    if (!contentInput || !contentCounter || !contentErr) return;

    let textLength = 0;

    if (window.jQuery && $(contentInput).next(".note-editor").length) {
        const html = $(contentInput).summernote("code");
        const tempDiv = document.createElement("div");
        tempDiv.innerHTML = html;
        textLength = tempDiv.textContent.replace(/\s+/g, "").length;
    } else {
        textLength = contentInput.value.trim().length;
    }

    contentCounter.textContent = `${textLength}자`;

    if (textLength > 0) {
        contentErr.style.display = "none";
    }
}

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

    if (window.jQuery && typeof window.jQuery.fn.summernote === "function" && $(contentInput).next(".note-editor").length) {
        const html = $(contentInput).summernote("code");
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
    }

    if (contentText === "") {
        contentErr.style.display = "block";
        if (isValid) {
            if (window.jQuery && $(contentInput).next(".note-editor").length) {
                $(contentInput).summernote("focus");
            } else {
                contentInput.focus();
            }
        }
        isValid = false;
    }

    return isValid;
}

const selectedFiles = [];
const MAX_FILES = 5;
const MAX_FILE_SIZE = 10 * 1024 * 1024;
const ALLOWED_TYPES = ["image/jpeg", "image/png"];

function handleFiles(files) {
    if (!files || files.length === 0) return;
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

            item.querySelector(".preview-del-btn").addEventListener("click", () => removeFile(index));
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

function onDragOver(event) {
    event.preventDefault();
    document.getElementById("uploadArea")?.classList.add("dragover");
}

function onDragLeave(event) {
    event.preventDefault();
    document.getElementById("uploadArea")?.classList.remove("dragover");
}

function onDrop(event) {
    event.preventDefault();
    document.getElementById("uploadArea")?.classList.remove("dragover");
    handleFiles(event.dataTransfer.files);
}

function escapeHtml(str) {
    return String(str)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#39;");
}