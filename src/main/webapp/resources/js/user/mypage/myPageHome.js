// DOM 로드 후 실행
document.addEventListener('DOMContentLoaded', function() {

    // =========================
    // 미니 캘린더 생성
    // =========================
    var miniCalendar = new FullCalendar.Calendar(
        document.getElementById('miniCalendar'), // 캘린더 영역
        {
            initialView: 'dayGridMonth', // 월간뷰
            height: 480, // 높이

            // 상단 버튼 구성
            headerToolbar: {
                left: 'prev',
                center: 'title',
                right: 'next'
            },

            dayMaxEvents: 1, // 하루 최대 1개 표시
            showNonCurrentDates: false, // 이전/다음 달 날짜 숨김

            events: miniEvents, // JSP에서 전달받은 데이터 연결

            // 이벤트 UI 커스터마이징
            eventContent: function(arg) {

                var wrap = document.createElement('div'); // 전체 컨테이너

                // 장소 타입 배지
                var typeBadge = document.createElement('div');
                typeBadge.className =
                    'mini_event_type ' + getTypeClass(arg.event.classNames);
                typeBadge.textContent =
                    arg.event.extendedProps.placeTypeText;

                // 상태 배지
                var statusBadge = document.createElement('div');
                statusBadge.className =
                    'mini_event_status ' + getStatusClass(arg.event.classNames);
                statusBadge.textContent =
                    arg.event.extendedProps.statusText;

                wrap.appendChild(typeBadge);
                wrap.appendChild(statusBadge);

                return { domNodes: [wrap] };
            },

            // 클릭 시 상세페이지 이동
            eventClick: function(info) {
                location.href =
                    contextPath + '/reservationDetail.do?reservation_id=' + info.event.id;
            }
        }
    );

    miniCalendar.render(); // 화면 출력 미니캘린더


    // =========================
    // 타입 / 상태 클래스 변환
    // =========================
    function getTypeClass(classNames) {
        if (classNames.includes('fc-type-rest')) return 'mini_type_rest';
        if (classNames.includes('fc-type-acc')) return 'mini_type_acc';
        if (classNames.includes('fc-type-fest')) return 'mini_type_fest';
        return 'mini_type_etc';
    }

    function getStatusClass(classNames) {
        if (classNames.includes('fc-status-completed')) return 'mini_status_completed';
        if (classNames.includes('fc-status-pending')) return 'mini_status_pending';
        if (classNames.includes('fc-status-reserved')) return 'mini_status_reserved';
        if (classNames.includes('fc-status-cancelled')) return 'mini_status_cancelled';
        if (classNames.includes('fc-status-noshow')) return 'mini_status_noshow';
        return 'mini_status_etc';
    }


    // =========================
    // 모달 캘린더 관련
    // =========================
    var calendarModal = document.getElementById('calendarModal');
    var openBtn = document.getElementById('openCalendarModal');
    var closeBtn = document.getElementById('closeCalendarModal');
    var overlay = document.querySelector('.calendar_modal_overlay');

    var bigCalendar = null;

    // 모달 열기
    function openCalendarModal() {

        calendarModal.classList.add('show'); // 모달 표시
        document.body.style.overflow = 'hidden'; // 스크롤 막기

        // 최초 1회만 생성
        if (!bigCalendar) {
            bigCalendar = new FullCalendar.Calendar(
                document.getElementById('bigCalendar'),
                {
                    initialView: 'dayGridMonth',
                    height: 650,

                    // 큰 캘린더 버튼
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,listMonth'
                    },

                    buttonText: {
                        today: '오늘',
                        dayGridMonth: '월',
                        listMonth: '목록'
                    },

                    events: modalEvents, // 큰 캘린더 데이터

                    // 이벤트 클릭 시 이동
                    eventClick: function(info) {
                        location.href =
                            contextPath + '/reservationDetail.do?reservation_id=' + info.event.id;
                    }
                }
            );

            bigCalendar.render();
        } else {
            bigCalendar.updateSize(); // 재열기 시 사이즈 보정
        }
    }

    // 모달 닫기
    function closeCalendarModal() {
        calendarModal.classList.remove('show');
        document.body.style.overflow = '';
    }

    // 이벤트 연결
    openBtn && openBtn.addEventListener('click', openCalendarModal);
    closeBtn && closeBtn.addEventListener('click', closeCalendarModal);
    overlay && overlay.addEventListener('click', closeCalendarModal);

    // ESC 키로 닫기
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeCalendarModal();
        }
    });


    // =========================
    // 포인트 내역 토글
    // =========================
    var toggleBtn = document.getElementById('toggleHistory');
    var historyDiv = document.querySelector('.point-history');

    if (toggleBtn && historyDiv) {
        toggleBtn.addEventListener('click', function() {

            var isHidden =
                historyDiv.style.display === 'none' ||
                historyDiv.style.display === '';

            historyDiv.style.display = isHidden ? 'block' : 'none';

            toggleBtn.textContent =
                isHidden ? '접기 ▲' : '펼치기 ▼';
        });
    }

});


// =========================
// 즐겨찾기 토글
// =========================
function toggleBookmark(event, el) {

    event.preventDefault();   // 링크 이동 방지
    event.stopPropagation();  // 카드 클릭 이벤트 막기

    const placeId = el.getAttribute('data-place-id');

    // 서버에 즐겨찾기 요청
    fetch(contextPath + '/togglemyFavorite.do?place_id=' + placeId, {
        method: 'GET'
    })
    .then(response => response.text())
    .then(result => {

        result = result.trim();

        // 로그인 안됨
        if (result === '-1') {
            alert('로그인이 필요합니다.');
            location.href = contextPath + '/login.do';
            return;
        }

        // 삭제 → 빈 아이콘
        if (result === '0') {
            el.innerHTML = '<i class="bi bi-bookmark"></i>';
        }
        // 추가 → 채운 아이콘
        else if (result === '1') {
            el.innerHTML = '<i class="bi bi-bookmark-fill"></i>';
        }
        else {
            alert('오류 발생');
        }
    })
    .catch(error => {
        console.error(error);
        alert('서버 오류');
    });
}