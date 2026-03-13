/* boardDetail.js */

/* ── 이미지 데이터 (IMAGE_STORE → CommunityDTO.imageList 매핑) ── */
  const images = [
    'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=900&q=80',
    'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=900&q=80',
    'https://images.unsplash.com/photo-1513407030348-c983a97b98d8?w=900&q=80',
    'https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?w=900&q=80',
  ];
  let curIdx = 0;

  /* 썸네일 클릭 → 대표 이미지 교체 */
  function changeMain(idx) {
    curIdx = idx;
    document.getElementById('mainImg').src = images[idx];
    document.querySelectorAll('.img-thumb').forEach((t, i) => {
      t.classList.toggle('active', i === idx);
    });
  }

  /* 라이트박스 열기 */
  function openLightbox(idx) {
    curIdx = idx;
    document.getElementById('lightbox').classList.add('show');
    updateLightbox();
  }
  function closeLightbox() {
    document.getElementById('lightbox').classList.remove('show');
  }
  function closeLightboxOutside(e) {
    if (e.target === document.getElementById('lightbox')) closeLightbox();
  }
  function lightboxNav(dir) {
    curIdx = (curIdx + dir + images.length) % images.length;
    updateLightbox();
  }
  function updateLightbox() {
    document.getElementById('lightboxImg').src = images[curIdx];
    document.getElementById('lightboxCounter').textContent = (curIdx + 1) + ' / ' + images.length;
    document.querySelectorAll('.img-thumb').forEach((t, i) => {
      t.classList.toggle('active', i === curIdx);
    });
    document.getElementById('mainImg').src = images[curIdx];
  }

  /* ── 좋아요 토글 ── */
  let liked = true;
  function toggleLike() {
    liked = !liked;
    const btn   = document.getElementById('btnLike');
    const icon  = document.getElementById('heartIcon');
    const label = document.getElementById('likeLabel');
    const count = document.getElementById('likeCount');
    if (liked) {
      btn.classList.add('liked');
      icon.className = 'bi bi-heart-fill';
      label.textContent = '좋아요 취소';
      count.textContent = parseInt(count.textContent) + 1;
    } else {
      btn.classList.remove('liked');
      icon.className = 'bi bi-heart';
      label.textContent = '좋아요';
      count.textContent = parseInt(count.textContent) - 1;
    }
  }

  /* ── 댓글 등록 ── */
  function submitComment() {
    const content = document.getElementById('commentContent').value.trim();
    if (!content) { alert('댓글 내용을 입력해주세요.'); return; }
    const list = document.getElementById('commentList');
    const item = document.createElement('div');
    item.className = 'comment-item';
    item.innerHTML = `
      <div class="comment-top">
        <div class="comment-author-wrap">
          <div class="comment-avatar me">나</div>
          <span class="comment-name">솔로트래블러</span>
          <span class="comment-date">방금 전</span>
        </div>
        <button class="btn-comment-del"><i class="bi bi-x-lg"></i> 삭제</button>
      </div>
      <div class="comment-content">${content}</div>`;
    list.appendChild(item);
    document.getElementById('commentContent').value = '';
    const cnt = document.querySelector('.comment-count');
    cnt.textContent = parseInt(cnt.textContent) + 1;
  }

  /* ── 댓글 삭제 ── */
  function deleteComment(id) {
    if (!confirm('댓글을 삭제하시겠습니까?')) return;
    const el = document.getElementById('cmt_' + id);
    if (el) {
      el.style.transition = 'opacity .2s';
      el.style.opacity = '0';
      setTimeout(() => el.remove(), 200);
      const cnt = document.querySelector('.comment-count');
      cnt.textContent = parseInt(cnt.textContent) - 1;
    }
  }

  /* 키보드 방향키로 라이트박스 탐색 */
  document.addEventListener('keydown', e => {
    if (!document.getElementById('lightbox').classList.contains('show')) return;
    if (e.key === 'ArrowRight') lightboxNav(1);
    if (e.key === 'ArrowLeft')  lightboxNav(-1);
    if (e.key === 'Escape')     closeLightbox();
  });