<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 탈퇴 | 맛침내!</title>
    <%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
    
    <style>
        :root { --point-color: #0CB574; --danger-color: #dc3545; }
        .delete-container { max-width: 500px; margin: 80px auto; background: #fff; border-radius: 20px; overflow: hidden; }
        .delete-header { padding: 40px 30px 20px; text-align: center; }
        .delete-body { padding: 0 40px 40px; }
        .icon-box { width: 80px; height: 80px; background: #fff5f5; color: var(--danger-color); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; font-size: 2rem; }
        .warning-box { background: #f8f9fa; border-radius: 12px; padding: 20px; margin-bottom: 25px; border-left: 4px solid var(--danger-color); }
        .warning-box ul { margin-bottom: 0; padding-left: 20px; color: #666; font-size: 0.9rem; }
        .form-control:focus { border-color: var(--danger-color); box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.1); }
        .btn-delete { background-color: var(--danger-color); color: white; border: none; padding: 12px; transition: 0.3s; }
        .btn-delete:hover { background-color: #bb2d3b; color: white; transform: translateY(-2px); }
    </style>

    <script type="text/javascript">
        function confirmDelete() {
            const pw = document.getElementById("password").value;
            if(!pw) {
                alert("본인 확인을 위해 비밀번호를 입력해주세요.");
                return false;
            }
            return confirm("탈퇴 후에는 복구가 불가능합니다.\n정말 '맛침내!'를 떠나시겠습니까?");
        }
    </script>
</head>
<body class="bg-light">
    <div class="wrap">
        <%@ include file="../../common/header.jsp"%>

        <div class="container">
            <div class="delete-container shadow-sm">
                <div class="delete-header">
                    <div class="icon-box">
                        <i class="fa-solid fa-user-slash"></i>
                    </div>
                    <h3 class="fw-bold">회원 탈퇴</h3>
                    <p class="text-muted small">그동안 '맛침내!'와 함께해주셔서 감사합니다.</p>
                </div>

                <div class="delete-body">
                    <div class="warning-box">
                        <p class="fw-bold mb-2" style="color: var(--danger-color);">⚠️ 유의사항을 확인해주세요</p>
                        <ul>
                            <li>탈퇴 시 사용 중인 <b>포인트는 모두 소멸</b>됩니다.</li>
                            <li>작성하신 리뷰 및 게시글은 삭제되지 않습니다.</li>
                            <li>동일한 아이디로 <b>재가입이 불가능</b>할 수 있습니다.</li>
                        </ul>
                    </div>

                    <form action="${path}/deleteUserAction.do" method="post" onsubmit="return confirmDelete();">
                        <div class="mb-4">
                            <label for="password" class="form-label small fw-bold">비밀번호 확인</label>
                            <input type="password" name="password" id="password" class="form-control form-control-lg" placeholder="현재 비밀번호를 입력하세요" required>
                        </div>

                        <div class="row g-2">
                            <div class="col-4">
                                <button type="button" class="btn btn-light w-100 py-3 fw-bold" onclick="history.back();">취소</button>
                            </div>
                            <div class="col-8">
                                <button type="submit" class="btn btn-delete w-100 py-3 fw-bold">탈퇴하기</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%@ include file="../../common/footer.jsp"%>
    </div>
</body>
</html>