document.addEventListener('DOMContentLoaded', function() {

    var miniCalendar = new FullCalendar.Calendar(document.getElementById('miniCalendar'), {
        initialView: 'dayGridMonth',
        height: 480,
        headerToolbar: {
            left: 'prev',
            center: 'title',
            right: 'next'
        },
        dayMaxEvents: 1,
        showNonCurrentDates: false,
        events: miniEvents,

        eventContent: function(arg) {
            var wrap = document.createElement('div');
            wrap.className = 'mini_event_wrap';

            var typeBadge = document.createElement('div');
            typeBadge.className = 'mini_event_type ' + getTypeClass(arg.event.classNames);
            typeBadge.textContent = arg.event.extendedProps.placeTypeText;

            var statusBadge = document.createElement('div');
            statusBadge.className = 'mini_event_status ' + getStatusClass(arg.event.classNames);
            statusBadge.textContent = arg.event.extendedProps.statusText;

            wrap.appendChild(typeBadge);
            wrap.appendChild(statusBadge);

            return { domNodes: [wrap] };
        },

        eventClick: function(info) {
            location.href = contextPath + '/reservationDetail.do?reservation_id=' + info.event.id;
        }
    });

    miniCalendar.render();

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

    function getModalStatusClass(classNames) {
        if (classNames.includes('fc-status-completed')) return 'modal_status_completed';
        if (classNames.includes('fc-status-pending')) return 'modal_status_pending';
        if (classNames.includes('fc-status-reserved')) return 'modal_status_reserved';
        if (classNames.includes('fc-status-cancelled')) return 'modal_status_cancelled';
        if (classNames.includes('fc-status-noshow')) return 'modal_status_noshow';
        return 'modal_status_etc';
    }

    function getModalStatusText(classNames) {
        if (classNames.includes('fc-status-completed')) return '완료';
        if (classNames.includes('fc-status-pending')) return '대기';
        if (classNames.includes('fc-status-reserved')) return '확정';
        if (classNames.includes('fc-status-cancelled')) return '취소';
        if (classNames.includes('fc-status-noshow')) return '미방';
        return '기타';
    }

    var calendarModal = document.getElementById('calendarModal');
    var openCalendarModalBtn = document.getElementById('openCalendarModal');
    var closeCalendarModalBtn = document.getElementById('closeCalendarModal');
    var modalOverlay = document.querySelector('.calendar_modal_overlay');
    var bigCalendar = null;

    function openCalendarModal() {
        calendarModal.classList.add('show');
        document.body.style.overflow = 'hidden';

        if (!bigCalendar) {
            bigCalendar = new FullCalendar.Calendar(document.getElementById('bigCalendar'), {
                initialView: 'dayGridMonth',
                height: 650,
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
                dayMaxEvents: true,
                events: modalEvents,

                eventContent: function(arg) {
                    if (arg.view.type === 'listMonth') {
                        return true;
                    }

                    var wrap = document.createElement('div');
                    wrap.className = 'modal_event_inline';

                    var titleText = document.createElement('span');
                    titleText.className = 'modal_event_title_text';
                    titleText.textContent = arg.event.title;

                    var statusBadge = document.createElement('span');
                    statusBadge.className = 'modal_event_badge ' + getModalStatusClass(arg.event.classNames);
                    statusBadge.textContent = getModalStatusText(arg.event.classNames);

                    wrap.appendChild(titleText);
                    wrap.appendChild(statusBadge);

                    return { domNodes: [wrap] };
                },

                eventClick: function(info) {
                    location.href = contextPath + '/reservationDetail.do?reservation_id=' + info.event.id;
                }
            });

            bigCalendar.render();
        } else {
            bigCalendar.updateSize();
        }
    }

    function closeCalendarModal() {
        calendarModal.classList.remove('show');
        document.body.style.overflow = '';
    }

    if (openCalendarModalBtn) {
        openCalendarModalBtn.addEventListener('click', openCalendarModal);
    }

    if (closeCalendarModalBtn) {
        closeCalendarModalBtn.addEventListener('click', closeCalendarModal);
    }

    if (modalOverlay) {
        modalOverlay.addEventListener('click', closeCalendarModal);
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeCalendarModal();
        }
    });

    var toggleBtn = document.getElementById('toggleHistory');
    var historyDiv = document.querySelector('.point-history');

    if (toggleBtn && historyDiv) {
        toggleBtn.addEventListener('click', function() {
            var isHidden = historyDiv.style.display === 'none' || historyDiv.style.display === '';
            historyDiv.style.display = isHidden ? 'block' : 'none';
            toggleBtn.textContent = isHidden ? '접기 ▲' : '펼치기 ▼';
        });
    }
});