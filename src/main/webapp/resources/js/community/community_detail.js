document.addEventListener("DOMContentLoaded", function () {
    const likeBtn = document.getElementById("likeBtn");
    const likeCountEl = document.getElementById("likeCount");
    const kakaoShareBtn = document.getElementById("kakaoShareBtn");

    // 좋아요 버튼
    if (likeBtn && likeCountEl) {
        likeBtn.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();

            let count = parseInt(likeCountEl.textContent.trim(), 10) || 0;
            const isActive = !likeBtn.classList.contains("active");

            if (isActive) {
                likeBtn.classList.add("active");
                likeCountEl.textContent = count + 1;
            } else {
                likeBtn.classList.remove("active");
                likeCountEl.textContent = Math.max(count - 1, 0);
            }

            const icon = likeBtn.querySelector("i");
            if (icon) {
                icon.className = isActive ? "bi bi-heart-fill" : "bi bi-heart";
            }
        });
    }

    // 카카오톡 공유 버튼
    if (kakaoShareBtn) {
        kakaoShareBtn.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();

            if (typeof shareKakao === "function") {
                shareKakao();
            } else {
                console.warn("shareKakao 함수가 없습니다.");
            }
        });
    }
});