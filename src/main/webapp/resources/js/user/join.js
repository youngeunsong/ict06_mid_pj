/**
 * join.js
 * 회원가입 단계별 제어 및 유효성 검사
 */

// 1. 단계 전환 함수 (Step 1 <-> Step 2)
function nextStep(step) {
    const step1 = document.getElementById("step_div1");
    const step2 = document.getElementById("step_div2");
    const dot1 = document.getElementById("dot1");
    const dot2 = document.getElementById("dot2");

    // [Step 1 -> Step 2로 이동 시 검사]
    if (step === 2) {
        const userId = document.inputform.user_id.value;
        const hiddenId = document.inputform.hiddenUserId.value;
        const userPwd = document.inputform.password.value; // [수정] user_password -> password
        const rePwd = document.inputform.re_password.value;
        
        const idRegExp = /^[a-zA-Z0-9]{6,20}$/; 
        const pwdRegExp = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+|<>?:{}]).{8,20}$/;

        // 1) 아이디 유효성 검사
        if (!idRegExp.test(userId)) {
            alert("아이디는 6~20자의 영문, 숫자여야 합니다.");
            document.inputform.user_id.focus();
            return;
        }

        // 2) 아이디 중복 확인 여부 체크
        if (hiddenId === "0") {
            const overlapBtn = document.querySelector('.btn_overlap');
            if (overlapBtn) {
                overlapBtn.classList.add('apply-shake');
                alert("아이디 중복확인이 필요합니다.");
                setTimeout(() => overlapBtn.classList.remove('apply-shake'), 1000);
                overlapBtn.focus();
            }
            return;
        }

        // 3) 비밀번호 유효성 검사 (조합 및 길이)
        if (!pwdRegExp.test(userPwd)) {
            alert("비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자여야 합니다.");
            document.inputform.password.focus(); // [수정] focus 대상 변경
            return;
        }

        // 4) 비밀번호 일치 확인
        if (userPwd !== rePwd) {
            alert("비밀번호가 일치하지 않습니다.");
            document.inputform.re_password.focus();
            return;
        }

        // 검사 통과 시 화면 전환
        step1.style.display = "none";
        step2.style.display = "block";
        dot1.style.color = "#ccc";
        dot1.style.fontWeight = "normal";
        dot2.style.color = "#f91a32";
        dot2.style.fontWeight = "bold";

    } else {
        // [Step 2 -> Step 1로 돌아갈 때]
        step1.style.display = "block";
        step2.style.display = "none";
        dot1.style.color = "#f91a32";
        dot1.style.fontWeight = "bold";
        dot2.style.color = "#ccc";
        dot2.style.fontWeight = "normal";
    }
}

// 2. 아이디 중복 확인 (AJAX)
function confirmId() {
    const userId = document.getElementById("user_id").value;
    const idMessage = document.getElementById("idMessage");
    const idRegExp = /^[a-zA-Z0-9]{6,20}$/; 

    if (!userId) {
        alert("아이디를 입력하세요.");
        document.getElementById("user_id").focus();
        return;
    }

    if (userId.toLowerCase().includes("admin")) { 
        alert("아이디에 'admin' 키워드를 포함할 수 없습니다.");
        document.getElementById("user_id").value = "";
        document.getElementById("user_id").focus();
        return;
    }

    if (!idRegExp.test(userId)) {
        idMessage.innerHTML = "6~20자의 영문, 숫자여야 합니다.";
        idMessage.style.color = "red"; 
        document.inputform.hiddenUserId.value = "0"; 
        idMessage.classList.add('apply-shake');
        setTimeout(() => idMessage.classList.remove('apply-shake'), 500);
        return; 
    }

    const xhr = new XMLHttpRequest();
    xhr.open("GET", "/midpj/idCheck.do?user_id=" + userId, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            const result = parseInt(xhr.responseText.trim(), 10);
            if (result === 1 || result === -2) { 
                idMessage.innerHTML = "이미 사용 중인 아이디입니다.";
                idMessage.style.color = "red";
                document.inputform.hiddenUserId.value = "0";
            } else if (result === -1) { 
                idMessage.innerHTML = "아이디가 너무 짧습니다 (6자 이상).";
                idMessage.style.color = "red";
                document.inputform.hiddenUserId.value = "0";
            } else if (result === 0) { 
                idMessage.innerHTML = "사용 가능한 아이디입니다.";
                idMessage.style.color = "blue";
                document.inputform.hiddenUserId.value = "1";
            }
        }
    };
    xhr.send();
}

