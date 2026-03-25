/**
 * 관리자 > FAQ리스트 관리 
 */

$(document).ready(function() {
    // [1] 실시간 필터링 로직 (타이핑할 때마다 목록 숨기기/보이기)
    $('#faqSearch').on('keyup', function(e) {
        var value = $(this).val().toLowerCase().trim();

        // 엔터키(13)를 누르면 실시간 필터링을 멈추고 서버로 검색 요청(goSearch)을 보냄
        if (e.keyCode === 13) {
            e.preventDefault();
            goSearch(); 
            return;
        }

        // 타이핑 중에는 일단 답변 창은 다 닫음
        $('.answer-row').removeClass('open').hide();

        // 검색어가 비어있으면 전체 목록 다시 표시
        if (value === "") {
            $('#faqBody tr.faq-row').show();
            return;
        }

        // [실시간 필터링 실행]
        $('#faqBody tr.faq-row').each(function() {
            var questionText = $(this).find('.faq-question').text().toLowerCase();
            var categoryText = $(this).find('.badge').text().toLowerCase();

            if (questionText.indexOf(value) > -1 || categoryText.indexOf(value) > -1) {
                $(this).show();
            } else {
                $(this).hide();
                $(this).next('.answer-row').hide();
            }
        });
    });

    // 폼 제출로 인한 페이지 새로고침 방지
    $('form').on('submit', function(e) {
        e.preventDefault();
    });
});

/**
 * [기능 1] 서버 검색 (JSP에서 이사 옴)
 * 엔터를 치거나 검색 버튼을 눌렀을 때 실행됨
 */
function goSearch() {
    const keyword = $('#faqSearch').val();
    // JSP에 선언된 currCat, currVis 변수를 참조함
    // 한글 검색어 깨짐 방지를 위해 encodeURIComponent 사용
    location.href = `adFaqList.adsp?category=${currCat}&visible=${currVis}&keyword=${encodeURIComponent(keyword)}`;
}

/**
 * [기능 2] 아코디언 토글 (JSP에서 이사 옴)
 */
function toggleAnswer(element) {
    var $answerRow = $(element).next('.answer-row');
    var isOpen = $answerRow.hasClass('open');

    // 다른 모든 답변은 닫고 시작
    $('.answer-row').removeClass('open').hide();

    if (!isOpen) {
        // 클릭한 답변만 열기
        $answerRow.addClass('open').show();
    }
}

/**
 * [기능 3] 삭제 (JSP에서 이사 옴)
 */
function deleteFaq(id) {
    if(confirm(id + "번 FAQ를 정말 삭제하시겠습니까?")) {
        location.href = 'adFaqDeleteAction.adsp?faq_id=' + id;
    }
}