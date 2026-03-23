/*
 * @author 송영은
 * 최초작성일: 2026-03-20
 * 최종수정일: 2026-03-23
 * 참고 코드: bestRestaurants.js
*/

// [랭킹 페이지 초기 설정]
// 맛집 랭킹 페이지 진입 시 더보기 기능 구현
document.addEventListener("DOMContentLoaded", function () {
    const rankingContent = document.getElementById("rankingContent");

    // [랭킹 페이지 전용 스크립트 보호]
    // 다른 페이지에서 이 JS가 같이 로드되어도 오류 없이 종료되도록 사용
    if (!rankingContent) return;

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

    // 날짜 데이터 포맷 처리 함수 : '월.일' 포맷으로 변환 
    function formatDate(dateStr) {
        if (!dateStr) return "";

        const d = new Date(dateStr);

        const month = d.getMonth() + 1;
        const day = String(d.getDate()).padStart(2, '0');

        return `${month}.${day}`;
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

            const start_date = escapeHtml(place.start_date || "");
            const end_date = escapeHtml(place.end_date || "");

            const description = escapeHtml(place.description || "");
            const status = escapeHtml(place.status || "");

            const rank = startRank + index; // 시작 순위에서 index만큼 증가시켜 이어지는 순위 계산

            html += `
                <div class="col-6 col-md-4 col-lg-3 ranking-added-item">
                    <div class="place-card-wrap position-relative big-rest-card-wrap">
                        <a href="${path}/festivalDetail.fe?place_id=${placeId}"
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

                                ${start_date || end_date ? `
                                <div class="big-rest-card__phone">
                                    <i class="bi bi-calendar-event"></i>
                                    ${formatDate(start_date)} ~ ${formatDate(end_date)}
                                </div>` : ""} <!-- start_date 혹은 end_date 있는 경우에만 표시 -->

                                ${status ? `<div class="big-rest-card__status">${status}</div>` : ""} <!-- 상태값이 있을 때만 표시 -->
                            </div>
                        </a>
                    </div>
                </div>
            `;
        });

        return html;
    }

    // [공통 클릭 이벤트 위임]
    // 동적으로 바뀌는 더보기/접기/필터 버튼까지 한 번에 처리하기 위해 이벤트 위임 방식 사용
    document.addEventListener("click", function (e) {
        const moreBtn = e.target.closest("#moreBtn");
        const collapseBtn = e.target.closest("#collapseBtn");

        // [더보기 기능]
        // 현재 탭/필터 상태를 유지한 채 다음 랭킹 데이터를 추가 조회하기 위해 사용
        if (moreBtn) {
            const moreListWrap = document.getElementById("moreListWrap");
            if (!moreListWrap) return;

            const offset = parseInt(moreBtn.dataset.offset || "17", 10); // 기본 시작값 17: TOP5 + 초기 출력 이후 다음 구간
            const limit = parseInt(moreBtn.dataset.limit || "12", 10);   // 한 번에 불러올 카드 수

            const url =
                path +
                "/bestFestivalsMore.fe?offset=" +
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
});