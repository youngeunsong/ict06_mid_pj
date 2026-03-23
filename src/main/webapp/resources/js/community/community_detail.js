/* community_detail.js */

document.addEventListener("DOMContentLoaded", function () {
    const likeBtn = document.getElementById("likeBtn");
    const likeCount = document.getElementById("likeCount");

    if (!likeBtn || !likeCount) return;

    likeBtn.addEventListener("click", function (e) {
        e.preventDefault();
        e.stopPropagation();

        const postId = this.dataset.postId;
        const path = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 1));

        fetch(path + "/community_likeToggle.co", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "AJAX": "true"
            },
            body: "post_id=" + encodeURIComponent(postId)
        })
        .then(response => response.text())
        .then(result => {
            result = result.trim();

            let currentCount = parseInt(likeCount.textContent, 10) || 0;

            if (result === "logout") {
                alert("로그인이 필요합니다.");
                window.location.href = path + "/login.do";
                return;
            }

            if (result === "insert") {
                likeCount.textContent = currentCount + 1;
                likeBtn.classList.add("liked");
            } else if (result === "delete") {
                likeCount.textContent = Math.max(0, currentCount - 1);
                likeBtn.classList.remove("liked");
            } else {
                alert("좋아요 처리 중 오류가 발생했습니다.");
            }
        })
        .catch(error => {
            console.error("좋아요 오류:", error);
            alert("좋아요 처리 중 오류가 발생했습니다.");
        });
    });
});