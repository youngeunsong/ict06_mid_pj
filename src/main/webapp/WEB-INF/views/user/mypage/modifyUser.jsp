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
<title>회원정보 수정 인증 | 맛침내!</title>

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
/* .auth-container: 인증 박스의 최대 너비를 제한하고 테두리 설정 */
.auth-container {
	max-width: 450px;
	border: 1px solid #eee;
}
/* .input-group-text: 입력창 옆 아이콘이 들어가는 배경색 설정 */
.input-group-text {
	background-color: #f9f9f9;
	border-right: none;
}
/* .form-control:focus: 입력창 클릭 시 테두리 색상을 포인트 컬러(#0CB574)로 변경 */
.form-control:focus {
	border-color: #0CB574;
	box-shadow: none;
}
/* .btn-dark:hover: 버튼에 마우스 올리면 초록색 포인트컬러(#0CB574)으로 강조 */
.btn-dark:hover {
	background-color: #0CB574 !important;
	border-color: #0CB574 !important;
}
</style>
</head>
<body class="bg-light">
	<%-- bg-light: 전체적으로 아주 연한 회색 배경 적용 --%>
	<div class="wrap">
		<%-- 공통 헤더 (네비게이션 바 등) --%>
		<%@ include file="../../common/header.jsp"%>

		<%-- 메인 컨테이너 영역: 위아래 여백(my-5) --%>
		<div id="container" class="container my-5">
			<%-- Flexbox를 이용해 박스를 화면 정가운데 배치 (가로: center, 세로: center) --%>
			<div id="contents"
				class="d-flex justify-content-center align-items-center"
				style="min-height: 60vh;">

				<%-- 인증 카드 박스: 흰색 배경, 안쪽여백(p-5), 둥근모서리(rounded-4), 그림자(shadow-sm) --%>
				<div
					class="auth-container bg-white p-5 rounded-4 shadow-sm text-center">

					<h2 class="fw-bold mb-4">회원정보 수정</h2>

					<%-- 안내 문구: 회색 글씨(text-muted), 작은 글씨(small) --%>
					<p class="text-muted mb-4 small">
						고객님의 개인정보를 안전하게 보호하기 위해<br> <span class="text-dark fw-bold">비밀번호를
							다시 한번 입력</span>해주세요.
					</p>

					<%-- 비밀번호 확인 폼: 제출 시 /modifyDetailPage.do로 데이터 전송 --%>
					<form name="modifyAuthForm" action="${path}/modifyDetailPage.do"
						method="post">

						<%-- 아이디 표시 영역: 읽기 전용(readonly), 배경은 밝은 회색(bg-light) --%>
						<div class="input-group mb-3">
							<span class="input-group-text text-secondary"> <i
								class="fa-regular fa-user"></i>
							</span> <input type="text" class="form-control bg-light"
								value="${sessionScope.sessionID}" readonly>
						</div>

						<%-- 비밀번호 입력 영역: input-group으로 아이콘과 입력창 결합 --%>
						<div class="input-group mb-4">
							<span class="input-group-text text-secondary"> <i
								class="fa-solid fa-lock"></i>
							</span> <input type="password" name="password" id="password"
								class="form-control" placeholder="비밀번호 입력" required autofocus>
							<%-- required: 필수입력, autofocus: 페이지 로드 시 자동 포커스 --%>
						</div>

						<%-- 에러 메시지 표시 영역 추가 --%>
						<c:if test="${not empty errMsg}">
							<div class="text-danger small text-start mb-3" id="pwError">
								<i class="fa-solid fa-circle-exclamation"></i> ${errMsg}
							</div>
						</c:if>

						<%-- 확인 버튼: 가로 꽉 채우기(w-100), 굵은 글씨(fw-bold), 그림자(shadow-sm) --%>
						<button type="submit"
							class="btn btn-dark w-100 py-3 fw-bold shadow-sm border-0 mt-2">
							확인</button>
					</form>
				</div>
				<%-- 인증 카드 박스 끝 --%>

			</div>
		</div>

		<%-- 공통 푸터 (하단 정보 등) --%>
		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>
