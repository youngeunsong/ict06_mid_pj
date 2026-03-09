<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
	/* 하위메뉴(nav-treeview) 전체에 왼쪽여백 추가 */
	.nav-treeview {
		padding-left: 1.5rem !important;
	}
	
	/* 하위메뉴 아이템 아이콘 크기 줄이기 */
	.nav-treeview .nav-icon {
		font-size: 0.8rem !important;
		margin-left: 0.2rem;
	}
</style>

<!-- ================= SIDEBAR ================= -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">

	<a href="#" class="brand-link"> <img
		src="${path}/resources/admin/dist/img/AdminLTELogo.png"
		class="brand-image img-circle elevation-3"> <span
		class="brand-text font-weight-light">맛침내 (관리자)</span> <!-- 관리자 페이지 임을 표시 -->
	</a>

	<div class="sidebar">
		<%-- <div class="user-panel mt-3 pb-3 mb-3 d-flex">
			<div class="image">
				<img src="${path}/resources/admin/dist/img/user2-160x160.jpg"
					class="img-circle elevation-2">
			</div> 
			<div class="info">
				<a href="#" class="d-block">Spring User</a>
			</div>
		</div> --%>

		<nav class="mt-2">
			<ul class="nav nav-pills nav-sidebar flex-column"
				data-widget="treeview" role="menu" data-accordion="false">
				<!-- Add icons to the links using the .nav-icon class
             with font-awesome or any other icon font library -->
             
             	<!-- 하위 메뉴 없는 경우 -->
             	<!--  -->
				<li class="nav-item">
					<!-- class 뒤에 active 붙여서 현재 선택한 메뉴임을 표시 가능 -->
					<a href="${path}/adminHome.ad" class="nav-link"> 
						<i class="nav-icon fas fa-tachometer-alt"></i>
						<!-- <p>Dashboard(통계)</p> -->
						KPI 대시보드
					</a>
				</li>
				
				<!-- 고객 지원 메뉴 시작 -->
				<li class="nav-item">
					<a href="${path}/supportHome.adsp" class="nav-link"> 
						<i class="fa-solid fa-headset"></i>
						고객지원
					</a>
				</li>
				<!-- 고객 지원 메뉴 끝 -->
				
				<!-- 예약 관리 메뉴 시작: 하위 메뉴 있음 -->
				<!-- <li class="nav-item menu-open"> -->
				<li class="nav-item">
					<!-- <a href="#" class="nav-link active">  -->
					<a href="#" class="nav-link"> 
						<i class="fa-solid fa-calendar"></i>
						예약 관리 
						<i class="right fas fa-angle-left"></i>
					</a>
					
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/adminDashboard.ad" class="nav-link"> 
								예약 통계 대시보드
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/getReservationList.ad" class="nav-link">
								예약 내역
							</a>
						</li>
					</ul>
				</li>
				<!-- 예약 관리 메뉴 끝 -->
				
				<!-- 커뮤니티 관리 메뉴 시작 -->
				<li class="nav-item">
					<a href="${path}/communityHome.adco" class="nav-link"> 
						<i class="fa-solid fa-comments"></i>
						커뮤니티 관리 
					</a>
				</li>
				
				<!-- <li class="nav-item">
					<a href="#" class="nav-link active"> 
					<a href="#" class="nav-link"> 
						아이콘을 쓰고 싶다면 아래 주석 해제해서 메뉴에 맞는 아이콘 넣어서 사용
						<i class="nav-icon fas fa-tachometer-alt"></i>
						커뮤니티 관리 
						<i class="right fas fa-angle-left"></i>
					</a>
					
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="#" class="nav-link"> 
								공지사항 관리
							</a>
						</li>
						<li class="nav-item">
							<a href="#" class="nav-link">
								이벤트 관리
							</a>
						</li>
					</ul>
				</li> -->
				<!-- 커뮤니티 관리 메뉴 끝 -->
				
				<!-- 장소 관리 메뉴 시작 -->
				<li class="nav-item">
					<!-- <a href="#" class="nav-link active">  -->
					<a href="#" class="nav-link"> 
						<!-- 아이콘을 쓰고 싶다면 아래 주석 해제해서 메뉴에 맞는 아이콘 넣어서 사용 -->
						<i class="fa-solid fa-location-dot"></i>
						장소 관리 
						<i class="right fas fa-angle-left"></i>
					</a>
					
					<ul class="nav nav-treeview">
						<li class="nav-item">
							<a href="${path}/restaurantList.adpl" class="nav-link"> 
								맛집 관리
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/accommodationList.adpl" class="nav-link">
								숙소 관리
							</a>
						</li>
						<li class="nav-item">
							<a href="${path}/festivalList.adpl" class="nav-link">
								축제 관리
							</a>
						</li>
					</ul>
				</li>
				<!-- 장소 관리 메뉴 끝 -->
			</ul>
		</nav>
	</div>
</aside>

<!-- ================= JS ================= -->
</html>