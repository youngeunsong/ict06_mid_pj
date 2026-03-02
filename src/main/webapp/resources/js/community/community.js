/**
 *  join.js
 */
/**
 * 회원가입 단계별 제어 및 유효성 검사
 */

// 1. 단계 전환 함수 (Step 1 <-> Step 2)
function nextStep(step) {
    const step1 = document.getElementById("step_div1");
    const step2 = document.getElementById("step_div2");
    const dot1 = document.getElementById("dot1");
    const dot2 = document.getElementById("dot2");

    if (step === 2) {	// [Step 1 -> Step 2로 갈 때 검사]
        const userId = document.inputform.user_id.value;
        const userPwd = document.inputform.user_password.value;
        const rePwd = document.inputform.re_password.value;
        const hiddenId = document.inputform.hiddenUserId.value;

        if (!userId) {
            alert("아이디를 입력해주세요.");
            document.inputform.user_id.focus();
            return;
        }
        if (hiddenId === "0") {
            alert("아이디 중복확인이 필요합니다.");
            return;
        }
        if (!userPwd) {
            alert("비밀번호를 입력해주세요.");
            document.inputform.user_password.focus();
            return;
        }
        if (userPwd !== rePwd) {
            alert("비밀번호가 일치하지 않습니다.");
            document.inputform.re_password.focus();
            return;
        }

        // 화면 전환
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

    if (!userId) {
        alert("아이디를 입력하세요.");
        return;
    }

    // XMLHttpRequest 객체 생성 (AJAX)
    const xhr = new XMLHttpRequest();
    // 서블릿 호출 (GET 방식)
    xhr.open("GET", "/midpj/idCheck.do?user_id=" + userId, true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            // idCheck.jsp에서 찍은 ${selectCnt}를 가져옴
            const result = xhr.responseText.trim();
			
			console.log("서버에서 온 값: [" + result + "]");
			
			
            if (parseInt(result, 10) >= 1) {
                idMessage.innerHTML = "이미 사용 중인 아이디입니다.";
                idMessage.style.color = "red";
                document.inputform.hiddenUserId.value = "0";
            } else {
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
    const name = document.inputform.user_name.value;
    const birthday = document.inputform.user_birthday.value;
    const email1 = document.inputform.user_email1.value;
    const email2 = document.inputform.user_email2.value;

    if (!name) {
        alert("이름을 입력해주세요.");
        return false;
    }
    if (!birthday) {
        alert("생년월일을 선택해주세요.");
        return false;
    }
    if (!email1 || !email2) {
        alert("이메일을 완성해주세요.");
        return false;
    }

    // 모든 검사 통과 시 서블릿으로 전송
    return true;
}