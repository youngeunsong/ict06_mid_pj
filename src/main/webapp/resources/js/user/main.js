/* main.js */

let top10Offset = 0;

/* =========================
   공통 값
========================= */

function getValue(id) {
  const el = document.getElementById(id);
  return el ? el.value : '';
}

function getContextPath() {
  return getValue('contextPath') || '/midpj';
}

/* =========================
   TOP10 카드 관련 함수
========================= */

function getTop10Elements() {
  const row = document.getElementById('top10Row');
  const viewport = document.querySelector('.top10-viewport');
  const cards = row ? row.querySelectorAll('.top10-card-wrap') : [];
  return { row, viewport, cards };
}

function getCardStep() {
  const firstCard = document.querySelector('#top10Row .top10-card-wrap');
  if (!firstCard) return 0;

  const row = document.getElementById('top10Row');
  if (!row) return firstCard.offsetWidth;

  const rowStyle = window.getComputedStyle(row);
  const gap = parseFloat(rowStyle.columnGap || rowStyle.gap || 0);

  return firstCard.offsetWidth + gap;
}

function getMaxTranslate() {
  const { row, viewport } = getTop10Elements();
  if (!row || !viewport) return 0;

  return Math.max(0, row.scrollWidth - viewport.clientWidth);
}

function scrollCards(direction) {
  const { row } = getTop10Elements();
  if (!row) return;

  const step = getCardStep();
  const maxTranslate = getMaxTranslate();

  if (step === 0) return;

  top10Offset += direction * step;

  if (top10Offset < 0) top10Offset = 0;
  if (top10Offset > maxTranslate) top10Offset = maxTranslate;

  row.style.transform = `translateX(-${top10Offset}px)`;
  row.style.transition = 'transform 0.35s ease';

  updateDots();
}

function updateDots() {
  const dots = document.querySelectorAll('#top10Dots span');
  const maxTranslate = getMaxTranslate();

  if (!dots.length) return;

  let currentPage = 0;

  if (maxTranslate > 0) {
    currentPage = Math.round((top10Offset / maxTranslate) * (dots.length - 1));
  }

  dots.forEach(function (dot, idx) {
    dot.classList.toggle('active', idx === currentPage);
  });
}

function resetTop10Slider() {
  const { row } = getTop10Elements();
  if (!row) return;

  top10Offset = 0;
  row.style.transform = 'translateX(0)';
  row.style.transition = 'transform 0.35s ease';

  updateDots();
}

window.scrollCards = scrollCards;

/* =========================
   BEST 추천 AJAX
   - 초기 ALL은 서버 렌더링
   - 탭 클릭 시만 AJAX
========================= */

function loadBestContent(type) {
  const bestContentWrap = document.getElementById('bestContentWrap');
  const contextPath = getContextPath();

  if (!bestContentWrap) return;

  fetch(contextPath + '/main/best/ajax?type=' + encodeURIComponent(type))
    .then(function (res) {
      if (!res.ok) {
        throw new Error('BEST AJAX 응답 실패: ' + res.status);
      }
      return res.text();
    })
    .then(function (html) {
      bestContentWrap.innerHTML = html;
    })
    .catch(function (err) {
      console.error('BEST 추천 AJAX 오류:', err);
    });
}

/* =========================
   DOM 로딩 후 실행
========================= */

