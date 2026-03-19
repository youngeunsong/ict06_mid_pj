/**
 * FAQ 관리 통합 JavaScript (등록/수정/임시저장)
 */

$(function() {
    // 1. 페이지 로드 시 글자 수 초기화 (수정 페이지 대응)
    if ($('textarea[name="answer"]').length > 0) {
        var initialLength = $('textarea[name="answer"]').val().length;
        $('#charCount').text(initialLength + " / 2000자");
    }

    // 2. 글자 수 세기 기능 (공통)
    $(document).on('input', 'textarea[name="answer"]', function() {
        var length = $(this).val().length;
        $('#charCount').text(length + " / 2000자");
    });
});

/**
 * [공통] 임시저장 기능
 * 등록이든 수정이든 '숨김' 상태로 저장합니다.
 */
function saveTemp() {
    // 노출 상태를 '숨김(N)'으로 강제 선택
    if(document.getElementById('visN')) {
        document.getElementById('visN').checked = true;
    }
    
    Swal.fire({
        title: '임시저장 하시겠습니까?',
        text: '내용이 저장되며, 사용자에게는 노출되지 않습니다.',
        icon: 'info',
        showCancelButton: true,
        confirmButtonColor: '#17a2b8',
        confirmButtonText: '저장',
        cancelButtonText: '취소',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById('faqForm').submit();
        }
    });
}

/**
 * [등록 전용] 새 FAQ 등록 핸들러
 */
function handleFaqSubmit(event) {
    event.preventDefault(); // 기본 제출 막기

    Swal.fire({
        title: 'FAQ를 등록하시겠습니까?',
        text: "등록 후 목록에서 바로 확인이 가능합니다.",
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#01D281',
        cancelButtonColor: '#aaa',
        confirmButtonText: '등록',
        cancelButtonText: '취소',
        reverseButtons: true 
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById('faqForm').submit();
        }
    });
    return false;
}

/**
 * [수정 전용] FAQ 수정 완료 핸들러
 */
function handleFaqUpdate(event) {
    event.preventDefault(); // 기본 제출 막기

    Swal.fire({
        title: '변경사항을 저장하시겠습니까?',
        text: "수정된 내용이 즉시 반영됩니다.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#01D281',
        cancelButtonColor: '#aaa',
        confirmButtonText: '수정 완료',
        cancelButtonText: '취소',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById('faqForm').submit();
        }
    });
    return false;
}