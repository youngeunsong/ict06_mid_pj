/* notice.js */

  /* ── 커뮤니티 상단 탭 전환 ── */
  function switchTab(el, type) {
    document.querySelectorAll('.comm-tabs .tab').forEach(t => t.classList.remove('on'));
    el.classList.add('on');
    if (type === 'free') location.href = '#'; // boardList.co
  }

  /* ── NOTICE / EVENT 내부 탭 전환 ── */
  function switchInner(cat) {
    const isNotice = cat === 'NOTICE';

    // 내부 탭 활성화
    document.getElementById('innerNotice').classList.toggle('on', isNotice);
    document.getElementById('innerEvent').classList.toggle('on', !isNotice);

    // 게시판 영역 전환
    document.getElementById('noticeBoard').style.display = isNotice ? 'block' : 'none';
    document.getElementById('eventBoard').style.display  = isNotice ? 'none'  : 'block';

    // 페이지 타이틀 & 경로 변경
    const title = document.getElementById('pageTitle');
    const cur   = document.getElementById('breadCur');
    if (isNotice) {
      title.innerHTML = '<i class="bi bi-megaphone-fill text-success me-1"></i> 공지사항';
      cur.textContent = '공지사항';
      document.getElementById('tabNotice').classList.add('on');
      document.getElementById('tabEvent').classList.remove('on');
    } else {
      title.innerHTML = '<i class="bi bi-gift-fill text-warning me-1"></i> 이벤트';
      cur.textContent = '이벤트';
      document.getElementById('tabEvent').classList.add('on');
      document.getElementById('tabNotice').classList.remove('on');
    }
  }

  /* 페이지네이션 */
  document.querySelectorAll('.pg').forEach(pg => {
    pg.addEventListener('click', e => {
      e.preventDefault();
      pg.closest('.paging').querySelectorAll('.pg').forEach(p => p.classList.remove('on'));
      pg.classList.add('on');
    });
  });