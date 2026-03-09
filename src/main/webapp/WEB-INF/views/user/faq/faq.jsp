<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>고객지원 - FAQ 페이지</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>

</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<hr>
		<!-- 컨텐츠 시작 -->
		<div align="center">
			<button type="button" class="btn_cancel" onclick="location.href='${path}/FAQDetail.do'">
		        숙소 체크인 시간은 언제인가요?
		     </button>	
			<img src="${path}/resources/images/user/faq/faq.png" width="100%"
				alt="main">
		</div>

		<!-- 컨텐츠 끝 -->

		<!-- 관련 SQL -->
		SQL 쿼리 : FAQ 1건 조회
		<pre>
			<code>
		 SELECT
		        faq_id,
		        question,
		        answer,
		        category,
		        order_no,
		        visible,
		        created_at
		   FROM FAQ
		  WHERE faq_id = #${'{'}faqId}
		    AND visible = 'Y'
			</code>
		</pre>

		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>