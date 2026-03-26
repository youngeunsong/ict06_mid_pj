function toggleBookmark(event, btn) {
	// 상세 페이지로 이동 막기
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }
	
	//HTML의 data-place-id 값 가져오기
    const placeId = btn.dataset.placeId; 
    if (!placeId) return;

	//서버 기본 경로 설정
    const contextPath = CTX || document.body.dataset.contextPath || '';

	//서버에 요청 보내기 - 비동기 통신
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
		    
		    // 현재 페이지의 경로를 가져옵니다 (예: /item/detail?id=123)
		    const currentPath = encodeURIComponent(window.location.pathname + window.location.search);
		    
		    // 로그인 페이지로 보내면서, 로그인 완료 후 돌아올 목적지(next)를 알려줍니다.
		    location.href = contextPath + "/login.do?next=" + currentPath;
		    return;
		}

        const icon = btn.querySelector("i");
        if (!icon) return;

		// 북마크 클릭 후 status가
		// "added"면 아이콘을 fa-solid(컬러 아이콘)으로, "removed"면 fa-regular로 변경
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