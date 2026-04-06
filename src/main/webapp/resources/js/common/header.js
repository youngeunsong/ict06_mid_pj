/* 헤더 자동검색 및 토글 패널 제어 */

document.addEventListener("DOMContentLoaded", function () {
    
    // 1. 공통 타겟 검색 폼 래핑 루프 (클래스 기반 다중 폼 제어)
    const searchModules = document.querySelectorAll(".search-module");
    
    searchModules.forEach(function (module) {
        const keywordInput = module.querySelector(".search-keyword-input");
        const suggestBox = module.querySelector(".search-suggest-box");
        
        const recentArea = module.querySelector(".search-recent-area");
        const recentList = module.querySelector(".search-recent-list");
        
        const autoArea = module.querySelector(".search-auto-area");
        const autoList = module.querySelector(".search-auto-list");

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
                recentList.innerHTML = '<li class="suggest-empty p-2 ps-3">최근 검색어가 없습니다.</li>';
            } else {
                let html = "";
                list.forEach(function (item) {
                    html += `<li class="suggest-item recent-item p-2 ps-3" data-keyword="${escapeHtml(item.keyword)}" style="cursor:pointer;">${escapeHtml(item.keyword)}</li>`;
                });
                recentList.innerHTML = html;
            }
            recentArea.classList.remove("d-none");
        }

        function renderAutoComplete(list) {
            if (!list || list.length === 0) {
                autoList.innerHTML = '<li class="suggest-empty p-2 ps-3">추천 검색어가 없습니다.</li>';
            } else {
                let html = "";
                list.forEach(function (item) {
                    html += `<li class="suggest-item auto-item p-2 ps-3" data-keyword="${escapeHtml(item)}" style="cursor:pointer;">${escapeHtml(item)}</li>`;
                });
                autoList.innerHTML = html;
            }
            autoArea.classList.remove("d-none");
        }

        function loadRecentKeywords() {
            fetch(`${window.location.pathname.substring(0, window.location.pathname.indexOf("/", 1))}/search/recent`, {
                method: "GET",
                headers: { "AJAX": "true" }
            })
            .then(res => res.json())
            .then(data => {
                autoArea.classList.add("d-none");
                autoList.innerHTML = "";
                renderRecentKeywords(data);
                openSuggestBox();
            })
            .catch(err => console.error("최근 검색어 조회 오류", err));
        }

        function loadAutoComplete(keyword) {
            fetch(`${window.location.pathname.substring(0, window.location.pathname.indexOf("/", 1))}/search/autocomplete?keyword=` + encodeURIComponent(keyword), {
                method: "GET",
                headers: { "AJAX": "true" }
            })
            .then(res => res.json())
            .then(data => {
                recentArea.classList.add("d-none");
                recentList.innerHTML = "";
                renderAutoComplete(data);
                openSuggestBox();
            })
            .catch(err => console.error("자동완성 조회 오류", err));
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

        // 추천어 클릭 및 바깥 클릭 제어 (모듈 독립 보장)
        document.addEventListener("click", function (e) {
            const target = e.target;
            
            // 해당 폼 내부 클릭 시 
            if (module.contains(target)) {
                if (target.classList.contains("recent-item") || target.classList.contains("auto-item")) {
                    const keyword = target.dataset.keyword;
                    keywordInput.value = keyword;
                    keywordInput.form.submit();
                }
            } else { // 폼 외부 클릭 시 모듈 내 검색박스 닫기
                if (target !== keywordInput) {
                    closeSuggestBox();
                }
            }
        });
    });

    // 2. 패널 토글 스크립트 연결 (is-open 단일 제어 방어 설계)
    const headerSearchToggleBtn = document.getElementById("headerSearchToggleBtn");
    const headerSearchPanel = document.getElementById("headerSearchPanel");

    // Null-safe 방어: 토글 버튼이 존재하는 경우에만
    if (headerSearchToggleBtn) {
        headerSearchToggleBtn.addEventListener("click", function(e) {
            e.preventDefault();
            if (!headerSearchPanel) return;
            
            const isOpen = headerSearchPanel.classList.toggle("is-open");
            
            // 패널 오픈 후 focus() 트리거: CSS transition과 충돌 없이 렌더링 완료 후 안전하게 focus 배정
            if (isOpen) {
                requestAnimationFrame(() => {
                    requestAnimationFrame(() => {
                        const input = headerSearchPanel.querySelector(".search-keyword-input");
                        if (input) input.focus();
                    });
                });
            }
        });
    }

    // 3. 바깥 화면 클릭 시 패널 우아하게 닫기 (contains 기반 제어)
    document.addEventListener("click", function (e) {
        if (!headerSearchPanel || !headerSearchToggleBtn) return;
        
        if (headerSearchPanel.classList.contains("is-open")) {
            // 타겟이 패널 내부도 아니고, 돋보기 버튼 내부도 아니라면 닫음
            if (!headerSearchPanel.contains(e.target) && !headerSearchToggleBtn.contains(e.target)) {
                headerSearchPanel.classList.remove("is-open");
            }
        }
    });

    // 4. 메인 전용 옵저버: 배너 폼 영역 연동 뷰체크 (header.js에서 통합 제어)
    const bannerSearchWrap = document.querySelector('.main-search-wrap');
    if (bannerSearchWrap && headerSearchToggleBtn) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) { 
                    // 배너가 10% 이상 화면에 걸치면: 토글 버튼 숨김
                    headerSearchToggleBtn.classList.add('d-none');
                    // 열려있던 패널이 혹시 있다면 즉시 강제로 안전 닫기
                    if (headerSearchPanel) headerSearchPanel.classList.remove('is-open');
                } else { 
                    // 배너가 10% 미만으로 넘어가면: 헤더에 돋보기 버튼 등장
                    headerSearchToggleBtn.classList.remove('d-none');
                }
            });
        }, { threshold: 0.1 }); 
        observer.observe(bannerSearchWrap);
    }
});