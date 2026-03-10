/* 카드 이미지 상단 북마크 */
// 꼭 css > bookmark.css와 함께 사용하세요.

function toggleBookmark(event, btn) {
    event.preventDefault();
    event.stopPropagation();

    const contextPath = document.getElementById('contextPath').value;
    const loginUserId = document.getElementById('loginUserId').value;

    if (!loginUserId) {
        alert('로그인 후 사용이 가능합니다.');
        location.href = contextPath + '/login.do';
        return;
    }

	const placeId = btn.dataset.placeId;
    const icon = btn.querySelector('i');

   fetch(contextPath + "/favorite/toggle", {

        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },

        body: "place_id=" + placeId

    })
    .then(res => res.json())
    .then(data => {

        if (data.status === "added") {

            icon.classList.remove("fa-regular");
            icon.classList.add("fa-solid");

        } else if (data.status === "removed") {

            icon.classList.remove("fa-solid");
            icon.classList.add("fa-regular");

        } else if (data.status === "logout") {

            alert("로그인이 필요합니다.");
            location.href = contextPath + "/login.do";

        }

    })
    .catch(err => {

        console.error("즐겨찾기 오류:", err);
    });
}