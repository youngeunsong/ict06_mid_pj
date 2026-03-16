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
<title>비밀번호 찾기 결과</title>

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

				<%-- 카드 박스: 흰색 배경, 안쪽여백(p-5), 둥근모서리(rounded-4), 그림자(shadow-sm) --%>
				<div
					class="auth-container bg-white p-5 rounded-4 shadow-sm text-center">
					<c:choose>
						<%-- 임시비밀번호 발급을 위한 회원정보가 일치하는 경우(ID, 이름, 이메일) --%>
						<c:when test="${result == 'success'}">
							<i class="fa-solid fa-circle-check text-success fa-3x mb-3"></i>
							<h2 class="fw-bold mb-3">본인확인 완료</h2>
							<p class="text-muted small mb-4">임시 비밀번호로 로그인 후 반드시 변경해주세요.</p>
							<div class="alert alert-warning fw-bold fs-5">
								${tempPassword}
							</div>
							<a href="${path}/login.do" class="btn btn-dark w-100 py-3 fw-bold shadow-sm border-0 mt-2">
								로그인하러 가기
							</a>
						</c:when>
						<%-- 회원정보 일치하지 않는 경우 --%>
						<c:otherwise>
							<i class="fa-solid fa-circle-xmark text-danger fa-3x mb-3"></i>
							<h2 class="fw-bold mb-3">확인 실패</h2>
							<p class="text-muted small mb-4">입력하신 정보와 일치하는 회원이 없습니다.</p>
							<a href="${path}/findPassword.do" class="btn btn-dark w-100 py-3 fw-bold shadow-sm border-0 mt-2">
								다시 시도하기
							</a>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>

		<%-- 공통 푸터 (하단 정보 등) --%>
		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>
