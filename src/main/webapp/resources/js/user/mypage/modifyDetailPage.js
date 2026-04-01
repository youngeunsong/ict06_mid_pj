function validateForm() {
    const pw = document.getElementById("password").value;
    const pwConfirm = document.getElementById("password_confirm").value;

    const hasEng = /[a-zA-Z]/.test(pw);
    const hasNum = /[0-9]/.test(pw);
    const hasSpe = /[~!@#$%^&*()_+|<>?:{}]/.test(pw);
    const validLen = pw.length >= 8 && pw.length <= 20;

    if (!validLen) {
        alert("비밀번호는 8~20자 이내로 입력해주세요.");
        document.getElementById("password").focus();
        return false;
    }

    if (!hasEng || !hasNum || !hasSpe) {
        alert("비밀번호는 영문, 숫자, 특수문자를 모두 포함해야 합니다.");
        document.getElementById("password").focus();
        return false;
    }

    if (pw !== pwConfirm) {
        alert("변경할 비밀번호가 서로 일치하지 않습니다.");
        document.getElementById("password_confirm").focus();
        return false;
    }

    if (!confirm("입력하신 정보로 수정하시겠습니까?")) {
        return false;
    }

    return true;
}