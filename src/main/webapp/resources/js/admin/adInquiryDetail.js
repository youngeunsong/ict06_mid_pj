/**
 * 1:1 문의 관리자 상세 페이지 전용 스크립트
 * 기능: 답변 임시저장(답변중) 및 최종 답변 등록 처리
 */

/**
 * 답변 저장 및 상태 업데이트 함수
 * @param {string} contextPath - JSP에서 전달받은 ${path} (서버 루트 경로)
 * @param {string} statusValue - 업데이트할 상태 값 ('PROGRESS' 또는 'ANSWERED')
 */

function saveReply(contextPath, statusValue) {
    
    // 1. 필요한 DOM 요소 참조
    const inquiryId = document.getElementById("inquiry_id").value.trim();
    const replyContent = document.getElementById("admin_reply").value;

    // 2. 유효성 검사
    if (statusValue === 'ANSWERED' && !replyContent.trim()) {
        alert("사용자에게 전달할 답변 내용을 입력해주세요.");
        document.getElementById("admin_reply").focus();
        return;
    }

    // 긴 텍스트와 특수문자 처리를 위해 파라미터를 직접 인코딩
    // URLSearchParams를 toString()으로 보내는 것보다 이 방식이 긴 문장에서 더 안전합니다.
    const bodyData = "inquiry_id=" + encodeURIComponent(inquiryId) + 
                     "&admin_reply=" + encodeURIComponent(replyContent) + 
                     "&status=" + encodeURIComponent(statusValue);
    
    // 경로 처리 간소화 (슬래시 중복 방지)
    const cleanPath = contextPath.endsWith('/') ? contextPath : contextPath + '/';
    const url = cleanPath + 'adInquiryAnswerAction.adsp';

    fetch(url, {
        method: 'POST',
        headers: {
            // 서버의 request.getParameter()와 호환되는 헤더 설정
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: bodyData // 인코딩된 문자열 전송
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('네트워크 응답이 정상적이지 않습니다.');
        }
        return response.json();
    })
    .then(data => {
        if (data && data.success) {
            const msg = (statusValue === 'PROGRESS') 
                        ? "답변이 임시저장되었습니다. (현재 상태: 답변중)" 
                        : "답변 등록이 완료되었습니다. (현재 상태: 답변완료)";
            alert(msg);
            
            location.reload(); 
        } else {
            alert("DB 저장 중 오류가 발생했습니다.");
        }
    })
    .catch(error => {
        console.error('Error Details:', error);
        alert("서버 통신 중 오류가 발생했습니다. 관리자에게 문의하세요.");
    });
}