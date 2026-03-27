/**
 * FAQ 전용 스크립트 (최종 수정본)
 * @author 조민수
 * @since 2026-03-24
 */

let searchTimer; // 실시간 검색 부하 방지용 타이머

/**
 * 1. 엔터키 및 타이핑 감지 (Debounce 적용)
 */
function checkEnter(event) {
    if (event.keyCode === 13) {
        clearTimeout(searchTimer);
        searchFaq(); // 엔터는 즉시 실행
    } else {
        // 타이핑 시 0.3초 대기 후 검색 (서버 부하 감소)
        clearTimeout(searchTimer);
        searchTimer = setTimeout(searchFaq, 300); 
    }
}

/**
 * 2. FAQ 검색 실행 (Ajax + 경로 분기)
 * 어느 페이지에서든 호출 가능하도록 경로 체크 로직이 포함됨
 */
function searchFaq() {
    let keyword = $("#keyword").val().trim();
    
    // 현재 페이지가 FAQ 메인(.sp)인지 정확히 판별 (URL에 faqMain이 포함되어 있는지 확인)
    const isFaqPage = window.location.pathname.includes('faqMain');

    // [분기 1] FAQ 메인 페이지가 아닐 때 (예: 1:1 문의 작성 페이지 등)
    if (!isFaqPage) {
        if (keyword !== "") {
            // 검색어를 쿼리 스트링으로 들고 FAQ 메인으로 페이지 이동
            location.href = contextPath + "/faqMain.sp?keyword=" + encodeURIComponent(keyword);
        }
        return; // 메인으로 이동하므로 아래 Ajax 로직은 실행하지 않음
    }

    // [분기 2] 이미 FAQ 메인 페이지일 때 (실시간 Ajax 검색 수행)
    let $activeTag = $(".tag.active");
    let currentCategory = ($activeTag.text() === '전체') ? '' : $activeTag.text();

    if (keyword !== "") {
        // 검색어가 있을 때: 검색 API 호출
        $.ajax({
            url: contextPath + "/searchFaqAjax.sp", 
            type: "GET",
            data: { "keyword": keyword },
            success: function(data) {
                renderFaqList(data); // 리스트 렌더링
                $("#selected-category-name").text("검색 결과");
            },
            error: function() {
                console.error("FAQ 검색 중 오류 발생");
            }
        });
    } else {
        // 검색어를 비웠을 때: 현재 선택된 카테고리의 기본 리스트(Top 5)로 복구
        loadFaqList(currentCategory); 
    }
}

/**
 * 3. 카테고리 데이터 로드 공통 함수 (중복 제거)
 */
function loadFaqList(category, keyword = '') {
    $.ajax({
        url: contextPath + "/getFaqTop5Ctg.sp",
        type: "GET",
        data: { "category": category, "keyword": keyword },
        success: function(data) {
            renderFaqList(data);
            if(category === '') $("#selected-category-name").text("전체");
            else $("#selected-category-name").text(category);
        }
    });
}

function changeCategory(category, obj) {
    $(".tag").removeClass("active");
    $(obj).addClass("active");
    $("#keyword").val(""); // 카테고리 클릭 시 검색창 초기화
    loadFaqList(category);
}

/**
 * 4. FAQ 리스트 렌더링 (맛침내 그린 테마 반영)
 */
function renderFaqList(list) {
    let html = "";
    let keyword = $("#keyword").val().trim();
    
    if(!list || list.length === 0) {
        html = `<div class='p-5 text-center text-muted'>
                    <i class="fa-solid fa-magnifying-glass mb-3 d-block" style="font-size: 3rem; color: #eee;"></i>
                    검색 결과가 없거나 등록된 질문이 없습니다.
                </div>`;
    } else {
        $.each(list, function(index, faq) {
            // 조회수 변수 처리 (DTO 필드명에 따라 view_count 또는 viewCount 자동 대응)
            let views = (faq.view_count !== undefined) ? faq.view_count : (faq.viewCount || 0);

            html += `
                <div class="faq-item border-bottom">
                    <div class="faq-question p-3 d-flex justify-content-between align-items-center" onclick="toggleAnswer(this)">
                        <div class="d-flex align-items-center">
                            <span class="fw-bold me-2" style="color: #3CB371;">Q.</span> 
                            <span class="fw-medium text-dark">${faq.question}</span>
                        </div>
                        
                        <div class="d-flex align-items-center">
                            <span class="text-muted small me-3" style="font-size: 0.8rem;">
                                <i class="fa-regular fa-eye me-1"></i> ${views}
                            </span>
                            <i class="fa-solid fa-chevron-down text-secondary transition-icon"></i>
                        </div>
                    </div>
                    
                    <div class="faq-answer bg-light" style="display: none;">
                        <div class="p-4 d-flex">
                            <span class="text-danger fw-bold me-2">A.</span>
                            <div class="text-muted" style="font-size: 0.95rem;">${faq.answer}</div>
                        </div>
                    </div>
                </div>`;
        });

        // (이하 전체보기 버튼 로직 동일...)
        if(keyword !== "" && list.length >= 5) { 
            html += `
                <div class="p-4 text-center">
                    <a href="${contextPath}/faqAllList.sp?keyword=${encodeURIComponent(keyword)}" 
                       class="btn btn-outline-success btn-sm rounded-pill px-4 shadow-sm" style="font-size: 0.85rem; border-color: #3CB371; color: #3CB371;">
                         '${keyword}' 관련 질문 전체보기 <i class="fa-solid fa-angles-right ms-1"></i>
                    </a>
                </div>`;
        }
    }
    $("#faqListArea").stop(true, true).hide().html(html).fadeIn(200);
}

