/* ========================================
   community.js - 관리자 > 커뮤니티 관리 공통 JS
   ========================================*/

//전체 선택
document.addEventListener("DOMContentLoaded", function() {
	const checkAll = document.getElementById("checkAll");
	if(checkAll) {
		checkAll.addEventListener("change", function() {
			document.querySelectorAll(".post-check").forEach(cb => cb.checked = this.checked);
		});
	}
});

//체크된 post_id 수집
function getCheckedIds() {
	const checked = document.querySelectorAll(".post-check:checked");
	if(checked.length === 0) {
		alert("선택된 게시글이 없습니다.");
		return null;
	}
	return Array.from(checked).map(cb => cb.value);
}

//일괄처리
function bulkAction(action) {
	const ids = getCheckedIds();
	if(!ids)
		return;
	
	const actionText = action === 'hide' ? '숨김' : action === 'show' ? '숨김해제' : '삭제';
	if(!confirm(ids.length + "개 게시글을 " + actionText + " 처리하시겠습니까?"))
		return;
	
	const params = new URLSearchParams();
	params.append("action", action);
	ids.forEach(id => params.append("post_ids", id));
	
	fetch(path + "/bulkAction.adco", {
		method: "post",
		headers: {"Content-Type": "application/x-www-form-urlencoded"},
		body: params.toString()
	})
	.then(res => res.text())
	.then(result => {
		const parts = result.split("/");
		alert(parts[0] + "/" + parts[1] + "개 처리 완료");
		location.reload();
	});
}

//게시글 숨김
function hidePost(post_id) {
	if(!confirm("이 게시글을 숨김 처리하시겠습니까?"))
		return;
	fetch(path + "/hidePost.adco", {
		method: "post",
		headers: {"Content-Type":"application/x-www-form-urlencoded"},
		body: "post_id=" + post_id
	})
	.then(res => res.text())
	.then(result => {
		alert(result === "success" ? "숨김 처리되었습니다." : "숨김 처리 실패")
		location.reload();
	});
}

//게시글 숨김 해제
function showPost(post_id) {
	if(!confirm("숨김을 해제하시겠습니까?"))
		return;
	fetch(path + "/showPost.adco", {
		method: "post",
		headers: {"Content-Type":"application/x-www-form-urlencoded"},
		body: "post_id=" + post_id
	})
	.then(res => res.text())
	.then(result => {
		alert(result === "success" ? "숨김 해제되었습니다." : "숨김 해제 실패")
		location.reload();
	});
}


//게시글 삭제
function deletePost(post_id) {
	if(!confirm("이 게시글을 삭제하시겠습니까?"))
		return;
	fetch(path + "/deletePost.adco", {
		method: "post",
		headers: {"Content-Type":"application/x-www-form-urlencoded"},
		body: "post_id=" + post_id
	})
	.then(res => res.text())
	.then(result => {
		alert(result === "success" ? "삭제되었습니다." : "삭제 실패")
		location.reload();
	})
}
