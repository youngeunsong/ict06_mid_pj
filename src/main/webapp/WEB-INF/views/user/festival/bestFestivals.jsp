<!-- 
 * @author 송영은
 * 최초작성일: 2026-03-19
 * 최종수정일: 2026-03-24
 * 참고 코드: bestRestaurants.jsp
 현재 종료되지 않은 축제를 평점 순으로 조회. 현재 틀만 제공.  
 * 변경사항
 v260324: 랭킹용 css 사용하도록 수정
-->

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>축제 랭킹</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="${path}/resources/css/common/ranking.css"/>	<!-- 랭킹용 공통 css -->
</head>

<body>
	<%@ include file="../../common/header.jsp"%>

	<main class="rk-page">
		<div class="container">

			<%-- [페이지 제목 영역]
           랭킹 페이지의 목적과 기능을 사용자에게 안내하기 위해 사용
      --%>
			<div class="rk-head">
				<h1 class="rk-title">
					<i class="fa-solid fa-ticket" style="color: var(--rk-brand);"></i>
					축제 랭킹
				</h1>
				<div class="rk-sub">실시간 인기 축제를 한눈에 확인해보세요.</div>
			</div>

			<div id="rankingContent">
				<jsp:include
					page="/WEB-INF/views/user/festival/bestFestivalsContent.jsp" />
			</div>
		</div>
	</main>

	<%-- [JS에서 사용할 공통 path 설정] --%>
	<script>
		const path = "${path}";
	</script>

	<%-- [랭킹 페이지 전용 JS]
       더보기 기능을 담당
  	--%>
	<script src="${path}/resources/js/festival/bestFestivals.js"></script>

	<%@ include file="../../common/footer.jsp"%>
</body>
</html>