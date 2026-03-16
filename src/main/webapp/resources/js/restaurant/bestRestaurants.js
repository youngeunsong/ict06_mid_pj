document.addEventListener("DOMContentLoaded", function () {
    const rankingContent = document.getElementById("rankingContent");
    if (!rankingContent) return;

    const state = {
        tab: "realtime"
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

    function renderMoreCards(list) {
        let html = "";

        list.forEach(function (place) {
            const placeId = place.place_id ?? "";
            const imageUrl = escapeHtml(place.image_url || "");
            const name = escapeHtml(place.name || "");
            const address = escapeHtml(place.address || "");
            const viewCount = place.view_count ?? 0;
            const avgRating = place.avg_rating ?? 0;
            const reviewCount = place.review_count ?? 0;

            html += `
                <div class="col-6 col-md-4 col-lg-3 ranking-added-item">
                    <a href="${path}/restaurantDetail.rs?place_id=${placeId}" class="place-card text-decoration-none text-dark">
                        <div class="place-card__thumb-wrap position-relative">
                            <img src="${imageUrl}" alt="${name}" loading="lazy" class="thumb-img" />
                        </div>

                        <div class="place-card__body">
                            <div class="place-card__title">${name}</div>

                            <div class="place-card__address">
                                <i class="bi bi-geo-alt-fill text-danger"></i>
                                ${address}
                            </div>

                            <div class="d-flex gap-3 text-muted small mt-2">
                                <span><i class="fa-regular fa-eye"></i> ${viewCount}</span>
                                <span><i class="fa-regular fa-heart"></i> ${avgRating}</span>
                                <span><i class="fa-regular fa-comment"></i> ${reviewCount}</span>
                            </div>
                        </div>
                    </a>
                </div>
            `;
        });

        return html;
    }

    function loadTabContent(tabType) {
        fetch(path + "/bestRestaurantsTabAjax.rs?tab=" + encodeURIComponent(tabType))
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

    // 탭 클릭
    document.querySelectorAll(".rk-tab").forEach(function (tab) {
        tab.addEventListener("click", function () {
            document.querySelectorAll(".rk-tab").forEach(function (t) {
                t.classList.remove("active");
            });

            this.classList.add("active");

            const tabType = this.dataset.tab || "realtime";
            state.tab = tabType;

            loadTabContent(tabType);
        });
    });

    // 더보기 / 접기 : 이벤트 위임
    document.addEventListener("click", function (e) {
        const moreBtn = e.target.closest("#moreBtn");
        const collapseBtn = e.target.closest("#collapseBtn");

        if (moreBtn) {
            const moreListWrap = document.getElementById("moreListWrap");
            if (!moreListWrap) return;

            const offset = parseInt(moreBtn.dataset.offset || "17", 10);
            const limit = parseInt(moreBtn.dataset.limit || "12", 10);

            fetch(
                path +
                "/bestRestaurantsMore.rs?tab=" +
                encodeURIComponent(state.tab) +
                "&offset=" +
                offset +
                "&limit=" +
                limit
            )
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

                    moreListWrap.insertAdjacentHTML("beforeend", renderMoreCards(list));

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
});