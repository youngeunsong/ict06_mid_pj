// [랭킹 페이지 초기 설정]
// 맛집 랭킹 페이지 진입 시 탭, 필터, 더보기 기능을 한 번에 연결하기 위해 사용
document.addEventListener("DOMContentLoaded", function () {
    const rankingContent = document.getElementById("rankingContent");
    const regionSelect = document.getElementById("regionSelect");
    const recommendFilterArea = document.getElementById("recommendFilterArea");

    // [랭킹 페이지 전용 스크립트 보호]
    // 다른 페이지에서 이 JS가 같이 로드되어도 오류 없이 종료되도록 사용
    if (!rankingContent) return;

    // [현재 선택 상태 관리]
    // 탭/지역/카테고리 값을 한곳에서 관리해서 AJAX 요청 시 계속 재사용하기 위해 사용
    const state = {
        tab: "realtime",
        region: "all",
        category: "ALL"
    };

    // [출력 데이터 문자 이스케이프]
    // 서버에서 받은 문자열을 그대로 HTML에 넣을 때 특수문자 해석을 막기 위해 사용
    function escapeHtml(value) {
        if (value === null || value === undefined) return "";
        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    // [탭별 필터 표시 제어]
    // 현재 탭에 따라 필요한 필터만 화면에 보여주기 위해 사용
    function updateFilterVisibility() {
        if (regionSelect) {
            regionSelect.style.display =
                (state.tab === "region" || state.tab === "recommend") ? "block" : "none"; // 지역/추천 탭에서만 지역 선택 표시
        }

        if (recommendFilterArea) {
            recommendFilterArea.style.display = (state.tab === "recommend") ? "block" : "none"; // 추천 탭에서만 카테고리 필터 표시
        }
    }

    // [더보기 카드 HTML 생성]
    // 더보기 버튼으로 불러온 데이터를 기존 BigRestCard 스타일과 동일하게 출력하기 위해 사용
    function renderMoreCards(list, startRank) {
        let html = "";

        list.forEach(function (place, index) {
            const placeDTO = place.placeDTO || {}; // placeDTO가 없을 경우를 대비한 기본 객체

            const placeId = placeDTO.place_id || "";
            const imageUrl = escapeHtml(placeDTO.image_url || "");
            const name = escapeHtml(placeDTO.name || "");
            const address = escapeHtml(placeDTO.address || "");
            const viewCount = placeDTO.view_count || 0;
            const avgRating = placeDTO.avg_rating || 0;
            const reviewCount = placeDTO.review_count || 0;

            const category = escapeHtml(place.category || "");
            const description = escapeHtml(place.description || "");
            const phone = escapeHtml(place.phone || "");
            const status = escapeHtml(place.status || "");

            const rank = startRank + index; // 시작 순위에서 index만큼 증가시켜 이어지는 순위 계산

            html += `
                <div class="col-6 col-md-4 col-lg-3 ranking-added-item">
                    <div class="place-card-wrap position-relative big-rest-card-wrap">
                        <a href="${path}/restaurantDetail.rs?place_id=${placeId}"
                           class="place-card big-rest-card text-decoration-none text-dark d-block">

                            <div class="place-card__thumb-wrap position-relative">
                                <img src="${imageUrl}"
                                     alt="${name}"
                                     loading="lazy"
                                     class="thumb-img"
                                     onerror="this.src='${path}/resources/images/common/no-image.png';" /> <!-- 이미지 없을 때 기본 이미지로 대체 -->

                                <span class="rank-badge rank-default">${rank}위</span>
                            </div>

                            <div class="place-card__body">
                                <div class="place-card__title">${name}</div>

                                ${category ? `<div class="big-rest-card__category">${category}</div>` : ""} <!-- 값이 있을 때만 카테고리 표시 -->

                                <div class="place-card__address">
                                    <i class="bi bi-geo-alt-fill text-danger"></i>
                                    ${address}
                                </div>

                                ${description ? `<div class="big-rest-card__desc">${description}</div>` : ""} <!-- 설명이 있을 때만 표시 -->

                                <div class="place-card__meta">
                                    <span><i class="fa-regular fa-eye"></i> ${viewCount}</span>
                                    <span><i class="fa-regular fa-heart"></i> ${avgRating}</span>
                                    <span><i class="fa-regular fa-comment"></i> ${reviewCount}</span>
                                </div>

                                ${phone ? `<div class="big-rest-card__phone"><i class="fa-solid fa-phone"></i> ${phone}</div>` : ""} <!-- 전화번호가 있을 때만 표시 -->
                                ${status ? `<div class="big-rest-card__status">${status}</div>` : ""} <!-- 상태값이 있을 때만 표시 -->
                            </div>
                        </a>
                    </div>
                </div>
            `;
        });

        return html;
    }

    // [탭별 콘텐츠 AJAX 로딩]
    // 실시간/지역/추천 탭 전환 시 페이지 전체 이동 없이 랭킹 영역만 교체하기 위해 사용
    function loadTabContent(tabType) {
        const url =
            path +
            "/bestRestaurantsTabAjax.rs?tab=" + encodeURIComponent(tabType) +
            "&region=" + encodeURIComponent(state.region) +
            "&category=" + encodeURIComponent(state.category);

        fetch(url)
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("HTTP " + response.status); // 서버 응답이 비정상이면 catch로 넘김
                }
                return response.text();
            })
            .then(function (html) {
                rankingContent.innerHTML = html; // 랭킹 영역만 새 HTML로 교체
            })
            .catch(function (error) {
                console.error("탭 콘텐츠 로딩 실패:", error);
            });
    }

    // [탭 클릭 이벤트]
    // 사용자가 선택한 탭을 활성화하고 해당 조건의 랭킹 데이터를 다시 불러오기 위해 사용
    document.querySelectorAll(".rk-tab").forEach(function (tab) {
        tab.addEventListener("click", function () {
            document.querySelectorAll(".rk-tab").forEach(function (t) {
                t.classList.remove("active"); // 기존 활성 탭 해제
            });

            this.classList.add("active");

            const tabType = this.dataset.tab || "realtime"; // data-tab 값이 없으면 실시간 탭으로 처리
            state.tab = tabType;

            updateFilterVisibility();
            loadTabContent(tabType);
        });
    });

    // [지역 선택 이벤트]
    // 지역 TOP 또는 추천 탭에서 선택된 지역 기준으로 랭킹을 다시 조회하기 위해 사용
    if (regionSelect) {
        regionSelect.addEventListener("change", function () {
            state.region = this.value || "all"; // 값이 없으면 전체 지역으로 처리

            if (state.tab === "region" || state.tab === "recommend") {
                loadTabContent(state.tab);
            }
        });
    }

    // [공통 클릭 이벤트 위임]
    // 동적으로 바뀌는 더보기/접기/필터 버튼까지 한 번에 처리하기 위해 이벤트 위임 방식 사용
    document.addEventListener("click", function (e) {
        const moreBtn = e.target.closest("#moreBtn");
        const collapseBtn = e.target.closest("#collapseBtn");
        const filterMoreBtn = e.target.closest("#filterMoreBtn");
        const filterCollapseBtn = e.target.closest("#filterCollapseBtn");
        const chip = e.target.closest("#recommendChipWrap .rk-chip");

        // [추천 카테고리 선택]
        // 추천 탭에서 선택한 카테고리 기준으로 데이터를 다시 불러오기 위해 사용
        if (chip) {
            document.querySelectorAll("#recommendChipWrap .rk-chip").forEach(function (btn) {
                btn.classList.remove("active");
            });

            chip.classList.add("active");
            state.category = chip.dataset.category || "ALL"; // data-category 값이 없으면 전체 처리

            if (state.tab === "recommend") {
                loadTabContent("recommend");
            }
            return;
        }

        // [추천 필터 펼치기]
        // 기본 필터 외에 숨겨둔 추가 카테고리를 보여주기 위해 사용
        if (filterMoreBtn) {
            document.querySelectorAll(".extra-filter").forEach(function (item) {
                item.classList.remove("d-none");
            });

            filterMoreBtn.classList.add("d-none");

            const btn = document.getElementById("filterCollapseBtn");
            if (btn) {
                btn.classList.remove("d-none");
            }
            return;
        }

        // [추천 필터 접기]
        // 펼친 추가 카테고리를 다시 숨겨서 필터 영역을 간단히 유지하기 위해 사용
        if (filterCollapseBtn) {
            document.querySelectorAll(".extra-filter").forEach(function (item) {
                item.classList.add("d-none");
            });

            filterCollapseBtn.classList.add("d-none");

            const btn = document.getElementById("filterMoreBtn");
            if (btn) {
                btn.classList.remove("d-none");
            }
            return;
        }

        // [더보기 기능]
        // 현재 탭/필터 상태를 유지한 채 다음 랭킹 데이터를 추가 조회하기 위해 사용
        if (moreBtn) {
            const moreListWrap = document.getElementById("moreListWrap");
            if (!moreListWrap) return;

            const offset = parseInt(moreBtn.dataset.offset || "17", 10); // 기본 시작값 17: TOP5 + 초기 출력 이후 다음 구간
            const limit = parseInt(moreBtn.dataset.limit || "12", 10);   // 한 번에 불러올 카드 수

            const url =
                path +
                "/bestRestaurantsMore.rs?tab=" +
                encodeURIComponent(state.tab) +
                "&region=" +
                encodeURIComponent(state.region) +
                "&category=" +
                encodeURIComponent(state.category) +
                "&offset=" +
                offset +
                "&limit=" +
                limit;

            fetch(url)
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("HTTP " + response.status);
                    }
                    return response.json();
                })
                .then(function (list) {
                    const collapseBtnNow = document.getElementById("collapseBtn");

                    // [추가 데이터 없음 처리]
                    // 더 불러올 데이터가 없으면 더보기 버튼을 숨기고 접기 버튼만 유지하기 위해 사용
                    if (!list || list.length === 0) {
                        moreBtn.style.display = "none";
                        if (collapseBtnNow) {
                            collapseBtnNow.style.display = "inline-block";
                        }
                        return;
                    }

                    const startRank = offset + 1; // 현재 offset 다음 번호부터 순위를 이어서 표시
                    moreListWrap.insertAdjacentHTML("beforeend", renderMoreCards(list, startRank)); // 기존 목록 뒤에 추가 카드 삽입

                    if (collapseBtnNow) {
                        collapseBtnNow.style.display = "inline-block";
                    }

                    moreBtn.dataset.offset = String(offset + limit); // 다음 더보기 요청을 위해 offset 갱신

                    if (list.length < limit) {
                        moreBtn.style.display = "none"; // 요청 수보다 적게 오면 마지막 데이터로 판단
                    }
                })
                .catch(function (error) {
                    console.error("더보기 로딩 실패:", error);
                });

            return;
        }

        // [접기 기능]
        // 더보기로 추가된 카드만 제거하고 초기 랭킹 리스트 상태로 되돌리기 위해 사용
        if (collapseBtn) {
            document.querySelectorAll(".ranking-added-item").forEach(function (item) {
                item.remove(); // 더보기로 붙인 카드만 삭제
            });

            const moreBtnNow = document.getElementById("moreBtn");
            if (moreBtnNow) {
                const initialOffset = parseInt(moreBtnNow.dataset.initialOffset || "17", 10); // 최초 시작 offset 복원
                moreBtnNow.dataset.offset = String(initialOffset);
                moreBtnNow.style.display = "inline-block";
            }

            collapseBtn.style.display = "none";
        }
    });

    // [초기 필터 상태 적용]
    // 첫 진입 시 기본 탭에 맞는 필터만 보이도록 맞춰주기 위해 사용
    updateFilterVisibility();
});