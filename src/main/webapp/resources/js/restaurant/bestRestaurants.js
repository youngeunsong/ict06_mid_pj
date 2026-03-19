document.addEventListener("DOMContentLoaded", function () {
    var rankingContent = document.getElementById("rankingContent");
    var regionSelect = document.getElementById("regionSelect");
    var recommendFilterArea = document.getElementById("recommendFilterArea");

    if (!rankingContent) return;

    var state = {
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
            recommendFilterArea.style.display =
                (state.tab === "recommend") ? "block" : "none";
        }
    }

    function renderMoreCards(list) {
        var html = "";

        list.forEach(function (place) {
            var placeId = (place.place_id !== null && place.place_id !== undefined) ? place.place_id : "";
            var imageUrl = escapeHtml(place.image_url || "");
            var name = escapeHtml(place.name || "");
            var address = escapeHtml(place.address || "");
            var viewCount = (place.view_count !== null && place.view_count !== undefined) ? place.view_count : 0;
            var avgRating = (place.avg_rating !== null && place.avg_rating !== undefined) ? place.avg_rating : 0;
            var reviewCount = (place.review_count !== null && place.review_count !== undefined) ? place.review_count : 0;

            html += ''
                + '<div class="col-6 col-md-4 col-lg-3 ranking-added-item">'
                + '    <a href="' + path + '/restaurantDetail.rs?place_id=' + placeId + '" class="place-card text-decoration-none text-dark">'
                + '        <div class="place-card__thumb-wrap position-relative">'
                + '            <img src="' + imageUrl + '" alt="' + name + '" loading="lazy" class="thumb-img" />'
                + '        </div>'
                + '        <div class="place-card__body">'
                + '            <div class="place-card__title">' + name + '</div>'
                + '            <div class="place-card__address">'
                + '                <i class="bi bi-geo-alt-fill text-danger"></i> '
                +                  address
                + '            </div>'
                + '            <div class="d-flex gap-3 text-muted small mt-2">'
                + '                <span><i class="fa-regular fa-eye"></i> ' + viewCount + '</span>'
                + '                <span><i class="fa-regular fa-heart"></i> ' + avgRating + '</span>'
                + '                <span><i class="fa-regular fa-comment"></i> ' + reviewCount + '</span>'
                + '            </div>'
                + '        </div>'
                + '    </a>'
                + '</div>';
        });

        return html;
    }

    function loadTabContent(tabType) {
        var url =
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

    // 탭 클릭
    document.querySelectorAll(".rk-tab").forEach(function (tab) {
        tab.addEventListener("click", function () {
            document.querySelectorAll(".rk-tab").forEach(function (t) {
                t.classList.remove("active");
            });

            this.classList.add("active");

            var tabType = this.dataset.tab || "realtime";
            state.tab = tabType;

            updateFilterVisibility();
            loadTabContent(tabType);
        });
    });

    // 지역 변경
    if (regionSelect) {
        regionSelect.addEventListener("change", function () {
            state.region = this.value || "all";

            if (state.tab === "region" || state.tab === "recommend") {
                loadTabContent(state.tab);
            }
        });
    }

    // 문서 전체 클릭 이벤트 위임
    document.addEventListener("click", function (e) {
        var moreBtn = e.target.closest("#moreBtn");
        var collapseBtn = e.target.closest("#collapseBtn");
        var filterMoreBtn = e.target.closest("#filterMoreBtn");
        var filterCollapseBtn = e.target.closest("#filterCollapseBtn");
        var chip = e.target.closest("#recommendChipWrap .rk-chip");

        // 추천 필터 칩 클릭
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

        // 추천 필터 더보기
        if (filterMoreBtn) {
            document.querySelectorAll(".extra-filter").forEach(function (item) {
                item.classList.remove("d-none");
            });

            filterMoreBtn.classList.add("d-none");

            var collapseFilterBtn = document.getElementById("filterCollapseBtn");
            if (collapseFilterBtn) {
                collapseFilterBtn.classList.remove("d-none");
            }
            return;
        }

        // 추천 필터 접기
        if (filterCollapseBtn) {
            document.querySelectorAll(".extra-filter").forEach(function (item) {
                item.classList.add("d-none");
            });

            filterCollapseBtn.classList.add("d-none");

            var moreFilterBtn = document.getElementById("filterMoreBtn");
            if (moreFilterBtn) {
                moreFilterBtn.classList.remove("d-none");
            }
            return;
        }

        // 랭킹 더보기
        if (moreBtn) {
            var moreListWrap = document.getElementById("moreListWrap");
            if (!moreListWrap) return;

            var offset = parseInt(moreBtn.dataset.offset || "17", 10);
            var limit = parseInt(moreBtn.dataset.limit || "12", 10);

            var url =
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
                    var collapseBtnNow = document.getElementById("collapseBtn");

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

            return;
        }

        // 랭킹 접기
        if (collapseBtn) {
            document.querySelectorAll(".ranking-added-item").forEach(function (item) {
                item.remove();
            });

            var moreBtnNow = document.getElementById("moreBtn");
            if (moreBtnNow) {
                var initialOffset = parseInt(moreBtnNow.dataset.initialOffset || "17", 10);
                moreBtnNow.dataset.offset = String(initialOffset);
                moreBtnNow.style.display = "inline-block";
            }

            collapseBtn.style.display = "none";
        }
    });

    updateFilterVisibility();
});