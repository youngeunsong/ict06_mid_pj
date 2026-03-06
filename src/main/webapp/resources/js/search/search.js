

// [ 공통 ] : 인기순 최신순 선택 라벨 반영
function updateSortLabel(){
	var sortLabel = document.querySelector('#viewFilterPage #sortLabel');
	if(sortLabel) sortLabel.textContent = (currentSort === 'latest' ? '최신순' : '인기순');
}


// [ 공통 ] : 전체 화면 → 필터 화면 전환
function switchToFilterView(){
	document.getElementById('viewAllPage').classList.add('d-none');
	document.getElementById('viewFilterPage').classList.remove('d-none');
}

// [ 공통 ] : 필터 화면 → 전체 화면 전환
function switchToAllView() {
  document.getElementById('viewFilterPage').classList.add('d-none');
  document.getElementById('viewAllPage').classList.remove('d-none');
}


/* 전체뷰 버튼에서 호출
* type: 'ALL'|'REST'|'ACC'|'FEST' => 카테고리 타입
*sort: optional ('popular'|'latest') => 인기순 | 최신순
*/

const keyword     = document.getElementById('searchKeyword').value;
let   currentType = 'ALL';
let   currentSort = 'popular';
let   currentPage = 1;

// (미사용) [ 전체화면 : 기본화면 ] : 인기순 | 최신순 버튼 클릭 시
function openFilter(type, sort){
	switchToFilterView();
	
	currentType = type || 'ALL';
	if(sort) currentSort = sort;
	currentPage = 1;
	
	//필터뷰 탭 active 동기화
	document.querySelectorAll('#viewFilterPage .chip-tabs .btn').forEach(function(b){
		b.classList.toggle('active', b.dataset.type === currentType);
	});
	
	updateSortLabel();	 	
	fetchResult();
}

// [ 전체화면 : 기본화면 ] : 이벤트 캐러셀 페이지 표시
/*
const eventCarousel = document.getElementById('eventCarousel');
if (eventCarousel) {
    const totalSlides = eventCarousel.querySelectorAll('.carousel-item').length;

    eventCarousel.addEventListener('slid.bs.carousel', function (e) {
        const current = e.to + 1;  // 0부터 시작이라 +1
        document.getElementById('carouselPageInfo').textContent = current + ' / ' + totalSlides;
        document.getElementById('carouselProgress').style.width = (current / totalSlides * 100) + '%';
    });
}
*/

// [ 필터(AJAX) 화면 ] : 클릭 된 상단버튼(전체|맛집|숙소|축제)에 active 삽입
document.querySelectorAll('#viewFilterPage .chip-tabs .btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
    
    	const type = this.dataset.type;
    	
    	if(type === "ALL"){
    		switchToAllView();
      		return;
    	}
    	
    	currentType = type;
    	currentPage = 1;
    	
        document.querySelectorAll('#viewFilterPage .chip-tabs .btn').forEach(function(b) {
        	b.classList.remove('active');
        });
        
        fetchResult();
    });
});

// [ 필터(AJAX) 화면 ] : 인기순 최신순 선택 라벨 반영에 따른 값 변환
function changeSort(sort) {
    currentSort = sort;
    currentPage = 1;
    
    updateSortLabel();
    fetchResult();
}

//[ 필터(AJAX) 화면 ] : AJAX 요청
function fetchResult() {
    // 타이틀 먼저 갱신
	var titleEl = document.getElementById('resultTitle');
	if(titleEl){
		titleEl.innerHTML =
			'“<span class="text-success fw-semibold">' + keyword + '</span>”에 대한 검색결과';
	}
    
    var url = '/midpj/search/ajax'
            + '?keyword=' + encodeURIComponent(keyword)
            + '&type='    + currentType
            + '&sort='    + currentSort
            + '&page='    + currentPage;

    fetch(url)
    .then(function(res){ return res.text(); })
    .then(function(html){
      document.getElementById('ajaxResultWrap').innerHTML = html;
    })
    .catch(function(err){ console.error('검색 오류:', err); });
}

/* ── 페이징 렌더링 ── */
function renderPaging(totalPages, page) {
    var paging = document.getElementById('pagination');

    if (totalPages <= 1) {
        paging.innerHTML = '';
        return;
    }

    var groupStart = Math.floor((page - 1) / 10) * 10 + 1;
    var groupEnd   = Math.min(groupStart + 9, totalPages);
    var html       = '';

    // 이전 버튼
    html += '<button class="btn btn-sm btn-outline-secondary"';
    html += ' onclick="goPage(' + (page - 1) + ')"';
    html += (page === 1 ? ' disabled' : '') + '>&lsaquo;</button>';

    // 페이지 번호
    for (var i = groupStart; i <= groupEnd; i++) {
        var btnClass = (i === page) ? 'btn-success' : 'btn-outline-secondary';
        html += '<button class="btn btn-sm ' + btnClass + '"';
        html += ' onclick="goPage(' + i + ')">' + i + '</button>';
    }

    // 다음 버튼
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
