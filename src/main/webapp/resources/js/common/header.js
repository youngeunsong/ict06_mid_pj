/* 헤더 자동검색 */

document.addEventListener("DOMContentLoaded", function () {
    const keywordInput = document.getElementById("headerKeyword");
    const suggestBox = document.getElementById("searchSuggestBox");

    const recentArea = document.getElementById("recentKeywordArea");
    const recentList = document.getElementById("recentKeywordList");

    const autoArea = document.getElementById("autoCompleteArea");
    const autoList = document.getElementById("autoCompleteList");

    if (!keywordInput || !suggestBox) return;

    // HTML escape
    function escapeHtml(str) {
        return str.replace(/[&<>"']/g, function (m) {
            switch (m) {
                case "&": return "&amp;";
                case "<": return "&lt;";
                case ">": return "&gt;";
                case '"': return "&quot;";
                case "'": return "&#39;";
                default: return m;
            }
        });
    }

    function openSuggestBox() {
        suggestBox.classList.remove("d-none");
    }

    function closeSuggestBox() {
        suggestBox.classList.add("d-none");
    }

    function renderRecentKeywords(list) {
        if (!list || list.length === 0) {
            recentList.innerHTML = '<li class="suggest-empty">최근 검색어가 없습니다.</li>';
        } else {
            let html = "";
            list.forEach(function (item) {
                html += `<li class="suggest-item recent-item" data-keyword="${escapeHtml(item.keyword)}">${escapeHtml(item.keyword)}</li>`;
            });
            recentList.innerHTML = html;
        }
        recentArea.classList.remove("d-none");
    }

    function renderAutoComplete(list) {
        if (!list || list.length === 0) {
            autoList.innerHTML = '<li class="suggest-empty">추천 검색어가 없습니다.</li>';
        } else {
            let html = "";
            list.forEach(function (item) {
                html += `<li class="suggest-item auto-item" data-keyword="${escapeHtml(item)}">${escapeHtml(item)}</li>`;
            });
            autoList.innerHTML = html;
        }
        autoArea.classList.remove("d-none");
    }

    function loadRecentKeywords() {
        fetch(`${window.location.pathname.substring(0, window.location.pathname.indexOf("/", 1))}/search/recent`, {
            method: "GET",
            headers: {
                "AJAX": "true"
            }
        })
        .then(res => res.json())
        .then(data => {
            autoArea.classList.add("d-none");
            autoList.innerHTML = "";

            renderRecentKeywords(data);
            openSuggestBox();
        })
        .catch(err => {
            console.error("최근 검색어 조회 오류", err);
        });
    }

    function loadAutoComplete(keyword) {
        fetch(`${window.location.pathname.substring(0, window.location.pathname.indexOf("/", 1))}/search/autocomplete?keyword=` + encodeURIComponent(keyword), {
            method: "GET",
            headers: {
                "AJAX": "true"
            }
        })
        .then(res => res.json())
        .then(data => {
            recentArea.classList.add("d-none");
            recentList.innerHTML = "";

            renderAutoComplete(data);
            openSuggestBox();
        })
        .catch(err => {
            console.error("자동완성 조회 오류", err);
        });
    }

    // 포커스 시: 입력값 없으면 최근 검색어
    keywordInput.addEventListener("focus", function () {
        const keyword = this.value.trim();
        if (keyword.length === 0) {
            loadRecentKeywords();
        } else {
            loadAutoComplete(keyword);
        }
    });

    // 입력 시: 자동완성
    keywordInput.addEventListener("input", function () {
        const keyword = this.value.trim();

        if (keyword.length === 0) {
            loadRecentKeywords();
            return;
        }

        loadAutoComplete(keyword);
    });

    // 추천어 클릭
    document.addEventListener("click", function (e) {
        const target = e.target;

        if (target.classList.contains("recent-item") || target.classList.contains("auto-item")) {
            const keyword = target.dataset.keyword;
            keywordInput.value = keyword;
            keywordInput.form.submit();
            return;
        }

        if (!suggestBox.contains(target) && target !== keywordInput) {
            closeSuggestBox();
        }
    });
});