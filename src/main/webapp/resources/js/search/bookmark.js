function toggleBookmark(event, btn) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }

    const placeId = btn.dataset.placeId;
    if (!placeId) return;

    const contextPath =
        window.contextPath ||
        document.body.dataset.contextPath ||
        '';

    fetch(contextPath + "/favorite/toggle", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
            "X-Requested-With": "XMLHttpRequest"
        },
        body: "place_id=" + encodeURIComponent(placeId)
    })
    .then(response => response.json())
    .then(data => {
        console.log("북마크 응답:", data);

        if (data.status === "logout") {
            alert("로그인이 필요합니다.");
            return;
        }

        const icon = btn.querySelector("i");
        if (!icon) return;

        if (data.status === "added") {
            icon.classList.remove("fa-regular");
            icon.classList.add("fa-solid");
        } else if (data.status === "removed") {
            icon.classList.remove("fa-solid");
            icon.classList.add("fa-regular");
        }
    })
    .catch(error => {
        console.error("북마크 처리 오류:", error);
    });
}

document.addEventListener("click", function(event) {
    const btn = event.target.closest(".bookmark-btn");
    if (!btn) return;

    toggleBookmark(event, btn);
});