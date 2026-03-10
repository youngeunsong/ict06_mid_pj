/**
 * login.js
 */

window.onload = function() {
    // 1. 비밀번호 보이기/숨기기 토글 로직
    const toggleBtn = document.getElementById('togglePassword');

    const pwInput = document.getElementById('password');


    if (toggleBtn) {
        toggleBtn.onclick = function() {
            // 알림창이 뜨는지 확인 (안 뜨면 JS 연결 문제)

            console.log("아이콘 클릭됨!"); 
            
            if (pwInput.type === 'password') {
                pwInput.type = 'text';
                this.className = 'fa-solid fa-eye'; // 클래스 교체
                this.style.color = '#f91a32';
            } else {
                pwInput.type = 'password';
                this.className = 'fa-solid fa-eye-slash';
                this.style.color = '#888';
            }
        };
    } else {

		console.log("아이콘을 찾을 수 없습니다.");
    }
};

function loginCheck() {
    const id = document.loginform.user_id.value;
    const pw = document.loginform.password.value;

    if (!id) {
        alert("아이디를 입력하세요.");
        document.loginform.user_id.focus();
        return false;
    }

    if (!pw) {
        alert("비밀번호를 입력하세요.");
        document.loginform.user_password.focus();
        return false;
    }

    return true;
}

