<!-- 
 * @author 송영은
 * 최초작성일: 2026-03-23
 * 최종수정일: 2026-03-23
 * 참고 코드: bestRestaurants.jsp의 css
지도를 이용해 내 위치 주변 축제 위주로 조회   
-->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp"%>
<!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>축제 페이지</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp"%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="${path}/resources/css/user/festival/festival.css"/>

</head>
<body>
	<div class="wrap">
		<%@ include file="../../common/header.jsp"%>

		<main class="rk-page">
			<div class="container">
				<%-- [페이지 제목 영역]
			           랭킹 페이지의 목적과 기능을 사용자에게 안내하기 위해 사용
			      --%>
				<div class="rk-head">
					<h1 class="rk-title">
						<i class="fa-solid fa-icons" style="color: var(--rk-brand);"></i>국내 축제
					</h1>
					<div class="rk-sub">나와 가까운 축제, 인기 있는 국내 축제를 한 눈에 확인해보세요.</div>
				</div>
				
				<!-- 임시 코드: 축제 랭킹 페이지로 연결 . 추후 아래의 탭과 연결 -->
				<a href="${path}/bestFestivals.fe">축제 랭킹</a><br>

				<!-- 탭: 내 주변 축제 & 축제 랭킹 시작 -->
				<div class="rk-tabs">
					<button type="button" class="rk-tab active" data-tab="festivalMap">
						내 주변 축제</button>
					<button type="button" class="rk-tab" data-tab="festivalRanking">축제 랭킹</button>
				</div>
				<!-- 탭: 내 주변 축제 & 축제 랭킹 끝 -->

				<!-- 필터 (조건: 평점, 거리, 검색) (필터 적용 버튼) 시작 -->
				<div class="border rounded p-4 bg-white shadow-sm d-inline-block" >
					<form>
						<div class="form-row" style="align:center">
							<div class="row">
								<!-- 필터 아이콘 -->
								<div class="col-auto">
									<i class="fa-solid fa-sliders"></i>
								</div>
								
								<!-- 평점 -->
								<div class="col-auto">
									<select id="ratingSelect" class="form-select" style="width:160px">
							          <option value="별점">별점</option>
							          <option value="5점 이상">⭐⭐⭐⭐⭐ 이상</option>
							          <option value="4점 이상">⭐⭐⭐⭐ 이상</option>
							          <option value="3점 이상">⭐⭐⭐ 이상</option>
							          <option value="2점 이상">⭐⭐ 이상</option>
							          <option value="1점 이상">⭐ 이상</option>
							        </select>
						        </div>
						        
						        <!-- 거리 설정 슬라이더 -->
						        <div class="col-auto">
						        	<input type="range"
									    id="volume"
									    min="0"
									    max="50"
									    step="10"
									    value="10"
									    list="markers"
									    title="조회 반경을 km 단위로 조절해보세요"> <!-- 마우스 오버하면 나오는 힌트 텍스트  -->
									<!-- 눈금 표시 -->
									<datalist id="markers">
									    <option value="0">0</option>
									    <option value="10">10</option>
									    <option value="20">20</option>
									    <option value="30">30</option>
									    <option value="40">40</option>
									    <option value="50">50</option>
									</datalist>    
									(단위: km)
						        </div>
						        
						        <!-- 검색창 -->
						        <div class="col-auto">
							        <input class="form-control mr-sm-2" type="search" placeholder="키워드를 입력해주세요" aria-label="검색">
						        </div>
						        
						        <!-- 필터 적용 버튼 -->
						        <div class="col-auto">
						        	<button class="btn btn-outline-success my-2 my-sm-0" type="submit">필터 적용</button>
						        </div>
					        </div>
						</div>
					</form>
				</div>
				<!-- 필터 끝 -->

				<!-- 지도 시작 -->
				<div id="map" style="width:500px;height:400px;"></div>
				
				<!-- 지도 끝 -->

				<!-- 카드 목록 시작 -->
				
				<!-- 카드 끝 -->
			</div>
		</main>
		<!-- [JS에서 사용할 공통 path 설정] -->
		<script>
			const path = "${path}";
		</script>
		
		<!-- 지도용 js -->
		<!-- <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=발급받은 APP KEY를 넣으시면 됩니다."></script> -->
		<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b28017774bdca5bee6c607b53f370dcd"></script>
		<script src="${path}/resources/js/festival/festivalMap.js"></script>
		
		<%@ include file="../../common/footer.jsp"%>
	</div>
</body>
</html>