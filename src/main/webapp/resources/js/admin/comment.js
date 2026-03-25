/* ========================================
   comment.js - 관리자 > 댓글 관리 공통 JS
   ========================================*/

//전체 선택
document.addEventListener("DOMContentLoaded", function() {
	const checkAll = document.getElementById("checkAll");
	if(checkAll) {
		checkAll.addEventListener("change", function() {
			document.querySelectorAll(".comment-check").forEach(cb => cb.checked = this.checked);
		});
	}
});

//체크된 comment_id 수집
function getCheckedIds() {
	const checked = document.querySelectorAll(".comment-check:checked");
	if(checked.length === 0) {
		alert("선택된 댓글이 없습니다.");
		return null;
	}
	return Array.from(checked).map(cb => cb.value);
}

//일괄처리
function bulkCommentAction(action) {
	const ids = getCheckedIds();
	if(!ids)
		return;
	
	const actionText = action === 'hide' ? '숨김' : action === 'show' ? '숨김해제' : '삭제';
	if(!confirm(ids.length + "개 댓글을 " + actionText + " 처리하시겠습니까?"))
		return;
	
	const params = new URLSearchParams();
	params.append("action", action);
	ids.forEach(id => params.append("comment_ids", encodeURIComponent(id)));
	
	fetch(path + "/bulkCommentAction.adco", {
		method: "post",
		headers: {"Content-Type": "application/x-www-form-urlencoded"},
		body: params.toString()
	})
	.then(res => res.text())
	.then(result => {
		alert(result + "개 처리 완료");
		location.reload();
	});
}

//댓글 숨김
function hideComment(comment_id) {
	if(!confirm("이 댓글을 숨김 처리하시겠습니까?"))
		return;
	fetch(path + "/hideComment.adco", {
		method: "post",
		headers: {"Content-Type":"application/x-www-form-urlencoded"},
		body: "comment_id=" + encodeURIComponent(comment_id)
	})
	.then(res => res.text())
	.then(result => {
		alert(result === "success" ? "숨김 처리되었습니다." : "숨김 처리 실패")
		location.reload();
	});
}

//댓글 숨김 해제
function showComment(comment_id) {
	if(!confirm("숨김을 해제하시겠습니까?"))
		return;
	fetch(path + "/showComment.adco", {
		method: "post",
		headers: {"Content-Type":"application/x-www-form-urlencoded"},
		body: "comment_id=" + encodeURIComponent(comment_id)
	})
	.then(res => res.text())
	.then(result => {
		alert(result === "success" ? "숨김 해제되었습니다." : "숨김 해제 실패")
		location.reload();
	});
}


//댓글 삭제
function deleteComment(comment_id) {
	if(!confirm("이 댓글을 삭제하시겠습니까?"))
		return;
	fetch(path + "/deleteComment.adco", {
		method: "post",
		headers: {"Content-Type":"application/x-www-form-urlencoded"},
		body: "comment_id=" + encodeURIComponent(comment_id)
	})
	.then(res => res.text())
	.then(result => {
		alert(result === "success" ? "삭제되었습니다." : "삭제 실패")
		location.reload();
	})
}
