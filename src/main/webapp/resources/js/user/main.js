/* main.js */

let top10Offset = 0;

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

  dots.forEach((dot, idx) => {
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

/* =========================
   DOM 로딩 후 실행
========================= */

document.addEventListener('DOMContentLoaded', function () {

  /* Hero 썸네일 싱크 */
  const heroEl = document.getElementById('heroCarousel');
  if (heroEl) {
    const thumbs = document.querySelectorAll('.hero-thumb');

    heroEl.addEventListener('slid.bs.carousel', (e) => {
      thumbs.forEach(t => t.classList.remove('active'));
      if (thumbs[e.to]) thumbs[e.to].classList.add('active');
    });
  }

  /* Notice Tabs */
  document.querySelectorAll('.notice-tabs .nav-link').forEach(link => {
    link.addEventListener('click', e => {
      e.preventDefault();
      document.querySelectorAll('.notice-tabs .nav-link').forEach(l => l.classList.remove('active'));
      link.classList.add('active');
    });
  });

  /* =========================
     TOP10 드롭다운
  ========================= */

  const CATEGORY_LABEL = { REST: '맛집', ACC: '숙소' };
  const CATEGORY_LINK = {
    REST: '/midpj/restaurant.rs',
    ACC: '/midpj/accommodation.ac'
  };

  document.querySelectorAll('[data-category]').forEach(item => {
    item.addEventListener('click', function (e) {
      e.preventDefault();

      const category = this.dataset.category;
      const label = CATEGORY_LABEL[category];

      const dropdownBtn = document.getElementById('categoryDropdown');
      if (dropdownBtn) dropdownBtn.textContent = label;

      const subtitle = document.getElementById('top10Subtitle');
      if (subtitle) {
        subtitle.textContent = `이번 주 가장 많은 사람들이 찾아본 ${label} TOP 10`;
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

      document.querySelectorAll('[data-category]').forEach(el => el.classList.remove('active'));
      this.classList.add('active');

      resetTop10Slider();
    });
  });

  /* =========================
     BEST 추천 AJAX 탭
  ========================= */

  const bestTabs = document.querySelectorAll('#bestTabs [data-best-type]');
  const bestContentWrap = document.getElementById('bestContentWrap');
  const contextPathEl = document.getElementById('contextPath');
  const contextPath = contextPathEl ? contextPathEl.value : '/midpj';

  function loadBestContent(type) {
    if (!bestContentWrap) return;

    fetch(contextPath + '/main/best/ajax?type=' + encodeURIComponent(type))
      .then(res => res.text())
      .then(html => {
        bestContentWrap.innerHTML = html;
      })
      .catch(err => {
        console.error('BEST 추천 AJAX 오류:', err);
      });
  }

  if (bestTabs.length && bestContentWrap) {
    bestTabs.forEach(link => {
      link.addEventListener('click', function (e) {

        e.preventDefault();

        bestTabs.forEach(tab => tab.classList.remove('active'));
        this.classList.add('active');

        const type = this.dataset.bestType;

        loadBestContent(type);
      });
    });

    /* 최초 로딩 */
    loadBestContent('ALL');
  }

  /* =========================
     TOP10 dots 초기화
  ========================= */

  updateDots();

  /* 브라우저 resize 대응 */

  window.addEventListener('resize', () => {

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