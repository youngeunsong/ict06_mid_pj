/* event.js */

  document.querySelectorAll('.pg').forEach(pg => {
    pg.addEventListener('click', e => {
      e.preventDefault();
      document.querySelectorAll('.pg').forEach(p => p.classList.remove('on'));
      pg.classList.add('on');
    });
  });