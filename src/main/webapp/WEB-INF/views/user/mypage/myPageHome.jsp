<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<link rel="stylesheet" href="${path}/resources/css/user/login.css">
<script src="https://kit.fontawesome.com/648e5e962b.js"
	crossorigin="anonymous"></script>

<style>
.delete_info {
	background-color: #f8f8f8;
	padding: 20px;
	border-radius: 8px;
	text-align: left;
	margin-bottom: 25px;
	font-size: 14px;
	color: #666;
	line-height: 1.6;
}

.delete_info strong {
	color: #f91a32;
}

.btn_delete {
	width: 100%;
	padding: 15px;
	background-color: #999; /* 처음엔 무채색 */
	color: white;
	border: none;
	border-radius: 4px;
	font-weight: bold;
	cursor: pointer;
	transition: 0.3s;
}

.btn_delete:hover {
	background-color: #f91a32;
} /* 하버 시 빨간색 */
</style>

</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>
		<button type="button" class="btn_area"
			onclick="location.href='${path}/viewBookmarks.do'">
			즐겨찾기</button>
			
		<button type="button" class="btn_area"
			onclick="location.href='${path}/viewReservations.do'">
			예약 목록</button>	
			
		<button type="button" class="btn_area"
			onclick="location.href='${path}/viewInquiries.do'">
			1:1 문의 목록</button>	
		
		<button type="button" class="btn_area"
			onclick="location.href='${path}/modifyUser.do'">
			회원 정보 수정/탈퇴</button>
			
		<!-- 컨텐츠 시작 -->
		<div align="center">
			<img src="${path}/resources/images/user/mypage/myPageHome.png"
				width="100%" alt="main">
		</div>

		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>