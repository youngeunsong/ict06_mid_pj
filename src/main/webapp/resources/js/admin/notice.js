/* ========================================
   notice.js - 관리자 > 공지/이벤트 관리 공통 JS
   ========================================*/

$(document).ready(function() {
	//----------------------------------------
	//0. Toast 설정
	//----------------------------------------
	const urlParams = new URLSearchParams(window.location.search);
	if(urlParams.get('deleted') === 'true') {
		const deleteToast = $('#deleteToast');
		
		//toast 초기화
		deleteToast.toast({
			autohide: true,
			delay: 3000
		});
		
		//toast 표시
		deleteToast.toast('show');
	}
	
	$(document).on('click', '[data-dismiss="toast"]', function() {
		$(this).closest('.toast').toast('hide');
	});

	//----------------------------------------
	//1. Summernote 에디터 초기화(등록/수정 페이지)
	//----------------------------------------
	if($('#content').length && typeof $.fn.summernote === 'function') {
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
				['insert', ['link', 'picture']],
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
	//7. 이미지 업로드 드래그&드롭 및 미리보기
	//----------------------------------------
	const $uploadArea = $('#uploadArea');
	const $fileInput = $('#fileInput');
	const $previewGrid = $('#previewGrid');
	
	//전송에서 제외할 파일 관리
	let selectedFiles = [];
	
	//드래그 이벤트 방지
	['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
		$uploadArea.on(eventName, function(e) {
			e.preventDefault();
			e.stopPropagation();
		});
	});
	
	//드래그 하이라이트 효과
	$uploadArea.on('dragover', function() {
		$(this).css('background-color', '#e9ecef');
	});
	$uploadArea.on('dragleave drop', function() {
		$(this).css('background-color', '#f8f9fa');
	});
	
	//파일 클릭 선택 시 처리
	$fileInput.on('change', function() {
		handleFiles(this.files);
	});
	
	//파일 드롭 시 처리
	$uploadArea.on('drop', function(e) {
		const files = e.originalEvent.dataTransfer.files;
		handleFiles(files);
	});
	
	//파일 처리 핵심 함수
	function handleFiles(files) {
		const fileArray = Array.from(files);
		
		//현재 화면에 보이는 이미지 개수(기존+추가)
		const currentTotal = $('.preview-item').length;
		
		if(currentTotal + fileArray.length > 5) {
			alert("이미지는 최대 5장까지 등록 가능합니다.");
			return;
		}
		
		fileArray.forEach(file => {
			//이미지 파일 형식 체크
			if(!file.type.match('image.*')) {
				alert("이미지 파일만 업로드 가능합니다.");
				return;
			}
			
			selectedFiles.push(file);
			
			//미리보기 HTML 생성
			const reader = new FileReader();
			reader.onload = function(e) {
				const html = `
					<div class="preview-item" data-name="${file.name}">
						<img src="${e.target.result}">
						<span class="remove-btn" onclick="removeFile('${file.name}')">
							<i class="bi bi-x"></i>
						</span>
					</div>
				`;
				$previewGrid.append(html);
			};
			reader.readAsDataURL(file);
		});
		updateInputFiles();
	}
	
	//파일 삭제
	window.removeFile = function(fileName) {
		selectedFiles = selectedFiles.filter(file => file.name !== fileName);
		$(`.preview-item[data-name="${fileName}"]`).remove();
		updateInputFiles();
	};
	
	//input 태그의 실제 파일 목록을 배열과 동기화
	function updateInputFiles() {
		const dataTransfer = new DataTransfer();
		selectedFiles.forEach(file => dataTransfer.items.add(file));
		$fileInput[0].files = dataTransfer.files;
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
		
		console.log("전송될 파일 개수:", $fileInput[0].files.length);
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
		type: 'post',
		data: {noticeId: noticeId},
		success: function(result) {
			if(result === 'success') {
				location.href = path + '/noticeList.adnt?deleted=true';
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

//기존 등록된 이미지 삭제 처리(수정 페이지용)
window.removeExistingFile = function(obj, fileName) {
	if(!confirm("기존 이미지를 삭제하시겠습니까?\n(수정 완료 시 삭제됩니다.)"))
		return;
		
	//해당 미리보기 삭제
	$(obj).closest('.preview-item').remove();
};