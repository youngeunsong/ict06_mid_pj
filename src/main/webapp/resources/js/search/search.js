let currentType = 'ALL';
let currentSort = 'popular';
let currentPage = 1;

// DOM 값 안전하게 읽기
function getValue(id) {
    const el = document.getElementById(id);
    return el ? el.value : '';
}

function getKeyword() {
    return getValue('searchKeyword');
}

function getRestListCnt() {
    return getValue('restListCnt');
}

function getAccListCnt() {
    return getValue('accListCnt');
}

function getFestListCnt() {
    return getValue('festListCnt');
}

// [공통] 인기순 / 최신순 라벨 반영
function updateSortLabel() {
    const sortLabel = document.querySelector('#viewFilterPage #sortLabel');
    if (sortLabel) {
        sortLabel.textContent = (currentSort === 'latest' ? '최신순' : '조회순');
    }
}

// [공통] 전체 화면 → 필터 화면
function switchToFilterView() {
    const allPage = document.getElementById('viewAllPage');
    const filterPage = document.getElementById('viewFilterPage');

    if (allPage) allPage.classList.add('d-none');
    if (filterPage) filterPage.classList.remove('d-none');
}

// [공통] 필터 화면 → 전체 화면
function switchToAllView() {
    const filterPage = document.getElementById('viewFilterPage');
    const allPage = document.getElementById('viewAllPage');

    if (filterPage) filterPage.classList.add('d-none');
    if (allPage) allPage.classList.remove('d-none');
}

// 전체뷰 버튼에서 호출
function openFilter(type) {
    currentType = type || 'ALL';
    currentPage = 1;

    if (currentType === 'ALL') {
        switchToAllView();
        return;
    }

    switchToFilterView();

    document.querySelectorAll('#viewFilterPage .chip-tabs .btn').forEach(function(btn) {
        btn.classList.remove('active');
        if (btn.dataset.type === currentType) {
            btn.classList.add('active');
        }
    });

    updateSortLabel();
    fetchResult();
}
window.openFilter = openFilter;

// 이벤트 캐러셀 페이지 표시 + 필터 탭 바인딩
document.addEventListener("DOMContentLoaded", function () {
    const eventCarousel = document.getElementById("eventCarousel");

    if (eventCarousel) {
        const items = eventCarousel.querySelectorAll(".carousel-item");
        const totalSlides = items.length;

        const pageInfo = document.getElementById("carouselPageInfo");
        const progressBar = document.getElementById("carouselProgress");

        function updateCarouselStatus(index) {
            const current = index + 1;

            if (pageInfo) {
                pageInfo.textContent = current + " / " + totalSlides;
            }

            if (progressBar) {
                progressBar.style.width = (current / totalSlides * 100) + "%";
            }
        }

        const activeIndex = Array.from(items).findIndex(item =>
            item.classList.contains("active")
        );
        updateCarouselStatus(activeIndex >= 0 ? activeIndex : 0);

        eventCarousel.addEventListener("slid.bs.carousel", function (e) {
            updateCarouselStatus(e.to);
        });
    }

    document.querySelectorAll('#viewFilterPage .chip-tabs .btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const type = this.dataset.type;

            if (type === "ALL") {
                currentType = "ALL";
                currentPage = 1;
                switchToAllView();
                return;
            }

            currentType = type;
            currentPage = 1;

            document.querySelectorAll('#viewFilterPage .chip-tabs .btn').forEach(function(b) {
                b.classList.remove('active');
            });

            this.classList.add('active');
            updateSortLabel();
            fetchResult();
        });
    });
});

// 필터 화면 정렬 변경
function changeSort(sort) {
    currentSort = sort;
    currentPage = 1;
    updateSortLabel();
    fetchResult();
}
window.changeSort = changeSort;

function getSectionCountText() {
    if (currentType === 'REST') return getRestListCnt();
    if (currentType === 'ACC')  return getAccListCnt();
    if (currentType === 'FEST') return getFestListCnt();
    return '';
}

// AJAX 요청
function fetchResult() {
    const keyword = getKeyword();

    const titleEl = document.getElementById('resultTitle');
    if (titleEl) {
        const countText = getSectionCountText();
        titleEl.innerHTML =
            '“<span class="text-success fw-semibold">' + keyword + '</span>”에 대한 검색결과'
            + (countText !== '' ? ' <span class="fw-semibold">' + countText + '개</span>' : '');
    }

    const contextPath = getValue('contextPath');
    const url = contextPath + '/search/ajax'
        + '?keyword=' + encodeURIComponent(keyword)
        + '&type=' + currentType
        + '&sort=' + currentSort
        + '&page=' + currentPage;

    fetch(url)
        .then(function(res) { return res.text(); })
        .then(function(html) {
            const wrap = document.getElementById('ajaxResultWrap');
            if (wrap) {
                wrap.innerHTML = html;
            }
        })
        .catch(function(err) {
            console.error('검색 오류:', err);
        });
}

// 하단 페이징 버튼 클릭
function goPage(page) {
    currentPage = page;
    fetchResult();
    window.scrollTo({ top: 0, behavior: 'smooth' });
}
window.goPage = goPage;