function confirmDelete() {
    const pw = document.getElementById("password").value;

    if (!pw) {
        alert("본인 확인을 위해 비밀번호를 입력해주세요.");
        return false;
    }

    return confirm("탈퇴 후에는 복구가 불가능합니다.\n정말 '맛침내!'를 떠나시겠습니까?");
}