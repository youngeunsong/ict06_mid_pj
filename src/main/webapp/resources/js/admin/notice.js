/* ========================================
   notice.js - 관리자 > 공지/이벤트 관리 공통 JS
   ========================================*/

$(document).ready(function() {
	
	//----------------------------------------
	//1. Summernote 에디터 초기화(등록/수정 페이지)
	//----------------------------------------
	if($('#content').length) {
		$('#content').summernote({
			lang: 'ko-KR',
			height: 400,
			placeholder: '내용 입력',
			toolbar: [
				['style', ['style']],
				['font', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
				['fontsize', ['fontsize']],
				['color', ['color']],
				['para', ['ul','ol','paragraph']],
				['table', ['table']],
				['insert', ['link']],
				['view', ['fullscreen','codeview']]
			],
			callbacks: {
				onImageUpload: function(files) {
					uploadImage(files[0],this);
				}
			}
		});
	}

	//----------------------------------------
	//2. 등록 폼 유효성 검사
	//----------------------------------------
	$('#noticeWriteForm').on('submit', function(e) {
		var category = $('select[name=category]').val();
		var title = $('input[name=title]').val().trim();
		var content = $('#content').summernote('isEmpty') ? '' : $('#content').summernote('code');
		
		if(!category) {
			alert('분류를 선택하세요.');
			e.preventDefault();
			return;
		}
		if(!title) {
			alert('제목을 입력하세요.');
			e.preventDefault();
			return;
		}
		if(!content || content === '<p><br></p>') {
			alert('내용을 입력하세요.');
			e.preventDefault();
			return;
		}
	});

	//----------------------------------------
	//3. 수정 폼 유효성 검사
	//----------------------------------------
	$('#noticeModifyForm').on('submit', function(e) {
		var category = $('select[name=category]').val();
		var title = $('input[name=title]').val().trim();
		var content = $('#content').summernote('isEmpty') ? '' : $('#content').summernote('code');
		
		if(!category) {
			alert('분류를 선택하세요.');
			e.preventDefault();
			return;
		}		
		if(!title) {
			alert('제목을 입력하세요.');
			e.preventDefault();
			return;
		}
		if(!content || content === '<p><br></p>') {
			alert('내용을 입력하세요.');
			e.preventDefault();
			return;
		}
	});

	//----------------------------------------
	//4. OverlayScrollbars 사이드바 설정
	//----------------------------------------
	const SELECTOR_SIDEBAR_WRAPPER = '.sidebar-wrapper';
	document.addEventListener('DOMContentLoaded', function () {
	    const sidebarWrapper = document.querySelector(SELECTOR_SIDEBAR_WRAPPER);
	    if (sidebarWrapper && typeof OverlayScrollbarsGlobal !== 'undefined'
	            && OverlayScrollbarsGlobal.OverlayScrollbars !== undefined) {
	        OverlayScrollbarsGlobal.OverlayScrollbars(sidebarWrapper, {
	            scrollbars: { theme: 'os-theme-light', autoHide: 'leave', clickScroll: true },
	        });
	    }
	});
});

//----------------------------------------
//5. 삭제 처리
//----------------------------------------
function deleteNotice(noticeId) {
	if(!confirm('정말 삭제하시겠습니까?'))
		return;
	
	$.ajax({
		url: path + '/noticeDelete.adnt',
		type: 'POST',
		data: {noticeId: noticeId},
		success: function(result) {
			if(result === 'success') {
				alert('삭제 완료');
				location.href = path + '/noticeList.adnt';
			}
			else {
				alert('삭제 실패');
			}
		},
		error: function() {
			alert('오류 발생');
		}
	});
}

//----------------------------------------
//6. 이미지 업로드 처리
//----------------------------------------
function uploadImage(file, editor) {
	var formData = new FormData();
	formData.append('file', file);
	
	$.ajax({
		url: path + '/noticeImageUpload.adnt',
		type: 'POST',
		data: formData,
		contentType: false,
		processData: false,
		success: function(url) {
			$(editor).summernote('insertImage', url);
		},
		error: function() {
			alert('이미지 업로드 실패');
		}
	});
}