// 3. 이메일 도메인 선택 함수
function selectEmail() {
    const email2 = document.getElementById("user_email2");
    const email3 = document.inputform.user_email3;

    if (email3.value === "0") {
        email2.value = "";
        email2.readOnly = false;
        email2.focus();
    } else {
        email2.value = email3.value;
        email2.readOnly = true;
    }
}

// 4. 회원가입 전 최종 유효성 검사 (onsubmit)
function signInCheck() {
    const name = document.inputform.name.value;           
    const birthday = document.inputform.birth_date.value; 
    const email1 = document.inputform.email1.value;      
    const email2 = document.inputform.email2.value;       
    const pwd = document.inputform.password.value; // [수정] name="password"
    
    if (!name) {
        alert("이름을 입력해주세요.");
        document.inputform.name.focus();
        return false;
    }

    const pwdRegExp = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+|<>?:{}]).{8,20}$/;
    if (!pwdRegExp.test(pwd)) {
        alert("비밀번호는 영문, 숫자, 특수문자를 포함하여 8~20자여야 합니다.");
        document.inputform.password.focus();
        return false;
    }

    if (!birthday) {
        alert("생년월일을 선택해주세요.");
        return false;
    }

    if (!email1 || !email2) {
        alert("이메일을 완성해주세요.");
        if(!email1) document.inputform.email1.focus();
        else document.getElementById("user_email2").focus();
        return false;
    }
    return true;
}

// 5. 실시간 유효성 검사 및 UI 제어
document.addEventListener('DOMContentLoaded', function() {
    // [수정] getElementById('password') -> JSP의 id="user_password"와 일치시킴
    const passwordInput = document.getElementById('user_password'); 
    const rePasswordInput = document.getElementById('re_password');
    
    const defaultTxt = document.getElementById('pwd_default_txt');
    const checkList = document.getElementById('pwd_check_list');
    const matchMsg = document.getElementById('pwdMatchMessage');
    
    const checkEng = document.getElementById('check_eng');
    const checkNum = document.getElementById('check_num');
    const checkSpe = document.getElementById('check_spe');
    const checkLen = document.getElementById('check_len');

    if (passwordInput) {
        passwordInput.addEventListener('input', function() {
            const val = this.value;

            if (val.length > 0) {
                if(defaultTxt) defaultTxt.style.display = 'none';
                if(checkList) checkList.style.display = 'block';
            } else {
                if(defaultTxt) defaultTxt.style.display = 'block';
                if(checkList) checkList.style.display = 'none';
            }

            // 실시간 체크 표시 활성화
            if (/[a-zA-Z]/.test(val)) checkEng.classList.add('active'); else checkEng.classList.remove('active');
            if (/[0-9]/.test(val)) checkNum.classList.add('active'); else checkNum.classList.remove('active');
            if (/[~!@#$%^&*()_+|<>?:{}]/.test(val)) checkSpe.classList.add('active'); else checkSpe.classList.remove('active');
            if (val.length >= 8 && val.length <= 20) checkLen.classList.add('active'); else checkLen.classList.remove('active');
            
            checkMatch(); 
        });
    }

    if (rePasswordInput) {
        rePasswordInput.addEventListener('input', checkMatch);
    }

    function checkMatch() {
        const p1 = passwordInput.value;
        const p2 = rePasswordInput.value;

        if (p2.length === 0) {
            matchMsg.innerText = "비밀번호를 한 번 더 입력해주세요.";
            matchMsg.classList.remove('match-success');
            rePasswordInput.classList.remove('input-match-highlight');
            return;
        }

        if (p1 === p2 && p1.length > 0) {
            matchMsg.innerText = "✓ 비밀번호가 일치합니다.";
            matchMsg.classList.add('match-success');
            rePasswordInput.classList.add('input-match-highlight');
        } else {
            matchMsg.innerText = "비밀번호가 일치하지 않습니다.";
            matchMsg.classList.remove('match-success');
            rePasswordInput.classList.remove('input-match-highlight');
        }
    }

    // 눈 모양 아이콘 토글
    const toggleIcons = document.querySelectorAll('.togglePwd');
    toggleIcons.forEach(icon => {
        icon.addEventListener('click', function() {
            const targetId = this.getAttribute('data-target');
            const field = document.getElementById(targetId);
            if (field) {
                const isPwd = field.getAttribute('type') === 'password';
                field.setAttribute('type', isPwd ? 'text' : 'password');
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
                this.style.color = isPwd ? '#f91a32' : '#ccc';
            }
        });
    });
});