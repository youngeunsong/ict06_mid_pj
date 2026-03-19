document.addEventListener("DOMContentLoaded", function () {
    const rankingContent = document.getElementById("rankingContent");
    const regionSelect = document.getElementById("regionSelect");
    const recommendFilterArea = document.getElementById("recommendFilterArea");

    if (!rankingContent) return;

    const state = {
        tab: "realtime",
        region: "all",
        category: "ALL"
    };

    function escapeHtml(value) {
        if (value === null || value === undefined) return "";
        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    function updateFilterVisibility() {
        if (regionSelect) {
            regionSelect.style.display =
                (state.tab === "region" || state.tab === "recommend") ? "block" : "none";
        }

        if (recommendFilterArea) {
            recommendFilterArea.style.display = (state.tab === "recommend") ? "block" : "none";
        }
    }

    function renderMoreCards(list, startRank) {
    let html = "";

    list.forEach(function (place, index) {
        const placeDTO = place.placeDTO || {};

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
        const rank = startRank + index;

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
                                 onerror="this.src='${path}/resources/images/common/no-image.png';" />

                            <span class="rank-badge rank-default">${rank}위</span>
                        </div>

                        <div class="place-card__body">
                            <div class="place-card__title">${name}</div>

                            ${category ? `<div class="big-rest-card__category">${category}</div>` : ""}

                            <div class="place-card__address">
                                <i class="bi bi-geo-alt-fill text-danger"></i>
                                ${address}
                            </div>

                            ${description ? `<div class="big-rest-card__desc">${description}</div>` : ""}

                            <div class="place-card__meta">
                                <span><i class="fa-regular fa-eye"></i> ${viewCount}</span>
                                <span><i class="fa-regular fa-heart"></i> ${avgRating}</span>
                                <span><i class="fa-regular fa-comment"></i> ${reviewCount}</span>
                            </div>

                            ${phone ? `<div class="big-rest-card__phone"><i class="fa-solid fa-phone"></i> ${phone}</div>` : ""}
                            ${status ? `<div class="big-rest-card__status">${status}</div>` : ""}
                        </div>
                    </a>
                </div>
            </div>
        `;
    });

    return html;
}

    function loadTabContent(tabType) {
        const url =
            path +
            "/bestRestaurantsTabAjax.rs?tab=" + encodeURIComponent(tabType) +
            "&region=" + encodeURIComponent(state.region) +
            "&category=" + encodeURIComponent(state.category);

        fetch(url)
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("HTTP " + response.status);
                }
                return response.text();
            })
            .then(function (html) {
                rankingContent.innerHTML = html;
            })
            .catch(function (error) {
                console.error("탭 콘텐츠 로딩 실패:", error);
            });
    }

    document.querySelectorAll(".rk-tab").forEach(function (tab) {
        tab.addEventListener("click", function () {
            document.querySelectorAll(".rk-tab").forEach(function (t) {
                t.classList.remove("active");
            });

            this.classList.add("active");

            const tabType = this.dataset.tab || "realtime";
            state.tab = tabType;

            updateFilterVisibility();
            loadTabContent(tabType);
        });
    });

    if (regionSelect) {
        regionSelect.addEventListener("change", function () {
            state.region = this.value || "all";

            if (state.tab === "region" || state.tab === "recommend") {
                loadTabContent(state.tab);
            }
        });
    }

    document.addEventListener("click", function (e) {
        const moreBtn = e.target.closest("#moreBtn");
        const collapseBtn = e.target.closest("#collapseBtn");
        const filterMoreBtn = e.target.closest("#filterMoreBtn");
        const filterCollapseBtn = e.target.closest("#filterCollapseBtn");
        const chip = e.target.closest("#recommendChipWrap .rk-chip");

        if (chip) {
            document.querySelectorAll("#recommendChipWrap .rk-chip").forEach(function (btn) {
                btn.classList.remove("active");
            });

            chip.classList.add("active");
            state.category = chip.dataset.category || "ALL";

            if (state.tab === "recommend") {
                loadTabContent("recommend");
            }
            return;
        }

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

        if (moreBtn) {
            const moreListWrap = document.getElementById("moreListWrap");
            if (!moreListWrap) return;

            const offset = parseInt(moreBtn.dataset.offset || "17", 10);
            const limit = parseInt(moreBtn.dataset.limit || "12", 10);

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

                    if (!list || list.length === 0) {
                        moreBtn.style.display = "none";
                        if (collapseBtnNow) {
                            collapseBtnNow.style.display = "inline-block";
                        }
                        return;
                    }

                    const startRank = offset + 1;
					moreListWrap.insertAdjacentHTML("beforeend", renderMoreCards(list, startRank));

                    if (collapseBtnNow) {
                        collapseBtnNow.style.display = "inline-block";
                    }

                    moreBtn.dataset.offset = String(offset + limit);

                    if (list.length < limit) {
                        moreBtn.style.display = "none";
                    }
                })
                .catch(function (error) {
                    console.error("더보기 로딩 실패:", error);
                });

            return;
        }

        if (collapseBtn) {
            document.querySelectorAll(".ranking-added-item").forEach(function (item) {
                item.remove();
            });

            const moreBtnNow = document.getElementById("moreBtn");
            if (moreBtnNow) {
                const initialOffset = parseInt(moreBtnNow.dataset.initialOffset || "17", 10);
                moreBtnNow.dataset.offset = String(initialOffset);
                moreBtnNow.style.display = "inline-block";
            }

            collapseBtn.style.display = "none";
        }
    });

    updateFilterVisibility();
});