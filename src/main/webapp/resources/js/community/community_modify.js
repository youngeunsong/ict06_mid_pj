/* community_modify.js */

const selectedFiles = [];
const MAX_FILES = 5;
const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
const ALLOWED_TYPES = ["image/jpeg", "image/png"];

document.addEventListener("DOMContentLoaded", function () {
    bindTitleCounter();
    bindCategoryPlaceholder();
    bindUploadEvents();
    initSummernote();
    countTitle();
    countContent();
});

function initSummernote() {
    const contentInput = document.getElementById("contentInput");

    if (!contentInput) return;

    if (!window.jQuery || !window.jQuery.fn || typeof window.jQuery.fn.summernote !== "function") {
        console.warn("[community_modify] Summernote 로드 실패");
        return;
    }

    $("#contentInput").summernote({
        lang: "ko-KR",
        height: 350,
        minHeight: 300,
        maxHeight: 600,
        focus: false,
        disableResizeEditor: true,
        placeholder: getCategoryPlaceholder(),
        toolbar: [
            ["style", ["style"]],
            ["font", ["bold", "underline", "italic", "clear"]],
            ["color", ["color"]],
            ["para", ["ul", "ol", "paragraph"]],
            ["insert", ["link", "picture"]],
            ["view", ["codeview"]]
        ],
        callbacks: {
            onChange: function (contents) {
                countContent();
                const plainText = extractPlainText(contents);
                if (plainText.length > 0) {
                    hideError("contentErr");
                }
                updateSummernotePlaceholder();
            },
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

function bindTitleCounter() {
    const titleInput = document.getElementById("titleInput");
    if (!titleInput) return;

    titleInput.addEventListener("input", function () {
        countTitle();
        if (titleInput.value.trim().length > 0) {
            hideError("titleErr");
        }
    });
}

function bindCategoryPlaceholder() {
    const radios = document.querySelectorAll('input[name="category"]');
    radios.forEach(function (radio) {
        radio.addEventListener("change", function () {
            updateSummernotePlaceholder();
        });
    });
}

function bindUploadEvents() {
    const uploadArea = document.getElementById("uploadArea");
    const fileInput = document.getElementById("fileInput");

    if (!uploadArea || !fileInput) return;

    uploadArea.addEventListener("dragover", onDragOver);
    uploadArea.addEventListener("dragleave", onDragLeave);
    uploadArea.addEventListener("drop", onDrop);

    fileInput.addEventListener("change", function () {
        handleFiles(fileInput.files);
    });
}

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

function updateSummernotePlaceholder() {
    const contentInput = document.getElementById("contentInput");
    if (!contentInput || !window.jQuery || !$(contentInput).next(".note-editor").length) return;

    const placeholder = getCategoryPlaceholder();
    const editor = $(contentInput).next(".note-editor");

    editor.find(".note-editable").attr("data-placeholder", placeholder);
    editor.find(".note-placeholder").text(placeholder);
}

function extractPlainText(html) {
    const tempDiv = document.createElement("div");
    tempDiv.innerHTML = html || "";
    return (tempDiv.textContent || tempDiv.innerText || "").trim();
}

function getSummernoteHtml() {
    const contentInput = document.getElementById("contentInput");
    if (!contentInput || !window.jQuery || !$(contentInput).next(".note-editor").length) {
        return "";
    }
    return $(contentInput).summernote("code");
}

function getSummernotePlainText() {
    return extractPlainText(getSummernoteHtml());
}

function getPlainTextLengthWithoutSpace() {
    return getSummernotePlainText().replace(/\s+/g, "").length;
}

function countTitle() {
    const titleInput = document.getElementById("titleInput");
    const titleCounter = document.getElementById("titleCounter");
    if (!titleInput || !titleCounter) return;

    titleCounter.textContent = titleInput.value.length + " / 200";
}

function countContent() {
    const contentCounter = document.getElementById("contentCounter");
    if (!contentCounter) return;

    const textLength = getPlainTextLengthWithoutSpace();
    contentCounter.textContent = textLength + "자";
}

function validateModifyForm() {
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

    fetch(window.contextPath + "/uploadImage.co", {
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

    renderPreview();
    syncFileInput();
}

function renderPreview() {
    const previewGrid = document.getElementById("previewGrid");
    if (!previewGrid) return;

    previewGrid.innerHTML = "";

    selectedFiles.forEach(function (file, index) {
        const reader = new FileReader();

        reader.onload = function (e) {
            const item = document.createElement("div");
            item.className = "preview-item";

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

            const delBtn = item.querySelector(".preview-del-btn");
            if (delBtn) {
                delBtn.addEventListener("click", function (event) {
                    event.stopPropagation();
                    removeFile(index);
                });
            }
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
    selectedFiles.forEach(function (file) {
        dataTransfer.items.add(file);
    });
    fileInput.files = dataTransfer.files;
}

function onDragOver(event) {
    event.preventDefault();
    const uploadArea = document.getElementById("uploadArea");
    if (uploadArea) uploadArea.classList.add("dragover");
}

function onDragLeave(event) {
    event.preventDefault();
    const uploadArea = document.getElementById("uploadArea");
    if (uploadArea) uploadArea.classList.remove("dragover");
}

function onDrop(event) {
    event.preventDefault();

    const uploadArea = document.getElementById("uploadArea");
    if (uploadArea) uploadArea.classList.remove("dragover");

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