document.addEventListener('DOMContentLoaded', function () {
  const contextPath = getContextPath();

  /* Hero 썸네일 싱크 */
  const heroEl = document.getElementById('heroCarousel');
  if (heroEl) {
    const thumbs = document.querySelectorAll('.hero-thumb');

    heroEl.addEventListener('slid.bs.carousel', function (e) {
      thumbs.forEach(function (t) {
        t.classList.remove('active');
      });

      if (thumbs[e.to]) {
        thumbs[e.to].classList.add('active');
      }
    });
  }


/* =========================
	이벤트 & 공지
========================= */
const noticeTabBtn = document.getElementById('noticeTabBtn');
const eventTabBtn = document.getElementById('eventTabBtn');
const noticeContent = document.getElementById('noticeContent');
const eventContent = document.getElementById('eventContent');

if (noticeTabBtn && eventTabBtn && noticeContent && eventContent) {
  noticeTabBtn.addEventListener('click', function (e) {
    e.preventDefault();
    e.stopPropagation();

    noticeTabBtn.classList.add('active');
    eventTabBtn.classList.remove('active');

    noticeContent.style.display = 'block';
    eventContent.style.display = 'none';
  });

  eventTabBtn.addEventListener('click', function (e) {
    e.preventDefault();
    e.stopPropagation();

    eventTabBtn.classList.add('active');
    noticeTabBtn.classList.remove('active');

    eventContent.style.display = 'block';
    noticeContent.style.display = 'none';
  });
}





  /* =========================
     TOP10 드롭다운
  ========================= */

  const CATEGORY_LABEL = {
    REST: '맛집',
    ACC: '숙소'
  };

  const CATEGORY_LINK = {
    REST: contextPath + '/restaurant.rs',
    ACC: contextPath + '/accommodation.ac'
  };

  document.querySelectorAll('[data-category]').forEach(function (item) {
    item.addEventListener('click', function (e) {
      e.preventDefault();

      const category = this.dataset.category;
      const label = CATEGORY_LABEL[category];

      const dropdownBtn = document.getElementById('categoryDropdown');
      if (dropdownBtn && label) {
        dropdownBtn.textContent = label;
      }

      const subtitle = document.getElementById('top10Subtitle');
      if (subtitle && label) {
        subtitle.textContent = '이번 달 가장 많은 사람들이 찾아본 ' + label + ' TOP 10';
      }

      const row = document.getElementById('top10Row');
      const hiddenSource = document.getElementById('top10Row_' + category);

      if (row && hiddenSource) {
        row.innerHTML = hiddenSource.innerHTML;
      }

      const viewAll = document.getElementById('top10ViewAllLink');
      if (viewAll && CATEGORY_LINK[category]) {
        viewAll.setAttribute('href', CATEGORY_LINK[category]);
      }

      document.querySelectorAll('[data-category]').forEach(function (el) {
        el.classList.remove('active');
      });
      this.classList.add('active');

      resetTop10Slider();
    });
  });

  /* =========================
     BEST 추천 탭
     - 초기 ALL은 서버 렌더링
     - 탭 클릭부터 AJAX
  ========================= */

  const bestTabs = document.querySelectorAll('#bestTabs [data-best-type]');
  const bestContentWrap = document.getElementById('bestContentWrap');

  if (bestTabs.length && bestContentWrap) {
    bestTabs.forEach(function (link) {
      link.addEventListener('click', function (e) {
        e.preventDefault();

        const type = this.dataset.bestType;
        if (!type) return;

        bestTabs.forEach(function (tab) {
          tab.classList.remove('active');
        });
        this.classList.add('active');

        loadBestContent(type);
      });
    });
  }

/* =========================
	TOP10 dots 초기화
========================= */

updateDots();

/* 브라우저 resize 대응 */
window.addEventListener('resize', function () {
	const maxTranslate = getMaxTranslate();

    if (top10Offset > maxTranslate) {
      top10Offset = maxTranslate;
    }

    const row = document.getElementById('top10Row');
    if (row) {
      row.style.transform = `translateX(-${top10Offset}px)`;
    }

    updateDots();
  });
});

/* =========================
	최하단 공지 이벤트 간락 표 형식
========================= */
document.addEventListener("DOMContentLoaded", function () {
    const noticeTabBtn = document.getElementById("noticeTabBtn");
    const eventTabBtn = document.getElementById("eventTabBtn");
    const noticeContent = document.getElementById("noticeContent");
    const eventContent = document.getElementById("eventContent");

    if (!noticeTabBtn || !eventTabBtn || !noticeContent || !eventContent) return;

    noticeTabBtn.addEventListener("click", function (e) {
        e.preventDefault();
        e.stopPropagation();

        noticeTabBtn.classList.add("active");
        eventTabBtn.classList.remove("active");

        noticeContent.style.display = "block";
        eventContent.style.display = "none";
    });

    eventTabBtn.addEventListener("click", function (e) {
        e.preventDefault();
        e.stopPropagation();

        eventTabBtn.classList.add("active");
        noticeTabBtn.classList.remove("active");

        eventContent.style.display = "block";
        noticeContent.style.display = "none";
    });
});