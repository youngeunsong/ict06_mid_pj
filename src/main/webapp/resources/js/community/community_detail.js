document.addEventListener("DOMContentLoaded", function () {
    const likeBtn = document.getElementById("likeBtn");
    const likeCountEl = document.getElementById("likeCount");
    const kakaoShareBtn = document.getElementById("kakaoShareBtn");

    if (likeBtn && likeCountEl) {
        likeBtn.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();

            const postId = likeBtn.dataset.postId;
            const path = likeBtn.dataset.path;
            const sessionId = likeBtn.dataset.sessionId;

            if (!sessionId) {
                alert("로그인 후 이용 가능합니다.");
                location.href = path + "/login.do";
                return;
            }

            fetch(path + "/community_likeToggle.co", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                },
                body: "post_id=" + encodeURIComponent(postId)
            })
            .then(response => response.text())
            .then(result => {
                let count = parseInt(likeCountEl.textContent.trim(), 10) || 0;
                const icon = likeBtn.querySelector("i");

                if (result === "insert") {
                    likeBtn.classList.add("active");
                    likeCountEl.textContent = count + 1;
                    if (icon) icon.className = "bi bi-heart-fill";
                } else if (result === "delete") {
                    likeBtn.classList.remove("active");
                    likeCountEl.textContent = Math.max(count - 1, 0);
                    if (icon) icon.className = "bi bi-heart";
                } else if (result === "logout") {
                    alert("로그인 후 이용 가능합니다.");
                    location.href = path + "/login.do";
                } else {
                    alert("좋아요 처리 중 오류가 발생했습니다.");
                    console.error("Unexpected result:", result);
                }
            })
            .catch(error => {
                console.error("좋아요 요청 실패:", error);
                alert("좋아요 처리 중 오류가 발생했습니다.");
            });
        });
    }

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