<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원 탈퇴 | 맛침내!</title>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet"
	href="${path}/resources/css/user/mypage/deleteUser.css">
</head>
<body class="bg-light">
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<div class="container">
			<div class="delete-container shadow-sm">
				<div class="delete-header">
					<div class="icon-box">
						<i class="bi bi-person-dash"></i>
					</div>
					<h3 class="fw-bold">회원 탈퇴</h3>
					<p class="text-muted small">그동안 '맛침내!'와 함께해주셔서 감사합니다.</p>
				</div>

				<div class="delete-body">
					<div class="warning-box">
						<p class="fw-bold mb-2" style="color: var(--danger-color);">⚠️
							유의사항을 확인해주세요</p>
						<ul>
							<li>탈퇴 시 사용 중인 <b>포인트는 모두 소멸</b>됩니다.
							</li>
							<li>작성하신 리뷰 및 게시글은 삭제되지 않습니다.</li>
							<li>동일한 아이디로 <b>재가입이 불가능</b>할 수 있습니다.
							</li>
						</ul>
					</div>

					<form action="${path}/deleteUserAction.do" method="post"
						onsubmit="return confirmDelete();">
						<div class="mb-4">
							<label for="password" class="form-label small fw-bold">비밀번호
								확인</label> <input type="password" name="password" id="password"
								class="form-control form-control-lg"
								placeholder="현재 비밀번호를 입력하세요" required>
						</div>

						<div class="row g-2">
							<div class="col-4">
								<button type="button" class="btn btn-light w-100 py-3 fw-bold"
									onclick="history.back();">취소</button>
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
	<script src="${path}/resources/js/user/mypage/deleteUser.js"></script>
</body>
</html>