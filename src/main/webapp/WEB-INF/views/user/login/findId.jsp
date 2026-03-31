<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 공통 경로(${path}) 및 설정값 포함 --%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%-- 반응형 웹: 모바일에서도 화면이 깨지지 않게 설정 --%>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>아이디 찾기</title>

<%-- 부트스트랩 5 및 폰트어썸 등 외부 라이브러리 설정 --%>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<%-- 기존 로그인 디자인과 통일감을 주기 위해 로드 --%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">

<%-- 아이콘 사용을 위한 폰트어썸 키트 --%>
<script src="https://kit.fontawesome.com/648e5e962b.js"
	crossorigin="anonymous"></script>

<link rel="stylesheet" href="${path}/resources/css/common/header.css">
<link rel="stylesheet" href="${path}/resources/css/common/footer.css">

<style>
.auth-container {
	max-width: 450px;
	border: 1px solid #eee;
}
.input-group-text {
	background-color: #f9f9f9;
	border-right: none;
}
.form-control:focus {
	border-color: #0CB574;
	box-shadow: none;
}
.btn-dark:hover {
	background-color: #0CB574 !important;
	border-color: #0CB574 !important;
}
</style>
</head>
<body class="bg-light">
	<div class="wrap">
		<%-- 공통 헤더 --%>
		<%@ include file="../../common/header.jsp"%>

		<div id="container" class="container my-5">
			<div id="contents" class="d-flex justify-content-center align-items-center" style="min-height: 60vh;">

				<%-- 카드 박스 영역 --%>
				<div class="auth-container bg-white p-5 rounded-4 shadow-sm text-center">

					<h2 class="fw-bold mb-4">아이디 찾기</h2>

					<%-- 안내 문구 변경 --%>
					<p class="text-muted mb-4 small">
						가입 시 등록한 정보를 입력해주세요.<br>
						정보가 일치하면 <span class="text-dark fw-bold">마스킹 처리된 아이디</span>를 보여드립니다.
					</p>

					<%-- 아이디 찾기 폼 --%>
					<form name="findIdForm" action="${path}/findIdAction.do" method="post">

						<%-- 이름 입력 (아이콘: person) --%>
						<div class="input-group mb-3">
							<span class="input-group-text text-secondary">
								<i class="fa-solid fa-user-tag"></i>
							</span>
							<input type="text" name="name" class="form-control"
								placeholder="이름 입력" required autofocus>
						</div>

						<%-- 이메일 입력 (아이콘: envelope) --%>
						<div class="input-group mb-4">
							<span class="input-group-text text-secondary">
								<i class="fa-solid fa-envelope"></i>
							</span>
							<input type="text" name="email1" class="form-control" placeholder="이메일" required>
							<span class="input-group-text">@</span>
							<input type="text" name="email2" class="form-control" placeholder="도메인" required>
						</div>
						
						<%-- 확인 버튼 (기존과 동일한 스타일) --%>
						<button type="submit" class="btn btn-dark w-100 py-3 fw-bold shadow-sm border-0 mt-2">
							확인
						</button>
					</form>

					<%-- 하단 링크 --%>
					<div class="mt-4 d-flex justify-content-between">
						<a href="${path}/login.do" class="text-muted small">로그인하러 가기</a>
						<a href="${path}/findPassword.do" class="text-muted small">비밀번호 찾기</a>
					</div>
				</div>
			</div>
		</div>

		<%-- 공통 푸터 --%>
		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>