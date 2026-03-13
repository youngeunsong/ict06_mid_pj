document.addEventListener("DOMContentLoaded", function () {
    const moreBtn = document.getElementById("moreBtn");
    const collapseBtn = document.getElementById("collapseBtn");
    const moreListWrap = document.getElementById("moreListWrap");

    if (!moreBtn || !moreListWrap) return;

    // 처음 버튼에 들어있는 시작 offset / limit 저장
    const initialOffset = parseInt(moreBtn.dataset.offset, 10);
    const limit = parseInt(moreBtn.dataset.limit, 10);

    moreBtn.addEventListener("click", function () {
        const offset = parseInt(moreBtn.dataset.offset, 10);

        fetch(path + "/bestRestaurantsMore.rs?offset=" + offset + "&limit=" + limit)
            .then(response => response.json())
            .then(list => {
                if (!list || list.length === 0) {
                    moreBtn.style.display = "none";
                    collapseBtn.style.display = "inline-block";
                    return;
                }

                let html = "";

                list.forEach(function (place) {
                    html += `
                        <div class="col-6 col-md-4 col-lg-3 ranking-added-item">
                            <a href="${path}/restaurantDetail.rs?place_id=${place.place_id}" class="place-card text-decoration-none text-dark">
                                <div class="place-card__thumb-wrap position-relative">
                                    <img src="${place.image_url}" alt="${place.name}" loading="lazy" class="thumb-img" />
                                </div>

                                <div class="place-card__body">
                                    <div class="place-card__title">${place.name}</div>

                                    <div class="place-card__address">
                                        <i class="bi bi-geo-alt-fill text-danger"></i>
                                        ${place.address}
                                    </div>

                                    <div class="d-flex gap-3 text-muted small mt-2">
                                        <span><i class="fa-regular fa-eye"></i> ${place.view_count}</span>
                                        <span><i class="fa-regular fa-heart"></i> ${place.avg_rating}</span>
                                        <span><i class="fa-regular fa-comment"></i> ${place.review_count}</span>
                                    </div>
                                </div>
                            </a>
                        </div>
                    `;
                });

                moreListWrap.insertAdjacentHTML("beforeend", html);

                // 더보기 한번이라도 했으면 접기 버튼 보이기
                collapseBtn.style.display = "inline-block";

                // 다음 요청 위치 갱신
                moreBtn.dataset.offset = offset + limit;

                // 이번에 받아온 개수가 limit보다 적으면 마지막 데이터
                if (list.length < limit) {
                    moreBtn.style.display = "none";
                }
            })
            .catch(error => {
                console.error("더보기 로딩 실패:", error);
            });
    });

    collapseBtn.addEventListener("click", function () {
        // AJAX로 추가된 카드들만 제거
        document.querySelectorAll(".ranking-added-item").forEach(function (item) {
            item.remove();
        });

        // 버튼 상태 초기화
        moreBtn.dataset.offset = initialOffset;
        moreBtn.style.display = "inline-block";
        collapseBtn.style.display = "none";
    });
});