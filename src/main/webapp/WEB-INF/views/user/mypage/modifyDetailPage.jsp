<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 공통 경로(${path}) 및 설정값 포함 --%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>회원정보 수정 | 맛침내!</title>

    <%-- 부트스트랩 5 및 외부 라이브러리 --%>
    <%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
    <link rel="stylesheet" href="${path}/resources/css/user/login.css">
    <script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>

    <style>
        :root { --point-color: #0CB574; }
        .modify-container { max-width: 800px; margin: 0 auto; background: #fff; border-radius: 15px; overflow: hidden; }
        .modify-header { background: #f8f9fa; padding: 30px; border-bottom: 1px solid #eee; text-align: center; }
        .modify-body { padding: 40px; }
        .table-label { background-color: #f9f9f9; width: 25%; font-weight: 600; vertical-align: middle; }
        .form-control:focus { border-color: var(--point-color); box-shadow: 0 0 0 0.25rem rgba(12, 181, 116, 0.25); }
        .btn-point { background-color: var(--point-color); color: white; border: none; }
        .btn-point:hover { background-color: #0a9660; color: white; }
        .section-title { font-size: 1.1rem; font-weight: bold; margin-top: 25px; margin-bottom: 15px; color: #333; border-left: 4px solid var(--point-color); padding-left: 10px; }
    </style>

    <script type="text/javascript">
        // 폼 제출 전 유효성 검사
        function validateForm() {
            const pw = document.getElementById("password").value;
            const pwConfirm = document.getElementById("password_confirm").value;
            
            if (pw !== pwConfirm) {
                alert("변경할 비밀번호가 서로 일치하지 않습니다.");
                document.getElementById("password_confirm").focus();
                return false;
            }
            
            if(!confirm("입력하신 정보로 수정하시겠습니까?")) return false;
            return true;
        }
    </script>
</head>
<body class="bg-light">
    <div class="wrap">
        <%@ include file="../../common/header.jsp"%>

        <div class="container my-5">
            <c:choose>
                <c:when test="${selectCnt == 1}">
                    <div class="modify-container shadow-sm">
                        <div class="modify-header">
                            <h2 class="fw-bold mb-2">회원정보 수정</h2>
                            <p class="text-muted mb-0">맛침내!의 소중한 정보를 최신으로 유지해주세요.</p>
                        </div>

                        <div class="modify-body">
                            <form action="${path}/modifyUserAction.do" method="post" onsubmit="return validateForm();">
                                
                                <div class="section-title">기본 정보</div>
                                <table class="table table-bordered align-middle">
                                    <tr>
                                        <th class="table-label text-center">아이디</th>
                                        <td>
                                            <span class="fw-bold px-2">${dto.user_id}</span>
                                            <input type="hidden" name="user_id" value="${dto.user_id}">
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="table-label text-center">포인트</th>
                                        <td>
                                            <span class="text-success fw-bold px-2">
                                                <i class="fa-solid fa-p"></i> ${dto.point_balance != null ? dto.point_balance : 0} P
                                            </span>
                                        </td>
                                    </tr>
                                </table>

                                <div class="section-title">비밀번호 변경</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold">새 비밀번호</label>
                                        <input type="password" name="password" id="password" class="form-control" placeholder="새 비밀번호 입력" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold">새 비밀번호 확인</label>
                                        <input type="password" id="password_confirm" class="form-control" placeholder="비밀번호 재입력" required>
                                    </div>
                                </div>

                                <div class="section-title">상세 정보</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold">이름</label>
                                        <input type="text" name="name" value="${dto.name}" class="form-control">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold">생년월일</label>
                                        <input type="date" name="birth_date" value="${dto.birth_date}" class="form-control">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold">이메일</label>
                                        <input type="email" name="email" value="${dto.email}" class="form-control">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold">연락처</label>
                                        <input type="text" name="phone" value="${dto.phone}" class="form-control" placeholder="010-0000-0000">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label small fw-bold">주소</label>
                                        <input type="text" name="address" value="${dto.address}" class="form-control">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label small fw-bold d-block">성별</label>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="gender" id="genderM" value="M" ${dto.gender == 'M' ? 'checked' : ''}>
                                            <label class="form-check-label" for="genderM">남성</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="gender" id="genderF" value="F" ${dto.gender == 'F' ? 'checked' : ''}>
                                            <label class="form-check-label" for="genderF">여성</label>
                                        </div>
                                    </div>
                                </div>

                                <hr class="my-4">

                                <div class="d-flex justify-content-between align-items-center">
                                    <button type="button" class="btn btn-outline-danger btn-sm" onclick="if(confirm('정말 탈퇴하시겠습니까? 데이터가 모두 삭제됩니다.')) location.href='${path}/deleteUser.do'">
                                        회원탈퇴
                                    </button>
                                    <div>
                                        <button type="button" class="btn btn-light px-4 me-2" onclick="location.href='${path}/main.do'">취소</button>
                                        <button type="submit" class="btn btn-point px-5 fw-bold">정보 수정 완료</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <script>
                        alert("인증 정보가 유효하지 않습니다.");
                        location.href="${path}/modifyUser.do";
                    </script>
                </c:otherwise>
            </c:choose>
        </div>

        <%@ include file="../../common/footer.jsp"%>
    </div>
</body>
</html>