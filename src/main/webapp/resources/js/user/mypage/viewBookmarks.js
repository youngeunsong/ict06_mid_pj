function toggleBookmark(event, el) {
    // 카드 클릭 이동 막기
    event.preventDefault();
    event.stopPropagation();

    // 장소 ID 가져오기
    const placeId = el.getAttribute('data-place-id');

    // 버튼 안의 아이콘 요소 선택
    const icon = el.querySelector('i');

    // 즐겨찾기 토글 요청 (백엔드 호출)
    fetch(contextPath + '/togglemyFavorite.do?place_id=' + placeId, {
        method: 'GET'
    })
    .then(response => response.text())
    .then(result => {
        result = result.trim();

        // 로그인 안 된 경우
        if (result === '-1') {
            alert('로그인이 필요합니다.');
            location.href = contextPath + '/login.do';
            return;
        }

        // 삭제 성공 (채움 → 빈)
        if (result === '0') {
            icon.classList.remove('bi-bookmark-fill');
            icon.classList.add('bi-bookmark');
        } 
        // 추가 성공 (빈 → 채움)
        else if (result === '1') {
            icon.classList.remove('bi-bookmark');
            icon.classList.add('bi-bookmark-fill');
        } 
        else {
            alert('즐겨찾기 처리 중 오류가 발생했습니다.');
        }
    })
    .catch(error => {
        console.error('togglemyFavorite 오류:', error);
        alert('서버와 통신 중 오류가 발생했습니다.');
    });
}

function filterBookmark(category) {
    location.href = contextPath + '/viewBookmarks.do?category=' + category;
}

function toggleBookmark(event, el) {
    // 카드 클릭 이동 막기
    event.preventDefault();
    event.stopPropagation();

    // 장소 ID 가져오기
    const placeId = el.getAttribute('data-place-id');

    // 버튼 안의 아이콘 요소 선택
    const icon = el.querySelector('i');

    // 즐겨찾기 토글 요청 (백엔드 호출)
    fetch(contextPath + '/togglemyFavorite.do?place_id=' + placeId, {
        method: 'GET'
    })
    .then(response => response.text())
    .then(result => {
        result = result.trim();

        // 로그인 안 된 경우
        if (result === '-1') {
            alert('로그인이 필요합니다.');
            location.href = contextPath + '/login.do';
            return;
        }

        // 삭제 성공 (채움 → 빈)
        if (result === '0') {
            icon.classList.remove('bi-bookmark-fill');
            icon.classList.add('bi-bookmark');
        } 
        // 추가 성공 (빈 → 채움)
        else if (result === '1') {
            icon.classList.remove('bi-bookmark');
            icon.classList.add('bi-bookmark-fill');
        } 
        else {
            alert('즐겨찾기 처리 중 오류가 발생했습니다.');
        }
    })
    .catch(error => {
        console.error('togglemyFavorite 오류:', error);
        alert('서버와 통신 중 오류가 발생했습니다.');
    });
}