/* modifyBoard.js */

  /* ── 초기 글자수 세팅 ── */
  window.addEventListener('DOMContentLoaded', () => {
    countTitle();
    countContent();
  });

  /* ── 글자수 카운터 ── */
  function countTitle() {
    const len = document.getElementById('titleInput').value.length;
    const el  = document.getElementById('titleCounter');
    el.textContent = len + ' / 200';
    el.className = 'char-counter' + (len >= 200 ? ' limit' : len >= 160 ? ' warn' : '');
  }
  function countContent() {
    const len = document.getElementById('contentInput').value.length;
    document.getElementById('contentCounter').textContent = len.toLocaleString() + '자';
  }

  /* ── 기존 이미지 상태 관리 ── */
  // 삭제 대기 목록 (image_id 기준, JSP에서는 hidden input으로 전송)
  const deletedIds = new Set();
  let repIdx = 0; // 현재 대표 이미지 인덱스
  const totalExist = 4;

  function deleteExist(idx) {
    if (!confirm('이미지를 삭제하시겠습니까?\n저장 시 실제로 삭제됩니다.')) return;
    const el = document.getElementById('exist_' + idx);
    el.classList.add('deleted');
    // 기존 액션 버튼 제거 후 삭제 배지 표시
    el.querySelector('.exist-actions').remove();
    if (!el.querySelector('.del-badge')) {
      const badge = document.createElement('div');
      badge.className = 'del-badge';
      badge.textContent = '삭제 예정';
      el.appendChild(badge);
    }
    deletedIds.add(idx);
    // 대표 이미지 삭제 시 다음 살아있는 이미지를 대표로
    if (idx === repIdx) {
      for (let i = 0; i < totalExist; i++) {
        if (!deletedIds.has(i)) { setRep(i); break; }
      }
    }
    updateChangeSummary();
    updateUploadHint();
  }

  function setRep(idx) {
    // 이전 대표 배지 제거
    document.querySelectorAll('.exist-item').forEach(el => {
      el.classList.remove('rep');
      const old = el.querySelector('.rep-badge');
      if (old) old.remove();
    });
    repIdx = idx;
    const el = document.getElementById('exist_' + idx);
    if (!el) return;
    el.classList.add('rep');
    const badge = document.createElement('div');
    badge.className = 'rep-badge';
    badge.textContent = '대표';
    el.appendChild(badge);
  }

  function updateChangeSummary() {
    const wrap = document.getElementById('changeSummary');
    wrap.innerHTML = '';
    if (deletedIds.size > 0) {
      const chip = document.createElement('span');
      chip.className = 'change-chip del';
      chip.textContent = '✕ 삭제 예정 ' + deletedIds.size + '장';
      wrap.appendChild(chip);
    }
    if (newFiles.length > 0) {
      const chip = document.createElement('span');
      chip.className = 'change-chip add';
      chip.textContent = '+ 새 이미지 ' + newFiles.length + '장';
      wrap.appendChild(chip);
    }
  }

  /* ── 새 이미지 업로드 ── */
  let newFiles = [];
  const MAX_TOTAL = 5;

  function currentTotal() {
    return (totalExist - deletedIds.size) + newFiles.length;
  }

  function updateUploadHint() {
    const remain = MAX_TOTAL - currentTotal();
    const hint = document.getElementById('uploadHint');
    if (remain <= 0) {
      hint.textContent = '최대 5장에 도달했습니다.';
    } else {
      hint.textContent = `현재 ${currentTotal()}장 · 최대 5장까지 가능 (${remain}장 더 추가 가능)`;
    }
  }

  function handleFiles(files) {
    const remain = MAX_TOTAL - currentTotal();
    if (remain <= 0) { alert('이미지는 최대 5장까지 첨부 가능합니다.'); return; }
    Array.from(files).slice(0, remain).forEach(file => {
      if (!['image/jpeg', 'image/png'].includes(file.type)) {
        alert('JPG, PNG 형식만 업로드 가능합니다.'); return;
      }
      if (file.size > 10 * 1024 * 1024) {
        alert('파일 크기는 10MB 이하만 가능합니다.'); return;
      }
      newFiles.push(file);
      const reader = new FileReader();
      reader.onload = e => renderNewPreview(e.target.result, newFiles.length - 1);
      reader.readAsDataURL(file);
    });
    document.getElementById('fileInput').value = '';
    updateUploadHint();
    updateChangeSummary();
  }

  function renderNewPreview(src, idx) {
    const grid = document.getElementById('newPreviewGrid');
    const item = document.createElement('div');
    item.className = 'new-preview-item';
    item.id = 'newprev_' + idx;
    item.innerHTML = `
      <img src="${src}" alt="새 이미지">
      <div class="new-badge">새 이미지</div>
      <button class="preview-del" onclick="removeNew(${idx})"><i class="bi bi-x"></i></button>`;
    grid.appendChild(item);
  }

  function removeNew(idx) {
    newFiles.splice(idx, 1);
    const grid = document.getElementById('newPreviewGrid');
    grid.innerHTML = '';
    newFiles.forEach((file, i) => {
      const reader = new FileReader();
      reader.onload = e => renderNewPreview(e.target.result, i);
      reader.readAsDataURL(file);
    });
    updateUploadHint();
    updateChangeSummary();
  }

  function onDragOver(e)  { e.preventDefault(); document.getElementById('uploadArea').classList.add('dragover'); }
  function onDragLeave()  { document.getElementById('uploadArea').classList.remove('dragover'); }
  function onDrop(e)      { e.preventDefault(); onDragLeave(); handleFiles(e.dataTransfer.files); }

  /* ── 유효성 검사 & 수정 ── */
  function submitForm() {
    let valid = true;
    const title   = document.getElementById('titleInput');
    const content = document.getElementById('contentInput');

    if (!title.value.trim()) {
      title.classList.add('err');
      document.getElementById('titleErr').classList.add('show');
      valid = false;
    } else {
      title.classList.remove('err');
      document.getElementById('titleErr').classList.remove('show');
    }
    if (!content.value.trim()) {
      content.classList.add('err');
      document.getElementById('contentErr').classList.add('show');
      valid = false;
    } else {
      content.classList.remove('err');
      document.getElementById('contentErr').classList.remove('show');
    }
    if (!valid) return;

    // 실제 프로젝트에서는 form POST (deletedIds, repIdx, newFiles 함께 전송)
    alert('게시글이 수정되었습니다!');
  }

  document.getElementById('titleInput').addEventListener('input', function() {
    if (this.value.trim()) { this.classList.remove('err'); document.getElementById('titleErr').classList.remove('show'); }
  });
  document.getElementById('contentInput').addEventListener('input', function() {
    if (this.value.trim()) { this.classList.remove('err'); document.getElementById('contentErr').classList.remove('show'); }
  });