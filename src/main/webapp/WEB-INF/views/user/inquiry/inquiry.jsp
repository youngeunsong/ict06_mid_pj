<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>고객지원 - 1:1문의 페이지</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>

</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<hr>
		1:1 문의
		<!-- 컨텐츠 시작 -->
		<div align="center">
			<img src="${path}/resources/images/user/inquiry/inquiryForm.png"
				width="100%" alt="main">
		</div>

		<!-- 관련 SQL -->
		SQL 쿼리 : 1대1 문의 내용 1건 추가
		<pre>
			<code>
		    INSERT INTO INQUIRY (
		        inquiry_id,
		        user_id,
		        title,
		        content,
		        status
		    )
		    VALUES (
		        INQUIRY_SEQ.NEXTVAL,
		        #${'{'}userId},
		        #${'{'}title},
		        #${'{'}content},
		        'PENDING'
		    )
			</code>
		</pre>

		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>