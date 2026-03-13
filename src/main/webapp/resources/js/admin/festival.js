/**
 * 관리자 > 축제 전체목록 > 상세조회
 */

//태그 토글
function toggleTag(el) {
	el.classList.toggle('active');
}

//검색 필터(체크박스)
function filterData() {
	const statusList = [];
	document.querySelectorAll('.tag-success.active, .tag-warning.active, .tag-secondary.active')
		.forEach(function(el) {
			if(el.dataset.value) statusList.push(el.dataset.value);	
		});
		
	const params = [];
	const sortType = document.getElementById('sortType').value;
	if(statusList.length > 0) params.push('status=' + statusList.join(','));
	if(sortType) params.push('sortType=' + sortType);
	
	location.href = path + '/festivalList.adpl' +
	(params.length > 0 ? '?' + params.join('&') : '');
}

//URL 파라미터 -> 태그 복원
$(document).ready(function() {
	const urlParams = new URLSearchParams(window.location.search);
	const statusParam = urlParams.get('status');
	const sortParam = urlParams.get('sortType');
	
	if(statusParam) {
		statusParam.split(',').forEach(function(val) {
			document.querySelectorAll('.tag[data-value="' + val + '"]')
				.forEach(function(el) {
					el.classList.add('active');
				});
		});
	}
	
	if(sortParam) {
		document.getElementById('sortType').value = sortParam;
	}
});

/* 키워드 검색 */
function keywordSearch() {
	const keyword = $('#keyword').val().trim();
	const sortType = document.getElementById('sortType').value;
	
	if(!keyword) {
		alert('축제명 혹은 설명에 해당하는 키워드를 입력해주세요!'); // TODO: 어떤 키워드를 넣을 수 있을 지 체크 
		return;
	}
	location.href = path + '/festivalList.adpl?keyword=' + encodeURIComponent(keyword)
					+ (sortType ? '&sortType=' + sortType : '');
}

/* 축제 상세 정보 조회 modal */

/* 축제 수정 modal */
/* 축제 수정 처리 */ 
