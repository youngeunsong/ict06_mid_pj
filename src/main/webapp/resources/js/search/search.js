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

// [ 공통 ] : 인기순 최신순 선택 라벨 반영
function updateSortLabel() {
    var sortLabel = document.querySelector('#viewFilterPage #sortLabel');
    if (sortLabel) {
        sortLabel.textContent = (currentSort === 'latest' ? '최신순' : '인기순');
    }
}

// [ 공통 ] : 전체 화면 → 필터 화면 전환
function switchToFilterView() {
    const allPage = document.getElementById('viewAllPage');
    const filterPage = document.getElementById('viewFilterPage');

    if (allPage) allPage.classList.add('d-none');
    if (filterPage) filterPage.classList.remove('d-none');
}

// [ 공통 ] : 필터 화면 → 전체 화면 전환
function switchToAllView() {
    const filterPage = document.getElementById('viewFilterPage');
    const allPage = document.getElementById('viewAllPage');

    if (filterPage) filterPage.classList.add('d-none');
    if (allPage) allPage.classList.remove('d-none');
}

/* 전체뷰 버튼에서 호출
* type: 'ALL'|'REST'|'ACC'|'FEST' => 카테고리 타입
* sort: optional ('popular'|'latest') => 인기순 | 최신순
*/

// [ 전체화면 : 기본화면 ] : 인기순 | 최신순 버튼 클릭 시
function openFilter(type, el) {
    switchToFilterView();

    currentType = type || 'ALL';
    currentPage = 1;

    document.querySelectorAll('.filter-tabs .nav-link').forEach(function(link) {
        link.classList.remove('active');
    });

    if (el) {
        el.classList.add('active');
    }

    updateSortLabel();
    fetchResult();
}

// 전역 노출 (inline onclick 대응)
window.openFilter = openFilter;

// [ 전체화면 : 기본화면 ] : 이벤트 캐러셀 페이지 표시
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

    // [ 필터(AJAX) 화면 ] : 클릭 된 상단버튼(전체|맛집|숙소|축제)에 active 삽입
    document.querySelectorAll('#viewFilterPage .chip-tabs .btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const type = this.dataset.type;

            if (type === "ALL") {
                switchToAllView();
                return;
            }

            currentType = type;
            currentPage = 1;

            document.querySelectorAll('#viewFilterPage .chip-tabs .btn').forEach(function(b) {
                b.classList.remove('active');
            });

            this.classList.add('active');
            fetchResult();
        });
    });
});

// [ 필터(AJAX) 화면 ] : 인기순 최신순 선택 라벨 반영에 따른 값 변환
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

// [ 필터(AJAX) 화면 ] : AJAX 요청
function fetchResult() {
    const keyword = getKeyword();

    var titleEl = document.getElementById('resultTitle');
    if (titleEl) {
        var countText = getSectionCountText();

        titleEl.innerHTML =
            '“<span class="text-success fw-semibold">' + keyword + '</span>”에 대한 검색결과'
            + (countText !== '' ? ' <span class="fw-semibold">' + countText + '개</span>' : '');
    }

    var url = '/midpj/search/ajax'
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

/* ── 페이징 렌더링 ── */
function renderPaging(totalPages, page) {
    var paging = document.getElementById('pagination');

    if (!paging) return;

    if (totalPages <= 1) {
        paging.innerHTML = '';
        return;
    }

    var groupStart = Math.floor((page - 1) / 10) * 10 + 1;
    var groupEnd = Math.min(groupStart + 9, totalPages);
    var html = '';

    html += '<button class="btn btn-sm btn-outline-secondary"';
    html += ' onclick="goPage(' + (page - 1) + ')"';
    html += (page === 1 ? ' disabled' : '') + '>&lsaquo;</button>';

    for (var i = groupStart; i <= groupEnd; i++) {
        var btnClass = (i === page) ? 'btn-success' : 'btn-outline-secondary';
        html += '<button class="btn btn-sm ' + btnClass + '"';
        html += ' onclick="goPage(' + i + ')">' + i + '</button>';
    }

    html += '<button class="btn btn-sm btn-outline-secondary"';
    html += ' onclick="goPage(' + (page + 1) + ')"';
    html += (page === totalPages ? ' disabled' : '') + '>&rsaquo;</button>';

    paging.innerHTML = html;
}

// [ 필터(AJAX) 화면 ] : 하단 페이징 버튼 클릭 시 부드럽게 최상단(0)으로 이동
function goPage(page) {
    currentPage = page;
    fetchResult();
    window.scrollTo({ top: 0, behavior: 'smooth' });
}
window.goPage = goPage;