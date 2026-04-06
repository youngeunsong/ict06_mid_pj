/* event.js */
/* 이벤트 목록(event.jsp) / 이벤트 상세(event_detail.jsp) 공통 JS */

document.addEventListener("DOMContentLoaded", function () {

    /* ─────────────────────────────────────────────
       이미지 경로 조립 (하위 호환)
       - JSP에서 <script>var APP_PATH = '${path}';</script> 로 주입
       - image_url: DB에 저장된 원본값 (콤마 구분 파일명)
           외부 URL) "https://..." → 그대로 사용
           레거시)   "/resources/upload/notice/xxx.jpg" → 그대로 사용
           신규)     "uuid1.jpg" or "uuid1.jpg,uuid2.png" → basePath 조립
    ───────────────────────────────────────────── */
    var basePath = (typeof APP_PATH !== 'undefined') ? APP_PATH : '';

    function resolveImageSrc(rawUrl) {
        if (!rawUrl) return null;
        var first = rawUrl.split(',')[0].trim();
        if (!first) return null;
        if (first.startsWith('http://') || first.startsWith('https://')) {
            // 외부 절대 URL (네이버 블로그, 카카오 등 외부 이미지)
            return first;
        }
        if (first.startsWith('/')) {
            // 레거시: 내부 전체 경로가 저장된 경우
            return first;
        }
        // 신규: 파일명만 저장된 경우 (외부 매핑 경로 사용)
        return basePath + '/upload_notice/' + first;
    }

    document.querySelectorAll('img[data-img]').forEach(function (img) {
        var src = resolveImageSrc(img.dataset.img);
        if (src) { img.src = src; }
    });

    /* ─────────────────────────────────────────────
       카카오 공유 imageUrl 동기화 (event_detail.jsp 전용)
       - hero 이미지(.event-hero-img)의 data-img를 실제 이미지 기준으로 조립
       - kakaoShareData.imageUrl을 덮어써서 공유 썸네일을 실제 대표 이미지와 일치시킴
       - heroImg가 없는 페이지(목록 등)에서는 무해하게 skip
    ───────────────────────────────────────────── */
    var heroImg = document.querySelector('.event-hero-img');
    if (heroImg && window.kakaoShareData) {
        var rawImgUrl = heroImg.dataset.img || '';
        var resolvedForKakao = resolveImageSrc(rawImgUrl);
        if (resolvedForKakao) {
            window.kakaoShareData.imageUrl = resolvedForKakao;
        }
    }

    // 제목 동기화: 따옴표 등 특수문자 문법 오류 방지를 위해 DOM에서 직접 추출
    var titleEl = document.querySelector('.event-title');
    if (titleEl && window.kakaoShareData) {
        window.kakaoShareData.title = titleEl.textContent.trim();
    }

    /* ─────────────────────────────────────────────
       페이지네이션 클릭 활성화 (event.jsp 전용, 없으면 무해)
    ───────────────────────────────────────────── */
    document.querySelectorAll('.pg').forEach(function (pg) {
        pg.addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelectorAll('.pg').forEach(function (p) {
                p.classList.remove('on');
            });
            pg.classList.add('on');
        });
    });

});