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
<title>아이디 찾기 결과</title>

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
/* 기존 비밀번호 찾기 결과 스타일과 동일하게 유지 */
.auth-container {
	max-width: 450px;
	border: 1px solid #eee;
}
.btn-dark:hover {
	background-color: #0CB574 !important;
	border-color: #0CB574 !important;
}
/* 아이디를 강조하기 위한 스타일 */
.id-highlight {
	background-color: #f8f9fa;
	border: 1px dashed #0CB574;
	color: #0CB574;
}
</style>
</head>
<body class="bg-light">
	<div class="wrap">
		<%-- 공통 헤더 --%>
		<%@ include file="../../common/header.jsp"%>

		<div id="container" class="container my-5">
			<div id="contents" class="d-flex justify-content-center align-items-center" style="min-height: 60vh;">

				<%-- 결과 카드 박스 --%>
				<div class="auth-container bg-white p-5 rounded-4 shadow-sm text-center">
					<c:choose>
						<%-- 아이디 찾기 성공 시 (결과가 null이 아닐 때) --%>
						<c:when test="${not empty foundId}">
							<i class="fa-solid fa-id-card text-success fa-3x mb-3"></i>
							<h2 class="fw-bold mb-3">아이디 찾기 성공</h2>
							<p class="text-muted small mb-4">입력하신 정보와 일치하는 아이디입니다.</p>
							
							<%-- 마스킹된 아이디 출력 영역 --%>
							<div class="id-highlight fw-bold fs-4 py-3 rounded-3 mb-4">
								${foundId}
							</div>
							
							<a href="${path}/login.do" class="btn btn-dark w-100 py-3 fw-bold shadow-sm border-0 mt-2">
								로그인하러 가기
							</a>
							<div class="mt-3">
								<a href="${path}/findPassword.do" class="text-muted small">비밀번호 찾기</a>
							</div>
						</c:when>

						<%-- 회원정보가 일치하지 않는 경우 --%>
						<c:otherwise>
							<i class="fa-solid fa-circle-xmark text-danger fa-3x mb-3"></i>
							<h2 class="fw-bold mb-3">찾기 실패</h2>
							<p class="text-muted small mb-4">입력하신 정보와 일치하는 회원이 없습니다.</p>
							
							<a href="${path}/findId.do" class="btn btn-dark w-100 py-3 fw-bold shadow-sm border-0 mt-2">
								다시 시도하기
							</a>
							<div class="mt-3">
								<a href="${path}/join.do" class="text-muted small">아직 회원이 아니신가요? 회원가입</a>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>

		<%-- 공통 푸터 --%>
		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>