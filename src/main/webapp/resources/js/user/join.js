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
        const hiddenId = document.inputform.hiddenUserId.value;
        const userPwd = document.inputform.user_password.value;
        const rePwd = document.inputform.re_password.value;
        const idRegExp = /^[a-zA-Z0-9]{6,20}$/; // 영문, 숫자 6~20자 규칙

		// 2) 아이디 유효성 검사
        if (!idRegExp.test(userId)) {
            alert("아이디는 6~20자의 영문, 숫자여야 합니다.");
            document.inputform.user_id.focus();
            return;
        }
        
    if (hiddenId === "0") {
	    // 1. 중복확인 버튼
	    const overlapBtn = document.querySelector('.btn_overlap');
	    
	    if (overlapBtn) {
	        // 2. 흔들림과 색상 변경 효과
	        overlapBtn.classList.add('apply-shake');
	        
	        // 3. 알림창
	        alert("아이디 중복확인이 필요합니다.");
	        
	        // 4. 원래 상태로 되돌리기
	        setTimeout(() => {
	            overlapBtn.classList.remove('apply-shake');
	        }, 1000); 
	        
	        // 5. 버튼으로 포커스
	        overlapBtn.focus();
    	}
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
    const idRegExp = /^[a-zA-Z0-9]{6,20}$/; 

    //(기본 검사): 아이디를 아예 입력 안 했을 때
    if (!userId) {
        alert("아이디를 입력하세요.");
        document.getElementById("user_id").focus();
        return;
    }

	// [수정 완료] userId (84번 줄에서 정의한 변수)를 사용하세요!
    if (userId.toLowerCase().includes("admin")) { 
        alert("아이디에 'admin' 키워드를 포함할 수 없습니다.");
        document.getElementById("user_id").value = "";
        document.getElementById("user_id").focus();
        return;
    }

    // 1차 필터링: 서버에 묻기 전에 '형식'이 맞는지 먼저 검사
    // 형식이 안 맞으면 서버(DB)까지 갈 필요도 없이 여기서 바로 차단
    if (!idRegExp.test(userId)) {
        idMessage.innerHTML = "6~20자의 영문, 숫자여야 합니다.";
        idMessage.style.color = "red"; 
        document.inputform.hiddenUserId.value = "0"; 
        
        // 메시지가 흔들리는 효과(CSS apply-shake)
        idMessage.classList.add('apply-shake');
        setTimeout(() => idMessage.classList.remove('apply-shake'), 500);
        return; 
    }

    // AJAX 실행: 형식이 통과되었다면 실제 DB에 중복된 아이디가 있는지 확인.
    const xhr = new XMLHttpRequest();
    
    // 서블릿 호출: GET 방식으로 입력받은 아이디를 파라미터로 보냄.
    xhr.open("GET", "/midpj/idCheck.do?user_id=" + userId, true);

    xhr.onreadystatechange = function() {
        // 서버로부터 응답이 완전히 돌아왔을 때(4) + 성공(200)일 때 실행.
        if (xhr.readyState === 4 && xhr.status === 200) {

            // 서버(UserServiceImpl)에서 보낸 숫자(-1, -2, 0, 1 등)를 정수로 변환
            const result = parseInt(xhr.responseText.trim(), 10);
            
            // 서버 결과값에 따른 상세 메시지 처리
            if (result === 1 || result === -2) { 
                // DB에 이미 있거나(-2), 중복(1)이라고 서버가 판단한 경우
                idMessage.innerHTML = "이미 사용 중인 아이디입니다.";
                idMessage.style.color = "red";
                document.inputform.hiddenUserId.value = "0"; // 다음 단계 못 넘어가게 0
                
            } else if (result === -1) { 
                // 서버에서 "길이가 너무 짧다"고 판단하여 보낸 값(-1) 처리
                idMessage.innerHTML = "아이디가 너무 짧습니다 (6자 이상).";
                idMessage.style.color = "red";
                document.inputform.hiddenUserId.value = "0";
                
            } else if (result === 0) { 
                // DB에 중복이 없고, 모든 검사를 통과했을 때 (성공)
                idMessage.innerHTML = "사용 가능한 아이디입니다.";
                idMessage.style.color = "blue"; // 성공은 파란색
                document.inputform.hiddenUserId.value = "1"; // 중복 확인 완료! 다음 단계 가능(1)
            }
        }
    };
    xhr.send(); // 서버로 요청 전송
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

/**
 * 4. 회원가입 전 최종 유효성 검사 (onsubmit)
 * 사용자가 '회원가입 완료' 버튼을 누르는 시점에 실행.
 * 하나라도 false를 리턴하면 서버로 데이터가 전송되지 못하게 함.
 */
function signInCheck() {
    const name = document.inputform.name.value;           
    const birthday = document.inputform.birth_date.value; 
    const email1 = document.inputform.email1.value;      
    const email2 = document.inputform.email2.value;       
    const pwd = document.inputform.password.value;      
    
    // [1. 이름 검사] 
    if (!name) {
        alert("이름을 입력해주세요.");
        document.inputform.name.focus();
        return false;
    }

    // [2. 비밀번호 보안 검사] 
    // 이건 서버(UserServiceImpl)의 보안 기준(-3번 에러)
    if (pwd.length < 8) {
        alert("비밀번호는 최소 8자 이상이어야 합니다.");
        document.inputform.password.focus();
        return false;
    }

    // [3. 생년월일 검사]
    if (!birthday) {
        alert("생년월일을 선택해주세요.");
        return false;
    }

    // [4. 이메일 정합성 검사] 
    if (!email1 || !email2) {
        alert("이메일을 완성해주세요.");
        if(!email1) document.inputform.email1.focus();
        else document.getElementById("user_email2").focus();
        return false;
    }

    return true;
}

// 5. 회원가입 비번 유효성검사, 눈모양
document.addEventListener('DOMContentLoaded', function() { // 안의 코드는 사용자가 타이핑을 할 때마다 반응
    const passwordInput = document.getElementById('user_password');
    const rePasswordInput = document.getElementById('re_password');
    
    // 요소들 정의
    const defaultTxt = document.getElementById('pwd_default_txt');
    const checkList = document.getElementById('pwd_check_list');
    const matchMsg = document.getElementById('pwdMatchMessage');
    
    const checkEng = document.getElementById('check_eng');
    const checkNum = document.getElementById('check_num');
    const checkSpe = document.getElementById('check_spe');
    const checkLen = document.getElementById('check_len');

    // 5-1. 비밀번호 실시간 유효성 검사 및 문구 전환
    passwordInput.addEventListener('input', function() {
        const val = this.value;

        // [기능 추가] 글자가 있으면 체크리스트 보이고, 없으면 기본문구 노출
        if (val.length > 0) {
            if(defaultTxt) defaultTxt.style.display = 'none';
            if(checkList) checkList.style.display = 'block';
        } else {
            if(defaultTxt) defaultTxt.style.display = 'block';
            if(checkList) checkList.style.display = 'none';
        }

        // 유효성 체크 (파란색 활성화)
        if (/[a-zA-Z]/.test(val)) checkEng.classList.add('active'); else checkEng.classList.remove('active');
        if (/[0-9]/.test(val)) checkNum.classList.add('active'); else checkNum.classList.remove('active');
        if (/[~!@#$%^&*()_+|<>?:{}]/.test(val)) checkSpe.classList.add('active'); else checkSpe.classList.remove('active');
        if (val.length >= 8 && val.length <= 20) checkLen.classList.add('active'); else checkLen.classList.remove('active');
        
        checkMatch(); // 비밀번호가 바뀔 때마다 일치 여부도 실시간 체크
    });

    // 2. 비밀번호 확인창 실시간 입력 감지
    rePasswordInput.addEventListener('input', checkMatch);

    // 3. 일치 여부 체크 및 하이라이트 함수 (핵심 기능!)
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
            matchMsg.classList.add('match-success'); // 텍스트 파란색
            rePasswordInput.classList.add('input-match-highlight'); // 입력창 파란 테두리/배경
        } else {
            matchMsg.innerText = "비밀번호가 일치하지 않습니다.";
            matchMsg.classList.remove('match-success');
            rePasswordInput.classList.remove('input-match-highlight');
        }
    }

    // 4. 눈 모양 아이콘 가시성 토글 (아이디/비번/확인창 공용)
    const toggleIcons = document.querySelectorAll('.togglePwd');
    toggleIcons.forEach(icon => {
        icon.addEventListener('click', function() {
            const targetId = this.getAttribute('data-target');
            const field = document.getElementById(targetId);
            const isPwd = field.getAttribute('type') === 'password';
            
            field.setAttribute('type', isPwd ? 'text' : 'password');
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
            
            // 시각적 피드백: 비밀번호가 보일 때는 강조색(#f91a32), 아닐 때는 회색
            this.style.color = isPwd ? '#f91a32' : '#ccc';
        });
    });
});

