function filterBookmark(category) {
    location.href = contextPath + '/viewBookmarks.do?category=' + category;
}

function toggleBookmark(event, el) {
    event.preventDefault();
    event.stopPropagation();

    const placeId = el.getAttribute('data-place-id');

    fetch(contextPath + '/togglemyFavorite.do?place_id=' + placeId, {
        method: 'GET'
    })
    .then(response => response.text())
    .then(result => {
        result = result.trim();

        if (result === '-1') {
            alert('로그인이 필요합니다.');
            location.href = contextPath + '/login.do';
            return;
        }

        if (result === '0') {
            const cardLink = el.closest('.bookmark-card-link');
            if (cardLink) {
                cardLink.remove();
            }

            const remainCards = document.querySelectorAll('.bookmark-card-link');
            if (remainCards.length === 0) {
                location.reload();
            }
        } else if (result === '1') {
            el.innerHTML = '<i class="bi bi-bookmark-fill"></i>';
        } else {
            alert('즐겨찾기 처리 중 오류가 발생했습니다.');
        }
    })
    .catch(error => {
        console.error('toggleFavorite 오류:', error);
        alert('서버와 통신 중 오류가 발생했습니다.');
    });
}