/**
 * 5. 아코디언 토글
 */
function toggleAnswer(element) {
    const $thisAnswer = $(element).next(".faq-answer");
    const $allAnswers = $(".faq-answer");
    const $allIcons = $(".transition-icon");
    
    if ($thisAnswer.is(":visible")) {
        $thisAnswer.stop(true, true).slideUp(300);
        $(element).find(".transition-icon").css("transform", "rotate(0deg)");
    } else {
        $allAnswers.stop(true, true).slideUp(300);
        $allIcons.css("transform", "rotate(0deg)");
        $thisAnswer.stop(true, true).slideDown(300);
        $(element).find(".transition-icon").css("transform", "rotate(180deg)");
    }
}

/**
 * 6. 스크롤 시 상단 디자인 변경 (맛침내 그린 테마 수치 적용)
 */
$(window).on("scroll", function() {
    // 현재 주소에 'faqMain'이 포함되어 있을 때만 이 스크롤 이벤트를 실행
    if (window.location.href.indexOf('faqMain.sp') > -1) {
        
        let scrollTop = $(window).scrollTop();
        let $title = $("#dynamic-title");

        if (scrollTop > 50) {
            if ($title.text() !== "맛침내 고객센터") {
                $title.stop().fadeOut(100, function() {
                    $(this).text("맛침내 고객센터").fadeIn(100);
                });
                $(".sticky-search-wrap").css("padding", "15px 0");
            }
        } else {
            if ($title.text() !== "무엇을 도와드릴까요?") {
                $title.stop().fadeOut(100, function() {
                    $(this).text("무엇을 도와드릴까요?").fadeIn(100);
                });
                $(".sticky-search-wrap").css("padding", "30px 0");
            }
        }
    }
});

// 초기 로드 시 URL 파라미터에 검색어가 있다면 자동 실행
$(document).ready(function() {
    const urlParams = new URLSearchParams(window.location.search);
    const keyword = urlParams.get('keyword');
    if (keyword) {
        $("#keyword").val(keyword);
        searchFaq();
    }
});

/**
 * 7. 불편사항 신고 모달 (AJAX 전송)
 */
$(document).on("click", "#btnSendReport", function() {
    
    // 1. 입력값 체크 (유효성 검사)
    const $form = $("#reportForm");
    const title = $form.find("input[name='title']").val().trim();
    const content = $form.find("textarea[name='content']").val().trim();
    
    if(!title) {
        alert("신고 제목을 입력해주세요.");
        $form.find("input[name='title']").focus();
        return;
    }
    if(!content) {
        alert("신고 내용을 입력해주세요.");
        $form.find("textarea[name='content']").focus();
        return;
    }

    // 2. AJAX 데이터 전송 (기존에 정의된 contextPath 변수 활용)
    const formData = $form.serialize();
    
    // category가 hidden으로 잘 들어있는지 확인
    if (formData.indexOf('category=') === -1) {
        formData += "&category=불편사항";
    }
    
    $.ajax({
        url: contextPath + "/reportInsertAjax.sp",
        type: "POST",
        data: formData,
        success: function(res) {
		    if (res.trim() === "success") { // trim() 추가로 공백 방지
		        alert("성공적으로 접수되었습니다.");
		        
		        // 모달 닫기 및 초기화 로직
		        $('#reportModal').modal('hide');
		        $('#reportForm')[0].reset();
		        
		        // JSP에서 선언한 JS 변수를 사용 (400 에러 해결)
		        location.href = "faqMain.sp?user_id=" + sessionUserId;
		    } else {
		        alert("접수 실패. 다시 시도해주세요.");
		    }
		},
        error: function() {
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    });
});

/**
 * 8. 모달 닫힘 이벤트 처리 (데이터 초기화)
 * 사용자가 '취소'를 누르거나 X를 눌러 모달을 닫을 때 폼을 리셋합니다.
 */
$(document).ready(function() {
    $('#reportModal').on('hidden.bs.modal', function () {
        // [0]을 붙이는 이유는 jQuery 객체를 순수 DOM 객체로 변환하여 reset() 함수를 쓰기 위함입니다.
        if ($('#reportForm').length > 0) {
            $('#reportForm')[0].reset();
        }
        
        // 혹시 모달을 강제로 닫을 때 배경(검은색)이 남는 버그 방지
        $('.modal-backdrop').remove();
        $('body').removeClass('modal-open');
        $('body').css('padding-right', '');
    });
});
