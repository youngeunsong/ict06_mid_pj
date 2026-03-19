/* ========================================
   member.js - 관리자 > 회원 관리 공통 JS
   ========================================*/

//필터 설정
//태그 클릭 시 hidden input 값 변경 후 폼 submit
function setFilter(type, value) {
	if(type === 'status') {
		document.getElementById('statusInput').value = value;
	} else if(type === 'role') {
		document.getElementById('roleInput').value = value;
	}
	document.querySelector('form').submit();
}

//체크된 user_id 수집
function getCheckedUserIds() {
	const checked = document.querySelectorAll(".member-check:checked");
	if(checked.length === 0) {
		alert("선택된 회원이 없습니다.");
		return null;
	}
	return Array.from(checked).map(cb => cb.value);
}

//전체 선택
document.addEventListener("DOMContentLoaded", function() {
	const checkAll = document.getElementById("checkAll");
	if(checkAll) {
		checkAll.addEventListener("change", function() {
			document.querySelectorAll(".member-check").forEach(cb => cb.checked = this.checked);
		});
	}
});

//일괄 제재
function bulkBan() {
	const ids = getCheckedUserIds();
	if(!ids) return;
	if(!confirm(ids.length + "명을 제재 처리하시겠습니까?")) return;
	
	const params = new URLSearchParams();
	ids.forEach(id => params.append("user_ids", id));
	
	fetch(path + "/bulkBan.adme", {
		method: "post",
		headers: {"Content-Type":"application/x-www-form-urlencoded"},
		body: params.toString()
	})
	.then(res => res.text())
	.then(result => {
		const parts = result.split("/");
		alert(parts[0] + "/" + parts[1] + "명 제재 완료");
		location.reload();
	});
}

//일괄 제재해제
function bulkUnban() {
	const ids = getCheckedUserIds();
	if(!ids) return;
	if(!confirm(ids.length + "명의 제재를 해제하시겠습니까?")) return;
	
	const params = new URLSearchParams();
	ids.forEach(id => params.append("user_ids", id));
	
	fetch(path + "/bulkUnban.adme", {
		method: "post",
		headers: {"Content-Type":"application/x-www-form-urlencoded"},
		body: params.toString()
	})
	.then(res => res.text())
	.then(result => {
		const parts = result.split("/");
		alert(parts[0] + "/" + parts[1] + "명 제재해제 완료");
		location.reload();
	});
}

//작성자 제재
function banUser(user_id) {
	if(!confirm(user_id + "사용자를 제재 처리하시겠습니까?"))
		return;
	fetch(path + "/banUser.adme", {
		method: "post",
		headers: {"Content-Type":"application/x-www-form-urlencoded"},
		body: "user_id=" + user_id
	})
	.then(res => res.text())
	.then(result => {
		alert(result === "success" ? "제재 처리되었습니다." : "제재 처리 실패")
		location.reload();
	});
}

//작성자 제재 해제
function unbanUser(user_id) {
	if(!confirm(user_id + "사용자의 제재를 해제하시겠습니까?"))
		return;
	fetch(path + "/unbanUser.adme", {
		method: "post",
		headers: {"Content-Type":"application/x-www-form-urlencoded"},
		body: "user_id=" + user_id
	})
	.then(res => res.text())
	.then(result => {
		alert(result === "success" ? "제재 해제되었습니다." : "제재 해제 실패")
		location.reload();
	});
}