/**
 * FAQ 전용 스크립트 (최종 수정본)
 * @author 조민수
 * @since 2026-03-24
 */

let searchTimer; // 실시간 검색 부하 방지용 타이머

/**
 * 0. 페이지 이탈 방지 체크 (신규 추가)
 * 문의 작성 중 검색이나 로고 클릭 시 데이터 유실을 막습니다.
 */
function confirmExit() {
    // 1. 현재 주소에 'inquiryWrite'가 포함되어 있는지 확인
    const isInquiryWrite = window.location.pathname.includes('inquiryWrite');
    
    // 2. 문의 작성 페이지가 아니라면? 그냥 true를 반환하고 끝남!
    if (isInquiryWrite) {
        const hasTitle = $("#title").val() && $("#title").val().trim() !== "";
        const hasContent = $("#content").val() && $("#content").val().trim() !== "";
        
        if (hasTitle || hasContent) {
            return confirm("작성 중인 내용은 저장되지 않습니다. 정말 이 페이지를 벗어나시겠습니까?");
        }
    }
    return true; 
}

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
 * 메인과 상세 페이지에서는 Ajax 검색을 수행하고, 
 * 그 외 페이지(문의 작성 등)에서만 메인으로 이동합니다.
 */
function searchFaq() {
    let keyword = $("#keyword").val().trim();
    
    // 현재 페이지 경로 확인 (.sp 주소 체계에 맞게)
    const isFaqPage = window.location.pathname.includes('faqMain');
    const isDetailPage = window.location.pathname.includes('faqDetail');

    // [분기 1] FAQ 메인도 상세도 아닐 때만 메인으로 이동
    if (!isFaqPage && !isDetailPage) {
        if (keyword !== "") {
            location.href = contextPath + "/faqMain.sp?keyword=" + encodeURIComponent(keyword);
        }
        return; 
    }

    // [분기 2] Ajax 검색 실행
    if (keyword !== "") {
        $.ajax({
            url: contextPath + "/searchFaqAjax.sp", 
            type: "GET",
            data: { "keyword": keyword },
            success: function(data) {
                // 1. 상세 내용 영역이나 기존 목록 영역을 숨김
                $(".faq-list-container").hide();
                $(".faq-q-section, .faq-a-section, nav[aria-label='breadcrumb'], .text-center.mt-5").hide();
                $("#detailViewSection").hide(); // 감싸는 div를 만드셨다면 이것만 숨기면 됨

                // 2. 결과 출력 영역 보여주기
                $("#faqListArea").show();
                
                // 3. 리스트 렌더링
                renderFaqList(data); 
                
                // 제목 영역이 있다면 '검색 결과'로 변경
                $(".content-card h4.fw-bold").first().text("검색 결과");
            }
        });
    } else {
        // 검색어를 다 지웠을 때
        if (isFaqPage) {
            let $activeTag = $(".tag.active");
            let currentCategory = ($activeTag.text() === '전체') ? '' : $activeTag.text();
            loadFaqList(currentCategory); 
        } else if (isDetailPage) {
            // 상세 페이지에서 검색어 지우면 원래대로 복구 (새로고침이 가장 확실함)
            location.reload(); 
        }
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
   // ⭐ 카테고리 변경 시에도 작성 중이면 체크 (선택 사항)
    if (!confirmExit()) return;
   
    $(".tag").removeClass("active");
    $(obj).addClass("active");
    $("#keyword").val(""); // 카테고리 클릭 시 검색창 초기화
    loadFaqList(category);
}

/**
 * 4. FAQ 리스트 렌더링 (맛침내 그린 테마 반영)
 */

/*
수정 사항: viewCount 안 보이게 처리
<span class="text-muted small me-3" style="font-size: 0.8rem;">
 <i class="fa-regular fa-eye me-1"></i> ${views}
</span>
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

// 초기 로드 시 URL 파라미터에 검색어가 있다면 자동 실행 및 커서 제어
$(document).ready(function() {
    const urlParams = new URLSearchParams(window.location.search);
    const keyword = urlParams.get('keyword');
    const $searchInput = $("#keyword"); // 검색창 선택

    if (keyword) {
        // 1. 검색창에 값 복원
        $searchInput.val(keyword);
        
        // 2. 검색 실행 (기존 함수 호출)
        searchFaq();

        // 3. ⭐ 커서 및 포커스 제어 (핵심!)
        $searchInput.focus(); // 일단 포커스를 줌
        
        // 커서를 글자 맨 뒤로 보내기 위한 트릭
        // 값을 비웠다가 다시 채우면 브라우저가 커서를 끝에 배치합니다.
        let tempVal = $searchInput.val();
        $searchInput.val('').val(tempVal);
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
