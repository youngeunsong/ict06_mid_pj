/**
 * 관리자 > FAQ리스트 관리 스크립트 
 */

$(document).ready(function() {
    // [1] 실시간 필터링 로직
    $('#faqSearch').on('keyup', function(e) {
        var value = $(this).val().toLowerCase().trim();

        // 엔터키(13) 눌렀을 때 서버 새로고침 방지
        if (e.keyCode === 13) {
            e.preventDefault();
        }

        // 타이핑 시 혹은 검색어 변경 시 항상 답변 창은 일단 닫음 (잔상 방지)
        $('.answer-row').removeClass('open').hide();

        // 검색어가 비어있으면(지우면) 전체 목록을 다시 보여줌
        if (value === "") {
            $('#faqBody tr.faq-row').show(); // 모든 질문 로우 표시
            // 답변 로우는 열려있지 않아야 하므로 hide 상태 유지
            return;
        }

        // [필터링] 검색어가 있을 때만 해당 내용 필터링
        $('#faqBody tr.faq-row').each(function() {
            var questionText = $(this).find('.faq-question').text().toLowerCase();
            var categoryText = $(this).find('.badge').text().toLowerCase();

            if (questionText.indexOf(value) > -1 || categoryText.indexOf(value) > -1) {
                $(this).show(); // 검색어 포함 시 노출
            } else {
                $(this).hide(); // 미포함 시 숨김
                $(this).next('.answer-row').hide(); // 해당 답변도 숨김
            }
        });
    });

    // 폼 제출(엔터)로 인한 페이지 새로고침 원천 봉쇄
    $('form').on('submit', function(e) {
        e.preventDefault();
    });
});

/**
 * [기능] 아코디언 토글
 */
function toggleAnswer(element) {
    var $answerRow = $(element).next('.answer-row');
    var isOpen = $answerRow.hasClass('open');

    // 다른 모든 답변은 닫고 시작
    $('.answer-row').removeClass('open').hide();

    if (!isOpen) {
        $answerRow.addClass('open').show();
    }
}

/**
 * [기능] 서버 검색 (엔터 키 입력 시 실행)
 */
function goSearch() {
    // 엔터를 치거나 검색 아이콘을 눌렀을 때 서버로 이동하지 않도록 비워둠
    // 대신 위 keyup 이벤트에서 모든 처리가 일어납니다.
    $('#faqSearch').trigger('keyup');
}

/**
 * [기능] 삭제
 */
function deleteFaq(id) {
    if(confirm("정말 삭제하시겠습니까?")) {
        location.href = 'adFaqDeleteAction.adsp?faq_id=' + id;
    }
}